class_name baseFighter

var sp = 10
var maxsp = 10
var health = 10
var maxhealth = 10
var skill1  : Skill = Skill.new(
	3,
	2,
	4,
	{
		0 : Coin.new(Skill.effects.Bleed,1),
		1 : Coin.new(Skill.effects.Bleed,1),
		2 : Coin.new(Skill.effects.Bleed, 1)
	}
)
var skill2  : Skill = Skill.new(
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
var skill3  : Skill = Skill.new(
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

func healHealth(value):
	health = clamp(health+value,0,maxhealth)

func healSp(value):
	sp = clamp(sp+value,0,maxsp)

func damagesp(value):
	sp = clamp(sp-value,0,maxsp)

func damage(value):
	if (health-value == 0):
		health = 0
		return
	health = clamp(health-value,0,maxhealth)
	
	
func genskills():
	var roll = randf()
	if (roll < 0.50):
		#50%
		return skill1
	elif (roll < 0.75):
		#25%
		return skill2
	else:
		#25%
		return skill3



func _init(givenhealth : int,givensp : float,givenskill1 : Skill,givenskill2 : Skill ,givenskill3 : Skill ,givenmaxsp : float,givenmaxhealth : int) -> void:
	health = givenhealth
	sp = givensp
	maxsp = givenmaxsp
	skill1 = givenskill1
	skill2 = givenskill2
	skill3 = givenskill3
	maxhealth = givenmaxhealth
