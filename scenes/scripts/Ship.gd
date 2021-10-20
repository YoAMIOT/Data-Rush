extends KinematicBody2D

###Variables###
var playerInShipControllerArea : bool = false;
var playerInBlasterControllerArea : bool = false;
var playerInRepairControllerArea : bool = false;
var playerInDataControllerArea : bool = false;
var velocity : Vector2 = Vector2.ZERO;
var speed : int = 0;
var maxSpeed : int = 400;
var minSpeed : int = -400;
var acceleration : int = 5;
var friction : int = 5;
var brakeForce : int = 9;
var rotationSpeed : float = 0;
var rotationAcceleration : float = 0.05;
var rotationFriction : float = 0.05;
var rotationBrake : float = 0.09;
var maxRotationSpeed: int = 3;
var minRotationSpeed : int = -3;
var turretRotationSpeed : int = 3;
var isMoving : bool = false;
var isRotating : bool = false;
var canShoot : bool = true;
var rightCannon : bool = true;
export (PackedScene) var Projectile : PackedScene;



###Function to get the inputs###
func getInput():
	velocity = Vector2(0, 0);

	if Input.is_action_pressed("right"):
		if rotationSpeed < maxRotationSpeed and rotationSpeed >= 0:
			rotationSpeed += rotationAcceleration;
		elif rotationSpeed > maxSpeed:
			rotationSpeed = maxSpeed;
		elif rotationSpeed < 0:
			rotationSpeed += rotationBrake;
		isRotating = true;
	if Input.is_action_pressed("left"):
		if rotationSpeed > minRotationSpeed and rotationSpeed <= 0:
			rotationSpeed -= rotationAcceleration;
		elif rotationSpeed < minSpeed:
			rotationSpeed = minSpeed;
		elif rotationSpeed > 0:
			rotationSpeed -= rotationBrake;
		isRotating = true;

	if Input.is_action_just_released("right") or Input.is_action_just_released("left"):
		isRotating = false;

	if Input.is_action_pressed("up"):
		if speed > minSpeed and speed <= 0:
			speed -= acceleration;
		elif speed < minSpeed:
			speed = minSpeed;
		elif speed > 0:
			speed -= brakeForce;
		velocity = Vector2(0, speed).rotated(rotation);
		isMoving = true;
	elif Input.is_action_pressed("down"):
		if speed < maxSpeed and speed >= 0:
			speed += acceleration;
		elif speed > maxSpeed:
			speed = maxSpeed;
		elif speed < 0:
			speed += brakeForce;
		velocity = Vector2(0, speed).rotated(rotation);
		isMoving = true;

	if Input.is_action_just_released("up") or Input.is_action_just_released("down"):
		isMoving = false;



###Process Function###
func _physics_process(delta):
	if get_parent().get_node("Player").isControllingTheShip:
		getInput();
		applyFriction();
		rotation += rotationSpeed * delta;
		velocity = move_and_slide(velocity);
	else: 
		speed = 0;
		rotationSpeed = 0;

	if get_parent().get_node("Player").isControllingTurret:
		turretControl();



###Function to apply the rotation to the turret###
func turretControl():
	var mousePosition : Vector2 = get_global_mouse_position();
	if $Turret.get_angle_to(mousePosition) + deg2rad(90) > 0:
		$Turret.rotation_degrees += turretRotationSpeed;
	elif $Turret.get_angle_to(mousePosition) + deg2rad(90) < 0:
		$Turret.rotation_degrees -= turretRotationSpeed;
	if $Turret.get_angle_to(mousePosition) + deg2rad(90) > deg2rad(-5) and $Turret.get_angle_to(mousePosition) + deg2rad(90) < deg2rad(5):
		$Turret.look_at(mousePosition);
		$Turret.rotation_degrees += 90;

	if Input.is_action_just_pressed("shoot") and canShoot:
		canShoot = false;
		get_node("ShootingCooldown").start();
		
		if rightCannon == true:
			rightCannon = false;
			var RProjectile = Projectile.instance();
			owner.add_child(RProjectile);
			RProjectile.transform = get_node("Turret/RCannon").global_transform;

		elif rightCannon == false:
			rightCannon = true;
			var LProjectile = Projectile.instance();
			owner.add_child(LProjectile);
			LProjectile.transform = get_node("Turret/LCannon").global_transform;



###Function to apply friction###
func applyFriction():
	if speed != 0 and !isMoving:
		if speed > 0:
			speed -= friction;
		elif speed < 0:
			speed += friction;
		if speed > -3 and speed < 3:
			speed = 0;
		velocity = Vector2(0, speed).rotated(rotation);

	if rotationSpeed != 0 and !isRotating:
		if rotationSpeed > 0:
			rotationSpeed -= rotationFriction;
		elif rotationSpeed < 0:
			rotationSpeed += rotationFriction;
		if rotationSpeed > -0.04 and rotationSpeed < 0.04:
			rotationSpeed = 0;



###Function to detect when a player gets in the Ship Controller area###
func _on_ShipControllerArea_body_entered(body):
	if body.is_in_group("player"):
		playerInShipControllerArea = true;
###Function to detect when a player gets off the Ship Controller area###
func _on_ShipControllerArea_body_exited(body):
	if body.is_in_group("player"):
		playerInShipControllerArea = false;
###Function to detect when a player gets in the Blaster Controller area###
func _on_BlasterControllerArea_body_entered(body):
	if body.is_in_group("player"):
		playerInBlasterControllerArea = true;
###Function to detect when a player gets off the Blaster Controller area###
func _on_BlasterControllerArea_body_exited(body):
	if body.is_in_group("player"):
		playerInBlasterControllerArea = false;
###Function to detect when a player gets in the Repair Controller area###
func _on_RepairControllerArea_body_entered(body):
	if body.is_in_group("player"):
		playerInRepairControllerArea = true;
###Function to detect when a player gets off the Repair Controller area###
func _on_RepairControllerArea_body_exited(body):
	if body.is_in_group("player"):
		playerInRepairControllerArea = false;
###Function to detect when a player gets in the Data Controller area###
func _on_DataControllerArea_body_entered(body):
	if body.is_in_group("player"):
		playerInDataControllerArea = true;
###Function to detect when a player gets off the Data Controller area###
func _on_DataControllerArea_body_exited(body):
	if body.is_in_group("player"):
		playerInDataControllerArea = false;



###Functiont to call when the Shooting Cooldown Timer is done###
func _on_ShootingCooldown_timeout():
	canShoot = true;
