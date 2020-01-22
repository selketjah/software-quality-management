module visualization::Components::ContentPanel

import IO;
import String;
import List;
import Map;

import structs::Visualization;
import visualization::Charts::Treemapping;
import visualization::Charts::ProjectGraph;
import visualization::Charts::InterdependenceGraph;
import visualization::Charts::DuplicationGraph;
import visualization::Components::Dashboard;

import scoring::Rank;
import scoring::Ranking;
import scoring::Average;
import scoring::Percentage;
import scoring::Maintainability;


import util::Math;

import vis::Figure;
import vis::Render;

public Figure renderContent(Panel active, ProjectVisData projectData) {
	Figure content;
	
	visit(active) {
		case \general(): content = renderDashboard(projectData);
		case \heatmap(): content = drawTreemap(projectData);
		case \architecture(): content = renderDependencyGraph(projectData);
		case \interdependency(): content = renderInterdependenceGraph(projectData.model);
		case \duplication(): content = renderDuplicationGraph(projectData.analysis.duplicationRelationships);
	}

	return content;
}