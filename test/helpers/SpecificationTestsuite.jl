module SpecificationTestsuite

    export ALL_IMPLEMENTATIONS, ALL_FIXTURES, Config, execute

    "List of all know implementations"
    const ALL_IMPLEMENTATIONS = [
      "substrate"
      "kagome"
      "gossamer"
    ]

    module Config
        import ..SpecificationTestsuite: ALL_IMPLEMENTATIONS

        "By default we log on a warning level."
        verbose = false

        "By default all implementations are enabled."
        implementations = ALL_IMPLEMENTATIONS

        "Path of folder containing all fixtures."
        function fixdir()
            return String(@__DIR__) * "/../fixtures"
        end

        "All subfolders of the fixture folder (i.e. all available fixtures)."
        function fixsubdirs()
            return first(walkdir(fixdir()))[2]
        end

        "By default all fixtures are enabled."
        fixtures = fixsubdirs()

        function set_verbose(v)
            global verbose = v
        end

        function set_implementations(impls)
            global implementations = impls
        end

        function set_fixtures(fixs)
            global fixtures = fixs
        end
    end

    "List of all available fixtures"
    const ALL_FIXTURES = Config.fixsubdirs()

    # Include helpers
    include("StringHelper.jl")
    include("AdapterFixture.jl")

    "Run specific fixture for configure implementations"
    function run(fixture::String)
        if !(fixture in ALL_FIXTURES)
            error("Unknown fixture: " * fixture)
        end

        @time include(Config.fixdir() * "/$fixture/include.jl")
    end

    "Run all configured fixtures"
    function execute()
        for fixture in Config.fixtures
            run(fixture)
        end
    end
end

