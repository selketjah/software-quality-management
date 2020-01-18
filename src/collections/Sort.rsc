module collections::Sort

import structs::Comments;

bool locationSortFunction(CommentLocation locA, CommentLocation locB){
	return locA.offset < locB.offset;
}