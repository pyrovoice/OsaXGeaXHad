extends Control
class_name CharacterInfoUI

@onready var energy_text:Label = $energyText
@onready var ally = $"../../Ally"

var char: Character = null

func _ready():
	init(ally)
	
func init(_char: Character):
	char = _char
	
func _process(delta: float):
	if !char:
		return
	energy_text.text = "Energy: " + str(char.data.actionPointCurrent) + "/" +  str(char.data.actionPointMax)
