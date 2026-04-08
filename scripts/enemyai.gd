extends Node3D
@export var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
var physics_delta: float
var following = false
var followingwho : Node3D = null
@onready var enemybattle = $enemybattle
func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	# Save the delta for use in _on_velocity_computed.
	if (following):
		enemybattle.anim.play("walk_side")
	else:
		enemybattle.anim.play("idle_side")
		
	if (following && followingwho != null):
		set_movement_target(followingwho.global_position)
	physics_delta = delta
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, physics_delta * movement_speed)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body.is_in_group("player")):
		set_movement_target(body.global_position)
		following = true
		followingwho = body


func _on_area_3d_body_exited(body: Node3D) -> void:
	if (following && followingwho != null):
		followingwho = null
		following = false
