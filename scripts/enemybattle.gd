extends Node3D

var health = 0
var sp = 0.25
var maxsp = 0.45
var maxhealth = 10

func _ready() -> void:
	print(skill3.roll_skill(0.45))

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
	base.healSp(1)
	sp = base.sp
	if (sp >= 0.25): 
		return skill3
	if (sp >= 0.15): 
		return skill2
	if (sp < 0.15):
		return skill3
	return skill1
		
