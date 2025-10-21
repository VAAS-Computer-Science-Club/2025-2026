extends Area2D
@onready var damage: CharacterBody2D = $".."
func TakeDamage(value : int):
	damage.damage(value)
