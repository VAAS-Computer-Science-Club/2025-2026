extends Node3D
var level_node : Node
signal levelchange
var base_level = preload("res://scenes/Levels/2.5D/level_1.tscn")
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



func change_level(level_resource : Resource, is_left : bool):
	global.fade_out.emit(2)
	await global.fade_finished
	global.loading.emit(1)
	var level = level_resource.instantiate()
	level_node.queue_free()
	level_node = level
	if spawnPoint == null:
		spawnPoint = level.right_spawn
	print(spawnPoint)
	add_child(level,true)
	await get_tree().create_timer(0.3).timeout
	if (is_left):
		if (level != null):
			spawnPoint = level.left_spawn
		else:
			spawnPoint = Vector3(0,0,0)
	else:
		if (level != null):
			spawnPoint = level.right_spawn
		else:
			spawnPoint = Vector3(0,0,0)
	player.position = spawnPoint
	player.active_transfer = false
	global.fade_in.emit(0.5)
		
