extends Area2D

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	queue_free()
	var hearts = get_tree().get_nodes_in_group("hearts")
	if hearts.size() == 1:
		Events.level_completed.emit()
