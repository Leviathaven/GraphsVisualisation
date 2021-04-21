extends ColorRect
onready var label = get_node("Label")
onready var Rect = get_node(".")
var key
var fl = false
var x
var y
var Adjacent_list = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func set_param(k, par1, par2):
	key = k
	x = par1
	y = par2

func init():
	if !fl:
		label.text = key as String
		self.set_global_position(Vector2(x, y))
		fl = true

func Adjacent_Add(num, w):
	Adjacent_list[num] = w
	
func Adjacent_Remove(num):
	Adjacent_list.erase(num)
	
func sizex():
	return self.rect_size.x

func changeColor():
	Rect.color = Color(1, 0, 0, 1)

func changeColor1():
	Rect.color = Color(0, 1, 0, 1)


func changeColorBack():
	Rect.color = Color(1, 1, 1, 1)
