extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var dragspeed=2

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	pass
	
func _unhandled_input(event):
	if event is InputEventScreenDrag:
		#print(-event.relative)
		dotranslate(-event.relative*dragspeed)
		
	
func dotranslate(inpvector):
	translate(inpvector)

func _process(delta):
	#dotranslate(Vector2(1,1))
	pass
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
