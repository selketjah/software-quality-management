module structs::Visualization

import scoring::Rank;
import scoring::Ranking;
import scoring::Average;
import scoring::Percentage;
import scoring::Maintainability;

alias ProjectData = tuple[loc project, Metrics metrics, int numberOfUnits, Average averages, Ranks ranks];

data Panel
    = \general()
    | \complexity()
    | \unitsize()
    | \dependencies()
    ;