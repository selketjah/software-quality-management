module structs::Visualization

import scoring::Rank;
import scoring::Ranking;
import scoring::Average;
import scoring::Percentage;
import scoring::Maintainability;
import structs::Ranking;
import structs::Rank;
import structs::Average;
import lang::java::m3::Core;

alias ProjectData = tuple[loc project, M3 model, Metrics metrics, rel[loc, loc] duplicationRelationships, int numberOfUnits, Average averages, Ranks ranks];

data Panel
    = \general()
    | \heatmap()
    | \architecture()
    | \interdependency()
    | \duplication()
    ;