module visualization::Components::Sidebar

import vis::Figure;
import vis::Render;

import structs::Visualization;

import visualization::Dashboard;

FProperty textColor = fontColor(rgb(3,54,73));
FProperty tabColor = fillColor(rgb(244,234,213));
FProperty activeTabColor = fillColor(rgb(205,179,128));

private Figure renderButton(ProjectData projectData, Panel active, Panel panel, str text) {
	FProperty color = tabColor;
	
	if (active == panel) {
		color = activeTabColor;
	}
	
	return button(text, void(){ rerenderDashboard(panel, projectData); }, resizable(false), size(150, 50), color, textColor);
}

public Figure renderSidebar(ProjectData projectData, Panel active) {
	return hcat([ renderButton(projectData, active, \general(), "General"),
				  renderButton(projectData, active, \dependencies(), "Dependency graph"),
				  renderButton(projectData, active, \complexity(), "Cyclomatic complexity"),
				  renderButton(projectData, active, \unitsize(), "Unit size"),
				  renderButton(projectData, active, \duplication(), "Duplication")
                ], resizable(false), align(0,0));
}