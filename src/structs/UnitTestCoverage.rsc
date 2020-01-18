module structs::UnitTestCoverage

alias UnitTestCoverageMap = map[loc, tuple[int numberOfAsserts, int locCoverage, int complexityCoverage]];
