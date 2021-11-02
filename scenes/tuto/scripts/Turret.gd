extends AnimatedSprite

var isControlled : bool = false;


func _physics_process(delta):
	if isControlled == true:
		turretControl();
	else:
		pass;



func turretControl():
	var mousePosition : Vector2 = get_global_mouse_position();
	$".".look_at(mousePosition);
	$".".rotation_degrees += 90;
