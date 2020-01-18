module visualization::Components::ContentPanel

import IO;
import String;
import List;
import Map;

import structs::Visualization;
import visualization::Charts::Treemapping;
import visualization::ProjectGraph;
import visualization::Components::Dashboard;

import scoring::Rank;
import scoring::Ranking;
import scoring::Average;
import scoring::Percentage;
import scoring::Maintainability;

import util::Math;

import vis::Figure;
import vis::Render;

public Figure renderContent(Panel active, ProjectData projectData, map[str, Figure] state) {
	Figure content;
	visit(active) {
		case \general(): content = renderDashboard(projectData);
		case \heatmap(): content = drawTreemap(state, projectData);
		case \dependencies(): content = renderDependencyGraph(projectData.project);
	}

	return content;
}