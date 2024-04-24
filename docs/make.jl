using LibAwsAuth
using Documenter

DocMeta.setdocmeta!(LibAwsAuth, :DocTestSetup, :(using LibAwsAuth); recursive=true)

makedocs(;
    modules=[LibAwsAuth],
    repo="https://github.com/JuliaServices/LibAwsAuth.jl/blob/{commit}{path}#{line}",
    sitename="LibAwsAuth.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://github.com/JuliaServices/LibAwsAuth.jl",
        assets=String[],
        size_threshold=2_000_000, # 2 MB, we generate about 1 MB page
        size_threshold_warn=2_000_000,
    ),
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/JuliaServices/LibAwsAuth.jl", devbranch="main")
