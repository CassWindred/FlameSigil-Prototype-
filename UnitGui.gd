extends MarginContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var BattleMap=get_node("../../BattleMap")


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	hide()
	BattleMap.connect("anyUnitSelected", self, "_on_unit_select")
	BattleMap.connect("unitDeselect", self, "_on_deselect")
	
func _on_unit_select(unit):
	
	$"Panel/VBoxContainer/HPTEXT".text="HP: "+str(unit.HPRemain)+"/"+str(unit.stats["HP"])
	$"Panel/VBoxContainer/MOVTEXT".text="Mov: "+str(unit.MovRemain)+"/"+str(unit.stats["Mov"])
	$"Panel/VBoxContainer/STRTEXT".text="Str: "+str(unit.stats["Str"])
	$"Panel/VBoxContainer/MAGTEXT".text="Mag: "+str(unit.stats["Mag"])
	$"Panel/VBoxContainer/SKLTEXT".text="Skl: "+str(unit.stats["Skl"])
	$"Panel/VBoxContainer/SPDTEXT".text="Spd: "+str(unit.stats["Spd"])
	$"Panel/VBoxContainer/LCKTEXT".text="Lck: "+str(unit.stats["Lck"])
	$"Panel/VBoxContainer/DEFTEXT".text="Def: "+str(unit.stats["Def"])
	$"Panel/VBoxContainer/RESTEXT".text="Res: "+str(unit.stats["Res"])
	$"Panel/VBoxContainer/ITEMTEXT".text="Items: "+str(unit.stats["Weapons"])
	show()
func _on_deselect():
	hide()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
