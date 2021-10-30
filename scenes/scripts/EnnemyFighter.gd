extends KinematicBody2D

###Constants###
const MIN_DISTANCE : int = 300;
const MINIX_DISTANCE : int = 150;
const MAX_SPEED : int = 600;



###Variables###
var velocity : Vector2 = Vector2.ZERO;
var speed : int = 450;
var rNG : RandomNumberGenerator = RandomNumberGenerator.new();
var trackerPath : String;
var health : int = 10;
var canShoot : bool = true;
var rightCannon : bool = true;
export (PackedScene) var Projectile : PackedScene;


###Ready function###
func _ready():
	rNG.randomize();
	var randomTracker : int = rNG.randi_range(1,3);
	if randomTracker == 1:
		trackerPath = "PlayerWithShip/Ship/Position2D/MidTracker";
	elif randomTracker == 2:
		trackerPath = "PlayerWithShip/Ship/Position2D/LeftTracker";
	elif randomTracker == 3:
		trackerPath = "PlayerWithShip/Ship/Position2D/RightTracker";


###Get Input function###
func getInput():
	velocity = Vector2(0, 0);
	var sub : Vector2 = Vector2(get_parent().get_node("PlayerWithShip/Ship").global_position - $".".global_position);
	var distanceToPlayerShip : float = sqrt((sub.x * sub.x) + (sub.y * sub.y));
	var playerShipSeed = get_parent().get_node("PlayerWithShip/Ship").speed;
	if playerShipSeed < 0:
		playerShipSeed = playerShipSeed * -1;

	if distanceToPlayerShip > (MIN_DISTANCE * 2):
		velocity = Vector2(0, -MAX_SPEED).rotated(rotation);
	elif distanceToPlayerShip < (MIN_DISTANCE * 2) and distanceToPlayerShip > MIN_DISTANCE:
		if get_parent().get_node("PlayerWithShip/Ship").speed != 0:
			velocity = Vector2(0, (-playerShipSeed)).rotated(rotation);
		elif get_parent().get_node("PlayerWithShip/Ship").speed == 0:
			velocity = Vector2(0, -200).rotated(rotation);
	elif distanceToPlayerShip < MIN_DISTANCE and distanceToPlayerShip >= MINIX_DISTANCE:
		if get_parent().get_node("PlayerWithShip/Ship").speed != 0:
			velocity = Vector2(0, (-playerShipSeed / 2)).rotated(rotation);
		elif get_parent().get_node("PlayerWithShip/Ship").speed == 0:
			velocity = Vector2(0, -80).rotated(rotation);

	if distanceToPlayerShip < (MIN_DISTANCE * 2) and canShoot == true:
		$Cooldown.start();
		canShoot = false;
		if rightCannon == true:
			rightCannon = false;
			$AnimatedSprite.animation = "RShooting";
			var projectile = Projectile.instance();
			owner.add_child(projectile);
			projectile.transform = $RCannon.global_transform;
		elif rightCannon == false:
			rightCannon = true;
			$AnimatedSprite.animation = "LShooting";
			var projectile = Projectile.instance();
			owner.add_child(projectile);
			projectile.transform = $LCannon.global_transform;



###Process function###
func _physics_process(delta):
	getInput();

	var shipPosition : Vector2 = get_parent().get_node(trackerPath).global_position;
	$".".look_at(shipPosition);
	$".".rotation_degrees += 90;

	velocity = move_and_slide(velocity);



###Function to detect if another area2D has entered the area2D###
func _on_Hitbox_area_entered(area):
	if area.is_in_group("Projectile"):
		health -= 5;
		if health <= 0:
			$CollisionShape2D.queue_free()
			$Hitbox.queue_free()
			canShoot = false;
			$Cooldown.stop();
			$AnimatedSprite.animation = "destroy";
	if area.is_in_group("asteroid"):
		$CollisionShape2D.queue_free()
		$Hitbox.queue_free()
		$AnimatedSprite.animation = "destroy";
		canShoot = false;
		$Cooldown.stop();
		area.get_parent().get_node("AnimatedSprite").animation = "destroy";



###Funcion to detect if a body has entered the area2D###
func _on_Hitbox_body_entered(body):
	if body.is_in_group("playerShip"):
		$CollisionShape2D.queue_free()
		$Hitbox.queue_free()
		$AnimatedSprite.animation = "destroy";
		canShoot = false;
		$Cooldown.stop();
		if body.is_in_group("playerShip"):
			body.speed = body.speed / 2;



###Function to detect when an animation is done###
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "destroy":
		queue_free()
	elif $AnimatedSprite.animation == "RShooting":
		$AnimatedSprite.animation = "default";
	elif $AnimatedSprite.animation == "LShooting":
		$AnimatedSprite.animation = "default";



###Function to detect the end of a cooldown###
func _on_Cooldown_timeout():
	canShoot = true;
