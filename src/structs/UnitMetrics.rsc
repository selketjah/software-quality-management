module structs::UnitMetrics

alias UnitMetric = tuple[str name, loc method, int complexity, int size];
alias CompilationUnitMetric =  tuple[loc file, list[UnitMetric] unitMetric];