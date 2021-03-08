
# # magic rounding constant: 1.5*2^52 Adding, then subtracting it from a float rounds it to an Int.
# MAGIC_ROUND_CONST(::Type{Float64}) = 6.755399441055744e15
# MAGIC_ROUND_CONST(::Type{Float32}) = 1.2582912f7

# # min and max arguments by base and type
# MAX_EXP(::Val{2},  ::Type{Float64}) =  1024.0                   # log2 2^1023*(2-2^-52)
# MIN_EXP(::Val{2},  ::Type{Float64}) = -1022.0                   # log2(big(2)^-1023*(2-2^-52))
# MAX_EXP(::Val{2},  ::Type{Float32}) =  128f0                    # log2 2^127*(2-2^-52)
# MIN_EXP(::Val{2},  ::Type{Float32}) = -126f0                    # log2 2^-1075
# MAX_EXP(::Val{ℯ},  ::Type{Float64}) =  709.782712893383996732   # log 2^1023*(2-2^-52)
# MIN_EXP(::Val{ℯ},  ::Type{Float64}) = -708.396418532264106335  # log 2^-1075
# MAX_EXP(::Val{ℯ},  ::Type{Float32}) =  88.72283905206835f0      # log 2^127 *(2-2^-23)
# MIN_EXP(::Val{ℯ},  ::Type{Float32}) = -87.3365448101577555f0#-103.97207708f0           # log 2^-150
# MAX_EXP(::Val{10}, ::Type{Float64}) =  308.25471555991675       # log10 2^1023*(2-2^-52)
# MIN_EXP(::Val{10}, ::Type{Float64}) = -307.65260000       # log10 2^-1075
# MAX_EXP(::Val{10}, ::Type{Float32}) =  38.531839419103626f0     # log10 2^127 *(2-2^-23)
# MIN_EXP(::Val{10}, ::Type{Float32}) = -37.9297794795476f0      # log10 2^-127 *(2-2^-23)

# # 256/log(base, 2) (For Float64 reductions)
# LogBo256INV(::Val{2}, ::Type{Float64})    = 256.
# LogBo256INV(::Val{ℯ}, ::Type{Float64})    = 369.3299304675746
# LogBo256INV(::Val{10}, ::Type{Float64})   = 850.4135922911647
# # -log(base, 2)/256 in upper and lower bits
# LogBo256U(::Val{2}, ::Type{Float64})      = -0.00390625
# LogBo256U(::Val{ℯ}, ::Type{Float64})      = -0.0027076061740622863
# LogBo256U(::Val{10}, ::Type{Float64})     = -0.0011758984205624266
# LogBo256L(base::Val{2}, ::Type{Float64})  =  0.
# LogBo256L(base::Val{ℯ}, ::Type{Float64})  = -9.058776616587108e-20
# LogBo256L(base::Val{10}, ::Type{Float64}) = 1.0952062999160822e-20

# # 1/log(base, 2) (For Float32 reductions)
# LogBINV(::Val{2}, ::Type{Float32})    =  1f0
# LogBINV(::Val{ℯ}, ::Type{Float32})    =  1.442695f0
# LogBINV(::Val{10}, ::Type{Float32})   =  3.321928f0
# # -log(base, 2) in upper and lower bits
# LogBU(::Val{2}, ::Type{Float32})      = -1f0
# LogBU(::Val{ℯ}, ::Type{Float32})      = -0.6931472f0
# LogBU(::Val{10}, ::Type{Float32})     = -0.30103f0
# LogBL(base::Val{2}, ::Type{Float32})  =  0f0
# LogBL(base::Val{ℯ}, ::Type{Float32})  =  1.9046542f-9
# LogBL(base::Val{10}, ::Type{Float32}) =  1.4320989f-8

# # Range reduced kernels          
# @inline function expm1b_kernel(::Val{2}, x::FloatType64)
#     return x * @horner(x, 0.6931471805599393, 0.2402265069590989,
#                             0.055504115022757844, 0.009618130135925114)
# end
# @inline function expm1b_kernel(::Val{ℯ}, x::FloatType64)
#     return x * @horner(x, 0.9999999999999998, 0.49999999999999983,
#                             0.1666666704849642, 0.04166666762124105)
# end
# @inline function expm1b_kernel(::Val{10}, x::FloatType64)
#     return x * @horner(x, 2.302585092994046, 2.6509490552382577,
#                             2.0346785922926713, 1.1712561359457612,
#                             0.5393833837413015)
# end
# @inline function expb_kernel(::Val{2}, x::FloatType32)
#     return @horner(x, 1.0f0, 0.6931472f0, 0.24022652f0, 
#                         0.05550327f0, 0.009617995f0, 
#                         0.0013400431f0, 0.00015478022f0)
# end
# @inline function expb_kernel(::Val{ℯ}, x::FloatType32)
#     return @horner(x, 1.0f0, 1.0f0, 0.5f0,
#                         0.16666415f0, 0.041666083f0,
#                         0.008375129f0, 0.0013956056f0)
# end
# @inline function expb_kernel(::Val{10}, x::FloatType32)
#     return @horner(x, 1.0f0, 2.3025851f0, 2.6509492f0,
#                         2.034648f0, 1.1712388f0, 
#                         0.54208815f0, 0.20799689f0)
# end

# const J_TABLE= Float64[2.0^(big(j-1)/256) for j in 1:256];

# @inline target_trunc(v, ::VectorizationBase.True) = v
# @inline target_trunc(v, ::VectorizationBase.False) = v % UInt32
# @inline target_trunc(v) = target_trunc(v, VectorizationBase.has_feature(Val(:x86_64_avx512dq)))

# @inline fast_fma(a, b, c, ::True) = fma(a, b, c)
# @inline function fast_fma(a, b, c, ::False)
#     d = dadd(dmul(Double(a),Double(b)),Double(c))
#     add_ieee(d.hi, d.lo)
# end

# for (func, base) in (:exp2=>Val(2), :exp=>Val(ℯ), :exp10=>Val(10))
#     func_fast = Symbol(func, :_fast)
#     @eval begin
#         @inline function $func_fast(x::FloatType64)
#             N_float = muladd(x, LogBo256INV($base, Float64), MAGIC_ROUND_CONST(Float64))
#             N = target_trunc(reinterpret(UInt64, N_float))
#             N_float = N_float - MAGIC_ROUND_CONST(Float64)
#             r = fast_fma(N_float, LogBo256U($base, Float64), x, fma_fast())
#             r = fast_fma(N_float, LogBo256L($base, Float64), r, fma_fast())
#             # @show (N & 0x000000ff) % Int
#             js = vload(VectorizationBase.zero_offsets(stridedpointer(J_TABLE)), (N & 0x000000ff,))
#             k = N >>> 0x00000008
#             small_part = reinterpret(UInt64, vfmadd(js, expm1b_kernel($base, r), js))
#             # return reinterpret(Float64, small_part), r, k, N_float, js
#             twopk = (k % UInt64) << 0x0000000000000034
#             res = reinterpret(Float64, twopk + small_part)
#             return res
#         end
#         @inline function $func(x::FloatType64)
#             res = $func_fast(x)
#             res = ifelse(x >= MAX_EXP($base, Float64), Inf, res)
#             res = ifelse(x <= MIN_EXP($base, Float64), 0.0, res)
#             res = ifelse(isnan(x), x, res)
#             return res
#         end
        
#         @inline function $func_fast(x::FloatType32)
#             N_float = vfmadd(x, LogBINV($base, Float32), MAGIC_ROUND_CONST(Float32))
#             N = reinterpret(UInt32, N_float)
#             N_float = (N_float - MAGIC_ROUND_CONST(Float32))

#             r = fast_fma(N_float, LogBU($base, Float32), x, fma_fast())
#             r = fast_fma(N_float, LogBL($base, Float32), r, fma_fast())
            
#             small_part = reinterpret(UInt32, expb_kernel($base, r))
#             twopk = N << 0x00000017
#             res = reinterpret(Float32, twopk + small_part)
#             return res
#         end
#         @inline function $func(x::FloatType32)
#             res = $func_fast(x)
#             res = ifelse(x >= MAX_EXP($base, Float32), Inf32, res)
#             res = ifelse(x <= MIN_EXP($base, Float32), 0.0f0, res)
#             res = ifelse(isnan(x), x, res)
#             return res
#         end
#     end
# end

# function findnonnan(f, x, n)
#     nlow = 1
#     nhigh = n
#     @assert isnan(f(prevfloat(x,nlow)))
#     @assert !isnan(f(prevfloat(x,nhigh)))
#     while nlow + 1 < nhigh
#         nmid = (nlow + nhigh) >> 1
#         if isnan(f(prevfloat(x,nmid)))
#             nlow = nmid
#         else
#             nhigh = nmid
#         end
#     end
#     nlow
# end

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
    small_round = fma(r, lo, fma(r, hi, -small_part))
    twopk = reinterpret(T, ((N%uinttype(T)) + uinttype(T)(exponent_bias(T))) << uinttype(T)(significand_bits(T)))
    
    # if !(abs(x)<=MIN_EXPM1(T))
    #     isnan(x) && return x
    #     x > MAX_EXPM1(T) && return T(Inf)
    #     x < MIN_EXPM1(T) && return T(-1)
    #     if N == exponent_max(T)
    #         return vfmadd(small_part, T(2), T(2)) * T(2)^(exponent_max(T)-1)
    #     end
    # end
    res = fma(twopk, small_round, fma(twopk, small_part, twopk-one(T)))
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

