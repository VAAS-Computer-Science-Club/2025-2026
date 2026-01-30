extends Area3D

@onready var sprite = $Sprite/Sprite
@onready var interact_button = $interact
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("idle_side")
	




func _on_body_entered(body: Node3D) -> void:
	if (body.is_in_group("player")): 
		global.InteractRadius.emit(true,self)
		interact_button.visible = true




func _on_body_exited(body: Node3D) -> void:
	if (body.is_in_group("player")): 
		global.InteractRadius.emit(false,self)
		interact_button.visible = false
