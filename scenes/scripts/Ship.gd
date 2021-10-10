extends KinematicBody2D

###Variables###
var playerInShipControllerArea : bool = false;
var playerInBlasterControllerArea : bool = false;
var playerInRepairControllerArea : bool = false;
var playerInDataControllerArea : bool = false;



func getInput():
	pass



func _physics_process(delta):
	if get_parent().get_node("Player").isControllingTheShip:
		getInput();



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
