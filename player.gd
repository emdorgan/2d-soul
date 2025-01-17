extends CharacterBody2D

@export var speed: float = 300.0
@onready var character_sprite: AnimatedSprite2D = $CharacterAnimation

var direction := Vector2.ZERO
var last_direction := Vector2.DOWN

func _process(delta: float) -> void:
	update_direction()
	move_character(delta)
	update_animation()

func update_direction() -> void:
	direction = Vector2.ZERO

	if Input.is_action_pressed("Up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("Down"):
		direction = Vector2.DOWN
	elif Input.is_action_pressed("Left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("Right"):
		direction = Vector2.RIGHT

	if direction != Vector2.ZERO:
		last_direction = direction

func move_character(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

func update_animation() -> void:
	if direction != Vector2.ZERO:
		match last_direction:
			Vector2.UP:
				character_sprite.play("walk_up")
			Vector2.DOWN:
				character_sprite.play("walk_down")
			Vector2.LEFT:
				character_sprite.play("walk_left")
			Vector2.RIGHT:
				character_sprite.play("walk_right")
	else:
		match last_direction:
			Vector2.UP:
				character_sprite.play("idle_up")
			Vector2.DOWN:
				character_sprite.play("idle_down")
			Vector2.LEFT:
				character_sprite.play("idle_left")
			Vector2.RIGHT:
				character_sprite.play("idle_right")


#func attack() -> void:
	#Global.is_attacking = true
	#perform_sword_slash()
#
#func perform_sword_slash() -> void:
	#var sword = sword_scene.instantiate()
	#add_child(sword)  # Attach the sword to the player
	#sword.position = $SlashStartingPos.position
	#sword.rotation_degrees = rotation_degrees + 20;
#
	#var sword_slash_tween = create_tween()
	## Animate the sword's rotation in a quarter-circle arc (from right to front)
	#sword_slash_tween.tween_property(sword, "rotation_degrees", rotation_degrees - 110, 0.3)
	#sword_slash_tween.finished.connect(func(): 
		#sword.queue_free()
		#Global.is_attacking = false
	#)
	#
