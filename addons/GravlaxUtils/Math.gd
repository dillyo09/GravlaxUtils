class_name GRXMath extends Node


static func Normalizef(number : float, lowerBound : float, upperBound : float, minNum : float, maxNum : float) -> float:
	return minNum + (number - lowerBound) * (maxNum - minNum) / (upperBound - lowerBound)


static func Normalizei(number : int, lowerBound : int, upperBound : int, minNum : int, maxNum : int) -> int:
	return minNum + (number - lowerBound) * (maxNum - minNum) / (upperBound - lowerBound)
