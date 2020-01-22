module structs::Analysis
import structs::Ranking;
import structs::Rank;
import structs::Average;

alias ProjectData = tuple[Metrics metrics, rel[loc, loc] duplicationRelationships, rel[loc name,loc src] methods, Average averages, Ranks ranks];