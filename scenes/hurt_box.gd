extends Area2D
@onready var damage: CharacterBody2D = $".."
func TakeDamage(value : int):
	print("damage valued here at ", value)
	damage.damage(value)
