extends CharacterBody2D

#region Setup variables
@export var Enemy_burst_speed : float = 300.0
@export var SPEED : float = 150.0
@export var JUMP_VELOCITY : float = -370.0
@export var SPECIAL_ENEMY_JUMP_VELOCITY : float = -50.0
@export var MAX_FALL_SPEED : float = 300.0
@export var MAX_SPEED : float = 500.0
@export var Cancel_speed : float = 200.0
@export var Max_groundsmash_distance = 300.0

#For editor
enum Directions{
	RIGHT,
	LEFT,
	NONE
}

@export var EnemyDirection = Directions.RIGHT
@export var distance : float = 100
@export var enemy_type : float = 0

var OriginalX : float = position.x

var Move : bool = true

var direction = 0 

@onready var Player = $"../Player"
@onready var MoveTimer = $"MoveTimer"
@onready var Sprite = $"Sprite2D"

var was_on_floor : bool = false
var was_on_wall : bool = false

#endregion

#region Jumping
func _jump(_jump_velocity) -> void:
	#The idea is for the enemies to jump when the player does a ground-smash
	if(is_on_floor()): velocity.y = _jump_velocity# * randf_range(1, 1.2)
#endregion

#region Player GroundSmash 
func _on_player_ground_smash_signal() -> void:
	if(is_on_floor() && global_position.distance_to(Player.position) <= Max_groundsmash_distance):
		_jump(JUMP_VELOCITY if enemy_type == 0 else SPECIAL_ENEMY_JUMP_VELOCITY)
		if(enemy_type == 0):
			#Player.FrameFreeze(0.05, 0.4)
			velocity.x = Enemy_burst_speed if Player.position.x < position.x else Enemy_burst_speed*-1
			Move = false
			Player.Controller_Vibrate_Player_Movement(1)
#endregion

#region Player Slide 
func _on_player_slide_signal() -> void:
	if(is_on_floor() && enemy_type == 0):
		#Player.FrameFreeze(0.05, 0.4)
		_jump(-400)
		velocity.x = Enemy_burst_speed if  Player.Sliding == Player.Sides.RIGHT else Enemy_burst_speed*-1
		Player.Controller_Vibrate_Player_Movement(1)
		Move = false
#endregion

func _ready():
	if(EnemyDirection == Directions.RIGHT): direction = 1
	elif(EnemyDirection == Directions.LEFT): direction = -1
	else: direction = 0

#region Physics
func _physics_process(delta: float) -> void:
	if(is_on_wall() && !was_on_wall): direction *= -1
	
	if(is_on_ceiling()): queue_free()
	
	if(velocity.y < 0): strech_size(0.7, 1.3)
	if(velocity.y >= MAX_FALL_SPEED): strech_size(0.5, 1.7)
	
	if(is_on_floor() && was_on_floor == false): strech_size(1.7, 0.5)
	
	_strech_tick(delta)
	
	
	#region Trigger Player GroundSmash
	if(Player && !Player.EnemyGroundSlamTimer.is_stopped()): _on_player_ground_smash_signal()
	#endregion
	#region Gravity
	if (!is_on_floor() &&  velocity.y < MAX_FALL_SPEED):
		velocity += get_gravity() * delta
	#endregion
	if(direction): Sprite.flip_h = false if direction >= 0 else true
	
	#region Horizontal Movement
	#Enemy Movement
	if(Move):
		if (direction && SPEED < MAX_SPEED && SPEED > MAX_SPEED*-1 && MoveTimer.is_stopped()):
			velocity.x = direction * SPEED# * randf_range(1, 1.2)
			strech_size(1.7, 0.5)
			MoveTimer.start()
		elif(!MoveTimer.is_stopped()):
			if(direction > 0): velocity.x -= Cancel_speed*delta
			elif(direction < 0): velocity.x += Cancel_speed*delta
		#if( (direction == 1 && position.x-OriginalX >= distance) || (direction == -1 && position.x-OriginalX < distance*-1) ):
		#	direction *= -1
	else:
		if(velocity.x > 0): velocity.x -= Cancel_speed*delta
		elif(velocity.x < 0): velocity.x += Cancel_speed*delta
	#endregion
	was_on_floor = is_on_floor()
	was_on_wall = is_on_wall()
	move_and_slide()
#endregion

#region Scaling
@onready var original_scale = Sprite.scale
func strech_size(X, Y):
	Sprite.scale = Vector2(original_scale.x*X, original_scale.y*Y)

func _strech_tick(delta : float):
	Sprite.scale.x += (original_scale.x - Sprite.scale.x) * 15 * delta
	Sprite.scale.y += (original_scale.y - Sprite.scale.y) * 15 * delta
#endregion

#region toggle collision
func enable_collision() -> void:
	#Enable
	set_collision_mask_value(1, true)
	set_collision_layer_value(1, true)
	
	set_collision_mask_value(2, false)
	set_collision_layer_value(2, false)

func disable_collision() -> void:
	#Disable
	set_collision_mask_value(1, false)
	set_collision_layer_value(1, false)
		
	set_collision_mask_value(2, true)
	set_collision_layer_value(2, true)

func toggle_collision() -> void:
	#Disable
	if(get_collision_mask_value(1)):
		set_collision_mask_value(1, false)
		set_collision_layer_value(1, false)
		
		set_collision_mask_value(2, true)
		set_collision_layer_value(2, true)
	else:
		#Enable
		set_collision_mask_value(1, true)
		set_collision_layer_value(1, true)
		
		set_collision_mask_value(2, false)
		set_collision_layer_value(2, false)
#endregion
#region Check collision
func check_collision() -> bool:
	if(get_collision_mask_value(1)): return true
	else: return false
#endregion
