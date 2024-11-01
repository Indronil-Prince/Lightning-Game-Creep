extends RigidBody2D

signal mob_hit(health)

var score = 0
var health = 3
var sprite: AnimatedSprite2D
var hud: CanvasLayer
var main: Node

func _ready():
	collision_layer = 2
	collision_mask = 1
	$AnimatedSprite2D.play()
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	add_to_group("mobs")
	sprite = $AnimatedSprite2D
	hud = get_node("/root/Main/HUD")
	main = get_node("/root/Main")
	
# Function to handle bullet hits
func take_damage():
	health -= 1
	emit_signal("mob_hit", health)
	# Scale the mob based on remaining health
	match health:
		2:
			sprite.scale = Vector2(0.5, 0.5)  # Scale down to 50%
			#sprite.modulate.a = 0.5
		1:
			sprite.scale = Vector2(0.25, 0.25)  # Scale down to 25%
			#sprite.modulate.a = 0.25
		0:
			queue_free()  # Remove the mob from the scene

# Connect this to bullet's body_entered signal if using Area2D for the bullet
func _on_Mob_body_entered(body):
	if body.is_in_group("bullets"):  # Assuming bullets are added to 'bullets' group
		take_damage()
		body.queue_free()  # Optional: Destroy the bullet as well
