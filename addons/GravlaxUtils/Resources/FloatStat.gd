class_name FloatStat extends StatBase

@export var BaseValue : float
@export var MinValue : float = 0
@export var UseMinValue : bool = false
@export var MaxValue : float = 0
@export var UseMaxValue : bool = false

func GetValue(args : Array[String] = []) -> float:
	return CalcValue(args)

func GetRawValue(args : Array[String] = []) -> float:
	return CalcRawValue(args)
	
func Mod(key : String, value : float, precentage : bool) -> void:
	if Registered(key):
		modifiers[key][0] = value
		modifiers[key][1] = precentage
	else:
		Register(key, value, precentage)

func CalcValue(args : Array[String]) -> float:
	var finalValue : float = CalcRawValue(args)
	
	if UseMinValue == true && UseMaxValue == true:
		return min(max(finalValue, MinValue), MaxValue)
	elif UseMaxValue == true:
		return min(finalValue, MaxValue)
	elif UseMinValue == true:
		return max(finalValue, MinValue)
	else:
		return finalValue

func CalcRawValue(args : Array[String]) -> float:
	var addValue : float = 0.0
	
	for modifierKey : String in modifiers.keys():
		if modifierKey in args:
			continue
		
		if modifiers[modifierKey][1] == false:
			addValue += modifiers[modifierKey][0]
	
	var finalValue : float = BaseValue + addValue
	
	for modifierKey in modifiers.keys():
		if modifiers[modifierKey][1] == true:
			finalValue *= 1 + modifiers[modifierKey][0]
	
	return finalValue
