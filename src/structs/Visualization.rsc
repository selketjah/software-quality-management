module structs::Visualization

import scoring::Rank;
import scoring::Ranking;
import scoring::Average;
import scoring::Percentage;
import scoring::Maintainability;
import structs::Analysis;
import lang::java::m3::Core;

alias ProjectVisData = tuple[loc project, M3 model, ProjectData analysis];

data Panel
    = \general()
    | \heatmap()
    | \architecture()
    | \interdependency()
    | \duplication()
    ;