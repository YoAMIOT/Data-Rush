extends KinematicBody2D

###Variables###
var rNG : RandomNumberGenerator = RandomNumberGenerator.new();



###Ready Function###
func _ready():
	rNG.randomize();
	var anim : int = rNG.randi_range(1, 3);
	rNG.randomize();
	rotation_degrees = rNG.randi_range(0, 360);
	$AnimatedSprite.animation = String(anim);



###Funcion to detect if a body has entered the area2D###
func _on_Area2D_body_entered(body):
	if body != get_node("."):
		$CollisionShape2D.queue_free();
		$Hitbox.queue_free();
		$AnimatedSprite.animation = "destroy";
		body.speed = body.speed / 2;


###Function to detect if another area2D has entered the area2D###
func _on_Area2D_area_entered(area):
	if area.is_in_group("Projectile") or area.is_in_group("fighterProjectiles"):
		$CollisionShape2D.queue_free();
		$Hitbox.queue_free();
		$AnimatedSprite.animation = "destroy";



###Function to detect when an animation is done###
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "destroy":
		queue_free()
