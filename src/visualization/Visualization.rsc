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

public void renderVisualization(Panel active, ProjectData projectData) {
	sidebar = renderSidebar(projectData, active);
	str sig = "SIG report - " + projectData.project.authority;
	sigTitle = text(sig, font("SILOM"), fontSize(40), textColor);
	content = renderContent(active, projectData);
	render(vcat([sidebar, sigTitle, content]));
}

public void initializeVisualization(ProjectData projectData) {
	renderVisualization(\general(), projectData);
}