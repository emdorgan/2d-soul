extends Node2D

var sword_scene : PackedScene = load("res://player_sword.tscn");



func _on_player_slash(slash_position: Variant, slash_rotation) -> void:
	var sword = sword_scene.instantiate()
	$Weapons.add_child(sword)
	sword.position = slash_position;
	sword.rotation_degrees = slash_rotation + 20;
	
	var sword_slash_tween = create_tween();
	sword_slash_tween.tween_property(sword, "rotation_degrees", slash_rotation -110, 0.3)
	sword_slash_tween.finished.connect(_on_slash_tween_finished.bind(sword))  
	
func _on_slash_tween_finished(sword):
	sword.queue_free();
	Global.is_attacking = false;
	
