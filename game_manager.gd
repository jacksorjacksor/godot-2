extends Node2D
var btn: Button
export(ButtonGroup) var group

var counter: int = 0
var current_player_score: String = ""
var high_score: int = 0
var game_over: bool = false
var all_buttons: Array

var parks_and_rec_checker: String = ""
var parks_and_rec_required: String = "parksandrec"

onready var user_answer_display = self.get_node("user_answer_display")
onready var required_answer_display = self.get_node("required_answer_display")
onready var high_score_display = self.get_node("high_score_display")

# Called when the node enters the scene tree for the first time.
func _ready():
	all_buttons = group.get_buttons()
	# Defines button group
	for i in all_buttons:
		i.connect("pressed", self, "button_pressed")
	restart_the_game()
	high_score_checker()
				

# mouse click version
func button_pressed():
	btn = group.get_pressed_button()
	if user_answer_display.bbcode_text in ["Hello!","Delete!", "ENTER!"]:
		user_answer_display.bbcode_text=""
	if game_over:
		match btn.text:
			"ENTER":
				restart_the_game()				
	else:
		match btn.text:
			"1","2","3","4","5","6","7","8","9","0":
				current_player_score += btn.text
				user_answer_display.bbcode_text = "[right]%s[/right]" % current_player_score
				$audio_manager.play_sound($audio_manager.keyclick_sounds)
			"F":
				current_player_score += "Fizz"
				user_answer_display.bbcode_text = "[right]%s[/right]" % current_player_score
				$audio_manager.play_sound($audio_manager.keyclick_sounds)				
			"B":
				current_player_score += "Buzz"
				user_answer_display.bbcode_text = "[right]%s[/right]" % current_player_score
				$audio_manager.play_sound($audio_manager.keyclick_sounds)				
			"DEL":
				current_player_score = ""
				user_answer_display.bbcode_text = ""
				$audio_manager.play_sound($audio_manager.delete_sounds)
			"ENTER":
				if user_answer_display.bbcode_text != "":	# Only check if user has answered
					result_checker(fizz_buzz_checker(counter+1))
#			"P","A","R","K","S","N","D","E","C":
#				pass
			_:
				user_answer_display.bbcode_text = "Unsure..."

func fizz_buzz_checker(check_counter: int):
	if check_counter%3==0 and check_counter%5==0:
		return "FizzBuzz"
	elif check_counter%3==0:
		return "Fizz"
	elif check_counter%5==0:
		return "Buzz"
	else:
		return str(check_counter)
		
func result_checker(required_answer: String):
	# Correct answer
	if current_player_score == required_answer:
		$audio_manager.play_sound($audio_manager.victory_sounds)
		$audio_manager.dragon_counting_player(counter)			
		counter += 1
		if counter == 30:
			required_answer_display.text = "YOU WIN!!!  Press ENTER to restart"
			game_over_state()
		current_player_score = ""
		required_answer_display.text = str(counter)
		user_answer_display.bbcode_text = ""
	# Wrong answer
	else:
		required_answer_display.text = "OH NO!!! Press ENTER to restart"
		user_answer_display.bbcode_text = "[right]%s [s]%s[/s][/right]" % [fizz_buzz_checker(counter+1), current_player_score]
		$audio_manager.play_sound($audio_manager.defeat_sounds)	
		$audio_manager.dragon_no_player()
		game_over_state()

func game_over_state():
	disable_all_buttons_except_enter()
	high_score_checker()
	game_over = true


func high_score_checker():
	if counter >= high_score:
		high_score = counter
		high_score_display.bbcode_text = "[right]"+str(high_score)+"/30[/right]"
		# New high score?

func restart_the_game():
	# Sets counter
	counter = 0
	required_answer_display.text = str(counter)
	current_player_score=""
	user_answer_display.bbcode_text=current_player_score
	game_over = false
	enable_all_buttons()
	$audio_manager.dragon_begin()
	
func disable_all_buttons_except_enter():
	for btn in all_buttons:
		if btn.name != "btn_enter":
			btn.disabled = true

func enable_all_buttons():
	for btn in all_buttons:
		btn.disabled = false

func _input(event):
	if event.is_action_pressed("p") or event.is_action_pressed("a") or event.is_action_pressed("r") or event.is_action_pressed("k") or event.is_action_pressed("s") or event.is_action_pressed("n") or event.is_action_pressed("d") or event.is_action_pressed("e") or event.is_action_pressed("c"):
		match parks_and_rec_checker.length():
			0:
				parks_and_rec_match_checker(event, "p")
			1:
				parks_and_rec_match_checker(event, "a")
			2:
				parks_and_rec_match_checker(event, "r")
			3:
				parks_and_rec_match_checker(event, "k")
			4:
				parks_and_rec_match_checker(event, "s")
			5:
				parks_and_rec_match_checker(event, "a")
			6:
				parks_and_rec_match_checker(event, "n")
			7:
				parks_and_rec_match_checker(event, "d")
			8:
				parks_and_rec_match_checker(event, "r")
			9:
				parks_and_rec_match_checker(event, "e")
			10: 
				parks_and_rec_match_checker(event, "c")

	
	# match event.is_action_pressed(["P","A","R","K","S","N","D","E","C"]):

func parks_and_rec_match_checker(event, action_name:String):
	if event.is_action_pressed(action_name):
		parks_and_rec_checker += action_name
		if parks_and_rec_checker.length() == 11:
			bobby_newport()
	else:
		parks_and_rec_checker = ""	



# Parks and rec
func bobby_newport():
	$audio_manager.dragon_bobby_newport()

