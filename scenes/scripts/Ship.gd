extends KinematicBody2D

###Constants###
const MAX_HEALTH : int = 1000;
const MAX_AMMO : int = 4;



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
var rNG : RandomNumberGenerator = RandomNumberGenerator.new();
var RThrusterBreakdown : bool = false;
var LThrusterBreakdown : bool = false;
var engineBreakdown : bool = false;
var cockpitBreakdown : bool = false;
var turretBreakdown : bool = false;
var health : int = 1000;
var ammo : int = 4;
var isReloading : bool = false;



###Paths###
var turretPath : String = "Turret";
var playerPath : String = "Player";
var shootingCooldownPath : String = "Timers/ShootingCooldown";
var reloadCooldownPath : String = "Timers/ReloadCooldown";
var LCannonPath : String = turretPath + "/LCannon";
var RCannonPath : String = turretPath + "/RCannon";
var repairUiPath : String = "RepairUI"
var repairTurretPath : String = repairUiPath + "/Turret";
var repairCockpitPath : String = repairUiPath + "/Cockpit";
var repairEnginePath : String = repairUiPath + "/Engine";
var RThrusterRepairPath : String = repairUiPath + "/RThruster";
var LThrusterRepairPath : String = repairUiPath + "/LThruster";
var stationPath : String = "Station"
var shipSpawnPath : String = stationPath + "/ShipSpawn";



###Ready Function###
func _ready():
	get_node(turretPath).rotation_degrees = 0;
	$".".global_position = get_parent().get_parent().get_node(shipSpawnPath).global_position;
	$".".rotation = get_parent().get_parent().get_node(stationPath).rotation;
	get_parent().get_node(playerPath).global_position = get_parent().get_parent().get_node(shipSpawnPath).global_position;
	



###Function to get the inputs###
func getInput():
	velocity = Vector2(0, 0);

	if engineBreakdown:
		if speed > 0:
			speed -= friction;
		elif speed < 0:
			speed += friction;
		if speed > -3 and speed < 3:
			speed = 0;
		if rotationSpeed > 0:
			rotationSpeed -= rotationFriction;
		elif rotationSpeed < 0:
			rotationSpeed += rotationFriction;
		if rotationSpeed > -0.04 and rotationSpeed < 0.04:
			rotationSpeed = 0;

	if engineBreakdown == false:
		if Input.is_action_pressed("right"):
			if RThrusterBreakdown == false and LThrusterBreakdown == false:
				if rotationSpeed < maxRotationSpeed and rotationSpeed >= 0:
					rotationSpeed += rotationAcceleration;
				elif rotationSpeed > maxSpeed:
					rotationSpeed = maxSpeed;
				elif rotationSpeed < 0:
					rotationSpeed += rotationBrake;
				isRotating = true;
		if Input.is_action_pressed("left"):
			if RThrusterBreakdown == false and LThrusterBreakdown == false:
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
			if LThrusterBreakdown == true:
				if rotationSpeed > minRotationSpeed and rotationSpeed <= 0:
					rotationSpeed -= rotationAcceleration;
				elif rotationSpeed < minSpeed:
					rotationSpeed = minSpeed;
				elif rotationSpeed > 0:
					rotationSpeed -= rotationBrake;
				isRotating = true;
			elif RThrusterBreakdown == true:
				if rotationSpeed < maxRotationSpeed and rotationSpeed >= 0:
					rotationSpeed += rotationAcceleration;
				elif rotationSpeed > maxSpeed:
					rotationSpeed = maxSpeed;
				elif rotationSpeed < 0:
					rotationSpeed += rotationBrake;
				isRotating = true;

		elif Input.is_action_pressed("down"):
			if speed < maxSpeed and speed >= 0:
				speed += acceleration;
			elif speed > maxSpeed:
				speed = maxSpeed;
			elif speed < 0:
				speed += brakeForce;
			velocity = Vector2(0, speed).rotated(rotation);
			isMoving = true;
			if LThrusterBreakdown == true:
				if rotationSpeed < maxRotationSpeed and rotationSpeed >= 0:
					rotationSpeed += rotationAcceleration;
				elif rotationSpeed > maxSpeed:
					rotationSpeed = maxSpeed;
				elif rotationSpeed < 0:
					rotationSpeed += rotationBrake;
				isRotating = true;
			elif RThrusterBreakdown == true:
				if rotationSpeed > minRotationSpeed and rotationSpeed <= 0:
					rotationSpeed -= rotationAcceleration;
				elif rotationSpeed < minSpeed:
					rotationSpeed = minSpeed;
				elif rotationSpeed > 0:
					rotationSpeed -= rotationBrake;
				isRotating = true;

		if Input.is_action_just_released("up") or Input.is_action_just_released("down"):
			isMoving = false;
			if RThrusterBreakdown or LThrusterBreakdown:
				isRotating = false;



###Process Function###
func _physics_process(delta):
	if get_parent().get_node(playerPath).isControllingTheShip:
		getInput();
		applyFriction();
		rotation += rotationSpeed * delta;
		velocity = move_and_slide(velocity);
	else: 
		speed = 0;
		rotationSpeed = 0;

	if get_parent().get_node(playerPath).isControllingTurret:
		turretControl();

	if isReloading == true:
		canShoot = false;

	if isReloading:
		get_node(turretPath).animation = "reload";
	elif !isReloading:
		get_node(turretPath).animation = "default";



###Function to apply the rotation to the turret###
func turretControl():
	var mousePosition : Vector2 = get_global_mouse_position();
	if get_node(turretPath).get_angle_to(mousePosition) + deg2rad(90) > 0:
		get_node(turretPath).rotation_degrees += turretRotationSpeed;
	elif get_node(turretPath).get_angle_to(mousePosition) + deg2rad(90) < 0:
		get_node(turretPath).rotation_degrees -= turretRotationSpeed;
	if get_node(turretPath).get_angle_to(mousePosition) + deg2rad(90) > deg2rad(-5) and get_node(turretPath).get_angle_to(mousePosition) + deg2rad(90) < deg2rad(5):
		get_node(turretPath).look_at(mousePosition);
		get_node(turretPath).rotation_degrees += 90;

	if Input.is_action_just_pressed("shoot") and canShoot:
		if isReloading == false && ammo > 0:
			canShoot = false;
			get_node(shootingCooldownPath).start();
			ammo -= 1;

			if rightCannon == true:
				rightCannon = false;
				var RProjectile = Projectile.instance();
				owner.add_child(RProjectile);
				RProjectile.transform = get_node(RCannonPath).global_transform;

			elif rightCannon == false:
				rightCannon = true;
				var LProjectile = Projectile.instance();
				owner.add_child(LProjectile);
				LProjectile.transform = get_node(LCannonPath).global_transform;

		elif isReloading == false && ammo <= 0:
			isReloading = true;
			get_node(reloadCooldownPath).start();



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



###Function to know when the timer is timed out###
func _on_ReloadCooldown_timeout():
	isReloading = false;
	canShoot = true;
	ammo = MAX_AMMO;



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



###Function to call when the Shooting Cooldown Timer is done###
func _on_ShootingCooldown_timeout():
	canShoot = true;



###Function to detect if an object enter the left thruster area###
func _on_LThrusterCollision_area_entered(area):
	if area.is_in_group("partDamager"):
		thrusterDamage(false);

###Function to detect if an object enter the right thruster area###
func _on_RThrusterCollision_area_entered(area):
	if area.is_in_group("partDamager"):
		thrusterDamage(true);

###Function to handle the damage applied to the thruster###
func thrusterDamage(var isRight : bool):
	rNG.randomize();
	var random = rNG.randi_range(1,20);
	if random == 12:
		if isRight == true:
			RThrusterBreakdown = true;
			get_node(RThrusterRepairPath).visible = true;
		elif isRight == false:
			LThrusterBreakdown = true;
			get_node(LThrusterRepairPath).visible = true;



###Function to detect if an object enter the engine area###
func _on_EngineCollision_area_entered(area):
	if area.is_in_group("partDamager"):
		health -= 60;
		rNG.randomize();
		var random = rNG.randi_range(1,20);
		if random == 13:
			engineBreakdown = true;
			get_node(repairEnginePath).visible = true;



###Function to detect if an object enter the body area###
func _on_BodyCollision_area_entered(area):
	if area.is_in_group("partDamager"):
		health -= 20;



###Function to detect if an object enter the cockpit area###
func _on_CockpitCollision_area_entered(area):
	if area.is_in_group("partDamager"):
		health -= 40;
		rNG.randomize();
		var random = rNG.randi_range(1,30);
		if random == 19:
			cockpitBreakdown = true;
			get_node(repairCockpitPath).visible = true;
			if get_parent().get_node(playerPath).isControllingTheShip == true:
				get_parent().exitShipControl();



###Function to detect if an object enter the turret area###
func _on_TurretCollision_area_entered(area):
	if area.is_in_group("partDamager"):
		health -= 30;
		rNG.randomize();
		var random = rNG.randi_range(1,30);
		if random == 17:
			turretBreakdown = true;
			get_node(repairTurretPath).visible = true;
			if get_parent().get_node(playerPath).isControllingTurret == true:
				get_parent().exitShipControl();
