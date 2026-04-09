extends Node3D

var health = 10
var sp = 0
var maxsp = 0.45
var maxhealth = 10
@onready var anim = $Sprite/Sprite
func _ready() -> void:
	pass

var skill1 : Skill = Skill.new(
	3,
	2,
	4,
	{
		0 : Coin.new(Skill.effects.Bleed,1),
		1 : Coin.new(Skill.effects.Bleed,1),
		2 : Coin.new(Skill.effects.Bleed, 1)
	}
)
var skill2 : Skill = Skill.new(
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
var skill3 : Skill  = Skill.new(
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


var base : baseFighter = baseFighter.new(
	health,
	sp,
	skill1,
	skill2,
	skill3,
	maxsp,
	maxhealth
)


func action():
	return base.genskills()
		
