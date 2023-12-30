class_name IntStat extends StatBase

@export var BaseValue : int
@export var MinValue : int = 0
@export var UseMinValue : bool = false
@export var MaxValue : int = 0
@export var UseMaxValue : bool = false

func GetValue(args : Array[String] = []) -> int:
	return CalcValue(args)

func GetRawValue(args : Array[String] = []) -> int:
	return CalcRawValue(args)
	
func Mod(key : String, value : float, precentage : bool) -> void:
	if Registered(key):
		modifiers[key][0] = value
		modifiers[key][1] = precentage
	else:
		Register(key, value, precentage)

func CalcValue(args : Array[String]) -> float:
	var finalValue : int = CalcRawValue(args)
	if UseMinValue:
		finalValue = max(finalValue, MinValue)
	if UseMaxValue:
		finalValue = min(finalValue, MaxValue)
	return finalValue

func CalcRawValue(args : Array[String]) -> float:
	var addValue : int = 0
	var finalMultiplier : float = 1.0

	for modifierKey in modifiers.keys():
		var modifierData = modifiers[modifierKey]
		
		if modifierKey not in args:
			if not modifierData[1]:
				addValue += modifierData[0]
			else:
				finalMultiplier *= 1 + modifierData[0]
	
	return round((BaseValue + addValue) * finalMultiplier)
