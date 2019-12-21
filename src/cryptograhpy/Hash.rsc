module cryptograhpy::Hash
import String;
import util::Math;
import math::Modulo;

public real computeHash(str toBeHashed){
	real p = 35.0;
	//m = a random but large number
	real m = 1e52*33;
	
	real hashVal = 0.0;
	real pPow= 1.0;
	setPrecision(0);
	for(int c <- chars(toBeHashed)){
		hashVal = toReal(modulo((hashVal + toReal(c - chars("a")[0] + 1) * pPow), m));

		pPow = toReal(modulo((pPow * p),m));
	}
	
	return hashVal;
}