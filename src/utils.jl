## utility functions mainly used by the private math functions in priv.jl

# function is_fma_fast end
# for T in (Float32, Float64)
#     @eval is_fma_fast(::Type{$T}) = $(muladd(nextfloat(one(T)), nextfloat(one(T)), -nextfloat(one(T), 2)) != zero(T))
# end
const FMA_FAST = SIMDPirates.VectorizationBase.FMA

@inline isnegzero(x::T) where {T<:Union{Float32,Float64}} = x === T(-0.0)
# Disabling the check for performance when vecterized.
# A PR succesfully vectorizing the check is welcome.
@inline isnegzero(::SVec{2}) = 0x00
@inline isnegzero(::SVec{4}) = 0x00
@inline isnegzero(::SVec{8}) = 0x00
@inline isnegzero(::SVec{16}) = 0x0000
@inline isnegzero(::SVec{32}) = 0x00000000
@inline isnegzero(::SVec{64}) = 0x0000000000000000
@inline isnegzero(x::SVec{N,T}) where {N,T} = x === -zero(T) #SVec{N,Bool}(false)

@inline ispinf(x::T) where {T<:FloatType} = x == T(Inf)
@inline isninf(x::T) where {T<:FloatType} = x == T(-Inf)

# _sign emits better native code than sign but does not properly handle the Inf/NaN cases
@inline _sign(d::T) where {T<:FloatType} = flipsign(one(T), d)

@inline integer2float(::Type{Float64}, m::Int) = reinterpret(Float64, (m % Int64) << significand_bits(Float64))
# @inline integer2float(::Type{Float32}, m::Union{Int32,Int64}) = reinterpret(Float32, (m % Int32) << Int32(significand_bits(Float32)))
@inline integer2float(::Type{Float32}, m::Int32) = reinterpret(Float32, (m % Int32) << Int32(significand_bits(Float32)))

@static if Int === Int64
    @inline function integer2float(::Type{<:Union{SVec{W,Float64},Float64}}, m::SVec{W,Int}) where {W}
        reinterpret(SVec{W,Float64}, m << significand_bits(Float64))
    end
    @inline function float2integer(d::SVec{W,Float64}) where {W}
        (reinterpret(SVec{W,Int64}, d) >> significand_bits(Float64))
    end
    @inline function integer2float(::Type{SVec{W,Float32}}, m::Int) where {W}
        reinterpret(Float32, (m % Int32) << (significand_bits(Float32)) % Int32)
    end
    @inline function integer2float(::Type{Float32}, m::Int)
        reinterpret(Float32, (m % Int32) << (significand_bits(Float32)) % Int32)
    end
else
    @inline function integer2float(::Type{Float64}, m::SVec{W,Int}) where {W}
        reinterpret(SVec{W,Float64}, (m % Int64) << Int64(significand_bits(Float64)))
    end
    @inline function integer2float(::Type{SVec{W,Float64}}, m::SVec{W,Int}) where {W}
        reinterpret(SVec{W,Float64}, (m % Int64) << Int64(significand_bits(Float64)))
    end
    @inline function float2integer(d::SVec{W,Float64}) where {W}
        (reinterpret(SVec{W,Int64}, d) >> significand_bits(Float64)) % Int
    end
end
@inline function integer2float(::Type{<:Union{SVec{W,Float32},Float32}}, m::SVec{W,<:Integer}) where {W}
    reinterpret(SVec{W,Float32}, (m % Int32) << (significand_bits(Float32)) % Int32)
end

@inline float2integer(d::Float64) = (reinterpret(Int64, d) >> significand_bits(Float64)) % Int
@inline float2integer(d::Float32) = (reinterpret(Int32, d) >> significand_bits(Float32)) % Int32

# @inline float2integer(d::SIMDPirates.SVecProduct) = float2integer(SVec(SIMDPirates.extract_data(d)))
@inline function float2integer(d::SVec{W,Float32}) where {W}
    (reinterpret(SVec{W,Int32}, d) >> significand_bits(Float32)) % Int32
end

@inline function pow2i(::Type{T}, q::I) where {T<:Union{Float32,Float64},I<:IntegerType}
    integer2float(T, q + I(exponent_bias(T)))
end

# sqrt without the domain checks which we don't need since we handle the checks ourselves
@inline _sqrt(x::T) where {T<:Union{Float32,Float64}} = Base.sqrt_llvm(x)
@inline _sqrt(x::SVec) = sqrt(x)
