module collections::Sort

alias CommentLocation = tuple[int offset, int length];

bool locationSortFunction(CommentLocation locA, CommentLocation locB){
	return locA.offset < locB.offset;
}