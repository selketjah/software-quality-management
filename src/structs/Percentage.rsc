module structs::Percentage

import Map;
import structs::RiskLevel;

alias RiskLevelsPercentages = tuple[map[RiskLevel risks, int percentages] complexityDivisions, map[RiskLevel risks, int percentages] unitSizeDivisions];
alias Percentages = tuple[int duplication, int unitTestCoverage, RiskLevelsPercentages unitPercentages];