module visualization::Charts::DuplicationGraph

import ListRelation;
import List;
import scoring::categories::UnitSize;
import Relation;
import util::Math;
import Set;
import vis::KeySym;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import structs::Duplication;
import structs::Volume;
import util::Editors;
import analysers::LocAnalyser;
import IO;
import vis::Figure; 
import structs::RiskLevel;
import visualization::Utils;
import vis::Render;

public Figure renderDuplicationGraph(DuplicationData duplicationData, ComponentLOC methodHolderSizeMap) {
	
	return box(createDuplicationTreemap(1000, duplicationData.duplicationRel, methodHolderSizeMap), size(1000, 600), gap(20));
}

private Figure createDuplicationTreemap(int scale, DuplicateCodeRel duplicationRel, ComponentLOC methodHolderSizeMap){
	int widthRef = 70;
	int heightRef = 45;
	FProperty boxSize = size(widthRef*scale,heightRef*scale);
	Figures figures = [];
	list[LineDecoration] currentDuplicateLineDecorations = [];
	int currentDuplicationPercentage = 0;
	
	for(<loc src, set[list[int]] codeDupLocationSet> <-duplicationRel){	
		if(size(codeDupLocationSet)>0){
			currentDuplicateLineDecorations = generateLineDecorations(codeDupLocationSet);
			currentDuplicateLocSize = size(currentDuplicateLineDecorations);
			currentDuplicationPercentage = percent(currentDuplicateLocSize,methodHolderSizeMap[src]);
			figures += 
					box(
						vcat([
							text("<src.file>"),
							outline(currentDuplicateLineDecorations, methodHolderSizeMap[src], size(scale/12, scale/6), id("<src>"), getSizeColor(currentDuplicationPercentage))
						])
					, gap(10), popup(src.file, currentDuplicateLocSize, methodHolderSizeMap[src], currentDuplicationPercentage));
		}
	}
	
	return box(hvcat(figures, gap(15)));
}

FProperty popup(str unitName, int duplicateLOC, int totalLoc, int duplicationPercentage) {
	unitNameText = text(unitName);
	duplicationText = text("#LOC copied: <duplicateLOC>/<totalLoc>");
	duplicationPercentageText = text("copy %: <duplicationPercentage>");
	
	message = vcat([ unitNameText, duplicationText ]);
	println(message);
	return mouseOver(box(message, resizable(false),gap(5), startGap(true), endGap(true), size(100, 100)));
}

public FProperty getSizeColor(int sizePercentage) {
	FProperty color;
	if(sizePercentage < 25){
		color = fillColor(rgb(168,219,168));
	}else if(sizePercentage < 30){
		color = fillColor(rgb(121,189,154));
	}else if(sizePercentage < 40){
		color = fillColor(rgb(59,134,134));
	}else if(sizePercentage < 50){
		color = fillColor(rgb(11,72,107));
	}else{
		color = fillColor(rgb(11,72,107));
	}
	return color;
}

private list[LineDecoration] generateLineDecorations(set[list[int]] codeLocationSet){
	list[LineDecoration] res =[];
	for(list[int] indexList <- codeLocationSet){
		for(int ind <- indexList){
			res += error(ind, "lorem ipsum");
		}
	}
	
	return res;
}


private Figure createDuplicationGraph(int n, rel[loc, loc] duplicationRelationships){
	nodes = [ellipse(text("<cl.file>"), id("<cl>"), fillColor(arbColor()), openDocumentOnClick(cl)) | cl <- carrier(duplicationRelationships)]; 
  	edges = [ edge("<to>", "<from>") | <from,to> <- duplicationRelationships ];
  	return graph(nodes, edges, hint("layered"), std(gap(5)), size(n), hgap(2), std(fontSize(n*3)), resizable(false));
}