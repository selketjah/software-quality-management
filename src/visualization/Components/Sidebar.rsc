module visualization::Components::Sidebar

import vis::Figure;
import vis::Render;

import structs::Visualization;

import visualization::Visualization;

FProperty textColor = fontColor(rgb(252,253,255));
FProperty tabColor = fillColor(rgb(108,120,142));
FProperty activeTabColor = fillColor(rgb(199,8,8));

private Figure renderButton(ProjectData projectData, Panel active, map[str, Figure] state, Panel panel, str text) {
	FProperty color = tabColor;
	
	if (active == panel) {
		color = activeTabColor;
	}
	
	return button(text, void(){ renderVisualization(panel, projectData, state); }, resizable(false), size(150, 50), color, textColor);
}

public Figure renderSidebar(ProjectData projectData, Panel active, map[str, Figure] state) {
	return hcat([ renderButton(projectData, active, state, \general(), "Dashboard"),
				  renderButton(projectData, active, state, \dependencies(), "Dependency graph"),
				  renderButton(projectData, active, state, \heatmap(), "Heat map cc and size"),
				  renderButton(projectData, active, state, \duplication(), "Duplication")
                ], resizable(false), align(0,0));
}