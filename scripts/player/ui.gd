extends SubViewport
var health = 5
var max_health = 0
@onready var fade = $Control/fade
@onready var health_nodes = {
	1:$Control/Panel/HBoxContainer/PanelContainer/HBoxContainer/hp1,
	2:$Control/Panel/HBoxContainer/PanelContainer/HBoxContainer/hp2,
	3:$Control/Panel/HBoxContainer/PanelContainer/HBoxContainer/hp3,
	4:$Control/Panel/HBoxContainer/PanelContainer/HBoxContainer/hp4,
	5:$Control/Panel/HBoxContainer/PanelContainer/HBoxContainer/hp5
	}
	
var full_heart_texture = preload("res://assets/images/sfb.png")
var empty_heart_texture = preload("res://assets/images/empty_sfb.png")
# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	global.death.connect(dead)

func dead():
	$RichTextLabel.visible = true
	for x in "You have died.".length():
		$RichTextLabel/VBoxContainer/death.text = $RichTextLabel/VBoxContainer/death.text + "You have died."[x]
		await get_tree().create_timer(0.1).timeout
	await  get_tree().create_timer(0.8).timeout
	for x in "Save them eventually.".length():
		$RichTextLabel/VBoxContainer/eventually.text = $RichTextLabel/VBoxContainer/eventually.text + "Save them eventually."[x]
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.8).timeout
	for x in "Not today.".length():
		$RichTextLabel/VBoxContainer/not.text = $RichTextLabel/VBoxContainer/not.text + "Not today."[x]
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(5.5).timeout
	get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_health():
	match health:
		0:
			health_nodes.get(1).texture = empty_heart_texture
			health_nodes.get(2).texture = empty_heart_texture
			health_nodes.get(3).texture = empty_heart_texture
			health_nodes.get(4).texture = empty_heart_texture
			health_nodes.get(5).texture = empty_heart_texture
		1:
			health_nodes.get(1).texture = full_heart_texture
			health_nodes.get(2).texture = empty_heart_texture
			health_nodes.get(3).texture = empty_heart_texture
			health_nodes.get(4).texture = empty_heart_texture
			health_nodes.get(5).texture = empty_heart_texture
		2:
			for iteration in 1:
				health_nodes.get(iteration+1).texture = full_heart_texture
			health_nodes.get(3).texture = empty_heart_texture
			health_nodes.get(4).texture = empty_heart_texture
			health_nodes.get(5).texture = empty_heart_texture
		3:
			for iteration in 2:
				health_nodes.get(iteration+1).texture = full_heart_texture
			health_nodes.get(4).texture = empty_heart_texture
			health_nodes.get(5).texture = empty_heart_texture
		4:
			for iteration in 3:
				health_nodes.get(iteration+1).texture = full_heart_texture
			health_nodes.get(5).texture = empty_heart_texture
		5:
			for iteration in 4:
				health_nodes.get(iteration+1).texture = full_heart_texture
		_:
			health = 0
			update_health()
			


func fade_in():
	fade.play("fade")
	
func fade_out():
	fade.play_backwards("fade")
