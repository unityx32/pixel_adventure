extends Area2D
class_name CollisionArea

onready var timer: Timer = get_node("timer")

export(int) var health
export(float) var invencibility_time

export(NodePath) onready var enemy = get_node(enemy) as KinematicBody2D
var can_die: bool = false


func _on_collision_area_entered(area):
	if area.get_parent() is Player:
		var player_stats: Node = area.get_parent().get_node("stats")
		var player_attack: int = player_stats.base_attack + player_stats.bonus_attack
		update_health(player_attack)
		
		
func update_health(damage: int) -> void:
	health -= damage
	if health <= 0:
		enemy.can_die = true
		return
	enemy.can_hit = true
