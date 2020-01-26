module structs::Duplication

alias DuplicationData = tuple[DuplicateCodeRel duplicationRel, rel[loc, loc] duplicationLocationRel];
alias DuplicateCodeRel = rel[loc, set[list[int]]];