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

FProperty textColor = fontColor(rgb(3,54,73));

public void renderVisualization(Panel active, ProjectData projectData, map[str, Figure] state) {
	sidebar = renderSidebar(projectData, active, state);
	sigTitle = text("SIG report - smallsql", font("SILOM"), fontSize(40), textColor);
	content = renderContent(active, projectData, state);
	render(vcat([sidebar, sigTitle, content]));
}

public void initializeVisualization(ProjectData projectData) {
	renderVisualization(\general(), projectData, ());
}