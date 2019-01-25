extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal unitSelect(gridloc, MovRange, AttRange)
var MovRange = 5
var AttRange = 1

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass




#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Button_pressed():
	emit_signal("unitSelect",get_parent().get_parent().get_node("BattleMap").world_to_map(get_global_mouse_position()),MovRange,AttRange)
	return
