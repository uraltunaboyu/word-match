extends HBoxContainer

@onready var file = "res://words.txt"
@onready var turkish_words = $"Turkish Words"
@onready var english_words = $"English Words"
@export var red_rect: ColorRect
@export var score_text: RichTextLabel
@onready var turkish_word_buttons = ButtonGroup.new()
@onready var english_word_buttons = ButtonGroup.new()
@onready var score = 0

const QUESTION_COUNT = 9

var turkish_words_index = {}
var english_words_index = {}

func _ready():
	load_file(file)
	generate_buttons()
	
	
func create_button(word, index):
	var button = Button.new()
	button.text = word
	button.toggle_mode = true
	button.toggled.connect(_on_button_toggled.bind(button))
	return button
	
func load_file(file):
	var f = FileAccess.open(file, FileAccess.READ)
	var index = 1
	while not f.eof_reached():
		var line = f.get_line()
		if line.contains(":"):
			var english_word = line.split(":")[0].strip_edges().capitalize()
			var turkish_word = line.split(":")[1].strip_edges().capitalize()
			english_words_index[english_word] = index
			turkish_words_index[turkish_word] = index
		index += 1
	f.close()
	return
	
func generate_buttons():
	var question_count = min(turkish_words_index.size(), QUESTION_COUNT)
	var turkish_words_list = turkish_words_index.keys()
	var english_words_list = english_words_index.keys()
	
	
	for i in range(question_count):
		var random_index = randi() % turkish_words_list.size()
		var word_index = turkish_words_index[turkish_words_list[random_index]]
			
		var english_word_button = create_button(get_matching_english_word(word_index), word_index)
		english_word_button.button_group = english_word_buttons
		english_words.add_child(english_word_button)
		
		var turkish_word_button = create_button(turkish_words_list[random_index], word_index)
		turkish_word_button.button_group = turkish_word_buttons
		turkish_words.add_child(turkish_word_button)
		
		turkish_words_list.remove_at(random_index)
		english_words_list.remove_at(random_index)
		
	turkish_words.shuffle_contents()
	english_words.shuffle_contents()
		
func get_matching_english_word(word_index):
	for word in english_words_index.keys():
		if english_words_index[word] == word_index:
			return word

func _on_button_toggled(button_toggled, button):
	var chosen_turkish_word = turkish_word_buttons.get_pressed_button()
	var chosen_english_word = english_word_buttons.get_pressed_button()
	if chosen_turkish_word != null and chosen_english_word != null:
		chosen_turkish_word.button_pressed = false
		chosen_english_word.button_pressed = false
		if turkish_words_index[chosen_turkish_word.text] == english_words_index[chosen_english_word.text]:
			chosen_turkish_word.queue_free()
			chosen_english_word.queue_free()
			turkish_words_index.erase(chosen_turkish_word.text)
			english_words_index.erase(chosen_english_word.text)
			score += 1
			score_text.text = "[center][b]Points:[/b] " + str(score) + "[/center]" 
			
			if turkish_words.get_children().size() == 1:
				generate_buttons()
				
			if turkish_words_index.size() == 0:
				score_text.text = "[center][b]Congratulations![/b][/center]"
		else:
			red_rect.flash()
