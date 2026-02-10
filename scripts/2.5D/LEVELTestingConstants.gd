extends Node3D
var spawnPoint = Vector3(0,5,0)
var LeftLevel = "Ant_1"
var RightLevel = "Ant_2"
@onready var BridgeLeft = $Bridge
@onready var BridgeRight = $Bridge2
var left_level = preload("res://scenes/Levels/2.5D/Testing.tscn")
var right_level = preload("res://scenes/Levels/2.5D/Testing.tscn")
@onready var left_spawn = $RightEnter.position
@onready var right_spawn = $LeftEnter.position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_bridges()

func set_bridges():
	BridgeLeft.level = left_level
	BridgeLeft.is_left = true
	BridgeRight.level = right_level
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
