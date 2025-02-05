extends RigidBody2D

@export var can_be_pushed : bool = false
@export var push_force : float = 80.0

@onready var SandTimer = $SandTimer
var CalledTimer : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_deferred("freeze", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(CalledTimer && SandTimer.is_stopped):
		set_deferred("freeze", false)
		self.set_deferred("sleeping", false)
		CalledTimer = false

@export var MAX_SPEED : float = 300.0  # Set your desired max speed

func _integrate_forces(state):
	var velocity = state.linear_velocity
	var speed = velocity.length()
	
	if (speed > MAX_SPEED):
		state.linear_velocity = velocity.normalized() * MAX_SPEED


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player") || body.is_in_group("Enemies")):
		SandTimer.start()
		CalledTimer = true
