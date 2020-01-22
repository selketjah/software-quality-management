module visualization::Visualization

import IO;
import String;
import List;
import Map;

import structs::Visualization;

import scoring::Rank;
import scoring::Ranking;
import scoring::Average;
import scoring::Percentage;
import scoring::Maintainability;

import visualization::Components::Sidebar;
import visualization::Components::ContentPanel;
import vis::Figure;
import vis::Render;

public void renderVisualization(Panel active, ProjectVisData projectData) {
	sidebar = renderSidebar(projectData, active);
	content = renderContent(active, projectData);
	render(vcat([sidebar, content]));
}

public void initializeVisualization(ProjectVisData projectData) {
	renderVisualization(\general(), projectData);
}