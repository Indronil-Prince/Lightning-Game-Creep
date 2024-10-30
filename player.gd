extends Area2D

signal hit

@export var hud:CanvasLayer = null
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var life = 3

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "right"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		rotation = PI if velocity.y > 0 else 0

func start(pos):
	position = pos
	rotation = 0
	life = 3
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(_body):
	life -= 1
	if life > 0:
		modulate = Color.RED
		get_parent().get_node("HitSound").play()
		var timer = Timer.new() # Create a new instance of Timer.
		timer.wait_time = 0.5 # Set how long the timer should run.
		timer.one_shot = true # Make sure the timer only runs once.
		add_child(timer) # Add the timer to the tree so it can start.
		timer.start()
		await timer.timeout # Wait for the timer to finish.
		modulate = Color.WHITE
	elif life == 0:
		hide() # Player disappears after being hit.
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
