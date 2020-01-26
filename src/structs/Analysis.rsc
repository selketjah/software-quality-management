module structs::Analysis
import structs::Ranking;
import structs::Rank;
import structs::Average;
import structs::Duplication;
import structs::Percentage;
import structs::UnitTestCoverage;

alias ProjectData = tuple[Metrics metrics, DuplicationData duplication, rel[loc name,loc src] methods, Ranks ranks, UnitTestCoverageMap unitTestCoverageMap];
alias SigMetricsResults = tuple[Metrics metrics, DuplicationData duplication, rel[loc name,loc src] methods, int volume, Percentages percentages, UnitTestCoverageMap unitTestCoverageMap];