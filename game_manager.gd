extends Node2D
var btn: Button
export(ButtonGroup) var group

var counter: int = 0
var current_player_score: String = ""
var high_score: int = 0
var game_over: bool = false
var all_buttons: Array

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
				$audio_manager/click_manager.play_sound($audio_manager/click_manager.keyclick_sounds)
			"F":
				current_player_score += "Fizz"
				user_answer_display.bbcode_text = "[right]%s[/right]" % current_player_score
				$audio_manager/click_manager.play_sound($audio_manager/click_manager.keyclick_sounds)				
			"B":
				current_player_score += "Fizz"
				user_answer_display.bbcode_text = "[right]%s[/right]" % current_player_score
				$audio_manager/click_manager.play_sound($audio_manager/click_manager.keyclick_sounds)				
			"DEL":
				current_player_score = ""
				user_answer_display.bbcode_text = ""
				$audio_manager/click_manager.play_sound($audio_manager/click_manager.delete_sounds)
			"ENTER":
				if user_answer_display.bbcode_text != "":	# Only check if user has answered
					result_checker(user_answer_display.bbcode_text, fizz_buzz_checker(counter+1))
			_:
				user_answer_display.bbcode_text = "Unsure..."


func fizz_buzz_checker(check_counter: int):
	# Takes in an int
	# Returns a string
	# Yes, check_counter is just counter+1
	if check_counter%3==0 and check_counter%5==0:
		return "FizzBuzz"
	elif check_counter%3==0:
		return "Fizz"
	elif check_counter%5==0:
		return "Buzz"
	else:
		return str(check_counter)
		
func result_checker(user_answer: String, required_answer: String):
	# Correct answer
	if user_answer == required_answer:
		$audio_manager/click_manager.play_sound($audio_manager/click_manager.victory_sounds)				
		counter += 1
		current_player_score = ""
		required_answer_display.text = str(counter)
		user_answer_display.bbcode_text = ""
	# Wrong answer
	else:
		disable_all_buttons_except_enter()
		required_answer_display.text = "OH NO!!! Press ENTER to restart"
		$audio_manager/click_manager.play_sound($audio_manager/click_manager.defeat_sounds)				
		high_score_checker()
		game_over = true

func high_score_checker():
	if counter >= high_score:
		high_score = counter
		high_score_display.bbcode_text = "[right]"+str(high_score)+"[/right]"
		# New high score?

func restart_the_game():
	# Sets counter
	counter = 0
	required_answer_display.text = str(counter)
	current_player_score=""
	user_answer_display.bbcode_text=current_player_score
	game_over = false
	enable_all_buttons()
	
func disable_all_buttons_except_enter():
	for btn in all_buttons:
		if btn.name != "btn_enter":
			btn.disabled = true

func enable_all_buttons():
	for btn in all_buttons:
		btn.disabled = false
		
# func score_always_on_right(score: String):
#	return "[right]%s[/right]" % score
