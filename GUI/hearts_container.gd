extends HBoxContainer

const HEART_GUI = preload("res://GUI/heart_gui.tscn")


func maxHearts(max: int):
	for i in range(max):
		var heart = HEART_GUI.instantiate()
		add_child(heart)

func updateHearts(currentHealth):
	var hearts = get_children()
	
	for i in range(currentHealth):
		hearts[i].update(false)

	for i in range(currentHealth, hearts.size()):
		hearts[i].update(true)
