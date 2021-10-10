extends Node2D

###Process Function###
func _physics_process(delta):
	if Input.is_action_just_pressed("interact"):
		if get_node("Player").isConnectedToTheShip == true:
			get_node("Player").isConnectedToTheShip = false;
			get_node("Player").isControllingTheShip = false;

		elif get_node("Player").isConnectedToTheShip == false:
			if get_node("Ship").playerInShipControllerArea == true:
				get_node("Player").isConnectedToTheShip = true;
				get_node("Player").isControllingTheShip = true;
			elif get_node("Ship").playerInBlasterControllerArea == true:
				get_node("Player").isConnectedToTheShip = true;
			elif get_node("Ship").playerInRepairControllerArea == true:
				get_node("Player").isConnectedToTheShip = true;
			elif get_node("Ship").playerInDataControllerArea == true:
				get_node("Player").isConnectedToTheShip = true;

	if Input.is_action_just_pressed("cancel"):
		if get_node("Player").isConnectedToTheShip == true:
			get_node("Player").isConnectedToTheShip = false;
			get_node("Player").isControllingTheShip = false;
