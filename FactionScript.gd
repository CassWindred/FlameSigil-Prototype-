extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (String) var Allies = ""
export (String) var Enemies = ""
var AllyList=[]
var EnemyList =[]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	var Allystrings=Allies.split(", ")
	var Enemystrings=Enemies.split(", ")
	for i in Allystrings:
		AllyList.append(get_parent().get_node(i))
	for i in Enemystrings:
		EnemyList.append(get_parent().get_node(i))

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
