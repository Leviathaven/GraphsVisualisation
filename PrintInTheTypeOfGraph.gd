extends ColorRect
onready var checkOrient = get_node("CheckOrient")





func _on_AcceptData_pressed():
	var orient
	var weight
	if (checkOrient.pressed == true):
		orient = true
	else:
		orient = false
	GlobalVars.oriented = orient
	print (GlobalVars.oriented)
	GlobalVars.currGraphScene = preload("res://Node2D.tscn").instance()
	get_tree().get_root().add_child(GlobalVars.currGraphScene)
	get_tree().change_scene_to(GlobalVars.currGraphScene)
