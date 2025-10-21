extends Area2D
@onready var damage: CharacterBody2D = $".."
func TakeDamage():
	damage.damage()
