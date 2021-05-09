"""
  pow(x, y)

Exponentiation operator, returns `x` raised to the power `y`.
"""
@inline function pow(x::V, y::V) where {V <: FloatType}
    T = eltype(x)
    yi = unsafe_trunc(fpinttype(T), y)
    yisint = yi == y
    yisodd = isodd(yi) & yisint
    absx = abs(x)
    logkx = logk(absx)

    logkxy = dmul(logkx, y)
    result = expk(logkxy)

    result = ifelse(isnan(result), V(Inf), result)
    result = ifelse(x > 0, result, ifelse(~yisint, V(NaN), ifelse(yisodd, -result, result)))

    efx = flipsign(abs(x) - one(x), y)
    # result = ifelse(y == V(Inf), ifelse(efx < 0, V(0.0), ifelse(efx == 0, V(1.0), V(Inf))), result)
    result = ifelse(isinf(y), ifelse(efx < 0, V(0.0), ifelse(efx == 0, V(1.0), V(Inf))), result)
    result = ifelse(isinf(x) | (x == 0), ifelse(yisodd, _sign(x), V(1.0)) * ifelse(ifelse(x == 0, -y, y) < 0, V(0.0), V(Inf)), result)
    result = ifelse(isnan(x) | isnan(y), V(NaN), result)
    result = ifelse((y == 0) | (x == 1), V(1.0), result)

    return result

end
@inline pow_fast(x, y) = exp2(y*log2(x))


@inline function cbrt_kernel(x::FloatType64)
    c6d = -0.640245898480692909870982
    c5d = 2.96155103020039511818595
    c4d = -5.73353060922947843636166
    c3d = 6.03990368989458747961407
    c2d = -3.85841935510444988821632
    c1d = 2.2307275302496609725722
    @horner x c1d c2d c3d c4d c5d c6d
end
@inline function cbrt_kernel(x::FloatType32)
    c6f = -0.601564466953277587890625f0
    c5f =  2.8208892345428466796875f0
    c4f = -5.532182216644287109375f0
    c3f =  5.898262500762939453125f0
    c2f = -3.8095417022705078125f0
    c1f =  2.2241256237030029296875f0
    @horner x c1f c2f c3f c4f c5f c6f
end
"""
Algorithm:

        movsxd  rax, edi
        imul    rax, rax, 1431655766
        mov     rcx, rax
        shr     rcx, 63
        shr     rax, 32
        add     eax, ecx
        ret
"""
@inline function divby3(a32::AbstractSIMD{<:Any,T}) where {T}
    c = 1431655766
    a = a32 % Int64
    rax = a * c
    rcx = rax
    rcx >>>= 63
    rax >>>= 32
    (rcx + rax) % T
end
@inline divby3(x::Int32) = x ÷ Int32(3)
@inline divby3(x::Int64) = ((x%Int32) ÷ Int32(3)) % Int64
"""
    cbrt_fast(x)

Return `x^{1/3}`.
"""
@inline function cbrt_fast(d::V) where {V <: FloatType}
    T  = eltype(d)
    e  = absilogbk(d)
    d  = ldexp2k_nem1(d, e)
    eplus6144 = e + 6145
    edivby3 = divby3(eplus6144)
    r = eplus6144 - edivby3*3
    # r  = (e + 6144) % 3
    q  = ifelse(r == 1, V(M2P13), V(1))
    q  = ifelse(r == 2, V(M2P23), q)
    q  = ldexp2k(q, edivby3 - 2048)
    q  = flipsign(q, d)
    d  = abs(d)
    x  = cbrt_kernel(d)
    y  = x * x
    y  = y * y
    x  = vfnmadd(vfmsub(d, y, x), T(1 / 3), x)
    y  = d * x * x
    y = (y - T(2 / 3) * y * vfmsub(y, x, 1)) * q
end


"""
    cbrt(x)

Return `x^{1/3}`. The prefix operator `∛` is equivalent to `cbrt`.
"""
function cbrt(d::V) where {V <: FloatType}
    T  = eltype(d)
    e  = absilogbk(d)
    d  = ldexp2k_nem1(d, e)
    eplus6144 = e + 6145
    edivby3 = divby3(eplus6144)
    r  = eplus6144 - edivby3*3
    q2 = ifelse(r == 1, MD2P13(T), Double(V(1)))
    q2 = ifelse(r == 2, MD2P23(T), q2)
    q2 = flipsign(q2, d)
    d  = abs(d)
    x  = cbrt_kernel(d)
    y  = x * x
    y  = y * y
    x  = vfnmadd(vfmsub(d, y, x), T(1 / 3), x)
    z  = x
    u  = dsqu(x)
    u  = dsqu(u)
    u  = dmul(u, d)
    u  = dsub(u, x)
    y  = V(u)
    y  = T(-2 / 3) * y * z
    v  = dadd(dsqu(z), y)
    v  = dmul(v, d)
    v  = dmul(v, q2)
    z  = ldexp2k(V(v), edivby3 - 2048)
    # @show z
    # z  = ifelse(isinf(d), flipsign(T(Inf), q2.hi), z)
    z = ifelse(isfinite(d), z, d)
    # z  = ifelse(d == 0, flipsign(T(0), q2.hi), z)
    z  = ifelse(d == 0, zero(V), z)
    return z
end



"""
    hypot(x,y)

Compute the hypotenuse `\\sqrt{x^2+y^2}` avoiding overflow and underflow.
"""
@inline function hypot(x::T, y::T) where {T<:vIEEEFloat}
    a = abs(x)
    b = abs(y)

    x = min(a,b)
    y = max(a,b)

    r = ifelse(x == 0, y, y / x)
    x * sqrt(T(1.0) + r * r)
end
