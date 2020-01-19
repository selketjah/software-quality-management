module visualization::Components::Legend

import vis::Figure;
import vis::Render;

public Figure topTitle(str t){
	volumeTitle = text(t, fontSize(15), textAngle(90), fontColor(rgb(108,120,142)));
	volumeBox = box(volumeTitle, resizable(false), size(35, 100));
	
	return volumeBox;
}

public Figure sideTitle(str t){
	volumeTitle = text(t, fontSize(15), fontColor(rgb(108,120,142)));
	volumeBox = box(volumeTitle, resizable(false), size(125, 35));
	
	return volumeBox;
}

public Figure squareBox() {
	sq = box(resizable(false), size(35, 35));
	
	return sq;
}

public Figure coloredBox(Color c, str s){
	x = text(s, fontSize(15), fontColor(rgb(108,120,142)));
	sq = box(x, fillColor(c), resizable(false), size(35, 35));
	
	return sq;
}

public Figure top(){
	whitespaceBox = box(resizable(false), size(125, 100));
	volumeTitle = topTitle("Volume");	
	unitSizeTitle = topTitle("Unit size");
	complexityTitle = topTitle("Complexity");
	duplicationTitle = topTitle("Duplication");
	unitTestingTitle = topTitle("Unit testing");
	
	return hcat([ whitespaceBox, volumeTitle, unitSizeTitle, complexityTitle, duplicationTitle, unitTestingTitle]);
}

public Figure analysabilityRow(Color c){
	analysabilityTitle = sideTitle("analysability");
	
	volumeTitle = coloredBox(c, "x");	
	unitSizeTitle = coloredBox(c, "x");
	complexityTitle = squareBox();
	duplicationTitle = coloredBox(c, "x");
	unitTestingTitle = coloredBox(c, "x");
	
	return hcat([ analysabilityTitle, volumeTitle, unitSizeTitle, complexityTitle, duplicationTitle, unitTestingTitle ], resizable(false));
}

public Figure changeabilityRow(Color c){
	changeabilityTitle = sideTitle("changeability");
	
	volumeTitle = squareBox();	
	unitSizeTitle = squareBox();
	complexityTitle = coloredBox(c, "x");
	duplicationTitle = coloredBox(c, "x");
	unitTestingTitle = squareBox();
	
	return hcat([ changeabilityTitle, volumeTitle, unitSizeTitle, complexityTitle, duplicationTitle, unitTestingTitle ], resizable(false));
	
}

public Figure stabilityRow(Color c){
	stabilityTitle = sideTitle("stability");
	
	volumeTitle = squareBox();	
	unitSizeTitle = squareBox();
	complexityTitle = squareBox();
	duplicationTitle = squareBox();
	unitTestingTitle = coloredBox(c, "x");
	
	return hcat([ stabilityTitle, volumeTitle, unitSizeTitle, complexityTitle, duplicationTitle, unitTestingTitle ], resizable(false));
}

public Figure testabilityRow(Color c){
	testabilityTitle = sideTitle("testability");
	
	volumeTitle = squareBox();	
	unitSizeTitle = coloredBox(c, "x");
	complexityTitle = coloredBox(c, "x");
	duplicationTitle = squareBox();
	unitTestingTitle = coloredBox(c, "x");
	
	return hcat([ testabilityTitle, volumeTitle, unitSizeTitle, complexityTitle, duplicationTitle, unitTestingTitle ], resizable(false));
}

public Figure renderLegend(Color analysabilityColor, Color changeabilityColor, Color stabilityColor, Color testabilityColor) {
	topRow = top();
	analysability = analysabilityRow(analysabilityColor);
	changeability = changeabilityRow(changeabilityColor);
	stability = stabilityRow(stabilityColor);
	testability = testabilityRow(testabilityColor);
	
	return vcat([ topRow, analysability, changeability, stability, testability ], resizable(false));
}