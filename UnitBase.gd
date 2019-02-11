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
export (String) var unitID = "Mercenary"

onready var BattleMap = get_node("/root/BattleMain/BattleMap")
onready var LabelVar = get_node("Node2D/W")


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	BattleMap.connect("newTurn", self, "newturn")
	LabelVar.text=unitID[0]
	getstatsfromID()
	MovRemain=stats["Mov"]
	HPRemain=stats["HP"]
	
	
	
	pass

func getstatsfromID():
	var filelocation="res://UnitID/"+unitID
	var file = File.new()
	if file.file_exists(filelocation):
		file.open(filelocation, file.READ)
		while not file.eof_reached():
			var line = file.get_line()
			var words = line.split(" ")
			if not len(words)==2:
				print("Incorrect formatting of UnitID("+unitID+"), word count for line incorrect, error E0002")
			else:
				stats[words[0]]=int(words[1])
		
	else:
		print("FILE NOT FOUND ERROR IN UnitBase.gd, error E0001")
	


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func newturn():
	MovRemain=stats["Mov"]

func _on_Button_pressed():
	emit_signal("unitSelect",BattleMap.world_to_map(get_global_mouse_position()), self)
	return
