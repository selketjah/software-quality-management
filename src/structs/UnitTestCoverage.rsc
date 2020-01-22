module structs::UnitTestCoverage

alias UnitTestCoverage = tuple[loc name, int numberOfAsserts, list[loc] methodCalls, int locCoverage, int complexityCoverage];
alias UnitTestCoverageMap = map[loc, UnitTestCoverage];
