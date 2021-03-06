module visualization::Components::RiskLevelBox

import Map;
import util::Math;

import structs::RiskLevel;
import structs::Rank;
import scoring::Rank;
import scoring::Ranking;

import vis::Figure;
import vis::Render;

FProperty titleColor = fontColor(rgb(143,190,0));
FProperty subTitleColor = fontColor(rgb(108,120,142));

Color rightSideColor = rgb(143,190,0);
Color leftSideColor = rgb(241,235,235);

public str toPercentageString(int percentage) {
	return toString(percentage) + "%";
}

public Figure riskLevelBox(int percentage, str level) {
	simpleValue = text(toPercentageString(percentage), fontSize(20), titleColor);
	simpleText = text(level, fontSize(10), titleColor);
	return vcat([ simpleValue, simpleText ]);
}

public Figure riskLevelPercentagesText(map[RiskLevel risks, int percentages] riskLevelDivisions) {

	tuple[int simple, int moderate, int high, int veryHigh] percentages = <riskLevelDivisions[\simple()] ? 0, riskLevelDivisions[\moderate()] ? 0, riskLevelDivisions[\high()] ? 0, riskLevelDivisions[\veryhigh()] ? 0>;

	simpleTitle = riskLevelBox(percentages.simple, "LOW");	
	moderateTitle = riskLevelBox(percentages.moderate, "MOD");
	highTitle = riskLevelBox(percentages.high, "HIGH");
	veryHighTitle = riskLevelBox(percentages.veryHigh, "VHIGH");
	
	return hcat([ simpleTitle, moderateTitle, highTitle, veryHighTitle ]);
}

public Figure riskLevelBox(str bottomText, Rank rank, map[RiskLevel risks, int percentages] riskLevelPercentages) {
	percentagesText = riskLevelPercentagesText(riskLevelPercentages);
	subtitle = text(bottomText, resizable(false), size(100, 25), subTitleColor);
	together = vcat([percentagesText, subtitle], gap(5), center());
	b1 = box(together, resizable(false), size(300, 75), fillColor(leftSideColor), lineColor(leftSideColor));
	
	rankingText = text(convertRankToLiteral(rank), fontSize(20), subTitleColor);
	b2 = box(rankingText, fillColor(rightSideColor), lineColor(rightSideColor), resizable(false), size(75, 75));
	return hcat([b1, b2], resizable(false), size(375, 75));
}