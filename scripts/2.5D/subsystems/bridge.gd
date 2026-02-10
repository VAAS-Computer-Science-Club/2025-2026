extends Area3D
var id = 0
var level
var is_left = false
@onready var spawn_point = $Spawn_Point.position


func _on_body_entered(body: Node3D) -> void:
	if (body.is_in_group("player")):
		if (body.active_transfer == false):
			global.change_level.emit(level, is_left)
			body.active_transfer = true
