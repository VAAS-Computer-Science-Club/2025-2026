extends Control

@onready var E = $E
@onready var run_that_fade = $"../../../fade"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.InteractRadius.connect(Interact)
	global.fade_in.connect(fade_in)


func Interact(can_interact, node):
	E.visible = can_interact


func fade_in(modifier): 
	run_that_fade.speed_scale = modifier
	run_that_fade.play("fade_in");


func fade_out(modifier): 
	run_that_fade.speed_scale = modifier
	run_that_fade.play("fade_out")
