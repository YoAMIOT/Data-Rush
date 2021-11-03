extends AnimatedSprite


var isControlled : bool = false;
export (PackedScene) var Projectile : PackedScene;
var rightCannon : bool = true;
var canShoot = true;



func _physics_process(delta):
	if isControlled == true:
		turretControl();
	else:
		pass;



func turretControl():
	var mousePosition : Vector2 = get_global_mouse_position();
	$".".look_at(mousePosition);
	$".".rotation_degrees += 90;

	if Input.is_action_just_pressed("shoot") && canShoot == true:
		canShoot = false;
		get_node("Timer").start();
		if rightCannon == true:
			rightCannon = false;
			var RProjectile = Projectile.instance();
			owner.add_child(RProjectile);
			RProjectile.transform = get_node("RCannon").global_transform;
		elif rightCannon == false:
			rightCannon = true;
			var LProjectile = Projectile.instance();
			owner.add_child(LProjectile);
			LProjectile.transform = get_node("LCannon").global_transform;


func _on_Timer_timeout():
	canShoot = true;
