extends RichTextLabel

@onready var Time_Left = $"../../Time_Left"
@onready var original_size = get_theme_font_size("normal_font_size")
@onready var Font_Size = get_theme_font_size("normal_font_size")

@export var change_size_multiplier : float = 1.2

@onready var previous_time = Time_Left
@onready var RaySprite = $"../Ray-time"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Time_Left):
		self.text = str(floor(Time_Left.time_left))
		#Trigger death when timer runs out
		if(Time_Left.time_left <= 0): get_node("../../Player").On_Death()
		
		if(str(self.text) != str(previous_time) ):
			previous_time = self.text
			add_theme_font_size_override("normal_font_size", 10)
			Font_Size = original_size * change_size_multiplier
			if(RaySprite): RaySprite.position.y += 3
			
	
	Font_Size = lerpf(Font_Size, original_size, 5  * delta)
	
	#Apply font change
	if(get_theme_font_size("normal_font_size") != Font_Size): add_theme_font_size_override("normal_font_size", Font_Size)
	
