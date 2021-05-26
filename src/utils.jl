## utility functions mainly used by the private math functions in priv.jl

# function is_fma_fast end
# for T in (Float32, Float64)
#     @eval is_fma_fast(::Type{$T}) = $(muladd(nextfloat(one(T)), nextfloat(one(T)), -nextfloat(one(T), 2)) != zero(T))
# end

# @inline isnegzero(x::T) where {T<:Union{Float32,Float64}} = x === T(-0.0)
# # Disabling the check for performance when vecterized.
# # A PR succesfully vectorizing the check is welcome.
# @inline isnegzero(::Vec{2}) = 0x00
# @inline isnegzero(::Vec{4}) = 0x00
# @inline isnegzero(::Vec{8}) = 0x00
# @inline isnegzero(::Vec{16}) = 0x0000
# @inline isnegzero(::Vec{32}) = 0x00000000
# @inline isnegzero(::Vec{64}) = 0x0000000000000000
# @inline isnegzero(x::Vec{N,T}) where {N,T} = x === -zero(T) #Vec{N,Bool}(false)

@inline ispinf(x::T) where {T<:FloatType} = x == T(Inf)
@inline isninf(x::T) where {T<:FloatType} = x == T(-Inf)

# _sign emits better native code than sign but does not properly handle the Inf/NaN cases
# @inline _sign(d::T) where {T<:FloatType} = flipsign(one(T), d)
@inline _sign(d::T) where {T<:FloatType} = ifelse(d > 0, one(T), -one(T))

@inline integer2float(::Type{Float64}, m::Int64) = reinterpret(Float64, m << significand_bits(Float64))
# @inline integer2float(::Type{Float32}, m::Union{Int32,Int64}) = reinterpret(Float32, (m % Int32) << Int32(significand_bits(Float32)))
@inline integer2float(::Type{Float32}, m::Base.BitInteger) = reinterpret(Float32, (m % Int32) << (significand_bits(Float32) % Int32))

@inline function integer2float(::Type{Float64}, m::AbstractSIMD{W,Int32}) where {W}
    reinterpret(Float64, (m % Int64) << (significand_bits(Float64) % Int64))
end

@static if Int === Int64
  @inline function integer2float(::Type{Float64}, m::AbstractSIMD{W,Int64}) where {W}
    reinterpret(Float64, m << significand_bits(Float64))
  end
else
  @inline integer2float(::Type{Float64}, m::Int32) = reinterpret(Float64, (m % Int64) << significand_bits(Float64))
  @inline function integer2float(::Type{Float64}, m::AbstractSIMD{W,Int64}) where {W}
    reinterpret(Float64, m << (significand_bits(Float64) % Int64))
  end
end
@inline function float2integer(d::AbstractSIMD{W,Float64}) where {W}
  (reinterpret(Int64, d) >> significand_bits(Float64))
end
@inline function integer2float(::Type{Float32}, m::AbstractSIMD{W,<:Integer}) where {W}
    reinterpret(Vec{W,Float32}, (m % Int32) << (significand_bits(Float32)) % Int32)
end

@inline float2integer(d::Float64) = (reinterpret(Int64, d) >> significand_bits(Float64)) % Int
@inline float2integer(d::Float32) = (reinterpret(Int32, d) >> significand_bits(Float32)) % Int32

@inline function float2integer(d::AbstractSIMD{W,Float32}) where {W}
    (reinterpret(Int32, d) >> (significand_bits(Float32) % Int32))
end

@inline function pow2i(::Type{T}, q::I) where {T<:Union{Float32,Float64},I<:IntegerType}
    integer2float(T, q + I(exponent_bias(T)))
end

# sqrt without the domain checks which we don't need since we handle the checks ourselves
@inline _sqrt(x::T) where {T<:Union{Float32,Float64}} = Base.sqrt_llvm(x)
@inline _sqrt(x) = sqrt(x)

