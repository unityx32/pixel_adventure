extends Sprite
class_name EnemyTexture

export(NodePath) onready var attack_area_collision = get_node("../enemy_attack_area/collision") as CollisionShape2D
export(NodePath) onready var animation = get_node("../animation") as AnimationPlayer
export(NodePath) onready var enemy = get_parent() as KinematicBody2D

func animate(_velocity: Vector2) -> void:
	pass


func _on_animation_finished(_anim_name: String) -> void:
	pass
