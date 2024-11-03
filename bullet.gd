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
	#position += velocity * delta
	position += velocity * delta
	if not get_viewport_rect().has_point(position):
		queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):  # Make sure mobs are in 'mobs' group
		emit_signal("mob_hit")
		body.take_damage()  # Handles the mob being hit
		queue_free()  # Remove the bullet
	
