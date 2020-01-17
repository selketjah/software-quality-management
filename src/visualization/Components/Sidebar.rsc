module visualization::Components::Sidebar

import vis::Figure;
import vis::Render;

import structs::Visualization;

import visualization::Dashboard;

public Figure renderSidebar(ProjectData projectData) {
	return vcat([ button("General", void(){ rerenderDashboard(\general(), projectData); }, vshrink(0.125)),
                  button("Cyclomatic complexity", void(){ rerenderDashboard(\complexity(), projectData); }, vshrink(0.125)),
                  button("Unit size", void(){ rerenderDashboard(\unitsize(), projectData); }, vshrink(0.125))
                ], vshrink(0.5), hshrink(0.1));
}