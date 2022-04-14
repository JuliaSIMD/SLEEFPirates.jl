

const exp = VectorizationBase.vexp
const exp2 = VectorizationBase.vexp2
const exp10 = VectorizationBase.vexp10

# Oscard Smith
# https://github.com/JuliaLang/julia/blob/3253fb5a60ad841965eb6bd218921d55101c0842/base/special/expm1.jl
MAX_EXPM1(::Type{Float64}) =  709.436139303104   # log 2^1023*(2-2^-52)
MIN_EXPM1(::Type{Float64}) = -37.42994775023705   # log 2^-54
MAX_EXPM1(::Type{Float32}) =  88.37627f0          # log 2^127 *(2-2^-23)
MIN_EXPM1(::Type{Float32}) = -17.32868f0          # log 2^-25

# -ln(2) in upper and lower bits
# Upper is truncated to only have 16 bits of significand since N has at most
# ceil(log2(-MIN_EXP(n, Float32)*Ln2INV(Float32))) = 8 bits. (19 for Float64)
# This ensures no rounding when multiplying Ln2U*N for FMAless hardware
Ln2INV(::Type{Float32}) = 1.442695f0
Ln2U(::Type{Float32}) = -0.69314575f0
Ln2L(::Type{Float32}) = -1.4286068f-6
Ln2INV(::Type{Float64}) = 1.4426950408889634
Ln2U(::Type{Float64}) = -0.6931471805437468
Ln2L(::Type{Float64}) = -1.619851018665656e-11


@inline function expm1_kernel(x::FloatType64)
    hi_order = evalpoly(x, (0.1666666666666668, 0.041666666666666706, 0.0083333333333196,
                            0.0013888888888864692, 0.00019841269890049138, 2.4801587363805883e-5,
                            2.7557240916652906e-6, 2.755724050237237e-7, 2.511003824738655e-8,
                            2.092503179646227e-9))
    return exthorner(x, (1.0, 0.5, hi_order))
end
@inline function expm1_kernel(x::FloatType32)
    hi_order = evalpoly(x, ((0.16666667f0, 0.04166648f0, 0.008333283f0, 0.0013933307f0, 0.00019909571f0)))
    return exthorner(x, (1.0f0, 0.5f0, hi_order))
end

if (Sys.ARCH === :x86_64) || (Sys.ARCH === :i686)
    @inline widest_supported_integer(::VectorizationBase.True) = Int64
    @inline widest_supported_integer(::VectorizationBase.False) = Int32
    @inline inttype(::Type{Float64}) = widest_supported_integer(VectorizationBase.has_feature(Val(:x86_64_avx512dq)))
    @inline inttype(::Type{Float32}) = Int32
else
    @inline inttype(_) = Int
end

@inline function expm1_fast(x::FloatType)
    T = eltype(x)
    N_float = round(x*Ln2INV(T))
    N = unsafe_trunc(inttype(T), N_float)
    r = vfmadd(N_float, Ln2U(T), x)
    r = vfmadd(N_float, Ln2L(T), r)
    hi, lo = expm1_kernel(r)
    small_part = r*hi
    small_round = vfmadd(r, lo, vfmadd(r, hi, -small_part))
    twopk = reinterpret(T, ((N%uinttype(T)) + uinttype(T)(exponent_bias(T))) << uinttype(T)(significand_bits(T)))
    
    # if !(abs(x)<=MIN_EXPM1(T))
    #     isnan(x) && return x
    #     x > MAX_EXPM1(T) && return T(Inf)
    #     x < MIN_EXPM1(T) && return T(-1)
    #     if N == exponent_max(T)
    #         return vfmadd(small_part, T(2), T(2)) * T(2)^(exponent_max(T)-1)
    #     end
    # end
    res = vfmadd(twopk, small_round, vfmadd(twopk, small_part, twopk-one(T)))
    return res
end
@inline function expm1(x::FloatType)
    res = expm1_fast(x)
    T = eltype(x)
    res = ifelse(x >= MAX_EXPM1(T), T(Inf), res)
    res = ifelse(x <= MIN_EXPM1(T), -one(T), res)
    res = ifelse(isnan(x), x, res)
    return res
end

