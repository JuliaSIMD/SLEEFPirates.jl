# magic rounding constant: 1.5*2^52 Adding, then subtracting it from a float rounds it to an Int.
MAGIC_ROUND_CONST(::Type{Float64}) = 6.755399441055744e15
MAGIC_ROUND_CONST(::Type{Float32}) = 1.2582912f7

# min and max arguments by base and type
MAX_EXP(::Val{2},  ::Type{Float64}) =  1024.0                   # log2 2^1023*(2-2^-52)
MIN_EXP(::Val{2},  ::Type{Float64}) = -1075.0                   # log2 2^-1075
MAX_EXP(::Val{2},  ::Type{Float32}) =  128f0                    # log2 2^127*(2-2^-52)
MIN_EXP(::Val{2},  ::Type{Float32}) = -140f0                    # log2 2^-1075
MAX_EXP(::Val{ℯ},  ::Type{Float64}) =  709.782712893383996732   # log 2^1023*(2-2^-52)
MIN_EXP(::Val{ℯ},  ::Type{Float64}) = -745.1332191019412076235  # log 2^-1075
MAX_EXP(::Val{ℯ},  ::Type{Float32}) =  88.72283905206835f0      # log 2^127 *(2-2^-23)
MIN_EXP(::Val{ℯ},  ::Type{Float32}) = -103.97207708f0           # log 2^-150
MAX_EXP(::Val{10}, ::Type{Float64}) =  308.25471555991675       # log10 2^1023*(2-2^-52)
MIN_EXP(::Val{10}, ::Type{Float64}) = -323.60724533877976       # log10 2^-1075
MAX_EXP(::Val{10}, ::Type{Float32}) =  38.531839419103626f0     # log10 2^127 *(2-2^-23)
MIN_EXP(::Val{10}, ::Type{Float32}) = -45.15449934959718f0      # log10 2^-150

# 256/log(base, 2) (For Float64 reductions)
LogBo256INV(::Val{2}, ::Type{Float64})    = 256.
LogBo256INV(::Val{ℯ}, ::Type{Float64})    = 369.3299304675746
LogBo256INV(::Val{10}, ::Type{Float64})   = 850.4135922911647
# -log(base, 2)/256 in upper and lower bits
LogBo256U(::Val{2}, ::Type{Float64})      = -0.00390625
LogBo256U(::Val{ℯ}, ::Type{Float64})      = -0.0027076061740622863
LogBo256U(::Val{10}, ::Type{Float64})     = -0.0011758984205624266
LogBo256L(base::Val{2}, ::Type{Float64})  =  0.
LogBo256L(base::Val{ℯ}, ::Type{Float64})  = -9.058776616587108e-20
LogBo256L(base::Val{10}, ::Type{Float64}) = 1.0952062999160822e-20

# 1/log(base, 2) (For Float32 reductions)
LogBINV(::Val{2}, ::Type{Float32})    =  1f0
LogBINV(::Val{ℯ}, ::Type{Float32})    =  1.442695f0
LogBINV(::Val{10}, ::Type{Float32})   =  3.321928f0
# -log(base, 2) in upper and lower bits
LogBU(::Val{2}, ::Type{Float32})      = -1f0
LogBU(::Val{ℯ}, ::Type{Float32})      = -0.6931472f0
LogBU(::Val{10}, ::Type{Float32})     = -0.30103f0
LogBL(base::Val{2}, ::Type{Float32})  =  0f0
LogBL(base::Val{ℯ}, ::Type{Float32})  =  1.9046542f-9
LogBL(base::Val{10}, ::Type{Float32}) =  1.4320989f-8

# Range reduced kernels          
@inline function expm1b_kernel(::Val{2}, x::Union{Float64, SVec{W, Float64} where W})
    return x * @horner(x, 0.6931471805599393, 0.2402265069590989,
                            0.055504115022757844, 0.009618130135925114)
end
@inline function expm1b_kernel(::Val{ℯ}, x::Union{Float64, SVec{W, Float64} where W})
    return x * @horner(x, 0.9999999999999998, 0.49999999999999983,
                            0.1666666704849642, 0.04166666762124105)
end
@inline function expm1b_kernel(::Val{10}, x::Union{Float64, SVec{W, Float64} where W})
    return x * @horner(x, 2.302585092994046, 2.6509490552382577,
                            2.0346785922926713, 1.1712561359457612,
                            0.5393833837413015)
end
@inline function expb_kernel(::Val{2}, x::Union{Float32, SVec{W, Float32} where W})
    return @horner(x, 1.0f0, 0.6931472f0, 0.24022652f0, 
                        0.05550327f0, 0.009617995f0, 
                        0.0013400431f0, 0.00015478022f0)
end
@inline function expb_kernel(::Val{ℯ}, x::Union{Float32, SVec{W, Float32} where W})
    return @horner(x, 1.0f0, 1.0f0, 0.5f0,
                        0.16666415f0, 0.041666083f0,
                        0.008375129f0, 0.0013956056f0)
end
@inline function expb_kernel(::Val{10}, x::Union{Float32, SVec{W, Float32} where W})
    return @horner(x, 1.0f0, 2.3025851f0, 2.6509492f0,
                        2.034648f0, 1.1712388f0, 
                        0.54208815f0, 0.20799689f0)
end

const J_TABLE= Float64[2.0^(big(j-1)/256) for j in 1:256]

@noinline function exp_fallback(::Val{2}, x::SVec{W,T}) where {W, T}
    return SVec(ntuple(Val(W)) do i Core.VecElement(exp2(x[i])) end)
end
@noinline function exp_fallback(::Val{ℯ}, x::SVec{W,T}) where {W, T}
    return SVec(ntuple(Val(W)) do i Core.VecElement(exp(x[i])) end)
end
@noinline function exp_fallback(::Val{10}, x::SVec{W,T}) where {W, T}
    return SVec(ntuple(Val(W)) do i Core.VecElement(exp10(x[i])) end)
end

for (func, base) in (:exp2=>Val(2), :exp=>Val(ℯ), :exp10=>Val(10))
    @eval begin
        @inline function ($func)(x::SVec{W,T}) where {W, T<:Float64}
            any(!(abs(x) < MAX_EXP($base, T))) && return exp_fallback($base, x)
            N_float = vmuladd(x, LogBo256INV($base, T), MAGIC_ROUND_CONST(T))
            N = reinterpret(SVec{W,Int64}, N_float) % Int32
            N_float = vsub(N_float, MAGIC_ROUND_CONST(T))
            
            r = vmuladd(N_float, LogBo256U($base, T), x)
            r = vmuladd(N_float, LogBo256L($base, T), r)
            js = vload(stridedpointer(J_TABLE), (N&255,))
            k = N >> 8
            
            small_part = reinterpret(SVec{W, Int64}, vmuladd(js, expm1b_kernel($base, r), js))
            twopk = rem(vadd(k,53), UInt64) << 52
            return reinterpret(SVec{W, T}, vadd(twopk, small_part))
        end
        
        @inline function ($func)(x::SVec{W,T}) where {W, T<:Float32}
            any(!(abs(x) < MAX_EXP($base, T))) && return exp_fallback(x)
            N_float = vmuladd(x, LogBINV($base, T), MAGIC_ROUND_CONST(T))
            N = reinterpret(SVec{W,Int32}, N_float)
            N_float = vsub(N_float, MAGIC_ROUND_CONST(T))
            
            r = vmuladd(N_float, LogBU($base, T), x)
            r = vmuladd(N_float, LogBL($base, T), r)
            
            small_part = reinterpret(SVec{W, Int32}, expb_kernel($base, r))
            twopk = N<< Int32(23)
            return reinterpret(SVec{W, T}, vadd(twopk, small_part))
        end
    end
end


const max_expm1(::Type{<:FloatType64}) = 7.09782712893383996732e2 # log 2^1023*(2-2^-52)
const max_expm1(::Type{<:FloatType32}) = 88.72283905206835f0 # log 2^127 *(2-2^-23)

const min_expm1(::Type{<:FloatType64}) = -37.42994775023704434602223
const min_expm1(::Type{<:FloatType32}) = -17.3286790847778338076068394f0

"""
    expm1(x)

Compute `eˣ- 1` accurately for small values of `x`.
"""
@inline function expm1(x::FloatType)
    T = eltype(x)
    v = dadd2(expk2(Double(x)), -T(1.0))
    u = v.hi + v.lo
    u = vifelse(x > max_expm1(T), T(Inf), u)
    u = vifelse(x < min_expm1(T), T(-1.0), u)
    # u = vifelse(isnegzero(x), T(-0.0), u)
    return u
end
