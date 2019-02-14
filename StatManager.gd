extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func _inititemdict():
	pass


func getunitstatsfromID(unitID):
	var stats={}
	var filelocation="res://UnitID/"+unitID
	var file = File.new()
	if file.file_exists(filelocation):
		file.open(filelocation, file.READ)
		while not file.eof_reached():
			var line = file.get_line()
			var words = line.split(" ")
			if words[0]=="Weapons":
				stats["Weapons"]=[]
				for i in range(1, len(words)):
					stats["Weapons"].append(words[i])
			else:
				if not len(words)==2:
					print("Incorrect formatting of UnitID("+unitID+"), word count for line incorrect, error E0002")
				else:
					stats[words[0]]=int(words[1])
		
	else:
		print("FILE NOT FOUND ERROR IN UnitBase.gd, error E0001")
	return stats
	
class item:
	var ID
	var Type
	var Rank
	var Uses
	var Mt
	var Hit
	var Crt
	var AttRange
	var Special
	var Cost
	
	var remUses
	
	
	func _init(ID=null):
		if not ID==null:
			self.ID=ID
			var file = File.new()
			if not file.file_exists("res://Items/Weapons"):
				print("Oh no the Weapons file doesnt exist :'(")
			file.open("res://Items/Weapons", file.READ)
			var statsretreived=false #False until all blocks received
			var statsrelevant=false #True while in the correct block of stats
			while not file.eof_reached() and statsretreived==false: #Searches for relevant statblock
				var line = file.get_line()
				if line.begins_with("---") and statsrelevant==true:
					statsretreived=true
				elif line == ID:
					statsrelevant = true
				elif statsrelevant == true:
					var words = line.split(": ")
					
					self.set(words[0],words[1])#Set the variable that is equivalent to the first part to the value of the second
			self.remUses=self.Uses
		


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
