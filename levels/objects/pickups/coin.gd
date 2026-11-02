extends Pickup
var target: Node3D = null
var _is_collect=false
@export var attract_speed := 10.0
func _physics_process(delta: float) -> void:
	if _is_collect:
		return
	# Nếu đang có mục tiêu (con cáo) thì bay thẳng tới đó
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * attract_speed * delta
		
		# Nếu bay đến sát con cáo (khoảng cách nhỏ hơn 1 mét) thì ăn coin
		if global_position.distance_to(target.global_position) < 1.0:
			_collect(target as Player)
			queue_free()
## One coin.
func _collect(_fox: Player) -> void:
	if _is_collect:
		return
	_is_collect=true
	Inventory.add_coin(1)
	EventBus.item_collected.emit("coin", 1)
	
func attract_to(fox: Node3D) -> void:
	if target == null: # Chỉ bắt đầu hút nếu chưa bị hút trước đó
		target = fox
