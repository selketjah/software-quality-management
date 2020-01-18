module visualization::Components::Sidebar

import vis::Figure;
import vis::Render;

import structs::Visualization;

import visualization::Visualization;

FProperty textColor = fontColor(rgb(252,253,255));
FProperty tabColor = fillColor(rgb(108,120,142));
FProperty activeTabColor = fillColor(rgb(199,8,8));

private Figure renderButton(ProjectData projectData, Panel active, Panel panel, str text) {
	FProperty color = tabColor;
	
	if (active == panel) {
		color = activeTabColor;
	}
	
	return button(text, void(){ renderVisualization(panel, projectData); }, resizable(false), size(150, 50), color, textColor);
}

public Figure renderSidebar(ProjectData projectData, Panel active) {
	return hcat([ renderButton(projectData, active, \general(), "Dashboard"),
				  renderButton(projectData, active, \dependencies(), "Dependency graph"),
				  renderButton(projectData, active, \complexity(), "Cyclomatic complexity"),
				  renderButton(projectData, active, \unitsize(), "Unit size"),
				  renderButton(projectData, active, \duplication(), "Duplication")
                ], resizable(false), align(0,0));
}