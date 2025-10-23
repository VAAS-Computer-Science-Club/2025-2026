extends Node2D
var moving_lights = false
var lights = false

@onready var the_full_power_of_the_sun = $DirectionalLight2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	light()
		


func light():
	if global.lights_enabled != lights:
		moving_lights = true
		var tween = get_tree().create_tween()
		if global.lights_enabled == false:
			tween.tween_property(the_full_power_of_the_sun,"energy",0,0.8)
		else:
			tween.tween_property(the_full_power_of_the_sun,"energy",1.46,0.8)
		await tween.finished
		lights = global.lights_enabled
		moving_lights = false


func _on_light_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("enabled")
		global.lights_enabled = true


func _on_light_detect_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("disabled")
		global.lights_enabled = false
