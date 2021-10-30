extends Sprite

###Process function###
func _physics_process(delta):
	if $".".visible == true:
		if $"CockpitButton".is_hovered() or $"RThrusterButton".is_hovered():
			get_parent().get_parent().get_node("Crosshair/AnimatedSprite").animation = "pointer";
		elif $"LThrusterButton".is_hovered() or $"EngineButton".is_hovered():
			get_parent().get_parent().get_node("Crosshair/AnimatedSprite").animation = "pointer";
		elif $"TurretButton".is_hovered():
			get_parent().get_parent().get_node("Crosshair/AnimatedSprite").animation = "pointer";
		else:
			get_parent().get_parent().get_node("Crosshair/AnimatedSprite").animation = "cursor";


###Functions to detect if a button is pressed###
func _on_CockpitButton_pressed():
	get_parent().cockpitBreakdown = false;
	$Cockpit.visible = false;
func _on_EngineButton_pressed():
	get_parent().engineBreakdown = false;
	$Engine.visible = false;
func _on_RThrusterButton_pressed():
	get_parent().RThrusterBreakdown = false;
	$RThruster.visible = false;
func _on_LThrusterButton_pressed():
	get_parent().LThrusterBreakdown = false;
	$LThruster.visible = false;
func _on_TurretButton_pressed():
	get_parent().turretBreakdown = false;
	$Turret.visible = false;
