module visualization::Components::Dashboard

import IO;
import List;
import Message;
import Set;
import Map;
import Relation;
import String;

import structs::Visualization;

import scoring::Rank;
import scoring::Ranking;
import scoring::Average;
import scoring::Percentage;
import scoring::Maintainability;

import util::Math;

import vis::Figure;
import vis::Render;

FProperty titleColor = fontColor(rgb(143,190,0));
FProperty subTitleColor = fontColor(rgb(108,120,142));

Color rightSideColor = rgb(143,190,0);
Color leftSideColor = rgb(241,235,235);

public Figure header(loc project, Rank projectRank) {
	projectTitle = text("SMALLSQL", fontSize(20), titleColor);
	rankTitle = text(convertRankToLiteral(projectRank), fontSize(20), titleColor);
	return hcat([projectTitle, rankTitle], size(250, 75));
}

public Figure rankBox(str amount, str measurementSign, str bottomText, Rank rank) {
	amountTitle = text(amount, fontSize(20), titleColor);
	measurement = text(measurementSign, fontSize(10), titleColor);
	information = hcat([amountTitle, measurement], left(), resizable(false), size(100, 25));
	
	subtitle = text(bottomText, resizable(false), size(100, 25), subTitleColor);
	together = vcat([information, subtitle], gap(5), center());
	b1 = box(together, resizable(false), size(200, 75), fillColor(leftSideColor), lineColor(leftSideColor));
	
	rankingText = text(convertRankToLiteral(rank), fontSize(20), subTitleColor);
	b2 = box(rankingText, fillColor(rightSideColor), lineColor(rightSideColor), resizable(false), size(75, 75));
	return hcat([b1, b2], resizable(false), size(275, 75));
}

public Figure ranking(ProjectData projectData) {
	volume = rankBox(toString(projectData.metrics.volume), "LOC", "VOLUME", projectData.ranks.volume);
	averageUnitSize = rankBox(toString(projectData.averages.size), "", "AVERAGE UNIT SIZE", projectData.ranks.unitSize);
	averageComplexity = rankBox(toString(projectData.averages.complexity), "", "AVERAGE COMPLEXITY", projectData.ranks.complexity);
	duplicationPercentage = rankBox(toString(projectData.metrics.percentages.duplication), "%", "DUPLICATION", projectData.ranks.duplication);
	unitTestCoveragePercentage = rankBox(toString(projectData.metrics.percentages.unitTestCoverage), "%", "UNIT TEST COVERAGE", projectData.ranks.unitTestCoverage);
	
	return hcat([volume, averageUnitSize, averageComplexity, duplicationPercentage, unitTestCoveragePercentage], gap(1));
}

public Figure renderDashboard(ProjectData projectData) {
	row0 = header(projectData.project, projectData.ranks.overall);
	row1 = ranking(projectData);
     
	return vcat( [ row0, row1 ]);
}