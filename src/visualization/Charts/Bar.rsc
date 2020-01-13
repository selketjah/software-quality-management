module visualization::Charts::Bar

import vis::Figure;
import vis::Render;

public void renderBar(int volume, int percentage) {
	b0 = box(size(150,50), fillColor("lightGray"));
	render(b0);	
}