

@testset "Accuracy (max error in ulp) for $T" for T in (Float32, Float64)
    println("Accuracy tests for $T")


    xx = nextfloat(SLEEFPirates.VectorizationBase.MIN_EXP(Val(ℯ),T)):T(0.02):prevfloat(SLEEFPirates.VectorizationBase.MAX_EXP(Val(ℯ),T));
    # xx = T == Float32 ? map(T, vcat(-10:0.0002:10, -50:0.1:50)) : map(T, vcat(-10:0.0002:10, -705:0.1:705))
    fun_table = Dict(SLEEFPirates.exp => Base.exp)
    tol = 3
    test_acc(T, fun_table, xx, tol)


    xx = map(T, vcat(-10:0.0002:10, -1000:0.02:1000));
    fun_table = Dict(SLEEFPirates.asinh => Base.asinh)
    tol = if !Bool(SLEEFPirates.fma_fast()) && T == Float32 #FIXME
        70
    else
        2
    end
    test_acc(T, fun_table, xx, tol)
    
    xx = map(T, -1:0.001:1)
    fun_table = Dict(SLEEFPirates.atanh => Base.atanh)
    tol = 1
    test_acc(T, fun_table, xx, tol)


    xx = map(T, vcat(1:0.0002:10, 1:0.02:1000));
    fun_table = Dict(SLEEFPirates.acosh => Base.acosh)
    tol = 1
    test_acc(T, fun_table, xx, tol)


    xx = T[]
    for i = 1:10000
        s = reinterpret(T, reinterpret(IntF(T), T(pi)/4 * i) - IntF(T)(20))
        e = reinterpret(T, reinterpret(IntF(T), T(pi)/4 * i) + IntF(T)(20))
        d = s
        while d <= e
            append!(xx, d)
            d = reinterpret(T, reinterpret(IntF(T), d) + IntF(T)(1))
        end
    end
    xx = append!(xx, -10:0.0002:10);
    xx = append!(xx, -MRANGE(T):200.1:MRANGE(T));

    fun_table = Dict(SLEEFPirates.sin => Base.sin, SLEEFPirates.cos => Base.cos, SLEEFPirates.tan => Base.tan)
    tol = 1
    test_acc(T, fun_table, xx, tol)

    fun_table = Dict(SLEEFPirates.sin_fast => Base.sin, SLEEFPirates.cos_fast => Base.cos, SLEEFPirates.tan_fast => Base.tan)
    tol = 4
    test_acc(T, fun_table, xx, tol)

    global sin_sincos_fast(x) = (SLEEFPirates.sincos_fast(x))[1]
    global cos_sincos_fast(x) = (SLEEFPirates.sincos_fast(x))[2]
    fun_table = Dict(sin_sincos_fast => Base.sin, cos_sincos_fast => Base.cos)
    tol = 4
    test_acc(T, fun_table, xx, tol)

    global sin_sincos(x) = (SLEEFPirates.sincos(x))[1]
    global cos_sincos(x) = (SLEEFPirates.sincos(x))[2]
    fun_table = Dict(sin_sincos => Base.sin, cos_sincos => Base.cos)
    tol = 1
    test_acc(T, fun_table, xx, tol)


    xx = map(T, vcat(-1:0.00002:1));
    fun_table = Dict(SLEEFPirates.asin_fast => Base.asin, SLEEFPirates.acos_fast => Base.acos)
    tol = 3
    test_acc(T, fun_table, xx, tol)

    fun_table = Dict(SLEEFPirates.asin => asin, SLEEFPirates.acos => Base.acos)
    tol = 1
    test_acc(T, fun_table, xx, tol)


    xx = map(T, vcat(-10:0.0002:10, -10000:0.2:10000, -10000:0.201:10000));
    fun_table = Dict(SLEEFPirates.atan_fast => Base.atan)
    tol = 3
    test_acc(T, fun_table, xx, tol)

    fun_table = Dict(SLEEFPirates.atan => Base.atan)
    tol = 1
    test_acc(T, fun_table, xx, tol)


    xx1 = map(Tuple{T,T}, [zip(-10:0.050:10, -10:0.050:10)...]);
    xx2 = map(Tuple{T,T}, [zip(-10:0.051:10, -10:0.052:10)...]);
    xx3 = map(Tuple{T,T}, [zip(-100:0.51:100, -100:0.51:100)...]);
    xx4 = map(Tuple{T,T}, [zip(-100:0.51:100, -100:0.52:100)...]);
    txx = vcat(xx1, xx2, xx3, xx4);

    fun_table = Dict(SLEEFPirates.atan_fast => Base.atan)
    tol = 2.5
    test_acc(T, fun_table, txx, tol)

    fun_table = Dict(SLEEFPirates.atan => Base.atan)
    tol = 1
    test_acc(T, fun_table, txx, tol)

    opoextrema = 1000# min(1000, floor(Int, log(prevfloat(T(Inf)))/T(log(1.1))))
    tpoextrema = 1000# min(1000, floor(Int, log(prevfloat(T(Inf)))/T(log(2.1))))
    xx = map(T, vcat(0.0001:0.0001:10, 0.001:0.1:10000, 1.1.^(-opoextrema:opoextrema), 2.1.^(-tpoextrema:tpoextrema)));
    fun_table = Dict(SLEEFPirates.log_fast => Base.log)
    tol = 3
    test_acc(T, fun_table, xx, tol)

    fun_table = Dict(SLEEFPirates.log => Base.log)
    tol = 1
    test_acc(T, fun_table, xx, tol)


    xx = map(T, vcat(0.0001:0.0001:10, 0.0001:0.1:10000));
    fun_table = Dict(SLEEFPirates.log10 => Base.log10, SLEEFPirates.log2 => Base.log2)
    tol = 1
    test_acc(T, fun_table, xx, tol)
    fun_table = Dict(SLEEFPirates.log10_fast => Base.log10, SLEEFPirates.log2_fast => Base.log2)
    tol = 3
    test_acc(T, fun_table, xx, tol)


    xx = map(T, vcat(0.0001:0.0001:10, 0.0001:0.1:10000, 10.0.^-(0:0.02:300), -10.0.^-(0:0.02:300)));
    fun_table = Dict(SLEEFPirates.log1p => Base.log1p)
    tol = 1
    test_acc(T, fun_table, xx, tol)


    xx1 = map(Tuple{T,T}, [(x,y) for x = -100:0.20:100, y = 0.1:0.20:100])[:];
    xx2 = map(Tuple{T,T}, [(x,y) for x = -100:0.21:100, y = 0.1:0.22:100])[:];
    xx3 = map(Tuple{T,T}, [(x,y) for x = 2.1, y = -1000:0.1:1000]);
    txx = vcat(xx1, xx2, xx2);
    fun_table = Dict(SLEEFPirates.pow => Base.:^);
    # tol = 1
    tol = 3
    test_acc(T, fun_table, txx, tol)

    xx1 = map(Tuple{T,T}, [(x,y) for x = 0:0.20:100, y = 0.1:0.20:100])[:];
    xx2 = map(Tuple{T,T}, [(x,y) for x = 0:0.21:100, y = 0.1:0.22:100])[:];
    xx3 = map(Tuple{T,T}, [(x,y) for x = 2.1, y = -1000:0.1:1000]);
    txx = vcat(xx1, xx2, xx2);
    fun_table = Dict(SLEEFPirates.pow_fast => Base.:^);
    tol = 10
    test_acc(T, fun_table, txx, tol, broken = true)


    xx = map(T, vcat(prevfloat(0.0):0.2:10000, 1.1.^(-1000:1000), 2.1.^(-1000:957)));
    fun_table = Dict(SLEEFPirates.cbrt_fast => Base.cbrt)
    tol = 2
    test_acc(T, fun_table, xx, tol)

    fun_table = Dict(SLEEFPirates.cbrt => Base.cbrt)
    tol = 1
    test_acc(T, fun_table, xx, tol)

    # xx = map(T, vcat(-10:0.0002:10, -120:0.023:1000, -1000:0.02:2000))
    # xx = vcat(
    #     SLEEFPirates.MIN_EXP(Val(2),T):T(0.02):0.5SLEEFPirates.MIN_EXP(Val(2),T),
    #     0.5SLEEFPirates.MIN_EXP(Val(2),T):T(0.023):0.5SLEEFPirates.MAX_EXP(Val(2),T),
    #     0.5SLEEFPirates.MAX_EXP(Val(2),T):T(0.02):SLEEFPirates.MAX_EXP(Val(2),T)
    # )
    xx = nextfloat(SLEEFPirates.VectorizationBase.MIN_EXP(Val(2),T)):T(0.02):prevfloat(SLEEFPirates.VectorizationBase.MAX_EXP(Val(2),T));
    fun_table = Dict(SLEEFPirates.exp2 => Base.exp2)
    tol = 2#1 #FIXME
    test_acc(T, fun_table, xx, tol)


    xx = nextfloat(SLEEFPirates.VectorizationBase.MIN_EXP(Val(10),T)):T(0.02):prevfloat(SLEEFPirates.VectorizationBase.MAX_EXP(Val(10),T));
    # xx = map(T, vcat(-10:0.0002:10, -35:0.023:1000, -300:0.01:300))
    fun_table = Dict(SLEEFPirates.exp10 => Base.exp10)
    tol = 3
    test_acc(T, fun_table, xx, tol)


    xx = nextfloat(SLEEFPirates.MIN_EXPM1(T)):T(0.02):prevfloat(SLEEFPirates.MAX_EXPM1(T));
    # xx = map(T, vcat(-10:0.0002:10, -1000:0.021:1000, -1000:0.023:1000,
        # 10.0.^-(0:0.02:300), -10.0.^-(0:0.02:300), 10.0.^(0:0.021:300), -10.0.^-(0:0.021:300)))
    fun_table = Dict(SLEEFPirates.expm1 => Base.expm1)
    tol = 2
    test_acc(T, fun_table, xx, tol)


    xx = map(T, vcat(-10:0.0002:10, -1000:0.02:1000));
    fun_table = Dict(
        SLEEFPirates.sinh => Base.sinh, first ∘ SLEEFPirates.sincosh => Base.sinh,
        SLEEFPirates.cosh => Base.cosh, last ∘ SLEEFPirates.sincosh => Base.cosh,
        SLEEFPirates.tanh => Base.tanh
    )
    tol = 1
    test_acc(T, fun_table, xx, tol)

    xxr = range(-SLEEFPirates.max_tanh(T),SLEEFPirates.max_tanh(T),length = 100_000);
    fun_table = Dict(tanh_fast => Base.tanh)
    tol = 3
    test_acc(T, fun_table, xxr, tol)

    xxr = T === Float64 ? range(-100.0, 37.0, length = 100_000) : range(-50f0, 18f0, length = 100_000);
    fun_table = Dict(SLEEFPirates.sigmoid_fast => x -> inv(1+exp(-x)))
    tol = 3
    test_acc(T, fun_table, xxr, tol)


    @testset "xilogb at arbitrary values" begin
        xd = Dict{T,Int}(T(1e-30) => -100, T(2.31e-11) => -36, T(-1.0) => 0, T(1.0) => 0,
                T(2.31e11) => 37,  T(1e30) => 99)
        for (i,j) in xd
            @test SLEEFPirates.ilogb(i)  == j
        end
    end

end


