extends Node3D
@onready var anim = $Sprite/Sprite
var base = baseFighter.new(
	global.health,
	global.sp,
	global.skill1,
	global.skill2,
	global.skill3,
	global.maxsp,
	global.maxhealth
)
