
module visualization::Charts::Pie

import vis::Figure;
import vis::Render;

FProperty volumeBoxColor = fillColor(rgb(238,174,170));
FProperty percentageBoxColor = fillColor(rgb(218,174,170));

public Figure renderPercentageBar() {
	Figure scaledbox(){
	   int n = 100;
	   return vcat([ 
	   		hcat([scaleSlider(int() { return 0; },     
	                                    int () { return 400; },  
	                                    int () { return n; },    
	                                    void (int s) { n = s; }, 
	                                    width(400)),
	                        text(str () { return "n: <n>";})
	                      ], left(),  top(), resizable(false)),  
	                 computeFigure(Figure (){ return box(size(n), resizable(false)); })
	                 
	               ]);
	}
render(scaledbox()); 
}