using Documenter, SLEEFPirates

makedocs(;
    modules=[SLEEFPirates],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/chriselrod/SLEEFPirates.jl/blob/{commit}{path}#L{line}",
    sitename="SLEEFPirates.jl",
    authors="Chris Elrod",
    assets=[],
)

deploydocs(;
    repo="github.com/chriselrod/SLEEFPirates.jl",
)
