
@generated function estrin(x, p::NTuple{N}) where {N}
    # N = length(p)
    # log2N = VectorizationBase.intlog2(N)
    ex = quote $(Expr(:meta,:inline)) end
    Nfrac1 = N >> 1
    nextp = :p_1_
    nextx = :x_1
    Nfrac1 > 1 && push!(ex.args, :( $nextx = x * x ))
    for n ∈ 1:Nfrac1
        push!(ex.args, :( $(Symbol(nextp,n)) = muladd(p[$(2n)],x,p[$(2n-1)]) ) )
    end
    oddNfrac = isodd(N)
    if oddNfrac
        Nfrac1 += 1
        push!(ex.args, :( $(Symbol(nextp,Nfrac1)) = p[$N]  ))
    end

    lastp = nextp
    lastx = nextx
    depth = 1
    while Nfrac1 > 1
    # while Nfrac1 > 1
        oddNfrac = isodd(Nfrac1)
        Nfrac1 >>= 1
        depth += 1
        nextp = Symbol(:p_, depth, :_)
        nextx = Symbol(:x_, depth)
        (Nfrac1 > 1 || oddNfrac) && push!(ex.args, :( $nextx = $lastx * $lastx ))
        for n ∈ 1:Nfrac1
            np = Symbol(nextp,n)
            # @show lastp, n
            lpu = Symbol(lastp,2n)
            lpl = Symbol(lastp,2n-1)
            push!(ex.args, :( $np = muladd($lpu,$lastx,$lpl) ) )
        end
        if oddNfrac
            Nfrac1 += 1
            push!(ex.args, :( $(Symbol(nextp,Nfrac1)) = $(Symbol(lastp,2Nfrac1-1)) ))
        end

        lastp = nextp
        lastx = nextx
    end
    ex
end

macro estrin(x, p...)
    t = Expr(:tuple); foreach(pᵢ -> push!(t.args, pᵢ), p)
    esc(Expr(:call, :estrin, x, t))
end

macro horner(x, p...)
    N = length(p)
    ex = Expr(:call, :muladd, p[N], x, p[N-1])
    for n ∈ 2:N-1
        ex = Expr(:call, :muladd, ex, x, p[N-n])
    end
    esc(ex)
end

@generated function evalpoly(x, p::Tuple{Vararg{Any,N}}) where {N}
    ex = Expr(:call, :muladd, Expr(:ref, :p, N), :x, Expr(:ref, :p, N-1))
    for n ∈ 2:N-1
        ex = Expr(:call, :muladd, ex, :x, Expr(:ref, :p, N - n))
    end
    Expr(:block, Expr(:meta, :inline), ex)
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


