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

  @static if VERSION ≥ v"1.6"
    result = exp_hilo(logkxy.hi, logkxy.lo, Val(ℯ), VectorizationBase.has_feature(Val(:x86_64_avx512f)))
  else
    result = expk(logkxy)
  end
  
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
@inline pow_fast(x, y) = exp2(y*log2_fast(x))

@static if VERSION ≥ v"1.6"
  @inline exp_hilo(x::Union{Float32,AbstractSIMD{<:Any,Float32}}, xlo::Union{Float32,AbstractSIMD{<:Any,Float32}}, ::Val{B}, _) where {B} = expk(Double(x, xlo))
  
  const J_TABLE_BASE = Ref(Base.Math.J_TABLE)
  @inline base_exp_table_pointer() = VectorizationBase.stridedpointer(Base.unsafe_convert(Ptr{UInt64}, pointer_from_objref(J_TABLE_BASE)), VectorizationBase.LayoutPointers.StrideIndex{1,(1,),1}((StaticInt{8}(),), (StaticInt{0}(),)))

  @inline function exp_hilo(x::Union{Float64,AbstractSIMD{<:Any,Float64}}, xlo::Union{Float64,AbstractSIMD{<:Any,Float64}}, ::Val{B}, ::False) where {B}
    N_float = muladd(x, VectorizationBase.LogBo256INV(Val{B}(), Float64), VectorizationBase.MAGIC_ROUND_CONST(Float64))
    N = VectorizationBase.target_trunc(reinterpret(UInt64, N_float))
    N_float = N_float - VectorizationBase.MAGIC_ROUND_CONST(Float64)
    r = VectorizationBase.fast_fma(N_float, VectorizationBase.LogBo256U(Val{B}(), Float64), x, fma_fast())
    r = VectorizationBase.fast_fma(N_float, VectorizationBase.LogBo256L(Val{B}(), Float64), r, fma_fast())
    # @show (N & 0x000000ff) % Int
    j = vload(base_exp_table_pointer(), (N & 0x000000ff,))
    jU = reinterpret(Float64, Base.Math.JU_CONST | (j&Base.Math.JU_MASK))
    jL = reinterpret(Float64, Base.Math.JL_CONST | (j >> 8))
    k = N >>> 0x00000008
    very_small = muladd(jU, VectorizationBase.expm1b_kernel(Val{B}(), r), jL)
    small_part = muladd(jU, xlo, very_small) + jU
    # small_part = reinterpret(UInt64, vfmadd(js, expm1b_kernel(Val{B}(), r), js))
    # return reinterpret(Float64, small_part), r, k, N_float, js
    twopk = (k % UInt64) << 0x0000000000000034
    res = reinterpret(Float64, twopk + reinterpret(UInt64, small_part))
    return res
  end
  @inline function exp_hilo(x::Union{Float64,AbstractSIMD{<:Any,Float64}}, xlo::Union{Float64,AbstractSIMD{<:Any,Float64}}, ::Val{B}, ::True) where {B}
    N_float = muladd(x, VectorizationBase.LogBo256INV(Val{B}(), Float64), VectorizationBase.MAGIC_ROUND_CONST(Float64))
    N = VectorizationBase.target_trunc(reinterpret(UInt64, N_float))
    N_float = N_float - VectorizationBase.MAGIC_ROUND_CONST(Float64)
    r = fma(N_float, VectorizationBase.LogBo256U(Val{B}(), Float64), x)
    r = fma(N_float, VectorizationBase.LogBo256L(Val{B}(), Float64), r)
    # @show (N & 0x000000ff) % Int
    # @show N N & 0x000000ff
    j = vload(base_exp_table_pointer(), (N & 0x000000ff,))
    jU = reinterpret(Float64, Base.Math.JU_CONST | (j&Base.Math.JU_MASK))
    jL = reinterpret(Float64, Base.Math.JL_CONST | (j >> 8))
    # @show N & 0x000000ff j jU jL
    # k = N >>> 0x00000008
    # small_part = reinterpret(UInt64, vfmadd(js, expm1b_kernel(Val{B}(), r), js))
    very_small = muladd(jU, VectorizationBase.expm1b_kernel(Val{B}(), r), jL)
    small_part = muladd(jU, xlo, very_small) + jU
    # small_part = vfmadd(js, expm1b_kernel(Val{B}(), r), js)
    # return reinterpret(Float64, small_part), r, k, N_float, js
    res = VectorizationBase.vscalef(small_part, 0.00390625*N_float)
    # twopk = (k % UInt64) << 0x0000000000000034
    # res = reinterpret(Float64, twopk + small_part)
    return res
  end
end


@inline function cbrt_kernel(x::FloatType64)
  c6 = -0.640245898480692909870982
  c5 = 2.96155103020039511818595
  c4 = -5.73353060922947843636166
  c3 = 6.03990368989458747961407
  c2 = -3.85841935510444988821632
  c1 = 2.2307275302496609725722
  evalpoly(x, (c1, c2, c3, c4, c5, c6))
end
@inline function cbrt_kernel(x::FloatType32)
  c6 = -0.601564466953277587890625f0
  c5 =  2.8208892345428466796875f0
  c4 = -5.532182216644287109375f0
  c3 =  5.898262500762939453125f0
  c2 = -3.8095417022705078125f0
  c1 =  2.2241256237030029296875f0
  evalpoly(x, (c1, c2, c3, c4, c5, c6))
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
  r = y / x
  ifelse(x == 0, y, x*sqrt(muladd(r,r, one(T))))
end
