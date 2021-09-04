extends AudioStreamPlayer2D

# onready var audio = self

var keyclick_sounds : Array
var delete_sounds : Array
var fizz_sounds : Array
var buzz_sounds : Array
var victory_sounds : Array
var defeat_sounds : Array
var audio

var sound_index: int
var sound

 
onready var keyclick_stream = $keyclick_stream # not finding it, HELP!


# ISSUE: one-shot SFX play stop one another playing (.play() vs .playOneShot in Unity)
# TODO: either find multiple channels OR make separate managers to allow 

func _ready():
	# NOTE: change these to .mp3, shorten tail length
	keyclick_sounds = [
		preload("res://audio/keyclick01.ogg"),
		preload("res://audio/keyclick02.ogg"),
		preload("res://audio/keyclick03.ogg"),
		preload("res://audio/keyclick04.ogg"),
		preload("res://audio/keyclick05.ogg"),
		preload("res://audio/keyclick06.ogg"),
		preload("res://audio/keyclick07.ogg"),
		preload("res://audio/keyclick08.ogg"),
	]
	
	# will rename files eventually!
	delete_sounds = [
		preload("res://audio/errorclick01.ogg"),
		preload("res://audio/errorclick02.ogg"),
		preload("res://audio/errorclick03.ogg"),
		preload("res://audio/errorclick04.ogg"),
		preload("res://audio/errorclick05.ogg"),
	]

	
	defeat_sounds = [
		preload("res://audio/failgong.ogg"),		
	]
	
	victory_sounds = [
		preload("res://audio/victorygong.ogg")
	]
	
func play_sound(sound_array:Array):
	if sound_array.size()>1:
		sound_index = randi() % (sound_array.size() - 1)
	else:
		sound_index = 0
	sound = sound_array[sound_index]
	
	
	match sound_array:
		keyclick_sounds, delete_sounds:
			$keyclick_stream.bus = "keyclick"
			$keyclick_stream.audio.stream = sound
			$keyclick_stream.audio.play()
		defeat_sounds, victory_sounds:
			audio = $defeat_victory_stream
			audio.bus = "defeat_victory" # make more audio sources

