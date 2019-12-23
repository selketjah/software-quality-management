module math::Modulo
import util::Math;
import IO;

public int modulo(real a, real b){
	return toInt(a - b * toInt(a/b));
}

public real reduce(real x, real N) {
  return ((x * N) / pow(2,32));
}

public test bool reduceTest(){
	real i = reduce(10.0,2.0);
	println(i);
	return true;
}