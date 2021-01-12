include("testsetup.jl")

function runtests()
    @testset "SLEEFPirates" begin
        # @test isempty(detect_unbound_args(SLEEFPirates))
        Aqua.test_all(SLEEFPirates)
        # include("exceptional.jl")
        include("accuracy.jl")
    end
end

runtests()


