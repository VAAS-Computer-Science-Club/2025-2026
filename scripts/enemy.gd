extends CharacterBody2D

@onready var agent = $NavigationAgent2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_on_screen = false
var target : Node = null
@onready var sprite = $Sprite2D
var dead_sprite = preload("res://assets/images/froggy.png")
var dead_modulation = Color(0.251, 0.251, 0.251, 1.0)
var has_died = false
var health = 5
var current_state = states.Alive
enum states {
	Alive,
	Tracking,
	Dead,
	Attacking,
}
func _physics_process(delta: float) -> void:
	if is_on_screen and target != null and current_state != states.Dead:
		agent.target_position = target.position
		# Do not query when the map has never synchronized and is empty.
		if NavigationServer2D.map_get_iteration_id(agent.get_navigation_map()) == 0:
			return
		if agent.is_navigation_finished():
			return

		var movement_delta = SPEED * delta
		var next_path_position: Vector2 = agent.get_next_path_position()
		var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_delta
		if agent.avoidance_enabled:
			agent.set_velocity(new_velocity)
		else:
			_on_agent_2d_velocity_computed(new_velocity)
	if current_state == states.Dead and has_died == false:
		$CollisionShape2D.disabled = true
		sprite.texture = dead_sprite
		sprite.self_modulate = dead_modulation
		has_died = true
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_on_screen = false


func _on_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()


func _on_is_player_near_body_entered(body: Node2D) -> void:
	if body.is_in_group("uninfected"):
		target = body


func _on_is_player_near_body_exited(body: Node2D) -> void:
	if target != null:
		if target == body:
			target = null


func damage(dmg : int):
	if health - dmg < 0:
		current_state = states.Dead
	else:
		health = health - dmg
		sprite.get_material().set_shader_parameter("is_flashing",true)
		await get_tree().create_timer(0.2).timeout
		sprite.get_material().set_shader_parameter("is_flashing",false)
	
