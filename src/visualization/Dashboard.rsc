module visualization::Dashboard

import vis::Figure;
import vis::Render;

public Figure inc(){
	int n = 0;
	return vcat([ button("Increment", void(){n += 1;}),
                  text(str(){return "<n>";})
                ]);
}

public Figure choiceTest(){
  str state = "A";
  return vcat([ choice(["A","B","C","D"], void(str s){ state = s;}),
                text(str(){return "Current state: " + state ;}, left())
              ]);
}

public void renderDashboard() {
	row1 = [ box(text("bla\njada"),fillColor("Red")),
	         ellipse(fillColor("Blue")),
	         box(fillColor("Yellow"))
	       ];
	row2 = [ box(ellipse(fillColor("Yellow")),fillColor("Green")),
	         box(fillColor("Purple")),
	         box(text("blablabalbalba"),fillColor("Orange"))
	       ];
	render(grid([row1, row2],hgrow(1.1),vgrow(1.3)));
}