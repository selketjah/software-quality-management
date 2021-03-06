module scoring::Maintainability

import structs::Maintainability;
    
public str convertMaintainabilityCharacteristicToLiteral(MaintainabilityCharacteristic maintainabilityCharacteristic) {
	switch(maintainabilityCharacteristic) {
		case \analysability():	return "Analysability";
		case \changeability():	return "Changeability";
		case \stability():		return "Stability";
		case \testability():	return "Testability";
		default:				return "N/A";
	}
}