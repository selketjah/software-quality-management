module structs::Duplicates

alias DuplicateCodeLocations = tuple[str code, list[loc] locations];
alias DuplicateLocMap = map[real, DuplicateCodeLocations];