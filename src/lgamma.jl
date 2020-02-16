function bn(n)
    sum(0:n) do k
        sum(0:k) do v
            (isodd(v) ? -1 : 1) * (v+1)^n * binomial(k,v)
        end / (k+1)
    end
end
coef(n) = bn(n+1)/((n+1)*n)
coefb(n) = Float64(coef(big(n)))
const HLN2PI = Float64(Base.log(big(2)π)/2)
const LGAMMA_COEF = ntuple(i -> coefb(31 - 2i), Val(15))
# lng(z) = (z-0.5)*log(z) - z + HLN2PI + 1/(12z) - 1/(360z^3) + 1/(1260z^5) - 0.0005952380952380953/z^7 + 0.0008417508417508417 / z^9 - 0.0019175269175269176 / z^11


@inline function loggamma_fast(z::Vec{W,Float64}) where {W}
    logz = log(z)
    zp1 = vadd(z, vbroadcast(Vec{W,Float64}, 1.0))
    logzp1 = log(zp1)
    lg = vsub(vfmsub(vadd(z, vbroadcast(Vec{W,Float64}, 0.5)), logzp1, logz), zp1)
    invz = vinv(zp1)
    invz² = vmul(invz, invz)
    s_0 = vmuladd(LGAMMA_COEF[1], invz², LGAMMA_COEF[2])
    Base.Cartesian.@nexprs 13 i -> begin
        @inbounds s_i = vmuladd(s_{i-1}, invz², LGAMMA_COEF[i+2])
    end
    vadd(vmuladd(s_13, invz, HLN2PI), lg)
end
@inline function loggamma_core(z::Vec{W,Float64}) where {W}
    logz = log(z)
    lg = vfmsub(vsub(z, vbroadcast(Vec{W,Float64}, 0.5)), logz, z)
    invz = vinv(z)
    invz² = vmul(invz, invz)
    s_0 = vmuladd(LGAMMA_COEF[1], invz², LGAMMA_COEF[2])
    Base.Cartesian.@nexprs 13 i -> begin
        @inbounds s_i = vmuladd(s_{i-1}, invz², LGAMMA_COEF[i+2])
    end
    vmuladd(s_13, invz, vadd(HLN2PI, lg))
end

"""
This is a fairly bad (slow, unoptimized, not all that accurate) implementation, but I wanted to have something.
"""
@inline function loggamma(z::Vec{W,Float64}) where {W}
    # i = Base.unsafe_trunc(Int, SIMDPirates.vminimum(z))
    i = 0
    incr = min_val = 5
    # incr = Base.FastMath.max_fast(min_val - i, 0)
    zincr = vadd(z, vbroadcast(Vec{W,Float64}, Float64(incr)))
    lg = loggamma_core(zincr)
    vone = vbroadcast(Vec{W,Float64}, 1.0)
    for _ ∈ i:min_val - 1
        zincr = vsub(zincr, vone)
        lg = vsub(lg, log(zincr))
    end
    lg
end

@inline loggamma(v::SVec) = SVec(loggamma(extract_data(v)))

