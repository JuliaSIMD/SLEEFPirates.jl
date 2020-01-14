
@generated function estrin(x, p::NTuple{N,T}) where {T,N}
    # N = length(p)
    # log2N = VectorizationBase.intlog2(N)
    ex = quote $(Expr(:meta,:inline)) end
    Nfrac1 = N >> 1
    nextp = :p_1_
    nextx = :x_1
    Nfrac1 > 1 && push!(ex.args, :( $nextx = SIMDPirates.vmul(x,x) ))
    for n ∈ 1:Nfrac1
        push!(ex.args, :( $(Symbol(nextp,n)) = SIMDPirates.vmuladd(p[$(2n)],x,p[$(2n-1)]) ) )
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
        (Nfrac1 > 1 || oddNfrac) && push!(ex.args, :( $nextx = SIMDPirates.vmul($lastx, $lastx) ))
        for n ∈ 1:Nfrac1
            np = Symbol(nextp,n)
            # @show lastp, n
            lpu = Symbol(lastp,2n)
            lpl = Symbol(lastp,2n-1)
            push!(ex.args, :( $np = SIMDPirates.vmuladd($lpu,$lastx,$lpl) ) )
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


macro estrin(x, p...)#::Vararg{N}) where {N}
    esc(Expr(:call, :estrin, x, Expr(:tuple, p...)))
    # esc(:(_estrin($x, $p)))
end

macro horner(x, p...)
    N = length(p)
    ex = Expr(:call, :vmuladd, p[N], x, p[N-1])
    for n ∈ 2:N-1
        ex = Expr(:call, :vmuladd, ex, x, p[N-n])
    end
    esc(ex)
end
