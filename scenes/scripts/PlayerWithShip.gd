extends Node2D

###Process Function###
func _physics_process(delta):
	if Input.is_action_just_pressed("interact"):
		if get_node("Player").isConnectedToTheShip == true:
			exitShipControl();
		elif get_node("Player").isConnectedToTheShip == false:
			if get_node("Ship").playerInShipControllerArea == true:
				get_node("Ship/Camera").zoom = Vector2(1, 1);
				get_node("Ship/Ext").visible = true;
				get_node("Ship/Turret").visible = true;
				get_node("Player/CollisionShape2D").disabled = true;
				get_node("Player/AnimatedSprite").visible = false;
				get_node("Player").isConnectedToTheShip = true;
				get_node("Player").isControllingTheShip = true;
				get_node("Ship/Porthole").visible = true;

			elif get_node("Ship").playerInBlasterControllerArea == true:
				get_node("Player").isConnectedToTheShip = true;
				get_node("Player").isControllingTurret = true;
				get_node("Ship/Camera").zoom = Vector2(1, 1);
				get_node("Ship/Ext").visible = true;
				get_node("Ship/Turret").visible = true;
				get_node("Ship/Porthole").visible = true;
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

			elif get_node("Ship").playerInRepairControllerArea == true:
				get_node("Player").isConnectedToTheShip = true;

			elif get_node("Ship").playerInDataControllerArea == true:
				get_node("Player").isConnectedToTheShip = true;

	if Input.is_action_just_pressed("cancel") and get_node("Player").isConnectedToTheShip == true:
		exitShipControl();



###Function when the player exit control desk###
func exitShipControl():
	get_node("Player").isConnectedToTheShip = false;
	get_node("Ship/Camera").zoom = Vector2(0.12, 0.12);
	if get_node("Player").isControllingTheShip == true:
		get_node("Player").isControllingTheShip = false;
		get_node("Player/AnimatedSprite").visible = true;
		get_node("Player/CollisionShape2D").disabled = false;
		get_node("Player").global_position = get_node("Ship/Position2D").global_position; 
	if get_node("Ship/Ext").visible == true:
		get_node("Ship/Ext").visible = false;
		get_node("Ship/Turret").visible = false;
		get_node("Ship/Porthole").visible = false;
	if get_node("Player").isControllingTurret == true:
		get_node("Player").isControllingTurret = false;
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN);
