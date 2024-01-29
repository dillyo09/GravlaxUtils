class_name IntStat extends StatBase

@export var BaseValue : int
@export var MinValue : int = 0
@export var UseMinValue : bool = false
@export var MaxValue : int = 0
@export var UseMaxValue : bool = false

var cachedValue : int = NAN
var cachedRawValue : int = NAN

func _set(property : StringName, value : Variant) -> bool:
	if property != "cachedValue" && property != "cachedRawValue":
		cachedValue = NAN
		cachedRawValue = NAN
	return false

func GetValue() -> int:
	if CheckNan(cachedValue):
		cachedValue = CalcValue()
	return cachedValue 

func GetRawValue() -> int:
	if CheckNan(cachedRawValue):
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

func CalcRawValue(args : Array[String] = []) -> float:
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

# CheckNan exists because is_nan doesn't work well with int, in Godot due to a bug
func CheckNan(number : int) -> bool:
	if number == -9223372036854775808:
		return true
	
	return is_nan(number)
