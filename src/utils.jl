## utility functions mainly used by the private math functions in priv.jl

# function is_fma_fast end
# for T in (Float32, Float64)
#     @eval is_fma_fast(::Type{$T}) = $(muladd(nextfloat(one(T)), nextfloat(one(T)), -nextfloat(one(T), 2)) != zero(T))
# end
const FMA_FAST = true#is_fma_fast(Float64) && is_fma_fast(Float32)

@inline isnegzero(x::T) where {T<:Union{Float32,Float64}} = x === T(-0.0)
# Disabling the check for performance when vecterized.
# A PR succesfully vectorizing the check is welcome.
@inline isnegzero(x::SVec{N}) where {N} = SVec{N,Bool}(false)

@inline ispinf(x::T) where {T<:FloatType} = x == T(Inf)
@inline isninf(x::T) where {T<:FloatType} = x == T(-Inf)

# _sign emits better native code than sign but does not properly handle the Inf/NaN cases
@inline _sign(d::T) where {T<:FloatType} = flipsign(one(T), d)

@inline integer2float(::Type{Float64}, m::Int) = reinterpret(Float64, (m % Int64) << significand_bits(Float64))
# @inline integer2float(::Type{Float32}, m::Union{Int32,Int64}) = reinterpret(Float32, (m % Int32) << Int32(significand_bits(Float32)))
@inline integer2float(::Type{Float32}, m::Int32) = reinterpret(Float32, (m % Int32) << Int32(significand_bits(Float32)))

@inline function integer2float(::Type{<:Union{SVec{N,Float64},Float64}}, m::SVec{N,Int}) where {N}
    reinterpret(SVec{N,Float64}, SVec{N,Int64}(ntuple(Val(N)) do n
        Core.VecElement(m[n] % Int64)
    end) << Int64(significand_bits(Float64)))
end
@inline function integer2float(::Type{<:Union{SVec{N,Float32},Float32}}, m::SVec{N,<:Integer}) where {N}
    reinterpret(SVec{N,Float32}, SVec{N,Int32}(ntuple(Val(N)) do n
        Core.VecElement(m[n] % Int32)
    end) << Int32(significand_bits(Float32)))
end

@inline float2integer(d::Float64) = (reinterpret(Int64, d) >> significand_bits(Float64)) % Int
@inline float2integer(d::Float32) = (reinterpret(Int32, d) >> significand_bits(Float32)) % Int32

@inline float2integer(d::SIMDPirates.SVecProduct) = float2integer(SVec(SIMDPirates.extract_data(d)))
@inline function float2integer(d::SVec{N,Float64}) where {N}
    SVec{N,Int64}(ntuple(Val(N)) do n
        Core.VecElement((reinterpret(Int64, d[n]) >> significand_bits(Float64)) % Int)
    end)
end
@inline function float2integer(d::SVec{N,Float32}) where {N}
    SVec{N,Int32}(ntuple(Val(N)) do n
        Core.VecElement((reinterpret(Int32, d[n]) >> Int32(significand_bits(Float32))) % Int32)
    end)
end

@inline function pow2i(::Type{T}, q::I) where {T<:Union{Float32,Float64},I<:IntegerType}
    integer2float(T, q + I(exponent_bias(T)))
end

# sqrt without the domain checks which we don't need since we handle the checks ourselves
@inline _sqrt(x::T) where {T<:Union{Float32,Float64}} = Base.sqrt_llvm(x)
@inline _sqrt(x::SVec) = sqrt(x)
