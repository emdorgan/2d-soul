extends CharacterBody2D

@export var speed: float = 300.0
@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 0.3

@onready var character_sprite: AnimatedSprite2D = $CharacterAnimation
@onready var character_animation: AnimationPlayer = $AnimationPlayer

var player_sword_scene : PackedScene = load("res://player_sword.tscn")
var active_weapon : Area2D;

var direction := Vector2.ZERO
var last_direction := Vector2.DOWN
var can_attack := true
var is_dashing := false
var dash_timer := 0.0
var dash_cooldown_timer := 0.0

func handle_input() -> void:
	if Input.is_action_just_pressed("Slash") and can_attack:  
		can_attack = false
		active_weapon = player_sword_scene.instantiate()
		$Weapon.add_child(active_weapon)
		active_weapon.position = Vector2(0,0)
		$AttackTimer.start()
		play_attack_animation()
		
	if Input.is_action_just_pressed("Dash") and not is_dashing and dash_cooldown_timer <= 0:
		start_dash()
		
	direction = Vector2.ZERO
	
	var horizontal_input = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var vertical_input = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	direction = Vector2(horizontal_input, vertical_input).normalized()
	
	if direction != Vector2.ZERO:
		last_direction = round_direction(direction)


func _physics_process(delta: float) -> void:
	handle_input()
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			dash_cooldown_timer = dash_cooldown  # Start cooldown after dash ends
	elif dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	
	move_character(delta)
	update_animation()

func move_character(delta: float) -> void:
	print("velocity: ",velocity)
	if is_dashing:
		velocity = direction * dash_speed
	else:
		velocity = direction * speed
	move_and_slide()
	
func start_dash() -> void:
	is_dashing = true
	dash_timer = dash_duration
	
func round_direction(dir: Vector2) -> Vector2:
	if abs(dir.x) > abs(dir.y):
		return Vector2(sign(dir.x), 0)
	else:
		return Vector2(0, sign(dir.y))
		
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
