import Base: -, <, copysign, flipsign, convert

const vIEEEFloat = Union{IEEEFloat,Vec{<:Any,<:IEEEFloat},VectorizationBase.VecUnroll{<:Any,<:Any,<:IEEEFloat}}

struct Double{T<:vIEEEFloat} <: Number
    hi::T
    lo::T
end
@inline Double(x::T) where {T<:vIEEEFloat} = Double(x, zero(T))
@inline function Double(x::Vec, y::Vec)
    Double(Vec(data(x)), Vec(data(y)))
end
@inline Base.convert(::Type{Double{V}}, v::Vec) where {W,T,V <: AbstractSIMD{W,T}} = Double(convert(V, v), vzero(V))
@inline Base.convert(::Type{Double{V}}, v::V) where {V <: AbstractSIMD} = Double(v, vzero(V))
# @inline Base.convert(::Type{Double{V}}, m::Mask) where {V} = m
# @inline Base.convert(::Type{Double{Mask{W,U}}}, m::Mask{W,U}) where {W,U} = m
@inline Base.convert(::Type{Double{V}}, d::Double{T}) where {W,T,V<:AbstractSIMD{W,T}} = Double(vbroadcast(Val{W}(), d.hi), vbroadcast(Val{W}(), d.lo))
@inline Base.eltype(d::Double) = eltype(d.hi)

(::Type{T})(x::Double{T}) where {T<:vIEEEFloat} = x.hi + x.lo

@inline Base.eltype(d::Double{T}) where {T <: IEEEFloat} = T
@inline function Base.eltype(d::Double{S}) where {N,T,S <: Union{Vec{N,T}, Vec{N,T}}}
    T
end
@inline ifelse(u::Mask, v1::Double, v2::Double) = Double(ifelse(u, v1.hi, v2.hi), ifelse(u, v1.lo, v2.lo))
@generated function ifelse(m::VecUnroll{N,W,T}, v1::Double{V1}, v2::Double{V2}) where {N,W,T,V1,V2}
    q = Expr(:block, Expr(:meta, :inline), :(md = m.data), :(v1h = v1.hi), :(v2h = v2.hi), :(v1l = v1.lo), :(v2l = v2.lo))
    if V1 <: VecUnroll
        push!(q.args, :(v1hd = v1h.data))
        push!(q.args, :(v1ld = v1l.data))
    end
    if V2 <: VecUnroll
        push!(q.args, :(v2hd = v2h.data))
        push!(q.args, :(v2ld = v2l.data))
    end
    th = Expr(:tuple); tl = Expr(:tuple)
    for n ∈ 1:N+1
        ifelseₕ = Expr(:call, :ifelse, Expr(:ref, :md, n))
        ifelseₗ = Expr(:call, :ifelse, Expr(:ref, :md, n))
        if V1 <: VecUnroll
            push!(ifelseₕ.args, Expr(:ref, :v1hd, n))
            push!(ifelseₗ.args, Expr(:ref, :v1ld, n))
        else
            push!(ifelseₕ.args, :v1h)
            push!(ifelseₗ.args, :v1l)
        end
        if V2 <: VecUnroll
            push!(ifelseₕ.args, Expr(:ref, :v2hd, n))
            push!(ifelseₗ.args, Expr(:ref, :v2ld, n))
        else
            push!(ifelseₕ.args, :v2h)
            push!(ifelseₕ.args, :v2l)
        end
        push!(th.args, ifelseₕ)
        push!(tl.args, ifelseₗ)
    end
    push!(q.args, :(Double(VecUnroll($th),VecUnroll($tl)))); q
end

@inline trunclo(x::Float64) = reinterpret(Float64, reinterpret(UInt64, x) & 0xffff_ffff_f800_0000) # clear lower 27 bits (leave upper 26 bits)
@inline trunclo(x::Float32) = reinterpret(Float32, reinterpret(UInt32, x) & 0xffff_f000) # clear lowest 12 bits (leave upper 12 bits)

# @inline trunclo(x::VecProduct) = trunclo(Vec(data(x)))
@inline function trunclo(x::AbstractSIMD{N,Float64}) where {N}
    reinterpret(Vec{N,Float64}, reinterpret(Vec{N,UInt64}, x) & vbroadcast(Val{N}(), 0xffff_ffff_f800_0000)) # clear lower 27 bits (leave upper 26 bits)
end
@inline function trunclo(x::AbstractSIMD{N,Float32}) where {N}
    reinterpret(Vec{N,Float32}, reinterpret(Vec{N,UInt32}, x) & vbroadcast(Val{N}(), 0xffff_f000)) # clear lowest 12 bits (leave upper 12 bits)
end
for (op,f,ff) ∈ [("fadd",:add_ieee,:(+)),("fsub",:sub_ieee,:(-)),("fmul",:mul_ieee,:(*)),("fdiv",:fdiv_ieee,:(/)),("frem",:rem_ieee,:(%))]
    @eval begin
        @generated $f(v1::Vec{W,T}, v2::Vec{W,T}) where {W,T<:Union{Float32,Float64}} = VectorizationBase.binary_op($op, W, T)
        @inline $f(s1::T, s2::T) where {T<:Union{Float32,Float64}} = $ff(s1,s2)
    end
end
@inline add_ieee(a, b, c) = add_ieee(add_ieee(a, b), c)
function sub_ieee!(ex)
    ex isa Expr || return
    if ex.head === :call
        _f = ex.args[1]
        if _f isa Symbol
            f::Symbol = _f
            if f === :(+)
                ex.args[1] = :add_ieee
            elseif f === :(-)
                ex.args[1] = :sub_ieee
            elseif f === :(*)
                ex.args[1] = :mul_ieee
            elseif f === :(/)
                ex.args[1] = :fdiv_ieee
            elseif f === :(%)
                ex.args[1] = :rem_ieee
            end
        end
    end
    foreach(sub_ieee!, ex.args)
end
macro ieee(ex)
    sub_ieee!(ex)
end


@inline function splitprec(x::vIEEEFloat)
    hx = trunclo(x)
    hx, x - hx
end

@inline function dnormalize(x::Double{T}) where {T}
    r = x.hi + x.lo
    Double(r, (x.hi - r) + x.lo)
end

@inline flipsign(x::Double{<:vIEEEFloat}, y::vIEEEFloat) = Double(flipsign(x.hi, y), flipsign(x.lo, y))

@inline scale(x::Double{<:vIEEEFloat}, s::vIEEEFloat) = Double(s * x.hi, s * x.lo)


@inline (-)(x::Double{T}) where {T<:vIEEEFloat} = Double(-x.hi, -x.lo)

@inline function (<)(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat})
    x.hi < y.hi
end

@inline function (<)(x::Double{<:vIEEEFloat}, y::Union{Number,Vec})
    x.hi < y
end

@inline function (<)(x::Union{Number,Vec}, y::Double{<:vIEEEFloat})
    x < y.hi
end

# quick-two-sum x+y
@inline function dadd(x::vIEEEFloat, y::vIEEEFloat) #WARNING |x| >= |y|
    s = x + y
    Double(s, ((x - s) + y))
end

@inline function dadd(x::vIEEEFloat, y::Double{<:vIEEEFloat}) #WARNING |x| >= |y|
    s = x + y.hi
    Double(s, (((x - s) + y.hi) + y.lo))
end

@inline function dadd(x::Double{<:vIEEEFloat}, y::vIEEEFloat) #WARNING |x| >= |y|
    s = x.hi + y
    Double(s, (((x.hi - s) + y) + x.lo))
end

@inline function dadd(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat}) #WARNING |x| >= |y|
    s = x.hi + y.hi
    Double(s, ((((x.hi - s) + y.hi) + y.lo) + x.lo))
end

@inline function dsub(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat}) #WARNING |x| >= |y|
    s = x.hi - y.hi
    Double(s, ((((x.hi - s) - y.hi) - y.lo) + x.lo))
end

@inline function dsub(x::Double{<:vIEEEFloat}, y::vIEEEFloat) #WARNING |x| >= |y|
    s = x.hi - y
    Double(s, (((x.hi - s) - y) + x.lo))
end

@inline function dsub(x::vIEEEFloat, y::Double{<:vIEEEFloat}) #WARNING |x| >= |y|
    s = x - y.hi
    Double(s, (((x - s) - y.hi - y.lo)))
end

@inline function dsub(x::vIEEEFloat, y::vIEEEFloat) #WARNING |x| >= |y|
    s = x - y
    Double(s, ((x - s) - y))
end


# two-sum x+y  NO BRANCH
@inline function dadd2(x::vIEEEFloat, y::vIEEEFloat)
    s = x + y
    v = s - x
    Double(s, ((x - (s - v)) + (y - v)))
end

@inline function dadd2(x::vIEEEFloat, y::Double{<:vIEEEFloat})
    s = x + y.hi
    v = s - x
    Double(s, (x - (s - v)) + (y.hi - v) + y.lo)
end

@inline dadd2(x::Double{<:vIEEEFloat}, y::vIEEEFloat) = dadd2(y, x)

@inline function dadd2(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat})
    s = (x.hi + y.hi)
    v = (s - x.hi)
    smv = (s - v)
    yhimv = (y.hi - v)
    Double(s, ((((x.hi - smv) + yhimv) + x.lo) + y.lo))
end

@inline function dsub2(x::vIEEEFloat, y::vIEEEFloat)
    s = x - y
    v = s - x
    Double(s, ((x - (s - v)) - (y + v)))
end

@inline function dsub2(x::vIEEEFloat, y::Double{<:vIEEEFloat})
    s = (x - y.hi)
    v = (s - x)
    Double(s, (((x - (s - v)) - (y.hi + v)) - y.lo))
end

@inline function dsub2(x::Double{<:vIEEEFloat}, y::vIEEEFloat)
    s = x.hi - y
    v = s - x.hi
    Double(s, (((x.hi - (s - v)) - (y + v)) + x.lo))
end

@inline function dsub2(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat})
    s = x.hi - y.hi
    v = s - x.hi
    Double(s, ((((x.hi - (s - v)) - (y.hi + v)) + x.lo) - y.lo))
end

@inline function ifelse(b::Mask{N}, x::Double{T1}, y::Double{T2}) where {N,T<:Union{Float32,Float64},T1<:Union{T,Vec{N,T}},T2<:Union{T,Vec{N,T}}}
    V = Vec{N,T}
    Double(ifelse(b, V(x.hi), V(y.hi)), ifelse(b, V(x.lo), V(y.lo)))
end

# two-prod-fma
@inline function dmul(x::vIEEEFloat, y::vIEEEFloat, ::True)
    z = (x * y)
    Double(z, vfmsub(x, y, z))
end
@inline function dmul(x::vIEEEFloat, y::vIEEEFloat, ::False)
    hx, lx = splitprec(x)
    hy, ly = splitprec(y)
    @ieee begin
        z = x * y
        Double(z, (((hx * hy - z) + lx * hy + hx * ly) + lx * ly))
    end
end
@inline function dmul(x::Double{<:vIEEEFloat}, y::vIEEEFloat, ::True)
    z = (x.hi * y)
    Double(z, vfmsub(x.hi, y, z) + x.lo * y)
end
@inline function dmul(x::Double{<:vIEEEFloat}, y::vIEEEFloat, ::False)
    hx, lx = splitprec(x.hi)
    hy, ly = splitprec(y)
    @ieee begin
        z = x.hi * y
        Double(z, (hx * hy - z) + lx * hy + hx * ly + lx * ly + x.lo * y)
    end
end
@inline function dmul(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat}, ::True)
    z = x.hi * y.hi
    Double(z, vfmsub(x.hi, y.hi, z) + x.hi * y.lo + x.lo * y.hi)
end
@inline function dmul(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat}, ::False)
    hx, lx = splitprec(x.hi)
    hy, ly = splitprec(y.hi)
    @ieee begin
    z = x.hi * y.hi
    Double(z, (((hx * hy - z) + lx * hy + hx * ly) + lx * ly) + x.hi * y.lo + x.lo * y.hi)
    end
end
@inline dmul(x::vIEEEFloat, y::Double{<:vIEEEFloat}) = dmul(y, x)
@inline dmul(x, y) = dmul(x, y, fma_fast())
    # x^2
@inline function dsqu(x::T, ::True) where {T<:vIEEEFloat}
    z = x * x
    Double(z, vfmsub(x, x, z))
end
@inline function dsqu(x::T, ::False) where {T<:vIEEEFloat}
    hx, lx = splitprec(x)
    @ieee begin
    z = x * x
    Double(z, (hx * hx - z) + lx * (hx + hx) + lx * lx)
    end
end
@inline function dsqu(x::Double{T}, ::True) where {T<:vIEEEFloat}
    z = x.hi * x.hi
    Double(z, vfmsub(x.hi, x.hi, z) + (x.hi * (x.lo + x.lo)))
end
@inline function dsqu(x::Double{T}, ::False) where {T<:vIEEEFloat}
    hx, lx = splitprec(x.hi)
    @ieee begin
    z = x.hi * x.hi
    Double(z, (hx * hx - z) + lx * (hx + hx) + lx * lx + x.hi * (x.lo + x.lo))
    end
end
@inline dsqu(x) = dsqu(x, fma_fast())

    # sqrt(x)
@inline function dsqrt(x::Double{T}, ::True) where {T<:vIEEEFloat}
    zhi = _sqrt(x.hi)
    Double(zhi, (x.lo + vfnmadd(zhi, zhi, x.hi)) / (zhi + zhi))
end
@inline function dsqrt(x::Double{T}, ::False) where {T<:vIEEEFloat}
    c = _sqrt(x.hi)
    u = dsqu(c, False())
    @ieee Double(c, (x.hi - u.hi - u.lo + x.lo) / (c + c))
end
@inline dsqrt(x) = dsqrt(x, fma_fast())

    # x/y
@inline function ddiv(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat}, ::True)
    invy = inv(y.hi)
    zhi = (x.hi * invy)
    Double(zhi, ((vfnmadd(zhi, y.hi, x.hi) + vfnmadd(zhi, y.lo, x.lo)) * invy))
end
@inline function ddiv(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat}, ::False)
    @ieee begin
        invy = one(y.hi) / y.hi
        c = x.hi * invy
        u = dmul(c, y.hi, False())
        Double(c, ((((x.hi - u.hi) - u.lo) + x.lo) - c * y.lo) * invy)
    end
end
@inline function ddiv(x::vIEEEFloat, y::vIEEEFloat, ::True)
    ry = inv(y)
    r = (x * ry)
    Double(r, (vfnmadd(r, y, x) * ry))
end
@inline function ddiv(x::vIEEEFloat, y::vIEEEFloat, ::False)
    @ieee begin
    ry = one(y) / y
    r = x * ry
    hx, lx = splitprec(r)
    hy, ly = splitprec(y)
    Double(r, (((-hx * hy + r * y) - lx * hy - hx * ly) - lx * ly) * ry)
    end
end
@inline ddiv(x, y) = ddiv(x, y, fma_fast())
    # 1/x
@inline function drec(x::vIEEEFloat, ::True)
    zhi = inv(x)
    Double(zhi, (vfnmadd(zhi, x, one(eltype(x))) * zhi))
end
@inline function drec(x::vIEEEFloat, ::False)
    @ieee begin
    c = one(x) / x
    u = dmul(c, x, False())
    Double(c, (one(eltype(u.hi)) - u.hi - u.lo) * c)
    end
end

@inline function drec(x::Double{<:vIEEEFloat}, ::True)
    zhi = inv(x.hi)
    Double(zhi, ((vfnmadd(zhi, x.hi, one(eltype(x))) - (zhi * x.lo)) * zhi))
end
@inline function drec(x::Double{<:vIEEEFloat}, ::False)
    @ieee begin
    c = inv(x.hi)
    u = dmul(c, x.hi, False())
    Double(c, (one(eltype(u.hi)) - u.hi - u.lo - c * x.lo) * c)
    end
end
@inline drec(x) = drec(x, fma_fast())
