extends Area2D

###Constants###
const SPEED : int = 600;



###Process Fonction###
func _physics_process(delta):
	position += transform.x * SPEED * delta;



###Function to detect when the projectile enters a body###
func _on_Projectile_body_entered(body):
	queue_free();
