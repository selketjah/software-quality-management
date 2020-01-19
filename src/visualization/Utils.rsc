module visualization::Utils

import lang::java::m3::Registry;
import util::Editors;
import vis::Figure;
import vis::Render;
import vis::KeySym;

FProperty popup(str message) {
	return mouseOver(box(text(message), resizable(false)));
}

FProperty openMethodOnClick(loc methodLoc) {
	return onMouseDown(
		bool (int butnr, map[KeyModifier,bool] modifiers) {
			edit(resolveJava(methodLoc));
			return true;
		}
	);
}

FProperty openDocumentOnClick(loc src) {
	return onMouseDown(
		bool (int btn, map[KeyModifier,bool] modifiers) {
		if(btn == 1){ 
			edit(src);
			return true;
		}
		return false;
	});
}