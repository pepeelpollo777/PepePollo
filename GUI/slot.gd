extends Panel

@onready var bg = $BG
@onready var itemSprite = $CenterContainer/Panel/Item

func update(item: InventoryItem):
	if not item:
		bg.frame = 0
		itemSprite.visible = false
	else:
		bg.frame = 1
		itemSprite.visible = true
		itemSprite.texture = item.texture


