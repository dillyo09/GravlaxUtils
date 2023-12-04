class_name Vector2Stat extends StatBase

@export var BaseValue : Vector2
@export var MinValue : Vector2 = Vector2.ZERO
@export var UseMinValue : bool = false
@export var MaxValue : Vector2 = Vector2.ZERO
@export var UseMaxValue : bool = false

func GetValue(args : Array[String] = []) -> Vector2:
	return CalcValue(args)

func GetRawValue(args : Array[String] = []) -> Vector2:
	return CalcRawValue(args)
	
func Mod(key : String, value : Vector2, precentage : bool) -> void:
	if Registered(key):
		modifiers[key][0] = value
		modifiers[key][1] = precentage
	else:
		Register(key, value, precentage)

func ModScalar(key : String, value : float, precentage : bool) -> void:
	Mod(key, Vector2(value, value), precentage)

func CalcValue(args : Array[String]) -> Vector2:
	var finalValue : Vector2 = CalcRawValue(args)
	
	if UseMinValue == true && UseMaxValue == true:
		return min(max(finalValue, MinValue), MaxValue)
	elif UseMaxValue == true:
		return min(finalValue, MaxValue)
	elif UseMinValue == true:
		return max(finalValue, MinValue)
	else:
		return finalValue

func CalcRawValue(args : Array[String]) -> Vector2:
	var addValue : Vector2 = Vector2.ZERO
	
	for modifierKey : String in modifiers.keys():
		if modifierKey in args:
			continue
		
		if modifiers[modifierKey][1] == false:
			addValue += modifiers[modifierKey][0]
	
	var finalValue : Vector2 = BaseValue + addValue
	
	for modifierKey in modifiers.keys():
		if modifiers[modifierKey][1] == true:
			finalValue *= Vector2.ONE + modifiers[modifierKey][0]
	
	return finalValue
