extends CharacterBody2D

@export var speed: float = 300.0
@onready var character_sprite: AnimatedSprite2D = $CharacterAnimation
@onready var character_animation: AnimationPlayer = $AnimationPlayer

var player_sword_scene : PackedScene = load("res://player_sword.tscn")
var active_weapon : Area2D;

var direction := Vector2.ZERO
var last_direction := Vector2.DOWN
var can_attack := true

func handle_input() -> void:
	if Input.is_action_just_pressed("Slash") and can_attack:  
		can_attack = false
		active_weapon = player_sword_scene.instantiate()
		$Weapon.add_child(active_weapon)
		active_weapon.position = Vector2(0,0)
		$AttackTimer.start()
		play_attack_animation()
		
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


func _physics_process(delta: float) -> void:
	handle_input()
	move_character(delta)
	update_animation()

func move_character(delta: float) -> void:
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

func play_attack_animation() -> void:

	match last_direction:
		Vector2.UP:
			character_animation.play("up_attack")
		Vector2.DOWN:
			character_animation.play("down_attack")
		Vector2.LEFT:
			character_animation.play("left_attack")
		Vector2.RIGHT:
			character_animation.play("right_attack")
	
	


func _on_attack_timer_timeout() -> void:
	if ($Weapon.get_child_count() > 0):
		$Weapon.remove_child(active_weapon)
	can_attack = true
