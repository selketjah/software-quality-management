module visualization::Charts::Bar

import vis::Figure;
import vis::Render;

FProperty volumeBoxColor = fillColor(rgb(238,174,170));
FProperty percentageBoxColor = fillColor(rgb(218,174,170));

public Figure renderPercentageBar(int percentage) {
	int shrink = (percentage / 100);

	b1 = box(hshrink(shrink), align(0, 0), percentageBoxColor);
	b0 = box(b1, size(150,50), volumeBoxColor);
	return b0;
}