include("testsetup.jl")

@show Sys.CPU_NAME
@show VectorizationBase.has_feature(Val(:x86_64_avx))
@show VectorizationBase.has_feature(Val(:x86_64_avx2))
@show VectorizationBase.has_feature(Val(:x86_64_fma))
@show VectorizationBase.has_feature(Val(:x86_64_avx512f))
@show VectorizationBase.has_feature(Val(:x86_64_avx512vl))
@show VectorizationBase.has_feature(Val(:x86_64_avx512dq))

function runtests()
    @testset "SLEEFPirates" begin
        # @test isempty(detect_unbound_args(SLEEFPirates))
        Aqua.test_all(SLEEFPirates)
        # include("exceptional.jl")
        include("accuracy.jl")
    end
end

runtests()


