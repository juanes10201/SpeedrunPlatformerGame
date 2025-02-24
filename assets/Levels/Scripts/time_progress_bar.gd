extends ProgressBar

@onready var Time_Left = $"../../Time_Left"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(Time_Left): self.max_value = Time_Left.wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Time_Left): self.value = Time_Left.time_left
