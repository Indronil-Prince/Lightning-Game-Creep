extends Node
@export var bullet_scene: PackedScene

@export var mob_scene: PackedScene
# var Bullet: Area2D
var score = 0
var life = 3
var bonus = 0

func _ready() -> void:
	mob_scene = preload("res://mob.tscn")

func game_over():
	$HUD.update_life(0)
	$HUD.update_bonus(0)
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func add_mob():
	var mob = mob_scene.instance()
	mob.connect("mob_hit", Callable(self, "_on_mob_hit"))
	add_child(mob)

# Adjusted signal handler that fetches the mob from the signal emitter's metadata
func _on_mob_hit(health):
	print("Health: ", health )
	

	# Apply the scoring logic as needed
	match health:
		2:
			score += 2
		1:
			score += 3
		0:
			score += 5
	#$HUD.update_score(score)
	
	score += 1  # Increase the score by 1 for each hit
	print("Score:", score)  # Check if score is incrementing
	$HUD.update_score(score)  # Update the score on the HUD


func new_game():
	get_tree().call_group(&"mobs", &"queue_free")
	score = 0
	life = 3
	bonus = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_life(life)
	$HUD.update_bonus(bonus)
	$HUD.show_message("Get Ready")
	$Music.play()

func shoot():
	if bullet_scene:  # Ensure the bullet scene is loaded
		var bullet = bullet_scene.instantiate()
		bullet.position = $Player.position
		bullet.rotation = $Player.rotation
		bullet.linear_velocity = Vector2(500, 0).rotated($Player.rotation)  # Adjust speed as necessary
		add_child(bullet)

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()

func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node(^"MobPath/MobSpawnLocation")
	mob_spawn_location.progress = randi()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)




func _on_ScoreTimer_timeout():
	#score += 1
	if score>0 and score%10==0:
		bonus+=1
		$HUD.update_bonus(bonus)
	$HUD.update_score(score)
	$HUD.update_life($Player.life  + bonus)
	$Player.life = $Player.life + bonus
	bonus = 0
	$HUD.update_bonus(bonus)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
