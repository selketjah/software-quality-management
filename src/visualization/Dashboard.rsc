module visualization::Dashboard

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

    
public void rerenderDashboard(Panel active, ProjectData projectData) {
	sidebar = renderSidebar(projectData);	
	content = renderContent(active, projectData);
	render(hcat([sidebar, content]));
}

public void renderDashboard(ProjectData projectData) {
	sidebar = renderSidebar(projectData);	
	content = renderContent(\general(), projectData);
	render(hcat([sidebar, content]));
}

public void sthsth() {
	i = hcat([box(fillColor("red"),project(text(s),"hscreen")) | s <- ["a","b"]],top());
	sc = hscreen(i,id("hscreen"));
	render(sc);

}