extends Node
signal state 
signal InteractRadius
signal change_level
signal hurt
var health = 20
var sp = 0
var maxsp = 0.45
var cutscene1 = false
var maxhealth = 20
var battlepreload = preload("res://scenes/Subsystems/Battle/battle.tscn")
enum actor_states {
	Annie,
	Calypso,
	Ricardo
}
var map_layout = {
	
	
	
	
}
enum dir {
	Left,
	Right,
	Up,
	Down
}



signal finishedDialog
signal dialog
signal BattleUpdate
signal loading
signal fade_in
signal fade_out
signal fade_finished
var skill1 = Skill.new(
	3,
	2,
	4,
	{
		0 : Coin.new(Skill.effects.Bleed,1),
		1 : Coin.new(Skill.effects.Bleed,1),
		2 : Coin.new(Skill.effects.Bleed, 1)
	}
)
var skill2 = Skill.new(
	4,
	2,
	6,
	{
		0 : Coin.new(Skill.effects.Bleed,1),
		1 : Coin.new(Skill.effects.Bleed,1),
		2 : Coin.new(Skill.effects.Bleed, 1),
		3 : Coin.new(Skill.effects.Bleed,1)
	}
)
var skill3 = Skill.new(
	4,
	2,
	12,
	{
		0 : Coin.new(Skill.effects.Bleed,1),
		1 : Coin.new(Skill.effects.Bleed,1),
		2 : Coin.new(Skill.effects.Bleed, 1),
		3 : Coin.new(Skill.effects.Bleed,1)
	}
)

func yeah():
	dialog.emit("baller",null)

var isbattling = false
var dialogactive = false
func battle(enemy : Node3D, player : CharacterBody3D):
	var battle = battlepreload.instantiate()
	battle.enemymain = enemy
	battle.player = player
	isbattling = true
	get_tree().root.get_child(1).add_child(battle)

var combatcutscne = false
var combat = 0
var current_dialog = 0
var combatconversation = {
	0 : spoken.new("What the heck was that??!!", global.actor_states.Annie),
	1: spoken.new("I really hope the queen is alright.",global.actor_states.Annie)
}
var currentcombatcutscene = false
func _process(delta: float) -> void:
	if (combatcutscne == false && combat == 1):
		if (current_dialog < combatconversation.size()):
			print("here2")
			var current_spoken = combatconversation[current_dialog]
			global.dialog.emit(current_spoken)
			current_dialog += 1
			combatcutscne = true
			currentcombatcutscene = true
	if (current_dialog < combatconversation.size() && Input.is_action_just_pressed("interact") && currentcombatcutscene):
			print("here2")
			var current_spoken = combatconversation[current_dialog]
			global.dialog.emit(current_spoken)
			current_dialog += 1
	elif current_dialog > combatconversation.size():
		global.finishedDialog.emit()
		currentcombatcutscene = false

func _ready() -> void:
	yeah()
	dialog.connect(ball)
	
func ball(conv):
	print(conv)
