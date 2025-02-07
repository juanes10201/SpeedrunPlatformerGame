extends CharacterBody2D
	
func enemy_jump():
	pass

#region Variable defining
enum Sides{
	LEFT,
	RIGHT,
	NONE,
	UP
}

var Sliding: Sides = Sides.NONE
var WasSliding : bool = false
var Slide : bool = false

var GroundSmash : bool = false
var PressingGroundSmash : bool = false

var WallJump : bool = false
var WallJumpSide: Sides = Sides.NONE
var WallJumpPreviousSide : Sides = Sides.NONE

var Speed = Vector2(10, 1)
var Acc = Vector2(500, 1)
var MaxAcc = Vector2(12000, 400)

var Dashed : bool = false
var DashAcc = Vector2(600, 400)
var DashMove = Vector2(0, 0) 

#@export var JUMP_VELOCITY = -350.0
@export var WallJumpVelocity : float = 7000.0

@export var JumpCancelAcc : float = 25.0
@export var GroundSmashAcc : float = 25000.0

var LastDirection : float = 0
var direction := Input.get_axis("ui_left", "ui_right")

@export var SlideVelocity = 600

@onready var DashTime = $DashTime
@onready var PreJumpTime = $PreJumpTime
@onready var CoyoteTimer = $CoyoteTimer
@onready var Sprite = $Sprite2D
@onready var EnemyGroundSlamTimer = $EnemyGroundSlamTimer
@onready var PreWallJumpTimer = $PreWallJumpTimer

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var was_on_floor : bool = true

#endregion

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F2:
			get_tree().reload_current_scene()

func _ready() -> void:
	pass


#region Physics proccess
func _physics_process(delta: float) -> void:
	WasSliding = false
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if(direction):
		Sprite.play("Walking")
	else: Sprite.play("Idle")
	
	if(is_on_floor() && was_on_floor == false):
		strech_size(1.7, 0.5)
		#if(GroundSmash): FrameFreeze(0.05, 0.5)
	
	_strech_tick(delta)
	_physics_apply_gravity(delta)
	_physics_jump(delta)
	_physics_h_movement(delta)
	_physics_dash(delta)
	_physics_slide_and_groundsmash(delta)
	_physics_walljump(delta)

	#region Apply horizontal movement
	# Update velocity based on Speed and Dash status
	if(DashTime.is_stopped()): velocity.x = Speed.x*delta
	else: velocity.x = DashMove.x
	#endregion
	
	#region Prevent overflow
	if(Acc.x > MaxAcc.x): Acc.x = MaxAcc.x
	if(velocity.y > MaxAcc.y && !GroundSmash): velocity.y = MaxAcc.y
	#endregion
	
	#region Set direction
	#Sprite direction
	Sprite.flip_h = false if LastDirection >= 0 else true
	$Wallchecker.rotation_degrees = 90 if LastDirection < 0 else -90
	#endregion
	
	#region Apply movement	
	if(direction != 0): LastDirection = direction
	
	was_on_floor = is_on_floor()
	
	# Move the character
	move_and_slide()
	#endregion
	
	
	
	#region Destructible walls w slide
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		# Check if the collider is a destructible wall
		if (collider.is_in_group("destructible_walls_slide")):
			# Check the wall's Sliding variable
			if Slide:
				collider.destroy()  # Call the wall's destroy method
		#if (collider.is_in_group("Sand") && collider.get_collider().can_be_pushed):
		#	collider.get_collider().apply_central_impulse(-collider.get_normal * collider.get_collider().push_force)
	#endregion
#endregion

#region Gravity
func _physics_apply_gravity(delta: float) -> void:
	if (!is_on_floor()):
		if(was_on_floor): CoyoteTimer.start()
		if(!WallJump && DashTime.is_stopped()):
			velocity.y += get_gravity_player() * Acc.y * delta
			if(!WallJump):
				if(velocity.y < 0): strech_size(0.7, 1.3)
				elif(velocity.y >= MaxAcc.y): strech_size(0.5, 1.7)
		#else: velocity.y += Speed.y * delta
	if (is_on_floor()):
		Dashed = false
		if(GroundSmash):
			GroundSmash = false
			enemy_jump()
			EnemyGroundSlamTimer.start()
		if(Sliding == Sides.UP):
			Sliding = Sides.NONE
			Slide = false
#endregion

#region jump
func _physics_jump(delta: float) -> void:
	# Handle jump.
	if ((!PreJumpTime.is_stopped() && (is_on_floor() || WallJump || !CoyoteTimer.is_stopped()) ) || (!PreWallJumpTimer.is_stopped() && Input.is_action_pressed("player_jump")) ):
		if(Sliding != Sides.NONE):
			Sliding = Sides.UP
			Speed.x = Acc.x*2 if LastDirection >= 0 else Acc.x*-2 
		velocity.y = jump_velocity
		Controller_Vibrate_Player_Movement(0.2)
		#region WallJump case
		if(WallJump || !PreWallJumpTimer.is_stopped()):
			Speed.x = WallJumpVelocity*-1 if WallJumpPreviousSide == Sides.RIGHT else WallJumpVelocity
			PreWallJumpTimer.stop()
			velocity.y -= 50
		#endregion
	
	#Cancel jump
	if(velocity.y < 0 && !Input.is_action_pressed("player_jump")):
		velocity.y += JumpCancelAcc
	
	if(Input.is_action_pressed("player_jump")): PreJumpTime.start()
	
	#Pre-detect jump
#endregion

#region Horizontal movement
func _physics_h_movement(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	# Fix the Movement Speed accumulating in the side touching a wall
	if(WallJump && WallJumpSide == Sides.RIGHT && Speed.x > 0): Speed.x = 0
	if(WallJump && WallJumpSide == Sides.LEFT && Speed.x < 0): Speed.x = 0
	
	# Get the input direction and handle the movement/deceleration.
	if (!WallJump && direction && Speed.x < MaxAcc.x && Speed.x > MaxAcc.x*-1):
		if((direction > 0 && Speed.x < 0) || (direction < 0 && Speed.x > 0)): Speed.x += Acc.x * direction
		#Move faster if coming from Walljump
		if((WallJumpPreviousSide == Sides.LEFT && direction < 0) || (WallJumpPreviousSide == Sides.RIGHT && direction > 0) && !PreWallJumpTimer.is_stopped()): Speed.x += Acc.x * direction *2
		
		Speed.x += Acc.x * direction  # Adjust speed based on input direction
	else:
		if(Speed.x > 0): Speed.x -= Acc.x
		if(Speed.x < 0): Speed.x += Acc.x
#endregion

#region Slide and Ground Smash
func _physics_slide_and_groundsmash(delta: float) -> void:
	if((Input.is_action_pressed("player_slide") || PressingGroundSmash)):
		#Groundsmash
		if(!is_on_floor() && !Slide && (Sliding != Sides.UP) ):# || velocity.y < jump_height+10)):
			velocity.y = SlideVelocity
			GroundSmash = true
			PressingGroundSmash = true
			set_collision_mask_value(4, false)
		#Slide
		elif(Sliding != Sides.UP && !PressingGroundSmash):
			Controller_Vibrate_Player_Movement(0.2)
			Speed.x = GroundSmashAcc if Sliding == Sides.RIGHT else GroundSmashAcc * -1
			if(Sliding == Sides.NONE): Sliding = Sides.RIGHT if LastDirection > 0  else Sides.LEFT
			Slide = true
			strech_size(1, .6)
			set_collision_mask_value(3, false)
	elif(Sliding != Sides.NONE):
		#strech_size(1, 1)
		#Speed.x -= Acc.x * LastDirection
		#if((Speed.x <= 250 && Speed.x > 0) || (Speed.x >= -250 && Speed.x < 0)):
		Sliding = Sides.NONE
		Slide = false
		if(Sliding != Sides.UP): Speed.x = 0
	#if(Sliding == Sides.UP):
		#strech_size(1, 1)
	if(!Slide): set_collision_mask_value(3, true)
	if(!GroundSmash): set_collision_mask_value(4, true)
	if(!Input.is_action_pressed("player_slide") && is_on_floor() ):
		PressingGroundSmash = false
	
	#endregion

#region Dash
func _physics_dash(delta: float) -> void:
	#Dash
	if(Input.is_action_just_pressed("player_dash") && !Dashed):
		Dashed = true
		strech_size(2, 0.5)
		DashTime.start()
		DashMove = DashAcc * LastDirection
		Controller_Vibrate_Player_Movement(0.7)
	#Dash movement
	if(DashTime.is_stopped()):
		if(DashMove.x > 250): DashMove.x -= Acc.x * LastDirection 
		else: DashMove.x = 0
		if(DashMove.y > 250): DashMove.y -= Acc.y * LastDirection
		else: DashMove.y = 0
	#When dashing suspend in air
	else: velocity.y = 0
#endregion

#region WallJump
func _physics_walljump(delta: float) -> void:
	#The idea is to mantain some vertical movement, but still be able to jump more than before, like SuperMeatBoy
	var direction := Input.get_axis("ui_left", "ui_right")
	if(is_near_wall() && direction):
		Dashed = false
		velocity.y += 50*delta
		if(!WallJump): velocity.y = 50
		WallJump = true
		if(direction > 0):
			WallJumpSide = Sides.RIGHT
			if(WallJumpPreviousSide == Sides.NONE): WallJumpPreviousSide = Sides.RIGHT
		else:
			WallJumpSide = Sides.LEFT
			if(WallJumpPreviousSide == Sides.NONE):  WallJumpPreviousSide = Sides.LEFT
	else:
		if(WallJump):
			PreWallJumpTimer.start()
			print("boing")
		if(PreWallJumpTimer.is_stopped()): WallJumpPreviousSide = Sides.NONE
		WallJump = false
	#endregion
	
func Controller_Vibrate_Player_Movement(Force):
	Input.start_joy_vibration(0, 0.3 * Force, 0.4 * Force, 0.2)
	
@onready var original_scale = Sprite.scale
func strech_size(X, Y):
	Sprite.scale = Vector2(original_scale.x*X, original_scale.y*Y)

func _strech_tick(delta : float):
	Sprite.scale.x += (original_scale.x - Sprite.scale.x) * 20 * delta
	Sprite.scale.y += (original_scale.y - Sprite.scale.y) * 20 * delta

func get_gravity_player() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func On_Death():
	#FrameFreeze(0.05, 0.7)
	get_tree().reload_current_scene() 

var FrameFreezeEnabled : bool = false

func FrameFreeze(TimeScale, duration):
	if(!FrameFreezeEnabled):
		FrameFreezeEnabled = true
		Engine.time_scale = TimeScale
		await(get_tree().create_timer(duration * TimeScale).timeout)
		Engine.time_scale = 1
		FrameFreezeEnabled = false

#region Wall Checker
func is_near_wall() -> bool:
	return $Wallchecker.is_colliding()
#endregion
