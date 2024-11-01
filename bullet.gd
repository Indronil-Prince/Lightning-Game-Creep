extends Area2D

class_name Bullet

@export var speed = 400

func _ready():
	add_to_group("bullets")
	collision_layer = 1
	collision_mask = 2
	connect("body_entered", Callable(self, "_on_Bullet_body_entered"))

func _process(delta):
	var velocity = Vector2(speed, 0).rotated(rotation)
	position += velocity * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):  # Make sure mobs are in 'mobs' group
		body.take_damage()  # Handles the mob being hit
	queue_free()  # Remove the bullet
