module structs::Analysis
import structs::Ranking;
import structs::Rank;
import structs::Average;
import structs::UnitTestCoverage;


alias ProjectData = tuple[Metrics metrics, rel[loc, loc] duplicationRelationships, rel[loc name,loc src] methods, Ranks ranks, UnitTestCoverageMap unitTestCoverageMap];