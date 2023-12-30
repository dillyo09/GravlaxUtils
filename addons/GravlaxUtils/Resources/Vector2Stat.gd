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
	if UseMinValue:
		finalValue = max(finalValue, MinValue)
	if UseMaxValue:
		finalValue = min(finalValue, MaxValue)
	return finalValue

func CalcRawValue(args : Array[String]) -> Vector2:
	var addValue : Vector2 = Vector2.ZERO
	var finalMultiplier : Vector2 = Vector2.ONE

	for modifierKey in modifiers.keys():
		var modifierData = modifiers[modifierKey]
		
		if modifierKey not in args:
			if not modifierData[1]:
				addValue += modifierData[0]
			else:
				finalMultiplier *= Vector2.ONE + modifierData[0]

	return (BaseValue + addValue) * finalMultiplier
