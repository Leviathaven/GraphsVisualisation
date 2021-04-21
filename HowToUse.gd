extends ColorRect
onready var DrawInstr = get_node("DrawVerticesInstr")
onready var EdgeInstr = get_node("EdgesInstr")
onready var FSInstr = get_node("FSInstr")
var flagDrawInstr = false
var flagEdgesInstr = false
var flagFSInstr = false

func _on_ShowVerticeInstr_pressed():
	if (flagDrawInstr == false):
		flagDrawInstr = true
		DrawInstr.percent_visible = 1
	else:
		flagDrawInstr = false
		DrawInstr.percent_visible = 0


func _on_ShowEdgeInstr_pressed():
	if (flagEdgesInstr == false):
		flagEdgesInstr = true
		EdgeInstr.percent_visible = 1
	else:
		flagEdgesInstr = false
		EdgeInstr.percent_visible = 0


func _on_ShowFsInstr_pressed():
	if (flagFSInstr == false):
		flagFSInstr = true
		FSInstr.percent_visible = 1
	else:
		flagFSInstr = false
		FSInstr.percent_visible = 0


func _on_ReturnToDrawing_pressed():
	get_tree().change_scene_to(GlobalVars.currGraphScene)
