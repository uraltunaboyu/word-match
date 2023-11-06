extends VBoxContainer

func shuffle_contents():
	var children = get_children().duplicate()
	for i in range(children.size()):
		var random_index = randi() % children.size()
		var temp = children[i]
		children[i] = children[random_index]
		children[random_index] = temp
		
	for child in children:
		remove_child(child)
		add_child(child)
