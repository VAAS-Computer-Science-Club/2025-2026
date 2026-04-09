extends Area3D
class_name NPC
@onready var sprite = $Sprite/Sprite
@onready var interact_button = $interact


var conversation = {
	0 : spoken.new("Who are you? Why are you just standing here?", global.actor_states.Annie),
	1 : spoken.new("The flames are nice", global.actor_states.Calypso),
	2 : spoken.new("The heat is kinda soothing", global.actor_states.Calypso),
	3: spoken.new("Well, alright then.", global.actor_states.Annie)
}

var current_dialog = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("idle_side")

func _on_body_entered(body: Node3D) -> void:
	if (body.is_in_group("player")): 
		global.InteractRadius.emit(true,self)
		interact_button.visible = true

func interact():
	if (current_dialog < conversation.size()):
		var current_spoken = conversation[current_dialog]
		global.dialog.emit(current_spoken)
		current_dialog += 1
	else:
		global.finishedDialog.emit()




func _on_body_exited(body: Node3D) -> void:
	if (body.is_in_group("player")): 
		global.InteractRadius.emit(false,self)
		interact_button.visible = false
