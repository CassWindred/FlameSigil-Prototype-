extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Standard Tiles
onready var TILE_TREE = tile_set.find_tile_by_name("--Tree")
onready var TILE_GRASS = tile_set.find_tile_by_name("Grass1")

#Overlay Tiles (OL=OVERLAY)
onready var OL = get_node("Overlays") #This will be a shortening for Overlays
onready var RED_OL =OL.tile_set.find_tile_by_name("Red")
onready var GREEN_OL =OL.tile_set.find_tile_by_name("Green")
onready var BLUE_OL =OL.tile_set.find_tile_by_name("Blue")
onready var LIGHTBLUE_OL =OL.tile_set.find_tile_by_name("LightBlue")

signal unitSelect(gridloc, MovRange, AttRange) 
export (int) var sizex=20
export (int) var sizey=30

onready var movecosts = []
onready var unitlocations = []

onready var UnitGui = get_node("../CanvasLayer/UnitGui")
onready var FightMan = get_node("../FightManager")

var move_range = {}
var attack_range = []
var selected
var factions = []
var units = []


signal newTurn() #Autolinked to EndTurnButton
signal anyUnitSelected()
signal unitDeselect()

var recentclickdown #Contains the square most recently clicked down on, for use when clicked up


func _ready():
	
	#Initialise Factions and units
	factions=get_parent().get_node("Factions").get_children()
	for i in factions:
		for j in i.get_children():
			units.append(j)
	
	



	#get_parent().get_node("Units").get_node("UnitWarrior").connect("unitSelect", self, "_onUnitSelect")
	movecosts.resize(sizex)
	for x in range(sizex):
		movecosts[x]=[]
		movecosts[x].resize(sizey)
		for y in range(sizey):
			var tile=get_cell(x,y)
			
			if tile==TILE_TREE:
				movecosts[x][y]= -1 #THE VALUE HERE REPRESENTS THE COST TO MOVE THERE, -2 IS IMPASSABLE, -1 IS ONLY PASSABLE FOR FLYERS
			else:
				movecosts[x][y]=1
			
	unitlocations.resize(sizex)
	for x in range(sizex):
		unitlocations[x]=[]
		unitlocations[x].resize(sizey)
		
	for instance in units:
		instance.connect("unitSelect", self, "_on_unit_select")
		#unitlocations[instance.startlocation.x][instance.startlocation.y]=instance

func _on_unit_select(gridloc, unit):
	if canselectedattack(gridloc) and gridloc!=selected.getlocation():
		selectedattack(gridloc)
	else:
		deselect()
		var AttRange=unit.AttRange
		var MovRange=unit.MovRemain
		findrange(gridloc,MovRange)

		
		#print("Attack Array is: ", str(attack_range))
		#print("Move Array is: ", str(move_range))
		for i in attack_range:
			OL.set_cellv(i, RED_OL)
		for i in move_range.keys():
			OL.set_cellv(i, BLUE_OL) #Set in range tiles as blue
	
		selected=unit
		emit_signal("anyUnitSelected",unit)
	
func _unhandled_input(event): #On an event not handled by anything else
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if Input.is_action_just_pressed("ui_click"):
			if event.pressed==true:
				recentclickdown=world_to_map(get_global_mouse_position())
		elif Input.is_action_just_released("ui_click") and recentclickdown==world_to_map(get_global_mouse_position()):
			var gridchosen
			gridchosen=world_to_map(get_global_mouse_position()) #Finds which grid tile the mouse is at
			if gridchosen in move_range:
				moveselected(gridchosen)
				deselect()
			elif canselectedattack(gridchosen):
				selectedattack(gridchosen)
			else:
				deselect() #Clear the overlay and arrays
				OL.set_cellv(gridchosen, GREEN_OL)
				var tile=get_cellv(gridchosen)
				print("Tile index for "+str(gridchosen) + " is " + str(tile))
				#if movecosts[gridchosen.x][gridchosen.y]["passable"]==true:
				#	print("Passable")
				#else:
				#	print("Not Passable")
				
				
func _on_EndTurnButton_pressed():
	newturn()

func deselect(): #Clears the overlay and the attack and move array
	attack_range = []
	move_range = {}
	OL.clear()
	emit_signal("unitDeselect")
	
func moveselected(target):
	var oldloc=selected.getlocation()
	unitlocations[oldloc.x][oldloc.y] = null
	unitlocations[target.x][target.y]=selected
	selected.rect_global_position=map_to_world(target)#physically move the node
	selected.MovRemain += -(move_range[target])
	
func canselectedattack(target): #Returns true if the target is a valid location to attack
	if unitlocations[target.x][target.y]!=null and selected!=null and (target in move_range or target in attack_range):
		print(unitlocations[target.x][target.y].get_parent())
		print(selected.get_parent().EnemyList)
		
		if unitlocations[target.x][target.y].get_parent() in selected.get_parent().EnemyList:
			return true
	return false
	
func selectedattack(target):
	print("Doing selectedattack")
	print("Selected is: "+str(selected))
	var neighbours=[Vector2(target.x+1,target.y), Vector2(target.x-1,target.y), Vector2(target.x,target.y+1), Vector2(target.x,target.y-1)]
	if selected.getlocation() in neighbours:
		FightMan.initbattle(selected,unitlocations[target.x][target.y])
		return
	else:
		for i in move_range:
			if i in neighbours:
				moveselected(i)
				FightMan.initbattle(selected,unitlocations[target.x][target.y])
				return

func newturn():
	for instance in units:
		instance.newturn()
	emit_signal("newTurn")
	deselect()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func findrange(origin, mov, flying=false):
	mov+=1
	var toexplore=[origin] #This is all the squares that need to be searched
	var dists = [] #This stores the distance to a square calculated so far
	
	dists.resize(sizex)
	for x in range(sizex):
		dists[x]=[]
		dists[x].resize(sizey)
		for y in range(sizey):
			dists[x][y]=999999
	dists[origin.x][origin.y]=0
	
	for SEARCHPOINT in range(mov):
		for node in toexplore.duplicate():
			var nodedist=dists[node.x][node.y]
			var targets=[Vector2(node.x+1,node.y), Vector2(node.x-1,node.y), Vector2(node.x,node.y+1), Vector2(node.x,node.y-1)]
			for target in targets:
				if target.x>=0 and target.x<sizex and target.y>=0 and target.y<sizey:
					var movecost=movecosts[target.x][target.y]
					if (flying==false and movecost!=-1) and movecost!=-2 and nodedist+movecost<mov: #-1 can be passed by flying
						if dists[target.x][target.y]>nodedist+movecost:
							dists[target.x][target.y]=nodedist+movecost
							toexplore.append(target)
							move_range[target]=nodedist+movecost
					else:
						attack_range.append(target)
			toexplore.erase(node)
				
		




