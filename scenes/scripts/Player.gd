extends KinematicBody2D

###Variables###
var speed : int = 200;
var velocity : Vector2 = Vector2();
var isWalking : bool = false;
var rNG : RandomNumberGenerator = RandomNumberGenerator.new()



###Function to get the input of the player###
func getInput():
	velocity = Vector2();
	if Input.is_action_pressed("right"):
		velocity.x += 1;
		isWalking = true;
		$AnimatedSprite.flip_h = false;
	if Input.is_action_just_released("right"):
		isWalking = false;

	if Input.is_action_pressed("left"):
		velocity.x -= 1;
		isWalking = true;
		$AnimatedSprite.flip_h = true;
	if Input.is_action_just_released("left"):
		isWalking = false;
	velocity = velocity.normalized() * speed;



###Process Function###
func _physics_process(delta):
	getInput();
	velocity = move_and_slide(velocity);
	animate();



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
