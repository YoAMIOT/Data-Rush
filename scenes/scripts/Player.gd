extends KinematicBody2D

###Variables###
var speed : int = 40;
var velocity : Vector2 = Vector2();
var isWalking : bool = false;
var rNG : RandomNumberGenerator = RandomNumberGenerator.new()
var gravity : int = 300;
var jumpForce : int = -90;
var isJumping : bool = true;



###Function to get the input of the player###
func getInput():
	velocity.x = 0;
	var right = Input.is_action_pressed("right");
	var left = Input.is_action_pressed("left");
	var jump = Input.is_action_just_pressed("jump");
	var rightRel = Input.is_action_just_released("right");
	var leftRel = Input.is_action_just_released("left");

	if jump and is_on_floor():
		velocity.y = jumpForce;
		isJumping = true;

	if right:
		velocity.x += speed;
		isWalking = true;
		$AnimatedSprite.flip_h = false;
	if rightRel:
		isWalking = false;
	if left:
		velocity.x -= speed;
		isWalking = true;
		$AnimatedSprite.flip_h = true;
	if leftRel:
		isWalking = false;



###Process Function###
func _physics_process(delta):
	getInput();
	animate();
	velocity.y += gravity * delta;
	velocity = move_and_slide(velocity, Vector2(0, -1));
	
	if isJumping and is_on_floor():
		isJumping = false;



###Function to animate the Animated Sprite by testing what the player is doing###
func animate():
	if isWalking == true:
		if $AnimatedSprite.animation != "walk":
			$AnimatedSprite.animation = "walk";
	else:
		if !$AnimatedSprite.animation.begins_with("idle"):
			rNG.randomize();
			var randomIdle = rNG.randi_range(1, 4);
			if randomIdle == 1:
				$AnimatedSprite.animation = "idle_matrix";
			elif randomIdle == 2:
				$AnimatedSprite.animation = "idle_pong";
			elif randomIdle == 3:
				$AnimatedSprite.animation = "idle_thinking";
			elif randomIdle == 4:
				$AnimatedSprite.animation = "idle_windob";

	if velocity.y < -1:
		$AnimatedSprite.animation = "jump_ascent";
	elif velocity.y > 1:
		$AnimatedSprite.animation = "jump_descent";
