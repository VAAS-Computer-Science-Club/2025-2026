extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var timer = $Timer
@onready var sprite = $Sprite/Sprite
var last_direction = Vector2(1,1);
var interact_node = null
var active_transfer = false
var bridge_left = false

func _ready() -> void:
	global.InteractRadius.connect(InteractLogic)

func InteractLogic(can_interact, node):
	interact_node = node

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if (active_transfer == false):
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			last_direction = input_dir
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			## ‼️ **KEEP ME AT THE FREAKING BOTTOM GUYS.** ‼️
		##Attacking + Other Stuff
		var light_attack = Input.is_action_pressed("light")
		var heavy_attack = Input.is_action_pressed("heavy")
		if (heavy_attack or light_attack):
			await get_tree().create_timer(0.1).timeout
			if(heavy_attack and light_attack):
				print("skill three")
			elif(heavy_attack):
				print("skill two")
			elif(light_attack):
				print("skill one")
		else:
			if (active_transfer == true):
				if (bridge_left == true):
					input_dir = Vector2(-1,0)
					var dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
					velocity.x = direction.x * SPEED
					velocity.z = direction.z * SPEED
				else:
					input_dir = Vector2(1,0)
					var dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
					velocity.x = direction.x * SPEED
					velocity.z = direction.z * SPEED
	play_animation(input_dir)
	move_and_slide()
	

func play_animation(direction):
	if (active_transfer):
		if (bridge_left == true):
			sprite.flip_h = false
			sprite.play("walk_side")
		else:
			sprite.flip_h = true
			sprite.play("walk_side")
	else:
		if (direction):
			if (direction.y < direction.x):
				if direction.x >= 0.1:
					sprite.flip_h = true
					sprite.play("walk_side")
				else:
					sprite.flip_h = false
					sprite.play("walk_side")
			else:
				if (direction.y >= 0.1):
					sprite.flip_h = true
					sprite.play("walk_side")
				else:
					sprite.flip_h = false
					sprite.play("walk_side")
		else:
			if (last_direction.x) >= 0.1:
				sprite.flip_h = true
				sprite.play("idle_side")
			else:
				sprite.flip_h = false
				sprite.play("idle_side")
	
