using SLEEFPirates, VectorizationBase
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

function test_vector(xfun, fun, ::Val{W}, x1::T) where {W,T<:Number}
    offset = x1 < 1 ? 0 : 1
    vxes1 = SVec(ntuple(w -> Core.VecElement{T}(offset + w / (W + 1)), Val(W)))
    v1 = xfun(vxes1)
    t2 = ntuple(w -> T(fun(offset + big(w) / (W + 1))), Val(W))
    t1 = ntuple(w -> v1[w], Val(W))
    @test all(t1 .≈ t2)
end
function test_vector(xfun, fun, ::Val{W}, ::NTuple{N,T}) where {W,N,T}
    if VERSION < v"1.3" && !ispow2(W)
        return
    end
    vxes1 = ntuple(i -> SVec(ntuple(w -> Core.VecElement{T}(w + i), Val(W))), Val(N))
    v1 = xfun(vxes1...)
    t2 = ntuple(w -> T(fun(ntuple(n -> big(n)+w, Val(N))...)), Val(W))
    t1 = ntuple(w -> v1[w], length(v1))
    @test all(t1 .≈ t2)
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
        test_vector(xfun, fun, VectorizationBase.pick_vector_width_val(T), first(xx))
        test_vector(xfun, fun, Val(2), first(xx))
        test_vector(xfun, fun, Val(4), first(xx))
        test_vector(xfun, fun, Val(6), first(xx))
        test_vector(xfun, fun, Val(8), first(xx))
        test_vector(xfun, fun, Val(16), first(xx))
    end
end

function runtests()
    @testset "SLEEFPirates" begin
        @test isempty(detect_unbound_args(SLEEFPirates))
        # include("exceptional.jl")
        include("accuracy.jl")
    end
end

runtests()


