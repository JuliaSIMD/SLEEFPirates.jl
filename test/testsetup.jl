
using SLEEFPirates, VectorizationBase, Aqua
using VectorizationBase: data
using Test

using Base.Math: significand_bits

isnzero(x::T) where {T <: AbstractFloat} = signbit(x)
ispzero(x::T) where {T <: AbstractFloat} = !signbit(x)

function cmpdenorm(x::Tx, y::Ty) where {Tx <: AbstractFloat, Ty <: AbstractFloat}
    sizeof(Tx) < sizeof(Ty) ? y = Tx(y) : x = Ty(x) # cast larger type to smaller type
    (isnan(x) && isnan(y)) && return true
    (isnan(x) || isnan(y)) && return false
    (isinf(x) != isinf(y)) && return false
    (x == Tx(Inf)  && y == Ty(Inf))  && return true
    (x == Tx(-Inf) && y == Ty(-Inf)) && return true
    if y == 0
        (ispzero(x) && ispzero(y)) && return true
        (isnzero(x) && isnzero(y)) && return true
        return false
    end
    (!isnan(x) && !isnan(y) && !isinf(x) && !isinf(y)) && return sign(x) == sign(y)
    return false
end

# the following compares the ulp between x and y.
# First it promotes them to the larger of the two types x,y
const infh(::Type{Float64}) = 1e300
const infh(::Type{Float32}) = 1e37
function countulp(T, x::AbstractFloat, y::AbstractFloat)
    X, Y = promote(x, y)
    x, y = T(X), T(Y) # Cast to smaller type
    (isnan(x) && isnan(y)) && return 0
    (isnan(x) || isnan(y)) && return 10000
    if isinf(x)
        (sign(x) == sign(y) && abs(y) > infh(T)) && return 0 # relaxed infinity handling
        return 10001
    end
    (x ==  Inf && y ==  Inf) && return 0
    (x == -Inf && y == -Inf) && return 0
    if y == 0
        x == 0 && return 0
        return 10002
    end
    if isfinite(x) && isfinite(y)
        return T(abs(X - Y) / ulp(y))
    end
    return 10003
end

const DENORMAL_MIN(::Type{Float64}) = 2.0^-1074
const DENORMAL_MIN(::Type{Float32}) = 2f0^-149

function ulp(x::T) where {T<:AbstractFloat}
    x = abs(x)
    x == T(0.0) && return DENORMAL_MIN(T)
    val, e = frexp(x)
    return max(ldexp(T(1.0), e - significand_bits(T) - 1), DENORMAL_MIN(T))
end

countulp(x::T, y::T) where {T <: AbstractFloat} = countulp(T, x, y)

# get rid off annoying warnings from overwritten function
macro nowarn(expr)
    quote
        _stderr = stderr
        tmp = tempname()
        stream = open(tmp, "w")
        redirect_stderr(stream)
        result = $(esc(expr))
        redirect_stderr(_stderr)
        close(stream)
        result
    end
end

# overide domain checking that base adheres to
using Base.MPFR: ROUNDING_MODE
for f in (:sin, :cos, :tan, :asin, :acos, :atan, :asinh, :acosh, :atanh, :log, :log10, :log2, :log1p)
    @eval begin
        import Base.$f
        @nowarn function ($f)(x::BigFloat)
            z = BigFloat()
            ccall($(string(:mpfr_, f), :libmpfr), Int32, (Ref{BigFloat}, Ref{BigFloat}, Int32), z, x, ROUNDING_MODE[])
            return z
        end
    end
end

strip_module_name(f::Function) = last(split(string(f), '.')) # strip module name from function f

MRANGE(::Type{Float64}) = 10000000
MRANGE(::Type{Float32}) = 10000
IntF(::Type{Float64}) = Int64
IntF(::Type{Float32}) = Int32

function tovector(u::VectorizationBase.VecUnroll{_N,W,T}) where {_N,W,T}
    N = _N + 1; i = 0
    x = Vector{T}(undef, N * W)
    for n ∈ 1:N
        v = data(u)[n]
        for w ∈ 0:W-1
            x[(i += 1)] = VectorizationBase.extractelement(v, w)
        end
    end
    x
end
tovector(v::VectorizationBase.AbstractSIMDVector{W}) where {W} = [VectorizationBase.extractelement(v,w) for w ∈ 0:W-1]

function test_vector(xfun, fun, ::Union{Val{W},SLEEFPirates.VectorizationBase.StaticInt{W}}, xf::T, xl::T, tol) where {W,T<:Number}
    xf = nextfloat(xf); xl = prevfloat(xl);
    δ = xl - xf
    loginputs = (δ > 1e3) & (xf > 0)
    if loginputs
        xf = log(xf)
        δ = log(xl) - xf
    end
    denom = 5W + 1
    vxes1 = Vec(ntuple(w -> Core.VecElement{T}(xf + δ * (w / denom)), Val(W)))
    vu = VectorizationBase.VecUnroll((
        Vec(ntuple(w -> Core.VecElement{T}(xf + δ * (( W + w) / denom)), Val(W))),
        Vec(ntuple(w -> Core.VecElement{T}(xf + δ * ((2W + w) / denom)), Val(W))),
        Vec(ntuple(w -> Core.VecElement{T}(xf + δ * ((3W + w) / denom)), Val(W))),
        Vec(ntuple(w -> Core.VecElement{T}(xf + δ * ((4W + w) / denom)), Val(W)))
    ))
    if loginputs
        vxes1 = exp(vxes1)
        vu = exp(vu)
    end
    t1 = tovector(xfun(vxes1));
    # @show xf, xl
    t2 = T.(fun.(big.(tovector(vxes1))));
    # if t1 ≉ t2
        # @show vxes1
    # end
    # @test t1 ≈ t2
    # @show W
    @test maximum(countulp.(t1, t2)) ≤ tol
    tu1 = tovector(xfun(vu));
    tu2 = T.(fun.(big.(tovector(vu))));
    @test maximum(countulp.(tu1, tu2)) ≤ tol
    # @test tu1 ≈ tu2
end
vbig(x) = big.(x)
function test_vector(xfun, fun, ::Union{Val{W},SLEEFPirates.VectorizationBase.StaticInt{W}}, xf::NTuple{N,T}, xl::NTuple{N,T}, tol) where {W,N,T}
    xf = nextfloat.(xf); xl = prevfloat.(xl);
    δ = xl .- xf
    denom = 5W + 1
    loginputs = any(δ .> 1e3) && all(xf .> -1)
    if loginputs
        xf = log.(xf)
        δ = log.(xl) .- xf
    end
    vxes1 = ntuple(Val(N)) do n
        Vec(ntuple(w -> Core.VecElement{T}(xf[n] + δ[n] * (w / denom)), Val(W)))
    end
    vu = ntuple(Val(N)) do n
        VectorizationBase.VecUnroll((
            Vec(ntuple(w -> T(xf[n] + δ[n] * (( W + w) / denom)), Val(W))...),
            Vec(ntuple(w -> T(xf[n] + δ[n] * ((2W + w) / denom)), Val(W))...),
            Vec(ntuple(w -> T(xf[n] + δ[n] * ((3W + w) / denom)), Val(W))...),
            Vec(ntuple(w -> T(xf[n] + δ[n] * ((4W + w) / denom)), Val(W))...)
        ))
    end
    if loginputs
        vxes1 = exp.(vxes1)
        vu = exp.(vu)
    end
    t1 = tovector(xfun(vxes1...))
    t2 = T.(fun.(vbig.(tovector.(vxes1))...))
    # if t1 ≉ t2
        # @show vxes1
    # end
    @test maximum(countulp.(t1, t2)) ≤ tol
    # @test t1 ≈ t2
    tu1 = tovector(xfun(vu...))
    tu2 = T.(fun.(vbig.(tovector.(vu))...))
    @test maximum(countulp.(tu1, tu2)) ≤ tol
    # @test tu1 ≈ tu2
end

# test the accuracy of a function where fun_table is a Dict mapping the function you want
# to test to a reference function
# xx is an array of values (which may be tuples for multiple arugment functions)
# tol is the acceptable tolerance to test against
function test_acc(T, fun_table, xx, tol; debug = false, tol_debug = 5)
    @testset "accuracy $(strip_module_name(xfun))" for (xfun, fun) in fun_table

        rmax = 0.0
        rmean = 0.0
        xmax = map(zero, first(xx))
        for x in xx
            q = xfun(x...)
            c = fun(map(BigFloat, x)...)
            u = countulp(T, q, c)
            rmax = max(rmax, u)
            xmax = rmax == u ? x : xmax
            rmean += u
            if debug && u > tol_debug
                @show strip_module_name(xfun), q, strip_module_name(fun), T(c), x, ulp(T(c))
            end
        end
        rmean = rmean / length(xx)

        t = @test trunc(rmax, digits=1) <= tol

        
        fmtxloc = isa(xmax, Tuple) ? join(xmax, ", ") : string(xmax)
        println(
            rpad(strip_module_name(xfun), 18, " "), ": max ", rmax,
            rpad(" at x = " * fmtxloc, 40, " "),  ": mean ", rmean
        )

        # Vector test is mostly to make sure that they do not error
        # Results should either be the same as scalar
        # Or they're from another library (e.g., GLIBC), and may differ slighlty
        W = VectorizationBase.pick_vector_width(T)
        test_vector(xfun, fun, W, first(xx), last(xx), tol)
        test_vector(xfun, fun, Val(2), first(xx), last(xx), tol)
        if W ≥ 4
            test_vector(xfun, fun, Val(4), first(xx), last(xx), tol)
        end
        if W ≥ 8
            # test_vector(xfun, fun, Val(6), first(xx), last(xx), tol)
            test_vector(xfun, fun, Val(8), first(xx), last(xx), tol)
        end
        if W ≥ 16
            test_vector(xfun, fun, Val(16), first(xx), last(xx), tol)
        end
    end
end

