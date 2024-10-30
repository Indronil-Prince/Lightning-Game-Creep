extends CanvasLayer

signal start_game
#signal update_life(int)

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$MessageLabel.text = "Dodge the\nCreeps"
	$MessageLabel.show()
	await get_tree().create_timer(1).timeout
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = "Score: " + str(score)

func update_life(life):
	$LifeLabel.text = "Life: " + str(life)
	
func update_bonus(bonus):
	if bonus == 0:
		var timer = Timer.new()  # Create a new Timer instance
		timer.wait_time = 0.5  # Set the timer to the desired duration
		timer.one_shot = true  # Make sure the timer only runs once
		add_child(timer)  # Add the timer to this node
		timer.start()
		await timer.timeout  # Wait for the timer to finish
		$BonusLabel.text = "   "
	else:
		$BonusLabel.text = "Bonus\n+" + str(bonus)

	
func _on_StartButton_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_MessageTimer_timeout():
	$MessageLabel.hide()
