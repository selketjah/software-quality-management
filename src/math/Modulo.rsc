module math::Modulo

public int modulo(real a, real b){
	
	return toInt(a - b * toInt(a/b));
}