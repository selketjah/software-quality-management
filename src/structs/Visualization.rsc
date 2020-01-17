module structs::Visualization

import scoring::Rank;
import scoring::Ranking;
import scoring::Average;
import scoring::Percentage;
import scoring::Maintainability;

alias ProjectData = tuple[loc project, int volume, int numberOfUnits, Percentages percentages, Average averages, Ranks ranks];

data Panel
    = \general()
    | \complexity()
    | \dependencies()
    ;