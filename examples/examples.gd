extends Node2D


func _ready() -> void:
	var stat : Vector4Stat = Vector4Stat.new()
	stat.BaseValue = Vector4(5, 3, 10, 8)
	stat.ModScalar("test", 0.5, true)
	print(stat.GetValue())
