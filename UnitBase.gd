extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal unitSelect(gridloc, MovRange, AttRange)
var MovRange = 5
var AttRange = 1
var MovRemain = 5
export (String) var unitID = "Warrior"

onready var BattleMap = get_node("/root/BattleMain/BattleMap")
onready var LabelVar = get_node("Node2D/W")


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	BattleMap.connect("newTurn", self, "newturn")
	LabelVar.text=unitID[0]
	
	
	pass




#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func newturn():
	MovRemain=MovRange

func _on_Button_pressed():
	emit_signal("unitSelect",BattleMap.world_to_map(get_global_mouse_position()),MovRemain,AttRange, self)
	return
