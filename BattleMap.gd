extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Standard Tiles
var TILE_TREE
var TILE_GRASS

#Overlay Tiles (OL=OVERLAY)
var OL #This will be a shortening for Overlays
var RED_OL
var GREEN_OL
var BLUE_OL
var LIGHTBLUE_OL

signal unitSelect(gridloc, MovRange, AttRange) 
var sizex=20
var sizey=30
onready var square_nodes = []
onready var selectsquare=get_node("SelectSquare")

var move_array = []
var attack_array = []
var selected
var factions = []
var units = []

signal newTurn() #Autolinked to EndTurnButton


func _ready():
		# Called when the node is added to the scene for the first time.
	# Initialization here
	#Initialise Tile Constants
	TILE_TREE=tile_set.find_tile_by_name("--Tree")
	TILE_GRASS=tile_set.find_tile_by_name("Grass1")
	
	#Initialise overlay tile constants
	OL=get_node("Overlays")
	RED_OL=OL.tile_set.find_tile_by_name("Red")
	GREEN_OL=OL.tile_set.find_tile_by_name("Green")
	BLUE_OL=OL.tile_set.find_tile_by_name("Blue")
	LIGHTBLUE_OL=OL.tile_set.find_tile_by_name("LightBlue")
	
	#Initialise Factions and units
	factions=get_parent().get_node("Units").get_children()
	for i in factions:
		for j in i.get_children():
			units.append(j)
	
	

	for instance in units:
		instance.connect("unitSelect", self, "_on_unit_select")

	#get_parent().get_node("Units").get_node("UnitWarrior").connect("unitSelect", self, "_onUnitSelect")
	square_nodes.resize(sizex)
	for x in range(sizex):
		square_nodes[x]=[]
		square_nodes[x].resize(sizey)
		for y in range(sizey):
			square_nodes[x][y] = {}
			square_nodes[x][y]["dist"]=9999 #Initialise to obscenely large distance, equivalent to infinity
			var tile=get_cell(x,y)
			
			if tile==TILE_TREE:
				square_nodes[x][y]["passable"]=false
			else:
				square_nodes[x][y]["passable"]=true
			
	

func _on_unit_select(gridloc, MovRange, AttRange, unit):
	clearmove()
	print(str(MovRange))
	move_array=rangefind(gridloc,MovRange,square_nodes.duplicate())
	attack_array=rangefind(gridloc,AttRange+MovRange,square_nodes.duplicate())
	#print(str(square_nodes[1][0]["dist"]))
	var TempAttack = []
	
	for i in attack_array: #Remove everything in move_array from attack_array
		if not i in move_array:
			TempAttack.append(i)
	attack_array=TempAttack
	
	print("Attack Array is: ", str(attack_array))
	print("Move Array is: ", str(move_array))
	for i in move_array:
		OL.set_cellv(i, BLUE_OL) #Set in range tiles as blue
	for i in attack_array:
		OL.set_cellv(i, RED_OL)
	selected=unit
		
		
func clearmove(): #Clears the overlay and the attack and move array
	attack_array = []
	move_array = []
	OL.clear()
	
func moveselected(target):
	selected.rect_global_position=map_to_world(target)
	selected.MovRemain += -(square_nodes[target.x][target.y]["dist"])
	clearmove()
	
func canselectedattack(target): #Returns true if the target is a valid location to attack
	return false
	
func selectedattack(target):
	pass

	
func _unhandled_input(event): #On an event not handled by anything else
	
	if event is InputEvent:
		
		if Input.is_action_just_pressed("ui_click"):
			
			var gridchosen
			gridchosen=world_to_map(get_global_mouse_position()) #Finds which grid tile the mouse is at
			if gridchosen in move_array:
				moveselected(gridchosen)
			elif canselectedattack(gridchosen):
				selectedattack(gridchosen)
			else:
				clearmove() #Clear the overlay and arrays
				print(str(gridchosen))
				selectsquare.rect_global_position=map_to_world(gridchosen)
				selectsquare.show()
				var tile=get_cellv(gridchosen)
				print("Tile index for "+str(gridchosen) + " is " + str(tile))
				if square_nodes[gridchosen.x][gridchosen.y]["passable"]==true:
					print("Passable")
				else:
					print("Not Passable")
				
func rangefind(stloc, gridrange, Nodes): #Start Location and Range to find
	#print(str(Nodes[1][0]["dist"]))
	for x in Nodes:
		for y in x:
			y["dist"]=9999
	var toExplore=[]
	var inRange=[]
	Nodes[stloc.x][stloc.y]["dist"]=0
	toExplore.append(stloc)
	inRange.append(stloc)
	var curr_range=0
	
	while curr_range<=gridrange:
		var currExplore=toExplore
		
		for i in currExplore: #Checks through every location that needs to be explored
		
			for modnum in range (-1,2,2):
				
				#Check if node is passable and that new distance would be lower than old distance
				if not (i.x+modnum>=sizex or i.x+modnum<0): #Check that location is within bounds
					if Nodes[i.x+modnum][i.y]["passable"]==true:
						var newdist=Nodes[i.x+modnum][i.y]["dist"]
						var olddist=Nodes[i.x][i.y]["dist"]+1
						
						if Nodes[i.x+modnum][i.y]["dist"]>Nodes[i.x][i.y]["dist"]+1:
							toExplore.append(Vector2(i.x+modnum,i.y))
							Nodes[i.x+modnum][i.y]["dist"]=Nodes[i.x][i.y]["dist"]+1
							if Nodes[i.x+modnum][i.y]["dist"]<=gridrange:
								#print("Adding to inRange")
								inRange.append(Vector2(i.x+modnum,i.y))
								
				if not (i.y+modnum>=sizey or i.y+modnum<0): #Check that location is within bounds
					if Nodes[i.x][i.y+modnum]["passable"]==true:
						if Nodes[i.x][i.y+modnum]["dist"]>Nodes[i.x][i.y]["dist"]+1:
							toExplore.append(Vector2(i.x,i.y+modnum))
							Nodes[i.x][i.y+modnum]["dist"]=Nodes[i.x][i.y]["dist"]+1
							if Nodes[i.x][i.y+modnum]["dist"]<=gridrange:
								#print("Adding to inRange")
								inRange.append(Vector2(i.x,i.y+modnum))
			toExplore.erase(i)
		curr_range+=1
	return inRange
			
			
func newturn():
	for instance in units:
		instance.newturn()
	emit_signal("newTurn")
	clearmove()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass









func _on_EndTurnButton_pressed():
	newturn()
