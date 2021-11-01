extends Node2D

###Variables###
var playerPath : String = "Player";
var shipPath : String = "Ship";
var cameraPath : String = shipPath + "/Camera";
var shipExternSprite : String = shipPath + "/Ext";
var shipTurretPath : String = shipPath + "/Turret";
var playerCollisionPath : String = playerPath + "/CollisionShape2D";
var playerAnimatedSpritePath : String = playerPath + "/AnimatedSprite";
var portholePath : String = shipPath + "/Porthole";
var crosshairPath : String = "Crosshair";
var stationPath : String = "Station";
var stationSpritePath : String = stationPath + "/Station";
var shipRepairUiPath : String = shipPath + "/RepairUI";
var shipPlayerRespawn : String = shipPath + "/Position2D";



###Process Function###
func _physics_process(delta):
	if Input.is_action_just_pressed("interact"):
		if get_node(playerPath).isConnectedToTheShip == true:
			exitShipControl();
		elif get_node(playerPath).isConnectedToTheShip == false:
			if get_node(shipPath).playerInShipControllerArea == true and get_node(shipPath).cockpitBreakdown == false:
				get_node(cameraPath).zoom = Vector2(1, 1);
				get_node(shipExternSprite).visible = true;
				get_node(shipTurretPath).visible = true;
				get_node(playerCollisionPath).disabled = true;
				get_node(playerAnimatedSpritePath).visible = false;
				get_node(playerPath).isConnectedToTheShip = true;
				get_node(playerPath).isControllingTheShip = true;
				get_node(portholePath).visible = true;
				get_parent().get_node(stationSpritePath).visible = true;

			elif get_node(shipPath).playerInBlasterControllerArea == true and get_node(shipPath).turretBreakdown == false:
				get_node(playerPath).isConnectedToTheShip = true;
				get_node(playerPath).isControllingTurret = true;
				get_node(cameraPath).zoom = Vector2(1, 1);
				get_node(shipExternSprite).visible = true;
				get_node(shipTurretPath).visible = true;
				get_node(portholePath).visible = true;
				get_node(crosshairPath).setVisible("turret");
				get_parent().get_node(stationSpritePath).visible = true;

			elif get_node(shipPath).playerInRepairControllerArea == true:
				get_node(playerPath).isConnectedToTheShip = true;
				get_node(shipRepairUiPath).visible = true;
				get_node(crosshairPath).setVisible("repair");

			elif get_node(shipPath).playerInDataControllerArea == true:
				get_node(playerPath).isConnectedToTheShip = true;

	if Input.is_action_just_pressed("cancel") and get_node(playerPath).isConnectedToTheShip == true:
		exitShipControl();



###Function when the player exit control desk###
func exitShipControl():
	get_node(playerPath).isConnectedToTheShip = false;
	get_node(cameraPath).zoom = Vector2(0.12, 0.12);
	if get_node(playerPath).isControllingTheShip == true:
		get_node(playerPath).isControllingTheShip = false;
		get_node(playerAnimatedSpritePath).visible = true;
		get_node(playerCollisionPath).set_deferred("disabled", false);
		get_node(playerPath).global_position = get_node(shipPlayerRespawn).global_position; 
	if get_node(shipExternSprite).visible == true:
		get_node(shipExternSprite).visible = false;
		get_node(shipTurretPath).visible = false;
		get_parent().get_node(stationSpritePath).visible = false;
		get_node(portholePath).visible = false;
	if get_node(playerPath).isControllingTurret == true:
		get_node(playerPath).isControllingTurret = false;
		get_node(crosshairPath).visible = false;
	if get_node(shipRepairUiPath).visible == true:
		get_node(shipRepairUiPath).visible = false;
		get_node(crosshairPath).visible = false;
