extends AnimatedSprite

var speedometer : float = 0;
var accelerometer : float = 0;

###Process Function###
func _physics_process(delta):
	speedometer = get_parent().speed;
	accelerometer = get_parent().rotationSpeed;
	if speedometer < 0:
		speedometer = speedometer * -1;
	animateSpeedometer();
	animateAccelerometer();



###Func to animate the accelerometer###
func animateAccelerometer():
	if accelerometer < 4 and accelerometer > 2:
		$Accelerometer.animation = "R3";
	elif accelerometer <= 2 and accelerometer > 1:
		$Accelerometer.animation = "R2";
	elif accelerometer <= 1 and accelerometer > 0:
		$Accelerometer.animation = "R1";
	elif accelerometer > -4 and accelerometer < -2:
		$Accelerometer.animation = "L3";
	elif accelerometer >= -2 and accelerometer < -1:
		$Accelerometer.animation = "L2";
	elif accelerometer >= -1 and accelerometer < 0:
		$Accelerometer.animation = "L1";
	else:
		$Accelerometer.animation = "default";



###Func to animate the speedometer###
func animateSpeedometer():
	if speedometer <= 400 and speedometer >= 395:
		$".".animation = "400";
	elif speedometer < 395 and speedometer >= 375:
		$".".animation = "375";
	elif speedometer < 375 and speedometer >= 350:
		$".".animation = "350";
	elif speedometer < 350 and speedometer >= 325:
		$".".animation = "325";
	elif speedometer < 325 and speedometer >= 300:
		$".".animation = "300";
	elif speedometer < 300 and speedometer >= 275:
		$".".animation = "275";
	elif speedometer < 275 and speedometer >= 250:
		$".".animation = "250";
	elif speedometer < 250 and speedometer >= 225:
		$".".animation = "225";
	elif speedometer < 225 and speedometer >= 200:
		$".".animation = "200";
	elif speedometer < 200 and speedometer >= 175:
		$".".animation = "175";
	elif speedometer < 175 and speedometer >= 150:
		$".".animation = "150";
	elif speedometer < 150 and speedometer >= 125:
		$".".animation = "125";
	elif speedometer < 125 and speedometer >= 100:
		$".".animation = "100";
	elif speedometer < 100 and speedometer >= 75:
		$".".animation = "75";
	elif speedometer < 75 and speedometer >= 50:
		$".".animation = "50";
	elif speedometer < 50 and speedometer >= 25:
		$".".animation = "25";
	else:
		$".".animation = "default";
