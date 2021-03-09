# exported logarithmic functions

const FP_ILOGB0   = typemin(Int)
const FP_ILOGBNAN = typemin(Int)
const INT_MAX     = typemax(Int)

"""
    ilogb(x)

Returns the integral part of the logarithm of `abs(x)`, using base 2 for the
logarithm. In other words, this computes the binary exponent of `x` such that

    x = significand × 2^exponent,

where `significand ∈ [1, 2)`.

* Exceptional cases (where `Int` is the machine wordsize)
    * `x = 0`    returns `FP_ILOGB0`
    * `x = ±Inf`  returns `INT_MAX`
    * `x = NaN`  returns `FP_ILOGBNAN`
"""
function ilogb(x::FloatType)
    e = ilogbk(abs(x))
    e = ifelse(x == 0, FP_ILOGB0, e)
    e = ifelse(isnan(x), FP_ILOGBNAN, e)
    e = ifelse(isinf(x), INT_MAX, e)
    return e
end



"""
    log10(x)

Returns the base `10` logarithm of `x`.
"""
function log10(a::V) where {V <: FloatType}
    T = eltype(a)
    x = V(dmul(logk(a), MDLN10E(T)))

    x = ifelse(isinf(a), T(Inf), x)
    x = ifelse((a < 0) | isnan(a), T(NaN), x)
    x = ifelse(a == 0, T(-Inf), x)

    return x
end



"""
    log2(x)

Returns the base `2` logarithm of `x`.
"""
function log2(a::V) where {V <: FloatType}
    T = eltype(a)
    u = V(dmul(logk(a), MDLN2E(T)))

    u = ifelse(isinf(a), T(Inf), u)
    u = ifelse((a < 0) | isnan(a), T(NaN), u)
    u = ifelse(a == 0, T(-Inf), u)

    return u
end



const over_log1p(::Type{Float64}) = 1e307
const over_log1p(::Type{Float32}) = 1f38

"""
    log1p(x)

Accurately compute the natural logarithm of 1+x.
"""
@inline function log1p(a::V) where {V<:FloatType}
    T = eltype(a)
    x = V(logk2(dadd2(a, T(1.0))))

    x = ifelse(a > over_log1p(T), T(Inf), x)
    x = ifelse(a < -1, T(NaN), x)
    x = ifelse(a == -1, T(-Inf), x)
    # x = ifelse(isnegzero(a), T(-0.0), x)

    return x
end






    


@inline function log_kernel(x::FloatType64)
    c7 = 0.1532076988502701353
    c6 = 0.1525629051003428716
    c5 = 0.1818605932937785996
    c4 = 0.2222214519839380009
    c3 = 0.2857142932794299317
    c2 = 0.3999999999635251990
    c1 = 0.6666666666667333541
    # return @horner x c1 c2 c3 c4 c5 c6 c7
    @horner x c1 c2 c3 c4 c5 c6 c7
end

@inline function log_kernel(x::FloatType32)
    c3 = 0.3027294874f0
    c2 = 0.3996108174f0
    c1 = 0.6666694880f0
    # return @horner x c1 c2 c3
    @horner x c1 c2 c3
end

"""
    log(x)

Compute the natural logarithm of `x`. The inverse of the natural logarithm is
the natural expoenential function `exp(x)`
"""
@inline function log(d::V) where {V <: FloatType}
    T = eltype(d)
    I = fpinttype(T)
    o = d < floatmin(T)
    d = ifelse(o, d * T(Int64(1) << 32) * T(Int64(1) << 32), d)

    e = ilogb2k(d * T(1.0/0.75))
    m = ldexp3k(d, -e)
    e = ifelse(o, e - I(64), e)
    # @show e m
    x  = ddiv(dadd2(T(-1.0), m), dadd2(T(1.0), m))
    x2 = x.hi*x.hi

    t = log_kernel(x2)

    s = dmul(MDLN2(T), convert(T,e))
    s = dadd(s, scale(x, T(2.0)))
    s = dadd(s, x2*x.hi*t)
    r = V(s)

    r = ifelse(isinf(d), T(Inf), r)
    r = ifelse((d < 0) | isnan(d), T(NaN), r)
    r = ifelse(d == 0, T(-Inf), r)

    return r
end



# First we split the argument to its mantissa `m` and integer exponent `e` so
# that `d = m \times 2^e`, where `m \in [0.5, 1)` then we apply the polynomial
# approximant on this reduced argument `m` before putting back the exponent
# in. This first part is done with the help of the private function
# `ilogbk(x)` and we put the exponent back using

#     `\log(m \times 2^e) = \log(m) + \log 2^e =  \log(m) + e\times MLN2

# The polynomial we evaluate is based on coefficients from

#     `log_2(x) = 2\sum_{n=0}^\infty \frac{1}{2n+1} \bigl(\frac{x-1}{x+1}^{2n+1}\bigr)`

# That being said, since this converges faster when the argument is close to
# 1, we multiply  `m` by `2` and subtract 1 for the exponent `e` when `m` is
# less than `sqrt(2)/2`

@inline function log_fast_kernel(x::FloatType64)
    c8 = 0.153487338491425068243146
    c7 = 0.152519917006351951593857
    c6 = 0.181863266251982985677316
    c5 = 0.222221366518767365905163
    c4 = 0.285714294746548025383248
    c3 = 0.399999999950799600689777
    c2 = 0.6666666666667778740063
    c1 = 2.0
    # return @horner x c1 c2 c3 c4 c5 c6 c7 c8
    @horner x c1 c2 c3 c4 c5 c6 c7 c8
end

@inline function log_fast_kernel(x::FloatType32)
    c5 = 0.2392828464508056640625f0
    c4 = 0.28518211841583251953125f0
    c3 = 0.400005877017974853515625f0
    c2 = 0.666666686534881591796875f0
    c1 = 2f0
    # return @horner x c1 c2 c3 c4 c5
    @horner x c1 c2 c3 c4 c5
end

@inline narrow(::Type{Float32}, x::Float64) = Float32(x)
@inline narrow(::Type{Float64}, x::Float64) = x
"""
    log_fast(x)

Compute the natural logarithm of `x`. The inverse of the natural logarithm is
the natural expoenential function `exp(x)`
"""
@inline function log_fast(d::FloatType, ::False)
    T = eltype(d)
    I = fpinttype(T)
    o = d < floatmin(T)
    d = ifelse(o, d * T(Int64(1) << 32) * T(Int64(1) << 32), d)

    e = ilogb2k(d * T(1.0/0.75))
    m = ldexp3k(d, -e)
    e = ifelse(o, e - I(64), e)
    # @show m e
    x  = (m - one(m)) / (m + one(m))
    x2 = x * x

    t = log_fast_kernel(x2)

    x = x * t + narrow(T, MLN2) * e

    x = ifelse(isinf(d), T(Inf), x)
    x = ifelse((d < zero(I)) | isnan(d), T(NaN), x)
    x = ifelse(d == zero(I), T(-Inf), x)

    return x
end
@inline log_fast(d::AbstractSIMD{2,Float32}, ::True) = log_fast(d, False())
@inline function log_fast(d::AbstractSIMD{W,T}, ::True) where {W,T<:Union{Float32,Float64}}
    m = VectorizationBase.vgetmant(d)
    e = VectorizationBase.vgetexp(T(1.3333333333333333)*d)
    en = narrow(T, MLN2) * e
    x  = (m - one(m)) / (m + one(m))
    x2 = x * x

    t = log_fast_kernel(x2)

    return muladd(x, t, en)
end
@static if Base.libllvm_version ≥ v"11"
    @inline log_fast(d::AbstractSIMD) = log_fast(float(d), VectorizationBase.has_feature(Val(:x86_64_avx512f)))
else
    @inline log_fast(d::AbstractSIMD) = log_fast(float(d), False())
end
@inline log_fast(d::Union{Float32,Float64}) = log_fast(d, False())

