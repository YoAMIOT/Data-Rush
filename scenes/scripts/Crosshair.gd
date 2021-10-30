extends Node2D

func _physics_process(delta):
	if visible == true:
		rotation = get_parent().get_node("Ship").rotation;
		position = get_global_mouse_position();
		if $AnimatedSprite.animation == "default":
			$AnimatedSprite.offset = Vector2(0, -3);
		elif $AnimatedSprite.animation == "cursor":
			$AnimatedSprite.offset = Vector2(2, 4);
		elif $AnimatedSprite.animation == "pointer":
			$AnimatedSprite.offset = Vector2(1, 4);


func setVisible(var state : String):
	$".".visible = true;
	if state == "turret":
		$AnimatedSprite.animation = "default";
	elif state == "repair":
		$AnimatedSprite.animation = "cursor";
		
