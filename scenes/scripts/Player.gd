extends KinematicBody2D

###Variables###
var speed : int = 40;
var gravity : int = 300;
var jumpForce : int = -90;
var velocity : Vector2 = Vector2.ZERO;
var rNG : RandomNumberGenerator = RandomNumberGenerator.new()
var isWalking : bool = false;
var isJumping : bool = true;
var isConnectedToTheShip : bool = false;
var isControllingTheShip : bool = false;
var isControllingTurret : bool = false;



###Ready function###
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);



###Function to get the input of the player###
func getInput():
	velocity.x = 0
	if !isConnectedToTheShip:
		if Input.is_action_pressed("right"):
			velocity.x += speed;
			isWalking = true;
			$AnimatedSprite.flip_h = false;
		if Input.is_action_just_released("right"):
			isWalking = false;

		if Input.is_action_pressed("left"):
			velocity.x -= speed;
			isWalking = true;
			$AnimatedSprite.flip_h = true;
		if Input.is_action_just_released("left"):
			isWalking = false;



###Process Function###
func _physics_process(delta):
	getInput();
	if isConnectedToTheShip:
		isWalking = false;

	if !isConnectedToTheShip:
		velocity.y += gravity * delta;
		velocity = move_and_slide(velocity.rotated(rotation), -transform.y, true, 4, PI/3);

	velocity = velocity.rotated(-rotation);
	rotation = get_parent().get_node("Ship").rotation;
	animate();

	if is_on_floor():
		isJumping = false;
		if Input.is_action_just_pressed("jump") and !isConnectedToTheShip:
			isJumping = true;
			velocity.y = jumpForce;



###Function to animate the Animated Sprite by testing what the player is doing###
func animate():
	if isConnectedToTheShip:
		$AnimatedSprite.animation = "connected";

	if !isConnectedToTheShip:
		if is_on_floor():
			if isWalking == true:
				if $AnimatedSprite.animation != "walk":
					$AnimatedSprite.animation = "walk";
			else:
				if !$AnimatedSprite.animation.begins_with("idle"):
					rNG.randomize();
					var randomIdle : int = rNG.randi_range(1, 4);
					if randomIdle == 1:
						$AnimatedSprite.animation = "idle_matrix";
					elif randomIdle == 2:
						$AnimatedSprite.animation = "idle_pong";
					elif randomIdle == 3:
						$AnimatedSprite.animation = "idle_thinking";
					elif randomIdle == 4:
						$AnimatedSprite.animation = "idle_windob";

		elif !is_on_floor():
			if velocity.y < -1:
				$AnimatedSprite.animation = "jump_ascent";
			elif velocity.y > 1:
				$AnimatedSprite.animation = "jump_descent";
