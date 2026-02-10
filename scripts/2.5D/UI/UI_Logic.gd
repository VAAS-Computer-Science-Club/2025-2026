extends Control

@onready var E = $E
@onready var run_that_fade = $"../../../fade"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.InteractRadius.connect(Interact)
	global.fade_in.connect(fade_in)
	global.fade_out.connect(fade_out)
	global.loading.connect(loadingscreen)


func Interact(can_interact, node):
	E.visible = can_interact


func fade_in(modifier): 
	run_that_fade.speed_scale = modifier
	run_that_fade.play("fade_in");
	print("fade in")
	await run_that_fade.animation_finished
	global.fade_finished.emit()


func fade_out(modifier): 
	run_that_fade.speed_scale = modifier
	run_that_fade.play("fade_out")
	print("fade out")
	await run_that_fade.animation_finished
	global.fade_finished.emit()


func loadingscreen(time):
	$"../../../Loading_Screen".visible = true
	await get_tree().create_timer(time).timeout
	$"../../../Loading_Screen".visible = false
