## This class is meant to be an abstract class
class_name SaveConverter extends Resource

## The version of the save that is being converted from.
@export var From : int
## The version of the save that is being converted to.
@export var To : int

func Convert(data : Dictionary) -> Dictionary:
	return data
