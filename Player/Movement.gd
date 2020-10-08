extends KinematicBody2D

var Velocity = Vector2()
var MaxSpeed = 200
var Gravity = 15
var Friction = 1.0
var Speed = 100
var Jump = 300
onready var was_on_floor = is_on_floor()

func PlaySound(SoundName):
	var Sound = get_node(SoundName)
	randomize()
	Sound.pitch_scale = rand_range(0.75,1.25)
	Sound.play()

func _physics_process(_delta):
	
	if not is_on_floor():
		Velocity.y += Gravity
	else:
		if not Velocity.y <= 15:
			PlaySound("HitGround")
		Velocity.y = 0
		
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		Velocity.y = -Jump
		PlaySound("Jump")
	
	if Input.is_action_pressed("Left"):
		Velocity.x -= Speed
		Velocity.x = min(-Velocity.x,-MaxSpeed)
	elif Input.is_action_pressed("Right"):
		Velocity.x += Speed
		Velocity.x = min(Velocity.x,MaxSpeed)
	else:
		Velocity.x = lerp(Velocity.x,0,Friction*0.2)
	 
	was_on_floor = is_on_floor()
	
	move_and_slide(Velocity,Vector2(0,-1))

func _on_VisibilityNotifier2D_screen_exited():
	var VS = get_viewport().size
	
	if position.x < 0:
		position.x = VS.x
	elif position.x > VS.x:
		position.x = 0
	if position.y < 0:
		position.y = VS.y
	elif position.y > VS.y:
		position.y = 0
		
	PlaySound("ScreenWrap")
