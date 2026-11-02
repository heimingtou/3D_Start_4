class_name ShieldDecorator
extends PowerupDecorator

## Blades circling the fox while it runs.

const Shield := preload("res://scenes/powerups/shield.tscn")

var _ring: Node3D

func on_apply() -> void:
	_ring = Shield.instantiate()
	fox.add_child(_ring)
	_ring.position = Vector3(0.0, 1, 0.5)
func on_remove() -> void:
	if is_instance_valid(_ring):
		_ring.queue_free()
