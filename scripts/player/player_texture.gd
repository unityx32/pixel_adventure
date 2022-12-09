extends Sprite
class_name PlayerTexture

signal game_over

var normal_attack: bool = false
var suffix: String = "_right"
var shield_off: bool = false
var crouch_off: bool = false

onready var animation: AnimationPlayer = get_node("../animation")
onready var player: KinematicBody2D = get_node("../")
onready var attack_collision: CollisionShape2D = get_node("../attack_area/collision")
# outra maneira de fazer essa referência é assim (só precisaria adicionar o animation_path no texture)
# export(NodePath) var animation = get_node(animation_path) as AnimationPlayer

func animate(direction: Vector2) -> void:
	verify_position(direction)
	
	if player.on_hit or player.dead:
		hit_behavior()
	elif player.attacking or player.defending or player.crouching or player.next_to_wall():
		action_behavior()
	elif direction.y != 0:
		vertical_behavior(direction)
	elif player.landing == true:
		animation.play("landing")
		player.set_physics_process(false)
	else:
		horizontal_behavior(direction)

func verify_position(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false
		suffix = "_right"
		player.direction = -1
		position = Vector2.ZERO
		player.wall_ray.cast_to = Vector2(11, 0)
	elif direction.x < 0:
		flip_h = true
		suffix = "_left"
		player.direction = 1
		position = Vector2(-2, 0)
		player.wall_ray.cast_to = Vector2(-13, 0)

func action_behavior() -> void:
	if player.next_to_wall():
		animation.play("wall_slide")
	elif player.attacking and normal_attack:
		animation.play("attack" + suffix)
	elif player.defending and shield_off:
		animation.play("shield")
		shield_off = false
	elif player.crouching and crouch_off:
		animation.play("crouch")
		crouch_off = false

func horizontal_behavior(velocity) -> void:
	if velocity.x != 0:
		animation.play("run")
	else:
		animation.play("idle")

func vertical_behavior(direction: Vector2) -> void:
	if direction.y > 0:
		player.landing = true
		animation.play("fall")
	elif direction.y < 0:
		animation.play("jump")
	
func hit_behavior() -> void:
	player.set_physics_process(false)
	attack_collision.set_deferred("disabled", true)
	if player.on_hit:
		animation.play("hit")
	elif player.dead:
		animation.play("dead")

func _on_animation_finished(anim_name):
	match anim_name:
		"landing":
			player.landing = false
			player.set_physics_process(true)
		"attack_left":
			normal_attack = false
			player.attacking = false
		"attack_right":
			normal_attack = false
			player.attacking = false
		"hit":
			player.on_hit = false
			player.set_physics_process(true)
			
			if player.defending:
				animation.play("shield")
			if player.crouching:
				animation.play("crouch")
		"dead":
			emit_signal("game_over")
