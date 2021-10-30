extends Area2D

###Constants###
var speed : int = 600;



###Process Fonction###
func _physics_process(delta):
	position += transform.x * speed * delta;



###Function to detect when the projectile enters an area###
func _on_Projectile_area_entered(area):
	if area.is_in_group("damageableByPlayer"):
		$AnimatedSprite.animation = "destroy";
		speed = 0;



###Function to detect when a animation is finished###
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "destroy":
		queue_free()
