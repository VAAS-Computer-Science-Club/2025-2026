extends Node3D
var spawnPoint = Vector3(0,5,0)
var LeftLevel = "Ant_1"
var RightLevel = "Ant_2"
@onready var BridgeLeft = $Bridge
@onready var BridgeRight = $Bridge2
var left_level = preload("res://scenes/Subsystems/Travel/bridge.tscn")
var right_level = preload("res://scripts/2.5D/subsystems/bridge.gd")
@onready var left_spawn = BridgeLeft.spawn_point
@onready var right_spawn = BridgeLeft.spawn_point
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_bridges():
	BridgeLeft.level = left_level
	BridgeRight.level = right_level
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
