extends VBoxContainer
enum States {
	Idle,
	Walking,
	Skill_One,
	Skill_Two,
	Skill_Three
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.state.connect(state_change)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func state_change(state):
	$State.clear()
	$State.add_text(States.keys().get(state))
