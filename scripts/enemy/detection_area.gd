extends Area2D
class_name DetectionArea

onready var enemy: KinematicBody2D = get_parent()


func _on_body_entered(body: Player) -> void:
	enemy.player_ref = body
	


func _on_body_exited(_body: Player) -> void:
	enemy.player_ref = null
