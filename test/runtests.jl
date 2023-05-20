using Aqua
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
  x = tovector(vx)
  y = tovector(vy)
  @test tovector(@fastmath(sin(vx))) ≈ sin.(x)
  @test tovector(@fastmath(cos(vx))) ≈ cos.(x)
  @test tovector(@fastmath(tan(vx))) ≈ tan.(x)
  @test tovector(@fastmath(asin(vx))) ≈ asin.(x)
  @test tovector(@fastmath(acos(vx))) ≈ acos.(x)
  @test tovector(@fastmath(atan(vx))) ≈ atan.(x)
  @test tovector(@fastmath(log2(vx))) ≈ log2.(x)
  @test tovector(@fastmath(log10(vx))) ≈ log10.(x)
  @test tovector(@fastmath(atan(vx, vy))) ≈ atan.(x, y)
  @test tovector(@fastmath(atan(0.7, vy))) ≈ atan.(0.7, y)
  @test tovector(@fastmath(atan(vx, 0.8))) ≈ atan.(x, 0.8)

  vxi32 = Vec(ntuple(_ -> rand(Int32(-5):Int32(5)), pick_vector_width(Int32))...)
  vxi64 = Vec(ntuple(_ -> rand(Int64(-5):Int64(5)), pick_vector_width(Int64))...)
  vxf32 = float(vxi32)
  vxf64 = float(vxi64)
  for f ∈ [
    SLEEFPirates.tanh_fast,
    SLEEFPirates.sigmoid_fast,
    SLEEFPirates.PReLu(0.3f0),
    SLEEFPirates.Φ,
    SLEEFPirates.gelu,
    SLEEFPirates.softplus,
    SLEEFPirates.silu,
    SLEEFPirates.Elu(0.4f0),
  ]
    @test VectorizationBase.vall(f(vxi32) == f(vxf32))
    @test VectorizationBase.vall(f(vxi64) == f(vxf64))
  end
end

runtests()
