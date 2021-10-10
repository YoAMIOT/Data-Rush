extends Node2D

###Process Function###
func _physics_process(delta):
	if Input.is_action_just_pressed("interact"):
		if get_node("Player").isConnectedToTheShip == true:
			exitShipControl();
		elif get_node("Player").isConnectedToTheShip == false:
			if get_node("Ship").playerInShipControllerArea == true:
				get_node("Ship/Camera").zoom = Vector2(0.6, 0.6);
				get_node("Ship/Ext").visible = true;
				get_node("Player/CollisionShape2D").disabled = true;
				get_node("Player/AnimatedSprite").visible = false;
				get_node("Player").isConnectedToTheShip = true;
				get_node("Player").isControllingTheShip = true;

			elif get_node("Ship").playerInBlasterControllerArea == true:
				get_node("Player").isConnectedToTheShip = true;
				get_node("Ship/Camera").zoom = Vector2(0.6, 0.6);
				get_node("Ship/Ext").visible = true;

			elif get_node("Ship").playerInRepairControllerArea == true:
				get_node("Player").isConnectedToTheShip = true;

			elif get_node("Ship").playerInDataControllerArea == true:
				get_node("Player").isConnectedToTheShip = true;

	if Input.is_action_just_pressed("cancel") and get_node("Player").isConnectedToTheShip == true:
		exitShipControl();



func exitShipControl():
	get_node("Player").isConnectedToTheShip = false;
	get_node("Ship/Camera").zoom = Vector2(0.15, 0.15);
	if get_node("Player").isControllingTheShip == true:
		get_node("Player").isControllingTheShip = false;
		get_node("Player/AnimatedSprite").visible = true;
		get_node("Player/CollisionShape2D").disabled = false;
		get_node("Player").global_position = get_node("Ship/Position2D").global_position; 
	if get_node("Ship/Ext").visible == true:
		get_node("Ship/Ext").visible = false;
