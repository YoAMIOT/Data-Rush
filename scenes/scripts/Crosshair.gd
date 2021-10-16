extends Node2D

func _physics_process(delta):
	if visible == true:
		rotation = get_parent().get_node("Ship").rotation;
		position = get_global_mouse_position();
