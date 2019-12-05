module analyser::LocAnalyser

import Message;
import Set;
import IO;
import String;
import List;
import Map;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Resources;

bool isClass(loc l) = contains(l.scheme, "class");
bool isInterface(loc l) = contains(l.scheme, "interface");
bool isEnum(loc l) = contains(l.scheme, "enum");
bool isAnonymousClass(loc l) = contains(l.scheme, "anonymousClass");
bool isMethod(loc l) = contains(l.scheme, "method") || contains(l.scheme, "constructor");
bool isField(loc l) = contains(l.scheme, "field");
bool isPackage(loc l) = contains(l.scheme, "package");

bool canContainMethods(loc l) = isClass(l) || isInterface(l) || isEnum(l) || isAnonymousClass(l);
bool canContainFields(loc l) = isClass(l) || isInterface(l) || isAnonymousClass(l);

bool hasPackageModifier(M3 model, loc l) = ({ \public(), \protected(), \private() } & model.modifiers[l]) == {}; 