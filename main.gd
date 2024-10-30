extends Node

@export var mob_scene: PackedScene
var score
var life
var bonus = 0

func game_over():
	$HUD.update_life(0)
	$HUD.update_bonus(0)
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


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
	score += 1
	if score>0 and score%10==0:
		bonus+=1
		$HUD.update_bonus(bonus)
	$HUD.update_score(score)
	$HUD.update_life($Player.life + bonus)
	$Player.life = $Player.life + bonus
	bonus = 0
	$HUD.update_bonus(bonus)
	

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
