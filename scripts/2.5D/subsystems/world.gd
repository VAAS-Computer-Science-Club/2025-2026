extends Node3D
var level_node : Node
signal levelchange
var base_level = preload("res://scenes/Levels/2.5D/Testing.tscn")
var player_instance = preload("res://scenes/Entities/2.5D/Player/Player.tscn")
var player
var spawnPoint = Vector3(0,0,0)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (level_node == null):
		level_node = base_level.instantiate()
		add_child(level_node)
		spawnPoint = level_node.spawnPoint
		level_node.set_bridges()
	player = player_instance.instantiate();
	add_child(player)
	player.position = spawnPoint
	global.change_level.connect(change_level)



func change_level(level_resource : Resource,Entrance : global.dir):
	var level = level_resource.instantiate()
	level_node.queue_free()
	level_node = level
	match Entrance:
		global.dir.Left:
			spawnPoint = level_node.left_spawn
		global.dir.Right:
			spawnPoint = level_node.right_spawn
