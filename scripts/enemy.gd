extends CharacterBody2D

@onready var agent = $NavigationAgent2D
@onready var cooldown = $Timer
@onready var attack_ani = $AnimationPlayer
const SPEED = 600.0
const JUMP_VELOCITY = -400.0
var is_on_screen = false
var target : Node = null
@onready var sprite = $Sprite2D
var dead_sprite = preload("res://assets/images/froggy.png")
var dead_modulation = Color(0.251, 0.251, 0.251, 1.0)
var has_died = false
var health = 5
var current_state = states.Alive
var current_attack = attacks.None
var cooldown_time = 1
enum attacks {
	None,
	Spit,
	Melee,
}
enum states {
	Alive,
	Tracking,
	Dead,
	Attacking,
}
func _ready() -> void:
	cooldown.autostart = false
func _physics_process(delta: float) -> void:
	var new_velocity : Vector2 = Vector2.ZERO
	if is_on_screen and target != null and (current_state != states.Dead or current_state != states.Attacking):
		var distance_to_target = global_position.distance_to(target.global_position)
		if (distance_to_target > 5):
			#Lunge
			pass
		elif (distance_to_target < 5):
			#Drop Hit
			pass 
		
		agent.target_position = target.position
		# Do not query when the map has never synchronized and is empty.
		if NavigationServer2D.map_get_iteration_id(agent.get_navigation_map()) == 0:
			return
		if agent.is_navigation_finished():
			return

		var movement_delta = SPEED * delta
		var next_path_position: Vector2 = agent.get_next_path_position()
		new_velocity = global_position.direction_to(next_path_position) * movement_delta
		if agent.avoidance_enabled:
			agent.set_velocity(new_velocity)
		else:
			_on_agent_2d_velocity_computed(new_velocity)
	if current_state == states.Dead and has_died == false:
		$CollisionShape2D.disabled = true
		#sprite.texture = dead_sprite
		sprite.self_modulate = dead_modulation
		has_died = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if new_velocity.x <= 0.1 and new_velocity.x >= -0.1:
		sprite.play("idle")
	else:
		if new_velocity.x <= 0.1:
			sprite.flip_h = false
			sprite.stop()
		elif new_velocity.x <= -0.1:
			sprite.flip_h = true
			sprite.stop()
		sprite.stop()
		#start attack timer
	move_and_slide()
func _on_cooldown_timeout() -> void:
	if(current_attack == attacks.Spit):
			attack_ani.play("Spit")
	elif(current_attack == attacks.Melee):
			attack_ani.play("Spit")


func _on_melee_range_area_entered(area: Area2D) -> void:
	current_attack = attacks.Melee


func _on_spit_range_area_entered(area: Area2D) -> void:
	cooldown.start(cooldown_time)
	if (current_attack != attacks.Melee):
		current_attack = attacks.Spit


func _on_spit_range_area_exited(area: Area2D) -> void:
	current_attack = attacks.None


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
		#sprite.get_material().set_shader_parameter("is_flashing",true)
		#await get_tree().create_timer(0.2).timeout
		#sprite.get_material().set_shader_parameter("is_flashing",false)
	
