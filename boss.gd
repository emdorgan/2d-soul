extends CharacterBody2D

func _on_player_detection_body_entered(body: Node2D) -> void:
	print('player detected', body)


func _on_boss_hurt_box_area_entered(area: Area2D) -> void:
	print('sword hit detected', area)
