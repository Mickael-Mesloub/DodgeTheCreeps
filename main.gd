extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	# Set the score to 0.
	score = 0
	# Set the player's start position.
	$Player.start($StartPosition.position)
	# Start the timer before the game starts.
	$StartTimer.start()
	# Call the update_score method from HUD.
	$HUD.update_score(score)
	# Display a message before the game starts.
	$HUD.show_message("Get ready!")
	# Remove all mobs that could be remaining from previous game
	# if player restarts the game after Game over.
	get_tree().call_group("mobs", "queue_free")
	
	$Music.play()

func _on_mob_timer_timeout() -> void:
	# Create a mob instance.
	var mob = mob_scene.instantiate()
	
	# Pick a random starting location along the Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# track player position and check if mob_spawn_location is in a zone around (to be defined), generate another position
	
	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position
	if(mob.position.x <= $Player.position.x + 10):
		print("***************************************************")
		print("PLAYER'S X POSITION : " + str($Player.position.x))
		print("MOB SPAWN X TOO CLOSE FROM PLAYER !!")
		print("MOB SPAWN PREVIOUS X POS : " + str(mob.position.x))
		mob.position.x += 20
		print("MOB SPAWN NEW POS : " + str(mob.position.x))
		print("---------------------------------------------------")
	elif(mob.position.y <= $Player.position.y + 10):
		print("***************************************************")
		print("PLAYER'S Y POSITION : " + str($Player.position.y))
		print("MOB SPAWN Y TOO CLOSE FROM PLAYER !!")
		print("MOB SPAWN PREVIOUS Y POS : " + str(mob.position.y))
		mob.position.y += 20 
		print("MOB SPAWN NEW Y POS : " + str(mob.position.y))
		print("---------------------------------------------------")
		
	# Set the mob's driection perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_hud_start_game() -> void:
	pass # Replace with function body.
