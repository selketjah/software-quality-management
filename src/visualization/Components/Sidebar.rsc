module visualization::Components::Sidebar

import vis::Figure;
import vis::Render;

import structs::Visualization;

import visualization::Dashboard;

public Figure renderSidebar() {
	return vcat([ button("General", void(){ rerenderDashboard("general"); }, vshrink(0.125)),
                  button("Complexity", void(){ rerenderDashboard("complexity"); }, vshrink(0.125))
                ], vshrink(0.5), hshrink(0.1));
}