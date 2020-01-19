module structs::Visualization

import scoring::Rank;
import scoring::Ranking;
import scoring::Average;
import scoring::Percentage;
import scoring::Maintainability;
import structs::Ranking;
import structs::Rank;
import structs::Average;

alias ProjectData = tuple[loc project, Metrics metrics, int numberOfUnits, Average averages, Ranks ranks];

data Panel
    = \general()
    | \heatmap()
    | \architecture()
    | \interdependency()
    | \duplication()
    ;