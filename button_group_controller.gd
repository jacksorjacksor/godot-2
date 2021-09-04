extends Node2D
var btn: Button
export(ButtonGroup) var group
var counter: int = 0
var high_score: int = 0
var game_over: bool = false

onready var user_answer_display = self.get_node("user_answer_display")
onready var required_answer_display = self.get_node("required_answer_display")
onready var high_score_display = self.get_node("high_score_display")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Defines button group
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")
	restart_the_game()
	high_score_checker()
		
func button_pressed():
	btn = group.get_pressed_button()
	if user_answer_display.text in ["Hello!","Delete!", "ENTER!"]:
		user_answer_display.text=""
	if game_over:
		match btn.text:
			"ENTER":
				restart_the_game()				
	else:
		match btn.text:
			"1","2","3","4","5","6","7","8","9","0":
				user_answer_display.text += btn.text
			"F":
				user_answer_display.text += "Fizz"
			"B":
				user_answer_display.text += "Buzz"
			"DEL":
				user_answer_display.text = "Delete!"
			"ENTER":
				if user_answer_display.text != "":	# Only check if user has answered
					result_checker(user_answer_display.text, fizz_buzz_checker(counter+1))
			_:
				user_answer_display.text = "Unsure..."


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
	if user_answer == required_answer:
		counter += 1
		required_answer_display.text = str(counter)
		user_answer_display.text = ""
	else:
		required_answer_display.text = "OH NO!!! Press ENTER to restart"
		high_score_checker()
		game_over = true

func high_score_checker():
	if counter >= high_score:
		high_score = counter
		high_score_display.text = str(high_score)
		# New high score?

func restart_the_game():
	# Sets counter
	counter = 0
	required_answer_display.text = str(counter)
	user_answer_display.text=""
	game_over = false
	
	
#
