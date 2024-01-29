class_name FloatStat extends StatBase

@export var BaseValue : float
@export var MinValue : float = 0
@export var UseMinValue : bool = false
@export var MaxValue : float = 0
@export var UseMaxValue : bool = false

var cachedValue : float = NAN
var cachedRawValue : float = NAN

func _set(property : StringName, value : Variant) -> bool:
	if property != "cachedValue" && property != "cachedRawValue":
		cachedValue = NAN
		cachedRawValue = NAN
	return false

func GetValue() -> float:
	if is_nan(cachedValue):
		cachedValue = CalcValue()
	return cachedValue 

func GetRawValue() -> float:
	if is_nan(cachedRawValue):
		cachedRawValue = CalcRawValue()
	return cachedRawValue
	
func Mod(key : String, value : float, precentage : bool) -> void:
	if Registered(key):
		modifiers[key][0] = value
		modifiers[key][1] = precentage
	else:
		Register(key, value, precentage)
	
	cachedRawValue = NAN
	cachedValue = NAN

func CalcValue(args : Array[String] = []) -> float:
	var finalValue: float = CalcRawValue(args)
	if UseMinValue:
		finalValue = max(finalValue, MinValue)
	if UseMaxValue:
		finalValue = min(finalValue, MaxValue)
	return finalValue

func CalcRawValue(args: Array[String] = []) -> float:
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
