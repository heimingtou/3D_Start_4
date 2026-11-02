class_name Chest
extends Node3D

## A chest that opens with a key. Press interact' next to it: with a keyin the inventory.
@export var reward_coins := 5
const Coin := preload("res://levels/objects/pickups/coin.tscn")
@onready var _sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var _area: InteractiveArea3D = $InteractiveArea3D

func _ready() -> void:
	_sprite.play("close")
	_area. interacted. connect(_on_interacted)

func _on_interacted() -> void:
	var fox := _fox_in_reach()
	if fox == null:
		return
	if not Inventory.use_key():
		Conversation.play("chest_lock", fox)
		return
	_area.queue_free()
	_sprite.play("open")
	_sprite.animation_finished.connect(_on_opened.bind(fox),CONNECT_ONE_SHOT)

func _on_opened(_fox: Player) -> void:
	var current_scene=get_tree().current_scene
	for i in range(reward_coins):
		var coin_instance=Coin.instantiate()
		if coin_instance:
			current_scene.add_child(coin_instance)
			coin_instance.global_position = global_position + Vector3(0, 0.5, 0)
		var angle = randf() * TAU
		var radius = randf_range( 1.8, 2.8)
		var drop_pos = global_position + Vector3(cos(angle) * radius, 0, sin(angle) * radius)
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(coin_instance, "global_position:x", drop_pos.x, 0.4)
		tween.tween_property(coin_instance, "global_position:z", drop_pos.z, 0.4)
		tween.tween_property(coin_instance, "global_position:y", global_position.y + 0.8, 0.2)\
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.chain().tween_property(coin_instance, "global_position:y", drop_pos.y, 0.2)\
				.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
func _fox_in_reach() -> Player:
	for body: Node3D in _area.get_overlapping_bodies():
		if body is Player:
			return body
	return null
