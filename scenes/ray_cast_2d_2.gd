extends RayCast2D
@onready var enemy = $".."


func _physics_process(delta: float) -> void:
	if (is_colliding()):
		enemy.collision_left()
	else:
		enemy.collision_right()
