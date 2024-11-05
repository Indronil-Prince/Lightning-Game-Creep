extends RigidBody2D

var screen_size
var offset = 20
var isActive = false


func _ready():
	screen_size = get_viewport_rect().size
	randomize()
	#var pos = Vector2(randi_range(offset, screen_size.x-offset), randi_range(offset, screen_size.y-offset))
	#position = pos
	hide_n_disable_poewrup_life()
	
func _llprocess(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	velocity.x += randi_range(-offset, offset)
	velocity.y += randi_range(-offset, offset)
	if velocity.length() > 0:
		velocity = velocity.normalized() * 1000
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	
func show_powerup_life():
	#if isActive:
	#	start_new_life_timer()
	#	return
	print(name, " old position: ", position)	
	var pos = Vector2(randi_range(offset, screen_size.x-offset), \
	randi_range(offset, screen_size.y-offset))
	position = pos #position = pos
	print("power position random: ", position)
	show()
	$CollisionShape2D.disabled = false
	$Timer.start()
	isActive = true
	
func hide_n_disable_poewrup_life():
	hide() # disappears after being hit.
	$CollisionShape2D.set_deferred("disabled", true)
	isActive = false
	#start_new_life_timer()

func _on_timer_timeout() -> void:
	hide_n_disable_poewrup_life()

'''
func _on_body_entered(body: Node2D) -> void:
	print("Powerup touched by... ", body.name)
func _on_new_life_timer_timeout() -> void: #add new life 
	show_powerup_life()

func start_new_life_timer(waiting_for_sec = 5):
	#$NewLifeTimer.start(waiting_for_sec)
	show_powerup_life()
'''
