module analysers::LocAnalyser

import String;
import lang::java::m3::Core; 

bool isAnonymousClass(loc l) = contains(l.scheme, "anonymousClass");
bool isJavaFile(loc l) = contains(l.extension, "java");

bool canContainMethods(loc l) = isClass(l) || isInterface(l) || isEnum(l) || isAnonymousClass(l);
bool canContainFields(loc l) = isClass(l) || isInterface(l) || isAnonymousClass(l);

bool hasPackageModifier(M3 model, loc l) = ({ \public(), \protected(), \private() } & model.modifiers[l]) == {}; 