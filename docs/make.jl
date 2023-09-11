using MatMeshMakie
using Documenter

DocMeta.setdocmeta!(MatMeshMakie, :DocTestSetup, :(using MatMeshMakie); recursive=true)

makedocs(;
    modules=[MatMeshMakie],
    authors="Nick Keepfer",
    repo="https://github.com/nickkeepfer/MatMeshMakie.jl/blob/{commit}{path}#{line}",
    sitename="MatMeshMakie.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://nickkeepfer.github.io/MatMeshMakie.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/nickkeepfer/MatMeshMakie.jl",
    devbranch="main",
    push_preview = true,
    deploy_config = Documenter.GitHubActions(),
)
