extends RigidBody2D

#@onready var Collision = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.set_deferred("sleeping", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@export var MAX_SPEED : float = 300.0  # Set your desired max speed

func _integrate_forces(state):
	var velocity = state.linear_velocity
	var speed = velocity.length()
	
	if (speed > MAX_SPEED):
		state.linear_velocity = velocity.normalized() * MAX_SPEED
