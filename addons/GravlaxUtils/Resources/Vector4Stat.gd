class_name Vector4Stat extends StatBase

@export var BaseValue : Vector4
@export var MinValue : Vector4 = Vector4.ZERO
@export var UseMinValue : bool = false
@export var MaxValue : Vector4 = Vector4.ZERO
@export var UseMaxValue : bool = false

func GetValue(args : Array[String] = []) -> Vector4:
	return CalcValue(args)

func GetRawValue(args : Array[String] = []) -> Vector4:
	return CalcRawValue(args)

func Mod(key : String, value : Vector4, precentage : bool) -> void:
	if Registered(key):
		modifiers[key][0] = value
		modifiers[key][1] = precentage
	else:
		Register(key, value, precentage)

func ModScalar(key : String, value : float, precentage : bool) -> void:
	Mod(key, Vector4(value, value, value, value), precentage)

func CalcValue(args : Array[String]) -> Vector4:
	var finalValue : Vector4 = CalcRawValue(args)
	
	if UseMinValue == true && UseMaxValue == true:
		return min(max(finalValue, MinValue), MaxValue)
	elif UseMaxValue == true:
		return min(finalValue, MaxValue)
	elif UseMinValue == true:
		return max(finalValue, MinValue)
	else:
		return finalValue

func CalcRawValue(args : Array[String]) -> Vector4:
	var addValue : Vector4 = Vector4.ZERO
	
	for modifierKey : String in modifiers.keys():
		if modifierKey in args:
			continue
		
		if modifiers[modifierKey][1] == false:
			addValue += modifiers[modifierKey][0]
	
	var finalValue : Vector4 = BaseValue + addValue
	
	for modifierKey in modifiers.keys():
		if modifiers[modifierKey][1] == true:
			finalValue *= Vector4.ONE + modifiers[modifierKey][0]
	
	return finalValue
