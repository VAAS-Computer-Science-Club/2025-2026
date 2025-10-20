extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var anim = $invincible
@onready var coyote_collider = $coyote
@onready var floor_ray = $floor_ray
const SPEED = 100.0
const JUMP_VELOCITY = -200.0
var spawn : Vector2
var coyote = false
var root
var UI
var health = 5
var last_health = 5
var main
var last_direction = 0
enum directions {
	up,
	down,
	left,
	right
}
var slash_positions = { 
	directions.right: Vector2(17,0),
	directions.left: Vector2(-17,0),
	directions.up: Vector2(0,-18),
	directions.down: Vector2(0,18)
}
var invincible = false
var can_move = true
var took_dmg = false
var is_jumping = false
@export var can_dash = true
var is_dashing = false
var unlocked_dash = true
var unlocked_jump = false
func _ready() -> void:
	spawn = self.global_position
	root = get_tree().root
	main = root.get_node("main")
	UI = main.get_node("Sub").get_node("UI")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if unlocked_dash and is_on_floor():
		can_dash = true
	if took_dmg == true:
		self.global_position = self.global_position
	if invincible == false:
		$invincible.stop()
	if health != last_health:
		UI.health = health
		UI.update_health()
		last_health = health
		
	if not is_on_floor() and is_jumping == false:
		velocity += get_gravity() * delta

	# Handle jump.
	if (floor_ray.is_colliding() == false or Input.is_action_pressed("ui_accept") == false):
		is_jumping = false
	if Input.is_action_pressed("ui_accept") and (is_on_floor() or coyote) and can_move and floor_ray.is_colliding() and unlocked_jump:
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	if Input.is_action_pressed("ui_accept") and can_move and floor_ray.is_colliding() and is_jumping and unlocked_jump:
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if (velocity.x == 0):
		is_dashing = false
	if direction == 0:
		match last_direction:
			0.0:
				sprite.play("idle_down")
			1.0:
				sprite.play("idle_side")
				sprite.flip_h = false
			-1.0:
				sprite.play("idle_side")
				sprite.flip_h = true
	else:
		match direction:
			1.0:
				sprite.play("walk_side")
				sprite.flip_h = false
			-1.0:
				sprite.play("walk_side")
				sprite.flip_h = true
		last_direction = direction
	
	if direction and can_move and !Input.is_action_just_pressed("dash") and is_dashing == false:
		velocity.x = direction * SPEED
	else:
		if (!Input.is_action_just_pressed("dash") and is_dashing == false):
			velocity.x = move_toward(velocity.x, 0, SPEED)
	if can_dash and Input.is_action_just_pressed("dash"):
		velocity.x = last_direction * (SPEED * 3)
		is_dashing = true
		stop_dash()
	
	move_and_slide()


func stop_dash():
	await get_tree().create_timer(0.2).timeout
	velocity.x = 0
	can_dash = false
	move_and_slide()

func _on_spike_check_body_entered(body: Node2D) -> void:
	took_dmg = true
	self.global_position = self.global_position
	$CPUParticles2D.emitting = true
	jerk_camera()
	await $jerk.animation_finished
	UI.fade_in()
	await get_tree().create_timer(0.5).timeout
	took_dmg  = false
	anim.stop()
	
	self.global_position = spawn
	deduct_health(1,true)


func jerk_camera():
	$jerk.play("jerk")
	
	
func deduct_health(value : int, fade : bool):
	if (invincible == false):
		invincible = true
		if (fade):
			can_move = false
		health = health - value
		
		invincible = true
		anim.play("invincibility_frames")
		if (fade):
			UI.fade_out()
		await get_tree().create_timer(1.5).timeout
		invincible = false
		if (fade):
			can_move = true


func _on_coyote_area_entered(area: Area2D) -> void:
	coyote = true

func attack(dir : directions):
	match dir:
		directions.up:
			pass
		directions.down:
			pass
		directions.right:
			pass
		directions.left:
			pass

func _on_coyote_area_exited(area: Area2D) -> void:
	coyote = false
