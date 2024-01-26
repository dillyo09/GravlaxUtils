class_name Vector3Stat extends StatBase

@export var BaseValue : Vector3
@export var MinValue : Vector3 = Vector3.ZERO
@export var UseMinValue : bool = false
@export var MaxValue : Vector3 = Vector3.ZERO
@export var UseMaxValue : bool = false

var cachedValue : Vector3 = Vector3(NAN, NAN, NAN)
var cachedRawValue : Vector3 = Vector3(NAN, NAN, NAN)

func _set(property : StringName, value : Variant) -> bool:
	if property != "cachedValue" || property != "cachedRawValue":
		cachedValue = Vector3(NAN, NAN, NAN)
		cachedRawValue = Vector3(NAN, NAN, NAN)
	return false

func GetValue() -> Vector3:
	if is_nan(cachedValue.x):
		cachedValue = CalcValue()
	return cachedValue 

func GetRawValue() -> Vector3:
	if is_nan(cachedRawValue.x):
		cachedRawValue = CalcRawValue()
	return cachedRawValue

func Mod(key : String, value : Vector3, precentage : bool) -> void:
	if Registered(key):
		modifiers[key][0] = value
		modifiers[key][1] = precentage
	else:
		Register(key, value, precentage)
	
	cachedValue = Vector3(NAN, NAN, NAN)
	cachedRawValue = Vector3(NAN, NAN, NAN)

func ModScalar(key : String, value : float, precentage : bool) -> void:
	Mod(key, Vector3(value, value, value), precentage)

func CalcValue(args : Array[String] = []) -> Vector3:
	var finalValue: Vector3 = CalcRawValue(args)
	if UseMinValue:
		finalValue = max(finalValue, MinValue)
	if UseMaxValue:
		finalValue = min(finalValue, MaxValue)
	return finalValue

func CalcRawValue(args : Array[String] = []) -> Vector3:
	var addValue : Vector3 = Vector3.ZERO
	var finalMultiplier : Vector3 = Vector3.ONE

	for modifierKey in modifiers.keys():
		var modifierData = modifiers[modifierKey]
		
		if modifierKey not in args:
			if not modifierData[1]:
				addValue += modifierData[0]
			else:
				finalMultiplier *= Vector3.ONE + modifierData[0]

	return (BaseValue + addValue) * finalMultiplier
