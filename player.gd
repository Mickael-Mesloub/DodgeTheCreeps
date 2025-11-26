extends Area2D

signal hit # Custom signal to send out when player collides with an enemy

@export var speed = 400 # How fast the player will move (pixels/sec)
var screen_size # Size of the game window

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector
	
	# ----- MANAGE INPUTS AND DIRECTION ----- #
	
	# Check for input and move in the given direction.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		# Prevents moving faster when moving diagonally using normalized()
		velocity = velocity.normalized() * speed 
		# Play the appropriate animation if player is moving
		$AnimatedSprite2D.play()
	else:
		# Otherwise, stop animation
		$AnimatedSprite2D.stop()
	
	# ----- UPDATE PLAYER'S POSITION AND ANIMATIONS ----- #

	position += velocity * delta
	# Clamp (= restrict) position so that player does not go out of the screen
	position = position.clamp(Vector2.ZERO, screen_size)
	
	
	if velocity.x != 0: # If player is moving left or right
		$AnimatedSprite2D.animation = "walk" # Use "walk" animation 
		$AnimatedSprite2D.flip_v = false # Don't flip character vertically
		$AnimatedSprite2D.flip_h = velocity.x < 0 # But flip horizontally if moving horizontally
	elif velocity.y != 0: # If player is moving up or down
		$AnimatedSprite2D.animation = "up" # Use "up" animation
		$AnimatedSprite2D.flip_v = velocity.y > 0 # Flip character horizontally if moving vertcally
	
# Manage player start
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Manage collisions with an enemy	
func _on_body_entered(_body: Node2D) -> void:
	hide() # Make player disappear after being hit by an enemy
	hit.emit()
	# Disabling the area's collision shape can cause an error 
	# if it happens in the middle of the engine's collision processing. 
	# Using set_deferred() tells Godot to wait to disable the shape until it's safe to do so.
	$CollisionShape2D.set_deferred("disabled", true) # Disable player's collision to avoid multiple triggers
