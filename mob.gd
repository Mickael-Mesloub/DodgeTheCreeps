extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names()) # Get all animation names
	var random_mob_type = mob_types.pick_random() # Pick a random animation from the array
	$AnimatedSprite2D.play(random_mob_type) # Play the random animation
	$Fly_Collision.disabled = random_mob_type != "fly" # Disable fly animation when mob is not flying

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Make the mobs delete themselves when they leave the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # queue_free() is a function that essentially 'frees', 
				 # or deletes, the node at the end of the frame   
