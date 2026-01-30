extends Area3D
var id = 0
var level
@onready var spawn_point = $Spawn_Point


func _on_body_entered(body: Node3D) -> void:
	if (body.is_in_group("Player")):
		global.change_level.emit(level)
