extends CharacterBody2D

@export var walk_speed := 500;

signal slash(slash_position, slash_direction)

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position());
	var direction = Input.get_vector("Left", "Right", "Up", "Down");
	velocity = direction * walk_speed;
	if(!Global.is_attacking):
		move_and_slide();
	
	if(Input.is_action_just_pressed("Slash") and !Global.is_attacking):
		slash.emit($SlashStartingPos.global_position, rotation_degrees)
		Global.is_attacking = true;
