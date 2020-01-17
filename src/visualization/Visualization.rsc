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

public void render(Panel active, ProjectData projectData) {
	sidebar = renderSidebar(projectData, active);
	title = text("SIG report - smallsql", font("SILOM"), fontSize(50), textColor);
	content = renderContent(active, projectData);
	render(vcat([sidebar, title, content]));
}

public void initialize(ProjectData projectData) {
	render(\general(), projectData);
}