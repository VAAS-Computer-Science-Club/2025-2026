extends Node
signal state 
signal InteractRadius
signal change_level
signal hurt
var health = 100
var sp = 10
var maxsp = 10
var maxhealth = 100
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

func _ready() -> void:
	yeah()
