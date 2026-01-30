extends Control

@onready var E = $E
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.InteractRadius.connect(Interact)


func Interact(can_interact, node):
	E.visible = can_interact
