extends Sprite2D

@onready var original_position_y = self.position.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(self.position.y != original_position_y):
		self.position.y = lerpf(self.position.y, original_position_y, 1 * delta)
