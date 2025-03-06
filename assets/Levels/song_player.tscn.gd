extends Node2D

@export var PlayMusic : bool = true
enum MusicStates{
	ingame,
	menu
}
var MusicState = MusicStates.ingame

@onready var SongInGame = $SongInGame
@onready var SongMenu = $SongMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_song_tick()

#region Play song
func _play_song(Song):
	if(Song && !Song.playing):
		SongInGame.stop()
		SongMenu.stop()
		Song.play()
#endregion

#region Songs

func _song_tick() -> void:
	if(PlayMusic):
		match MusicState:
			MusicStates.ingame:
				_play_song(SongInGame)
			MusicStates.menu:
				_play_song(SongMenu)
#endregion
