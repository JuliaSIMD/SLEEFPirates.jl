# exported hyperbolic functions

over_sch(::Type{Float64}) = 710.0
over_sch(::Type{Float32}) = 89.0f0

"""
    sinh(x)

Compute hyperbolic sine of `x`.
"""
@inline function sinh(x::V) where {V<:FloatType}
  T = eltype(x)
  u = abs(x)
  d = expk2(Double(u))
  d = dsub(d, drec(d))
  u = V(d) * T(0.5)
  u = ifelse(abs(x) > over_sch(T), T(Inf), u)
  u = ifelse(isnan(u), T(Inf), u)
  u = flipsign(u, x)
  u = ifelse(isnan(x), T(NaN), u)
  return u
end



"""
    cosh(x)

Compute hyperbolic cosine of `x`.
"""
@inline function cosh(x::V) where {V<:FloatType}
  T = eltype(x)
  u = abs(x)
  d = expk2(Double(u))
  d = dadd(d, drec(d))
  u = V(d) * T(0.5)
  u = ifelse(abs(x) > over_sch(T), T(Inf), u)
  u = ifelse(isnan(u), T(Inf), u)
  u = ifelse(isnan(x), T(NaN), u)
  return u
end

@inline function sincosh(x::V) where {V<:FloatType}
  T = eltype(x)
  absx = abs(x)
  d = expk2(Double(absx))
  isnanx = isnan(x)
  x_too_large = absx > over_sch(T)
  drecd = drec(d)
  ds = dsub(d, drecd)
  dc = dadd(d, drecd)
  us = V(ds) * T(0.5)
  uc = V(dc) * T(0.5)
  alt = ifelse(isnanx, T(NaN), T(Inf))
  us = ifelse(x_too_large, T(Inf), us)
  uc = ifelse(x_too_large, T(Inf), uc)
  us = ifelse(isnan(us), alt, us)
  uc = ifelse(isnan(uc), alt, uc)
  us = flipsign(us, x)
  return us, uc
end

over_th(::Type{Float64}) = 18.714973875
over_th(::Type{Float32}) = 18.714973875f0

"""
    tanh(x)

Compute hyperbolic tangent of `x`.
"""
@inline function tanh(x::V) where {V<:FloatType}
  T = eltype(x)
  u = abs(x)
  d = expk2(Double(u))
  e = drec(d)
  d = ddiv(dsub(d, e), dadd(d, e))
  u = V(d)
  u = ifelse(abs(x) > over_th(T), T(1.0), u)
  u = ifelse(isnan(u), T(1), u)
  u = flipsign(u, x)
  # u = ifelse(isnan(x), T(NaN), u)
  return u
end


"""
    asinh(x)

Compute the inverse hyperbolic sine of `x`.
"""
@inline function asinh(x::V) where {V<:FloatType}
  T = eltype(x)
  y = abs(x)

  yg1 = y > 1
  d = ifelse(yg1, drec(x), Double(y, V(0.0)))
  d = dsqrt(dadd2(dsqu(d), T(1.0)))
  d = ifelse(yg1, dmul(d, y), d)

  d = logk2(dnormalize(dadd(d, x)))
  y = V(d)

  y = ifelse(((abs(x) > SQRT_MAX(T)) | isnan(y)), flipsign(T(Inf), x), y)
  y = ifelse(isnan(x), T(NaN), y)
  # y = ifelse(isnegzero(x), T(-0.0), y)

  return y
end



"""
    acosh(x)

Compute the inverse hyperbolic cosine of `x`.
"""
@inline function acosh(x::V) where {V<:FloatType}
  T = eltype(x)
  d = logk2(dadd2(dmul(dsqrt(dadd2(x, T(1.0))), dsqrt(dsub2(x, T(1.0)))), x))
  y = V(d)

  y = ifelse(((x > SQRT_MAX(T)) | isnan(y)), T(Inf), y)
  y = ifelse(x == T(1.0), T(0.0), y)
  y = ifelse(x < T(1.0), T(NaN), y)
  y = ifelse(isnan(x), T(NaN), y)

  return y
end



"""
    atanh(x)

Compute the inverse hyperbolic tangent of `x`.
"""
@inline function atanh(x::V) where {V<:FloatType}
  T = eltype(x)
  u = abs(x)
  d = logk2(ddiv(dadd2(T(1.0), u), dsub2(T(1.0), u)))
  # u = ifelse(u > T(1.0), T(NaN), ifelse(u == T(1.0), T(Inf), V(d) * T(0.5)))
  u = ifelse(u > T(1.0), T(NaN), ifelse(u == T(1.0), T(Inf), V(d) * T(0.5)))
  m = isinf(x) | isnan(u)

  u = ifelse(m, T(NaN), u)
  # u = ifelse(isinf(x) | isnan(u), T(NaN), u)
  u = flipsign(u, x)
  u = ifelse(isnan(x), T(NaN), u)

  return u
end
