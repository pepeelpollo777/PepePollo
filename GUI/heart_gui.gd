extends Panel
@onready var heart = $Heart


func update(whole: bool):
	if whole:
		heart.frame = 0
	else:
		heart.frame = 4
