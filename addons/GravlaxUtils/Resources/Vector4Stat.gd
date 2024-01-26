class_name Vector4Stat extends StatBase

@export var BaseValue : Vector4
@export var MinValue : Vector4 = Vector4.ZERO
@export var UseMinValue : bool = false
@export var MaxValue : Vector4 = Vector4.ZERO
@export var UseMaxValue : bool = false

var cachedValue : Vector4 = Vector4(NAN, NAN, NAN, NAN)
var cachedRawValue : Vector4 = Vector4(NAN, NAN, NAN, NAN)

func _set(property : StringName, value : Variant) -> bool:
	if property != "cachedValue" || property != "cachedRawValue":
		cachedValue = Vector4(NAN, NAN, NAN, NAN)
		cachedRawValue = Vector4(NAN, NAN, NAN, NAN)
	return false

func GetValue() -> Vector4:
	if is_nan(cachedValue.x):
		cachedValue = CalcValue()
	return cachedValue 

func GetRawValue() -> Vector4:
	if is_nan(cachedRawValue.x):
		cachedRawValue = CalcRawValue()
	return cachedRawValue

func Mod(key : String, value : Vector4, precentage : bool) -> void:
	if Registered(key):
		modifiers[key][0] = value
		modifiers[key][1] = precentage
	else:
		Register(key, value, precentage)
	
	cachedValue = Vector4(NAN, NAN, NAN, NAN)
	cachedRawValue = Vector4(NAN, NAN, NAN, NAN)

func ModScalar(key : String, value : float, precentage : bool) -> void:
	Mod(key, Vector4(value, value, value, value), precentage)

func CalcValue(args : Array[String] = []) -> Vector4:
	var finalValue: Vector4 = CalcRawValue(args)
	if UseMinValue:
		finalValue = max(finalValue, MinValue)
	if UseMaxValue:
		finalValue = min(finalValue, MaxValue)
	return finalValue

func CalcRawValue(args : Array[String] = []) -> Vector4:
	var addValue : Vector4 = Vector4.ZERO
	var finalMultiplier : Vector4 = Vector4.ONE

	for modifierKey in modifiers.keys():
		var modifierData = modifiers[modifierKey]
		
		if modifierKey not in args:
			if not modifierData[1]:
				addValue += modifierData[0]
			else:
				finalMultiplier *= Vector4.ONE + modifierData[0]

	return (BaseValue + addValue) * finalMultiplier
