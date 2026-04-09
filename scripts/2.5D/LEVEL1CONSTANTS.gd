extends NavigationRegion3D
var spawnPoint = Vector3(0,5,0)
@onready var BridgeLeft = $Bridge
@onready var BridgeRight = $Bridge2
var player;
var left_level = preload("res://scenes/Levels/2.5D/level_2.tscn")
var right_level = preload("res://scenes/Levels/2.5D/level_1.tscn")
@onready var left_spawn = $RightEnter.position
@onready var right_spawn = $LeftEnter.position
# Called when the node enters the scene tree for the first time.
var conversation = {
	0 : spoken.new("I really need to get back to the nest...", global.actor_states.Annie),
	1: spoken.new("Though the expedition was sucessful! I got some sugar for the queen!",global.actor_states.Annie)
}
var current_dialog = 0
func _ready() -> void:
	set_bridges()




@onready var anim = $AnimationPlayer

func set_bridges():
	BridgeLeft.level = left_level
	BridgeLeft.is_left = true
	BridgeRight.level = right_level
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (global.cutscene1 == false):
		global.cutscene1 = true
		print("here")
		if (current_dialog < conversation.size()):
			print("here2")
			var current_spoken = conversation[current_dialog]
			global.dialog.emit(current_spoken)
			current_dialog += 1
	if (Input.is_action_just_pressed("interact")):
		if (current_dialog < conversation.size()):
			var current_spoken = conversation[current_dialog]
			global.dialog.emit(current_spoken)
			current_dialog += 1
		else:
			global.finishedDialog.emit()
			global.cutscene1 = true
