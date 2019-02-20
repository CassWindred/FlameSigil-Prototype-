extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func initbattle(attacker, defender):
	print("TIME TO DO BATTLE")
	var astats=attacker.stats
	var aweapon=attacker.items[attacker.equippeditem]
	var dstats=defender.stats
	var dweapon=defender.items[defender.equippeditem]
	
	var doubleattack=false
	if astats["Spd"]>=dstats["Spd"]+5:
		doubleattack=true
		
	var PhysicalAttack=0.0
	var MagicalAttack=0.0
	var HitRate=0.0
	var AvoidRate=0.0
	var StaffHitRate=0.0
	var StaffAvoidRate=0.0
	var CritRate=0.0
	var DodgeRate=0.0
	var Rating=0.0
	
	advantagedweapon=isadvantaged(aweapon,dweapon)
	if advantagedweapon!=dweapon:
		PhysicalAttack+=WRAttackBonus(aweapon)
	if advantagedweapon==aweapon:
		PhysicalAttack+=WTAttackMod(aweapon)
		HitRate+=WTHitRate(aweapon)
	elif advantagedweapon==dweapon:
		PhysicalAttack+=-WTAttackMod(dweapon)
		HitRate+=-WTHitRate(dweapon)
		
	
	PhysicalAttack = astats["Str"]+aweapon.Mt
	

func WTAttackMod(weapon): #Returns the Attack Modifier from the Weapon Triangle
	rank=weapon.Rank
	if rank=="E" or rank=="D" or rank=="C":
		return 0
	if rank=="B" or rank=="A":
		return 1
	if rank=="S":
		return 2

func WTHitRate(weapon):
	rank=weapon.Rank
	if rank=="E" or rank=="D":
		return 5
	if rank=="B" or rank=="C":
		return 10
	if rank=="A":
		return 15
	if rank=="S":
		return 20

func WRAttackBonus(weapon):
	match weapon.Rank:
		"E","D":
			return 0
		"C":
			return 1
		"B":
			return 2
		"A":
			return 3
		"S":
			return 4
			
func WRHitRateBonus(weapon):
	match weapon.Rank:
		"E","D", "C", "B", "A":
			return 0
		"S":
			return 5

func isadvantaged(weapon1,weapon2):
	if (weapon1.Type=="Axe" and weapon2.Type=="Lance") or (weapon1.Type=="Lance" and weapon2.Type=="Sword") or (weapon1.Type=="Sword" and weapon2.Type=="Axe"):
		return weapon1
	elif (weapon2.Type=="Axe" and weapon1.Type=="Lance") or (weapon2.Type=="Lance" and weapon1.Type=="Sword") or (weapon2.Type=="Sword" and weapon1.Type=="Axe"):
		return weapon2
	else:
		return null
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
