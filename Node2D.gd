extends ColorRect
onready var touch = get_node("TouchScreenButton")
onready var newKeyText = get_node("Menu/AddNewKey")
onready var menu = get_node("Menu")
onready var flag = get_node("Menu/FlagButton")
onready var flag2 = get_node("Menu/FlagButton2")
onready var startEdge = get_node("Menu/StartOfEdge")
onready var endEdge = get_node("Menu/EndOfEdge")
onready var sourceText = get_node("Menu/Source")
onready var time = get_node("Timer")
onready var time2 = get_node("Timer2")
signal InsertNewNode()
signal AddingConnections()
var keyCount = 0
var currentVert = []
var vis
var massGraph = {}
var massLines = {}
var flagDFS = false
var flagBFS = false
var flagDFSTimer = false
var flagBFSTimer = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_click"):
		if GlobalVars.adding_graph_node:
			var check = false
			if GlobalVars.currKey in massGraph:
				check = true
			if check == false:
				var current_pos = touch.get_global_mouse_position()
				var menu_pos = menu.rect_position
				var node = preload("res://Node/GraphNode.tscn").instance()
				if current_pos.x <= menu_pos.x - node.sizex():
					node.set_param(GlobalVars.currKey, current_pos.x, current_pos.y)
					self.connect("InsertNewNode", node, "init")
					self.add_child(node)
					massGraph[GlobalVars.currKey] = node
					massLines[GlobalVars.currKey] = {}
					print(massLines)
					emit_signal("InsertNewNode")
					GlobalVars.adding_graph_node = false
			else:
				GlobalVars.adding_graph_node = false
				flag.text = "Такой ключ уже есть в графе"
	if Input.is_action_just_released("next_step"):
		if (flagDFS == true) and (flagDFSTimer == false):
			if (currentVert.size() != 0):
				DFS(currentVert[0], vis)
			else:
				ClearAll()
		if (flagBFS == true) and (flagBFSTimer == false):
			if (currentVert.size() != 0):
				BFS(currentVert[0], vis)
			else:
				ClearAll()


func _on_BtnNewKey_pressed():
	ClearAll()
	if newKeyText.text != null:
		flag.text = ""
		GlobalVars.currKey = int(float(String(newKeyText.text)))
		GlobalVars.adding_graph_node = true
		newKeyText.text = ""


func _on_BtnAddEdge_pressed():
	ClearAll()
	var a = String(startEdge.text)
	var b = String(endEdge.text)
	var aint = int(float(a))
	var bint = int(float(b))
	if (aint in massGraph) and (bint in massGraph):
		var orient = GlobalVars.oriented
		var firstNode = massGraph[aint]
		var secondNode = massGraph[bint]
		if (orient == false):
			firstNode.Adjacent_Add(bint, 0.0)
			secondNode.Adjacent_Add(aint, 0.0)
		else:
			firstNode.Adjacent_Add(bint, 0.0)
		var s = firstNode.sizex()
		var x1 = firstNode.x
		var y1 = firstNode.y
		var x2 = secondNode.x
		var y2 = secondNode.y
		print (x1, y1, x2, y2)
		if (x1 + s < x2):
			GlobalVars.v1 = Vector2(x1 + s, y1 + s / 2)
			GlobalVars.v2 = Vector2(x2, y2 + s / 2)
		elif (x2 + s < x1): 
			GlobalVars.v1 = Vector2(x1, y1 + s / 2)
			GlobalVars.v2 = Vector2(x2 + s, y2 + s / 2)
		elif (y2 + s < y1):
			GlobalVars.v1 = Vector2(x1 + s / 2, y1)
			GlobalVars.v2 = Vector2(x2 + s / 2, y2 + s)
		else:
			GlobalVars.v2 = Vector2(x2 + s / 2, y2)
			GlobalVars.v1 = Vector2(x1 + s / 2, y1 + s)
		print (x1, y1, x2, y2)
			
		print (GlobalVars.v1, GlobalVars.v2)
		var line = preload("res://TheLine.tscn").instance()
		line.a = aint
		line.b = bint
		self.add_child(line)
		if (GlobalVars.oriented == true):
			massLines[aint][bint] = line
		else:
			massLines[aint][bint] = line
			massLines[bint][aint] = line
	else: 
		flag2.text = "Одной из вершин нет в графе"
	startEdge.text = ""
	endEdge.text = ""

func ClearAll():
	currentVert.clear()
	flag2.text = ""
	flag.text = ""
	flagBFS = false
	flagDFS = false
	flagBFSTimer = false
	flagDFSTimer = false
	for vert in massGraph.values():
		vert.changeColorBack()


func _on_BtnDeleteEdge_pressed():
	ClearAll()
	var a = String(startEdge.text)
	var b = String(endEdge.text)
	var aint = int(float(a))
	var bint = int(float(b))
	if (aint in massGraph) and (bint in massGraph):
		if (GlobalVars.oriented == true):
			if (bint in massGraph[aint].Adjacent_list.keys()):
				massLines[aint][bint].free()
				massLines[aint].erase(bint)
				massGraph[aint].Adjacent_Remove(bint)
		else:
			if (bint in massGraph[aint].Adjacent_list.keys()) and (aint in massGraph[bint].Adjacent_list.keys()):
				massLines[aint][bint].free()
				massLines[aint].erase(bint)
				massLines[bint].erase(aint)
				massGraph[bint].Adjacent_Remove(aint)
				massGraph[aint].Adjacent_Remove(bint)
	else:
		flag2.text = "Одной из вершин нет в графе"


func _on_DFSBtn_pressed():
	ClearAll()
	flagDFS = true
	var src = int(float(String(sourceText.text)))
	if massGraph.has(src):
		var visited = {}
		for keys in massGraph.keys():
			visited[keys] = 0
		DFS(src, visited)
	
func DFS(src, visited):
	visited[src] = 2
	currentVert.pop_front()
	print(massGraph[src])
	massGraph[src].changeColor()
	var adj = massGraph[src].Adjacent_list.keys()
	for vert in adj:
		if visited[vert] == 0:
			visited[vert] = 1
			massGraph[vert].changeColor1()
			currentVert.push_front(vert)
			vis = visited
	if (flagDFSTimer == true):
		time.start()

func _on_BFSBtn_pressed():
	ClearAll()
	flagBFS = true
	var src = int(float(String(sourceText.text)))
	if massGraph.has(src):
		var visited = {}
		for keys in massGraph.keys():
			visited[keys] = 0
		BFS(src, visited)

func BFS(src, visited):
	visited[src] = 2
	currentVert.pop_front()
	print(massGraph[src])
	massGraph[src].changeColor()
	var adj = massGraph[src].Adjacent_list.keys()
	for vert in adj:
		if visited[vert] == 0:
			visited[vert] = 1
			massGraph[vert].changeColor1()
			currentVert.push_back(vert)
			vis = visited
	if (flagBFSTimer == true):
		time2.start()


func _on_DFSBtn2_pressed():
	ClearAll()
	flagDFSTimer = true
	flagDFS = true
	var src = int(float(String(sourceText.text)))
	if massGraph.has(src):
		var visited = {}
		for keys in massGraph.keys():
			visited[keys] = 0
		DFS(src, visited)

func _on_Timer_timeout():
	if flagDFS == true:
		if (currentVert.size() != 0):
			DFS(currentVert[0], vis)
		else:
			ClearAll()

func _on_BFSBtn2_pressed():
	ClearAll()
	flagBFSTimer = true
	flagBFS = true
	var src = int(float(String(sourceText.text)))
	if massGraph.has(src):
		var visited = {}
		for keys in massGraph.keys():
			visited[keys] = 0
		BFS(src, visited)


func _on_Timer2_timeout():
	if flagBFS == true:
		if (currentVert.size() != 0):
			BFS(currentVert[0], vis)
		else:
			ClearAll()


func _on_OpenInstructions_pressed():
	GlobalVars.currGraphScene = self
	get_tree().change_scene("res://HowToUse.tscn")
