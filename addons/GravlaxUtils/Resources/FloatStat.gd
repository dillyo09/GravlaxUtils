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
	var finalValue: float = CalcRawValue(args)
	if UseMinValue:
		finalValue = max(finalValue, MinValue)
	if UseMaxValue:
		finalValue = min(finalValue, MaxValue)
	return finalValue

func CalcRawValue(args : Array[String]) -> float:
	var addValue : float = 0.0
	var finalMultiplier : float = 1.0

	for modifierKey in modifiers.keys():
		var modifierData = modifiers[modifierKey]
		
		if modifierKey not in args:
			if not modifierData[1]:
				addValue += modifierData[0]
			else:
				finalMultiplier *= 1 + modifierData[0]

	return (BaseValue + addValue) * finalMultiplier
