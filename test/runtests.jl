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
  vx = Vec(ntuple(_ -> rand(), pick_vector_width(Float64))...)
  vy = Vec(ntuple(_ -> rand(), pick_vector_width(Float64))...)
  x = tovector(vx);
  y = tovector(vy);
  @test tovector(@fastmath(sin(vx))) ≈ sin.(x)
  @test tovector(@fastmath(cos(vx))) ≈ cos.(x)
  @test tovector(@fastmath(tan(vx))) ≈ tan.(x)
  @test tovector(@fastmath(asin(vx))) ≈ asin.(x)
  @test tovector(@fastmath(acos(vx))) ≈ acos.(x)
  @test tovector(@fastmath(atan(vx))) ≈ atan.(x)
  @test tovector(@fastmath(log2(vx))) ≈ log2.(x)
  @test tovector(@fastmath(log10(vx))) ≈ log10.(x)
  @test tovector(@fastmath(atan(vx,vy))) ≈ atan.(x,y)
  @test tovector(@fastmath(atan(0.7,vy))) ≈ atan.(0.7,y)
  @test tovector(@fastmath(atan(vx,0.8))) ≈ atan.(x,0.8)
end

runtests()


