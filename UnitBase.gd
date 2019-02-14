extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal unitSelect(gridloc, MovRange, AttRange)
var MovRange
var AttRange=1
var MovRemain
var HPRemain
var stats = {}
var items = []
var equippeditem = 0
export (String) var unitID = "Mercenary"

onready var BattleMap = get_node("/root/BattleMain/BattleMap")
onready var LabelVar = get_node("Node2D/W")

onready var startlocation = BattleMap.world_to_map(rect_position)


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	BattleMap.connect("newTurn", self, "newturn")
	LabelVar.text=unitID[0]
	stats=StatManager.getunitstatsfromID(unitID)
	MovRemain=stats["Mov"]
	HPRemain=stats["HP"]
	for i in stats["Weapons"]:
		items.append(StatManager.item.new(i))
	
	
	
	pass


	


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func newturn():
	MovRemain=stats["Mov"]
	
func getlocation():
	return BattleMap.world_to_map(rect_position)
	

func _on_Button_pressed():
	emit_signal("unitSelect",BattleMap.world_to_map(get_global_mouse_position()), self)
	return
