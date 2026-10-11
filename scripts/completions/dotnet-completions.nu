def "nu-complete dotnet" [buffer: string] {
    ^dotnet complete $"($buffer)" | lines 
}

export extern "dotnet" [
    ...command: string@"nu-complete dotnet"
]
