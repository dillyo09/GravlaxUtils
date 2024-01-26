class_name StatBase extends Resource

var modifiers : Dictionary

func GetValue() -> Variant:
	return null

func GetRawValue() -> Variant:
	return null

func CalcValue(args : Array[String] = []) -> Variant:
	return null

func CalcRawValue(args: Array[String] = []) -> Variant:
	return null
	
func TryGetValue(key : String) -> Variant:
	if Registered(key):
		return modifiers.get(key)[0]
	else:
		assert(true, "Key not registered?!")
		return 0

func Register(key : String, value : Variant, precentage : bool) -> void:
	modifiers[key] = [value, precentage]

func Registered(key : String) -> bool:
	return modifiers.keys().has(key)
