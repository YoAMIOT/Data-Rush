extends KinematicBody2D

###Variables###
var speed : int = 40;
var gravity : int = 300;
var jumpForce : int = -90;
var velocity : Vector2 = Vector2.ZERO;
var rNG : RandomNumberGenerator = RandomNumberGenerator.new()
var isWalking : bool = false;
var isJumping : bool = true;



###Function to get the input of the player###
func getInput():
	velocity.x = 0
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
	animate();
	velocity.y += gravity * delta;
	velocity = move_and_slide(velocity.rotated(rotation), -transform.y, true, 4, PI/3);
	velocity = velocity.rotated(-rotation);

	if is_on_floor():
		rotation = get_floor_normal().angle() + PI/2;
		isJumping = false;
		if Input.is_action_just_pressed("jump"):
			isJumping = true;
			velocity.y = jumpForce;
	print(is_on_floor());



###Function to animate the Animated Sprite by testing what the player is doing###
func animate():
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

	if !is_on_floor():
		if velocity.y < -1:
			$AnimatedSprite.animation = "jump_ascent";
		elif velocity.y > 1:
			$AnimatedSprite.animation = "jump_descent";
