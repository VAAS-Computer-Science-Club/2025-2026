extends Control
@onready var headspot = $HBOX/VBoxContainer/headspot
@onready var E = $E
@onready var run_that_fade = $"../../../fade"
@onready var health = $HBOX/VBoxContainer/Health
@onready var dialogBox = $"../../../dialog_box/RichTextLabel"
@onready var dialogSprite = $"../../../AnimatedSprite2D"
@onready var tween = get_tree().create_tween();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.InteractRadius.connect(Interact)
	global.fade_in.connect(fade_in)
	global.fade_out.connect(fade_out)
	global.loading.connect(loadingscreen)
	global.hurt.connect(hurt)
	global.dialog.connect(dialog)
	global.finishedDialog.connect(end_dialog)

func end_dialog():
	dialogBox.visible = false
	$"../../../dialog_box".visible = false
	dialogSprite.visible = false


func dialog(spoken):
	if (dialogActive == false):
		dialogBox.visible = true
		$"../../../dialog_box".visible = true
		dialogSprite.visible = true
		print("ran" + " " + spoken.dialog)
		set_actor(spoken.actor)
		run_dialog(spoken.dialog)
	else:
		dialogActive = false
		await get_tree().create_timer(0.05).timeout
		dialog(spoken)
func set_actor(actor):
	$"../../../AnimatedSprite2D/SwitchSprite".play("SwitchSprite")
	match (actor):
		null:
			dialogSprite.play("annie")
		global.actor_states.Annie:
			dialogSprite.play("annie")
		global.actor_states.Calypso:
			dialogSprite.play("calypso")
		global.actor_states.Ricardo:
			dialogSprite.play("ricardo")

var dialogActive = false

func run_dialog(dialog : String):
	dialogBox.clear()
	dialogActive = true
	for iteration in dialog.length():
		if (dialogActive == false):
			break
		var extratime = 0
		if (dialog[iteration]) == ".":
			extratime = 0.5
		if (dialog[iteration]) == ",":
			extratime = 0.05
		if (dialog[iteration]) == "!":
			extratime = 0.5
		if (dialog[iteration]) == "?":
			extratime = 0.5
		if (dialog[iteration]) == ";":
			extratime = 0.15
		if (dialog[iteration]) == ":":
			extratime = 0.15
		if (dialog[iteration]) == "-":
			extratime = -0.15
		await get_tree().create_timer(0.05 + extratime).timeout
		
		dialogBox.add_text(dialog[iteration])
	dialogActive = false

var ismovinghealth = false
func hurt(damage):
	headspot.play("hurt")
	await get_tree().create_timer(2.0).timeout
	headspot.play("default");
	if (ismovinghealth == false):
		ismovinghealth = true
		var tween = get_tree().create_tween();
		tween.tween_property(health,"value",damage,0.5)
		await tween.finished
		ismovinghealth = false
	else:
		await get_tree().create_timer(0.1).timeout
		hurt(damage)


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
