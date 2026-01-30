extends CharacterBody2D

@onready var sprite = $Sprite
@onready var timer = $Timer
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
# To do Idle animation
var state = States.Idle
var skillones = {
	"Base" : Attack_Collider.new(9,20,0.3,self,null),
	"Nail" : Attack_Collider.new(23,20,0.3,self,null)
}

enum States {
	Idle,
	Walking,
	Skill_One,
	Skill_Two,
	Skill_Three
}

var last_direction = 0.1;
func _ready() -> void:
	sprite.play("idle_side")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	global.state.emit(state)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	##MOVEMENT + ANIMATIONS FOR DIRECTION
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		#Set Direction First
		velocity.x = direction * SPEED
		# Then if Idle or Walking play animation
		if (state == States.Idle or state == States.Walking):
			if (direction > 0.1): 
				# Look Left
				sprite.flip_h = true
				sprite.play("walk_side")
			elif (direction < -0.1):
				#Look Right
				sprite.flip_h = false
				sprite.play("walk_side")
			state = States.Walking
			last_direction = direction
	else:
		if (state == States.Idle or state == States.Walking):
			if (last_direction > 0.1): 
				# Look Left
				sprite.flip_h = true
				sprite.play("idle_side")
			elif (last_direction < -0.1):
				#Look Right
				sprite.flip_h = false
				sprite.play("idle_side")
			state = States.Idle
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	## ‼️ **KEEP ME AT THE FREAKING BOTTOM AUDEN.** ‼️
	##Attacking + Other Stuff
	var light_attack = Input.is_action_pressed("light")
	var heavy_attack = Input.is_action_pressed("heavy")
	if (heavy_attack and light_attack):
		
		skill3()
		return
	else:
		if (light_attack):
			skill1()
			return
		if (heavy_attack):
			
			skill2()
			return


func skill1():
	print("Skill One")
	## TODO integrate gravity into attack particles
	## TODO integrate angle min and max to flip sprite

	pass
func skill2():
	print("Skill Two")
	pass
func skill3():
	print("Skill Three")
	
	pass
	


class Attack_Collider:
	var length : float
	var width : float
	var time : float
	var owned : Node
	var instance : Node
	func _init(len,wid,tim,owne,inst):
		length = len
		width = wid
		time = tim
		owned = owne
		instance = inst
