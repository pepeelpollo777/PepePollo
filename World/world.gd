extends Node2D
@onready var hearths_container = $CanvasLayer/HeartsContainer
@onready var player = $TileMap/Player


func _ready():
	hearths_container.maxHearts(player.maxHealt)
	hearths_container.updateHearts(player.currentHealt)
	player.healthChange.connect(hearths_container.updateHearts)


func _on_inventory_gui_opened():
	get_tree().paused = true


func _on_inventory_gui_closed():
	get_tree().paused = false
