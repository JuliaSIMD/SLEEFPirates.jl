import Base: -, <, copysign, flipsign, convert

const vIEEEFloat = Union{IEEEFloat,SVec{<:Any,<:IEEEFloat}}#,SIMDPirates.SVecProduct{<:Any,<:IEEEFloat}}

struct Double{T<:vIEEEFloat} <: Number
    hi::T
    lo::T
end
@inline Double(x::T) where {T<:vIEEEFloat} = Double(x, zero(T))
# @inline Double(x::T) where {T<:SIMDPirates.SVecProduct} = Double(SVec(SIMDPirates.extract_data(x)), zero(T))
@inline function Double(x::SIMDPirates.SVec, y::SIMDPirates.SVec)
    Double(SVec(SIMDPirates.extract_data(x)), SVec(SIMDPirates.extract_data(y)))
end
@inline SIMDPirates.promote_vtype(::Type{Mask{W,U}}, ::Type{Double{V}}) where {W, U, T, V <: SIMDPirates.AbstractSIMDVector{W,T}} = Double{V}
@inline SIMDPirates.promote_vtype(::Type{Double{V}}, ::Type{Mask{W,U}}) where {W, U, T, V <: SIMDPirates.AbstractSIMDVector{W,T}} = Double{V}
@inline SIMDPirates.promote_vtype(::Type{Mask{W,U}}, ::Type{Double{T}}) where {W, U, T <: Number} = Double{SVec{W,T}}
@inline SIMDPirates.promote_vtype(::Type{Double{T}}, ::Type{Mask{W,U}}) where {W, U, T <: Number} = Double{SVec{W,T}}
@inline SIMDPirates.vconvert(::Type{Double{V}}, v::SVec) where {W,T,V <: SIMDPirates.AbstractSIMDVector{W,T}} = Double(vconvert(V, v), vzero(V))
@inline SIMDPirates.vconvert(::Type{Double{V}}, v::V) where {V <: SIMDPirates.AbstractSIMDVector} = Double(v, vzero(V))
@inline SIMDPirates.vconvert(::Type{Double{V}}, m::Mask) where {V} = m
@inline SIMDPirates.vconvert(::Type{Double{V}}, d::Double{T}) where {W,T,V<:SIMDPirates.AbstractSIMDVector{W,T}} = Double(vbroadcast(V, d.hi), vbroadcast(V, d.lo))

(::Type{T})(x::Double{T}) where {T<:vIEEEFloat} = x.hi + x.lo

@inline Base.eltype(d::Double{T}) where {T <: IEEEFloat} = T
@inline function Base.eltype(d::Double{S}) where {N,T,S <: Union{SVec{N,T}, SIMDPirates.SVec{N,T}}}
    T
end
@inline SIMDPirates.vifelse(u::Unsigned, v1::Double, v2::Double) = Double(vifelse(u, v1.hi, v2.hi), vifelse(u, v1.lo, v2.lo))
@inline SIMDPirates.vifelse(u::Mask, v1::Double, v2::Double) = Double(vifelse(u.u, v1.hi, v2.hi), vifelse(u.u, v1.lo, v2.lo))

@inline trunclo(x::Float64) = reinterpret(Float64, reinterpret(UInt64, x) & 0xffff_ffff_f800_0000) # clear lower 27 bits (leave upper 26 bits)
@inline trunclo(x::Float32) = reinterpret(Float32, reinterpret(UInt32, x) & 0xffff_f000) # clear lowest 12 bits (leave upper 12 bits)

# @inline trunclo(x::SIMDPirates.SVecProduct) = trunclo(SVec(SIMDPirates.extract_data(x)))
@inline function trunclo(x::SVec{N,Float64}) where {N}
    reinterpret(SVec{N,Float64}, reinterpret(SVec{N,UInt64}, x) & vbroadcast(SVec{N,UInt64}, 0xffff_ffff_f800_0000)) # clear lower 27 bits (leave upper 26 bits)
end
@inline function trunclo(x::SVec{N,Float32}) where {N}
    reinterpret(SVec{N,Float32}, reinterpret(SVec{N,UInt32}, x) & vbroadcast(SVec{N,UInt32}, 0xffff_f000)) # clear lowest 12 bits (leave upper 12 bits)
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

@inline function (<)(x::Double{<:vIEEEFloat}, y::Union{Number,SVec})
    x.hi < y
end

@inline function (<)(x::Union{Number,SVec}, y::Double{<:vIEEEFloat})
    x < y.hi
end

# quick-two-sum x+y
@inline function dadd(x::vIEEEFloat, y::vIEEEFloat) #WARNING |x| >= |y|
    s = x + y
    Double(s, SIMDPirates.evsub(x, s) + y)
end

@inline function dadd(x::vIEEEFloat, y::Double{<:vIEEEFloat}) #WARNING |x| >= |y|
    s = x + y.hi
    Double(s, SIMDPirates.evsub(x, s) + y.hi + y.lo)
end

@inline function dadd(x::Double{<:vIEEEFloat}, y::vIEEEFloat) #WARNING |x| >= |y|
    s = x.hi + y
    Double(s, SIMDPirates.evsub(x.hi, s) + y + x.lo)
end

@inline function dadd(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat}) #WARNING |x| >= |y|
    s = x.hi + y.hi
    Double(s, SIMDPirates.evsub(x.hi, s) + y.hi + y.lo + x.lo)
end

@inline function dsub(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat}) #WARNING |x| >= |y|
    s = x.hi - y.hi
    Double(s, SIMDPirates.evsub(x.hi, s) - y.hi - y.lo + x.lo)
end

@inline function dsub(x::Double{<:vIEEEFloat}, y::vIEEEFloat) #WARNING |x| >= |y|
    s = x.hi - y
    Double(s, SIMDPirates.evsub(x.hi, s) - y + x.lo)
end

@inline function dsub(x::vIEEEFloat, y::Double{<:vIEEEFloat}) #WARNING |x| >= |y|
    s = x - y.hi
    Double(s, SIMDPirates.evsub(x, s) - y.hi - y.lo)
end

@inline function dsub(x::vIEEEFloat, y::vIEEEFloat) #WARNING |x| >= |y|
    s = x - y
    Double(s, SIMDPirates.evsub(x, s) - y)
end


# two-sum x+y  NO BRANCH
@inline function dadd2(x::vIEEEFloat, y::vIEEEFloat)
    s = x + y
    v = SIMDPirates.evsub(s, x)
    Double(s, SIMDPirates.evsub(x, SIMDPirates.evsub(s, v)) + SIMDPirates.evsub(y, v))
end

@inline function dadd2(x::vIEEEFloat, y::Double{<:vIEEEFloat})
    s = x + y.hi
    v = s - x
    Double(s, SIMDPirates.evsub(x, SIMDPirates.evsub(s, v)) + SIMDPirates.evsub(y.hi, v) + y.lo)
end

@inline dadd2(x::Double{<:vIEEEFloat}, y::vIEEEFloat) = dadd2(y, x)

@inline function dadd2(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat})
    s = x.hi + y.hi
    v = SIMDPirates.evsub(s, x.hi)
    smv = SIMDPirates.evsub(s, v)
    yhimv = SIMDPirates.evsub(y.hi, v)
    Double(s, SIMDPirates.evsub(x.hi, smv) + (yhimv) + x.lo + y.lo)
end

@inline function dsub2(x::vIEEEFloat, y::vIEEEFloat)
    s = x - y
    v = s - x
    Double(s, SIMDPirates.evsub(x, SIMDPirates.evsub(s, v)) + SIMDPirates.evsub(-y, v))
end

@inline function dsub2(x::vIEEEFloat, y::Double{<:vIEEEFloat})
    s = x - y.hi
    v = s - x
    Double(s, SIMDPirates.evsub(x, SIMDPirates.evsub(s, v)) + SIMDPirates.evsub(-y.hi, v) - y.lo)
end

@inline function dsub2(x::Double{<:vIEEEFloat}, y::vIEEEFloat)
    s = x.hi - y
    v = s - x.hi
    Double(s, SIMDPirates.evsub(x.hi, SIMDPirates.evsub(s, v)) + SIMDPirates.evsub(-y, v) + x.lo)
end

@inline function dsub2(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat})
    s = x.hi - y.hi
    v = s - x.hi
    Double(s, SIMDPirates.evsub(x.hi, SIMDPirates.evsub(s, v)) + SIMDPirates.evsub(-y.hi, v) + x.lo - y.lo)
end

@inline function SIMDPirates.vifelse(b::SVec{N,Bool}, x::Double{T1}, y::Double{T2}) where {N,T<:Union{Float32,Float64},T1<:Union{T,SVec{N,T}},T2<:Union{T,SVec{N,T}}}
    V = SVec{N,T}
    Double(vifelse(b, V(x.hi), V(y.hi)), vifelse(b, V(x.lo), V(y.lo)))
end

if FMA_FAST

    # two-prod-fma
    @inline function dmul(x::vIEEEFloat, y::vIEEEFloat)
        z = x * y
        Double(z, fma(x, y, -z))
    end

    @inline function dmul(x::Double{<:vIEEEFloat}, y::vIEEEFloat)
        z = x.hi * y
        Double(z, fma(x.hi, y, -z) + x.lo * y)
    end

    @inline dmul(x::vIEEEFloat, y::Double{<:vIEEEFloat}) = dmul(y, x)

    @inline function dmul(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat})
        z = x.hi * y.hi
        Double(z, fma(x.hi, y.hi, -z) + x.hi * y.lo + x.lo * y.hi)
    end

    # x^2
    @inline function dsqu(x::T) where {T<:vIEEEFloat}
        z = x * x
        Double(z, fma(x, x, -z))
    end

    @inline function dsqu(x::Double{T}) where {T<:vIEEEFloat}
        z = x.hi * x.hi
        Double(z, fma(x.hi, x.hi, -z) + x.hi * (x.lo + x.lo))
    end

    # sqrt(x)
    @inline function dsqrt(x::Double{T}) where {T<:vIEEEFloat}
        zhi = _sqrt(x.hi)
        Double(zhi, (x.lo + fma(-zhi, zhi, x.hi)) / (zhi + zhi))
    end

    # x/y
    @inline function ddiv(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat})
        invy = 1 / y.hi
        zhi = x.hi * invy
        Double(zhi, SIMDPirates.evmul((fma(-zhi, y.hi, x.hi) + fma(-zhi, y.lo, x.lo)), invy))
    end

    @inline function ddiv(x::vIEEEFloat, y::vIEEEFloat)
        ry = 1 / y
        r = x * ry
        Double(r, SIMDPirates.evmul(SIMDPirates.vfnmadd(r, y, x), ry))
        # Double(r, SIMDPirates.evmul(fma(-r, y, x), ry))
    end

    # 1/x
    @inline function drec(x::vIEEEFloat)
        zhi = 1 / x
        Double(zhi, fma(-zhi, x, one(eltype(x))) * zhi)
    end

    @inline function drec(x::Double{<:vIEEEFloat})
        zhi = 1 / x.hi
        Double(zhi, (fma(-zhi, x.hi, one(eltype(x))) + -zhi * x.lo) * zhi)
    end

else

    #two-prod x*y
    @inline function dmul(x::vIEEEFloat, y::vIEEEFloat)
        hx, lx = splitprec(x)
        hy, ly = splitprec(y)
        z = x * y
        Double(z, ((hx * hy - z) + lx * hy + hx * ly) + lx * ly)
    end

    @inline function dmul(x::Double{<:vIEEEFloat}, y::vIEEEFloat)
        hx, lx = splitprec(x.hi)
        hy, ly = splitprec(y)
        z = x.hi * y
        Double(z, (hx * hy - z) + lx * hy + hx * ly + lx * ly + x.lo * y)
    end

    @inline dmul(x::vIEEEFloat, y::Double{<:vIEEEFloat}) = dmul(y, x)

    @inline function dmul(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat})
        hx, lx = splitprec(x.hi)
        hy, ly = splitprec(y.hi)
        z = x.hi * y.hi
        Double(z, (((hx * hy - z) + lx * hy + hx * ly) + lx * ly) + x.hi * y.lo + x.lo * y.hi)
    end

    # x^2
    @inline function dsqu(x::T) where {T<:vIEEEFloat}
        hx, lx = splitprec(x)
        z = x * x
        Double(z, (hx * hx - z) + lx * (hx + hx) + lx * lx)
    end

    @inline function dsqu(x::Double{T}) where {T<:vIEEEFloat}
        hx, lx = splitprec(x.hi)
        z = x.hi * x.hi
        Double(z, (hx * hx - z) + lx * (hx + hx) + lx * lx + x.hi * (x.lo + x.lo))
    end

    # sqrt(x)
    @inline function dsqrt(x::Double{T}) where {T<:vIEEEFloat}
        c = _sqrt(x.hi)
        u = dsqu(c)
        Double(c, (x.hi - u.hi - u.lo + x.lo) / (c + c))
    end

    # x/y
    @inline function ddiv(x::Double{<:vIEEEFloat}, y::Double{<:vIEEEFloat})
        invy = 1 / y.hi
        c = x.hi * invy
        u = dmul(c, y.hi)
        Double(c, ((((x.hi - u.hi) - u.lo) + x.lo) - c * y.lo) * invy)
    end

    @inline function ddiv(x::vIEEEFloat, y::vIEEEFloat)
        ry = 1 / y
        r = x * ry
        hx, lx = splitprec(r)
        hy, ly = splitprec(y)
        Double(r, (((-hx * hy + r * y) - lx * hy - hx * ly) - lx * ly) * ry)
    end


    # 1/x
    @inline function drec(x::T) where {T<:vIEEEFloat}
        c = 1 / x
        u = dmul(c, x)
        Double(c, (one(T) - u.hi - u.lo) * c)
    end

    @inline function drec(x::Double{T}) where {T<:vIEEEFloat}
        c = 1 / x.hi
        u = dmul(c, x.hi)
        Double(c, (one(T) - u.hi - u.lo - c * x.lo) * c)
    end

end
