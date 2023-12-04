class_name Vector3Stat extends StatBase

@export var BaseValue : Vector3
@export var MinValue : Vector3 = Vector3.ZERO
@export var UseMinValue : bool = false
@export var MaxValue : Vector3 = Vector3.ZERO
@export var UseMaxValue : bool = false

func GetValue(args : Array[String] = []) -> Vector3:
	return CalcValue(args)

func GetRawValue(args : Array[String] = []) -> Vector3:
	return CalcRawValue(args)

func Mod(key : String, value : Vector3, precentage : bool) -> void:
	if Registered(key):
		modifiers[key][0] = value
		modifiers[key][1] = precentage
	else:
		Register(key, value, precentage)

func ModScalar(key : String, value : float, precentage : bool) -> void:
	Mod(key, Vector3(value, value, value), precentage)

func CalcValue(args : Array[String]) -> Vector3:
	var finalValue : Vector3 = CalcRawValue(args)
	
	if UseMinValue == true && UseMaxValue == true:
		return min(max(finalValue, MinValue), MaxValue)
	elif UseMaxValue == true:
		return min(finalValue, MaxValue)
	elif UseMinValue == true:
		return max(finalValue, MinValue)
	else:
		return finalValue

func CalcRawValue(args : Array[String]) -> Vector3:
	var addValue : Vector3 = Vector3.ZERO
	
	for modifierKey : String in modifiers.keys():
		if modifierKey in args:
			continue
		
		if modifiers[modifierKey][1] == false:
			addValue += modifiers[modifierKey][0]
	
	var finalValue : Vector3 = BaseValue + addValue
	
	for modifierKey in modifiers.keys():
		if modifiers[modifierKey][1] == true:
			finalValue *= Vector3.ONE + modifiers[modifierKey][0]
	
	return finalValue
