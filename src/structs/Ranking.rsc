module structs::Ranking

import structs::Rank;
import structs::Maintainability;
import structs::UnitMetrics;
import structs::Percentage;

alias Metrics = tuple[int volume, set[CompilationUnitMetric] compilationUnitMetrics, Percentages percentages];
alias Ranks = tuple[Rank overall, map[MaintainabilityCharacteristic, Rank] maintainability, Rank volume, Rank unitSize, Rank complexity, Rank duplication, Rank unitTestCoverage];