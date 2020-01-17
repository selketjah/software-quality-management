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

    
public void rerenderDashboard(Panel active) {
	sidebar = renderSidebar();	
	content = box(text(sthsth),fillColor("Orange"));
	render(hcat([sidebar, content]));
}

public void renderDashboard(loc project, int volume, int numberOfUnits, Percentages percentages, Average averages, Ranks ranks) {
	projectData = <project, volume, numberOfUnits, percentages, averages, ranks>;
	sidebar = renderSidebar();	
	content = renderContent(\general(), projectData);
	render(hcat([sidebar, content]));
}

public void sthsth() {
	i = hcat([box(fillColor("red"),project(text(s),"hscreen")) | s <- ["a","b"]],top());
	sc = hscreen(i,id("hscreen"));
	render(sc);

}