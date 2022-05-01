extends Node

# ERROR MARGIN
const ERRM: float = pow(10, -5)

func floatIsEqual(float_a: float, float_b: float):
	return abs(abs(float_a) - abs(float_b)) < ERRM
	
