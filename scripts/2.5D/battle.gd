extends Node3D
@onready var player_preload = preload("res://scripts/2.5D/subsystems/Battle/player_base.tscn")


var player_turn = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.BattleUpdate.connect(update_cycle)
	


func update_cycle():
	pass
