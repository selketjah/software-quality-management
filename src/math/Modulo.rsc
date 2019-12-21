module math::Modulo
import util::Math;

public int modulo(real a, real b){
	
	return toInt(a - b * toInt(a/b));
}