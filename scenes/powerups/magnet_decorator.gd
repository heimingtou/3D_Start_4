class_name MagnetDecorator
extends PowerupDecorator

## Blades circling the fox while it runs.
func on_apply() -> void:
	
	var magnet_area = fox.get_node_or_null("Direction/MagnetArea") as Area3D
	if magnet_area:
		print("apply")
		# Bật vùng từ trường lên
		magnet_area.monitoring = true
		if magnet_area.monitoring:
			print("bat vung hut")
		# Kết nối sự kiện khi có vật thể (đồng xu) bước vào vùng
		if not magnet_area.area_entered.is_connected(_on_coin_entered_magnet):
			magnet_area.area_entered.connect(_on_coin_entered_magnet)
	pass
func on_remove() -> void:
	if fox and is_instance_valid(fox):
		var magnet_area = fox.get_node_or_null("Direction/MagnetArea") as Area3D
		if magnet_area:
			magnet_area.monitoring = false
			if magnet_area.area_entered.is_connected(_on_coin_entered_magnet):
				magnet_area.area_entered.disconnect(_on_coin_entered_magnet)
	
func _on_coin_entered_magnet(area: Area3D) -> void:
	print("catch ")
	# Kiểm tra xem vật thể chạm vào có phải là đồng xu không
	if area.has_method("attract_to"):
		print("catch coin")
		area.attract_to(fox)
