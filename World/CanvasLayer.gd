extends CanvasLayer

@onready var inventoryGui = $InventoryGui

func _ready():
	inventoryGui.close()

func _input(event):
	if Input.is_action_pressed("inventoryOpen"):
		if inventoryGui.isOpen:
			inventoryGui.close()
		else:
			inventoryGui.open()
