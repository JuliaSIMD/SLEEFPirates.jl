

# @generated function estrin(x, p::NTuple{N}) where {N}
#     # N = length(p)
#     # log2N = VectorizationBase.intlog2(N)
#     ex = Expr(:block, Expr(:meta, :inline))
#     Nfrac1 = N >> 1
#     nextp = :p_1_
#     nextx = :x_1
#     Nfrac1 > 1 && push!(ex.args, :( $nextx = Base.FastMath.mul_fast(x, x)))
#     for n ∈ 1:Nfrac1
#         push!(ex.args, :( $(Symbol(nextp,n)) = muladd(p[$(2n)],x,p[$(2n-1)]) ) )
#     end
#     oddNfrac = isodd(N)
#     if oddNfrac
#         Nfrac1 += 1
#         push!(ex.args, :( $(Symbol(nextp,Nfrac1)) = p[$N]  ))
#     end

#     lastp = nextp
#     lastx = nextx
#     depth = 1
#     while Nfrac1 > 1
#     # while Nfrac1 > 1
#         oddNfrac = isodd(Nfrac1)
#         Nfrac1 >>= 1
#         depth += 1
#         nextp = Symbol(:p_, depth, :_)
#         nextx = Symbol(:x_, depth)
#         (Nfrac1 > 1 || oddNfrac) && push!(ex.args, :( $nextx = Base.FastMath.mul_fast($lastx, $lastx)))
#         for n ∈ 1:Nfrac1
#             np = Symbol(nextp,n)
#             # @show lastp, n
#             lpu = Symbol(lastp,2n)
#             lpl = Symbol(lastp,2n-1)
#             push!(ex.args, :( $np = muladd($lpu,$lastx,$lpl) ) )
#         end
#         if oddNfrac
#             Nfrac1 += 1
#             push!(ex.args, :( $(Symbol(nextp,Nfrac1)) = $(Symbol(lastp,2Nfrac1-1)) ))
#         end

#         lastp = nextp
#         lastx = nextx
#     end
#     ex
# end
# Given a `VecUnroll` argument, we'll instruction level parallelism that way and can thus forgo `estrin` 

# macro estrin(x, p...)
#     t = Expr(:tuple); foreach(pᵢ -> push!(t.args, pᵢ), p)
#     if __module__ == SLEEFPirates
#         esc(Expr(:call, :estrin, x, t))
#     else
#         esc(Expr(:call, Expr(:(.), :SLEEFPirates, QuoteNode(:estrin)), x, t))
#     end
# end

# macro horner(x, p...)
#     N = length(p)
#     ex = Expr(:call, :muladd, p[N], x, p[N-1])
#     for n ∈ 2:N-1
#         ex = Expr(:call, :muladd, ex, x, p[N-n])
#     end
#     esc(ex)
# end

@inline evalpoly(x, p::Tuple{T1}) where {T1} = only(p)
@inline evalpoly(x, p::Tuple{T1,T2}) where {T1,T2} = muladd(p[2], x, p[1])
@inline evalpoly(x, p::Tuple{T1,T2,T3,Vararg{Any,N}}) where {T1,T2,T3,N} = evalpoly(x, (ntuple(n -> p[n], Val(N+1))..., muladd(p[end], x, p[end-1])))

@inline estrin(x::VecUnroll, p::NTuple{N}) where {N} = evalpoly(x, p)
@inline estrin(x, p::Tuple{Vararg{Any,N}}) where {N} = estrin(x, p, StaticInt{N}() & StaticInt{3}(), lt(StaticInt{N}(), StaticInt(7)))
@inline estrin(x, p, r, ::True) = evalpoly(x, p)
@inline function estrin(x, p::Tuple{Vararg{Any,N}}, ::StaticInt{0}, ::False) where {N}
  x2 = Base.FastMath.mul_fast(x, x)
  x4 = Base.FastMath.mul_fast(x2, x2)
  res = muladd(x2, muladd(x, p[end], p[end-1]), muladd(x, p[end-2], p[end-3]))
  return _estrin(x, x2, x4, res, ntuple(n -> p[n], Val(N-4)))
end
@inline function estrin(x, p::Tuple{Vararg{Any,N}}, ::StaticInt{R}, ::False) where {N,R}
  x2 = Base.FastMath.mul_fast(x, x)
  x4 = Base.FastMath.mul_fast(x2, x2)
  res = evalpoly(x, p[N-R+1:N])
  return _estrin(x, x2, x4, res, ntuple(n -> p[n], Val(N-R)))
end
@inline function __estrin(x, x2, x4, ex, p1, p2, p3, p4)
    part = muladd(x2, muladd(x, p4, p3), muladd(x, p2, p1))
    muladd(x4, ex, part)
end
@inline _estrin(x, x2, x4, ex, p::Tuple{}) = ex
@inline function _estrin(x, x2, x4, ex, p::Tuple{T1,T2,T3,T4,Vararg{Any,N}}) where {T1,T2,T3,T4,N}
  ex = _estrin(x, x2, x4, ex, ntuple(n -> p[n+4], Val(N)))
  __estrin(x, x2, x4, ex, p[1], p[2], p[3], p[4])
end


# OscardSmith
# https://github.com/JuliaLang/julia/blob/3253fb5a60ad841965eb6bd218921d55101c0842/base/special/expm1.jl
@generated function exthorner(x, p::Tuple{Vararg{Any,N}}) where {N}
    # polynomial evaluation using compensated summation.
    # much more accurate, especially when lo can be combined with other rounding errors
    hi_old = Symbol(:hi_, N)
    q = Expr(:block, :($hi_old = p[$N]))
    lo_old = hi_old
    for n in N-1:-1:1
        pₙ = Symbol(:p_,n)
        prodₙ = Symbol(:prod_,n)
        errₙ = Symbol(:err_,n)
        hi = Symbol(:hi_,n)
        lo = Symbol(:lo_,n)
        push!(q.args, :($pₙ = p[$n]))
        push!(q.args, :($prodₙ = $hi_old*x))
        push!(q.args, :($errₙ = fma($hi_old, x, -$prodₙ)))
        push!(q.args, :($hi = $pₙ + $prodₙ))
        if lo_old === hi_old
            push!(q.args, :($lo = $prodₙ - ($hi - $pₙ) + $errₙ))
        else
            push!(q.args, :($lo = fma($lo_old, x, $prodₙ - ($hi - $pₙ) + $errₙ)))
        end
        hi_old = hi
        lo_old = lo
    end
    push!(q.args, Expr(:tuple, hi_old, lo_old))
    Expr(:block, Expr(:meta, :inline), q)
end


