class_name SaveManager extends Node

## The current version of the save file.
@export var CurrentVersion : int
## An unordered list of Save Converters, these are sorted via code.
@export var Converters : Array[SaveConverter]

func SaveExists(path : String) -> bool:
	return FileAccess.file_exists(path)

func Save(path : String, data : Dictionary) -> void:
	var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if FileAccess.get_open_error() != OK:
		printerr("Could not open the file %s. Aborting save operation. Error code: %s" % [path, FileAccess.get_open_error()])
		return
	
	data["CurrentVersion"] = CurrentVersion
	
	file.store_var(data, true)
	file.close()

func Load(path : String) -> Dictionary:
	var file : FileAccess = FileAccess.open(path, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		printerr("Could not open the file %s. Aborting load operation. Error code: %s" % [path, FileAccess.get_open_error()])
		return {}
	
	var data : Dictionary = file.get_var(true)
	LoadCell("CurrentVersion", data)
	
	Converters.sort_custom(SortVersion)
	for converter in Converters:
		if CurrentVersion < converter.To:
			data = converter.Convert(data)
			CurrentVersion = converter.To
	
	# Don't re-save data right away in case of conversion error.
	file.close()
	return data

func SortVersion(a : SaveConverter, b : SaveConverter) -> bool:
	return a.From < b.From

func LoadCell(value : String, data : Dictionary) -> void:
	if data.has(value):
		set(value, data[value])
