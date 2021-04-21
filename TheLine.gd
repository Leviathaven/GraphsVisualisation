extends Node2D
var a
var b

onready var textNonOrient
onready var LineOr = get_node("Line2DOriented")
onready var LineNonOr = get_node("Line2DNonOriented")

func _ready():
	if (GlobalVars.oriented == true):
		LineOr.add_point(GlobalVars.v1)
		LineOr.add_point(GlobalVars.v2)
	else:
		LineNonOr.add_point(GlobalVars.v1)
		LineNonOr.add_point(GlobalVars.v2)
