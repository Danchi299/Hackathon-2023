extends ProgressBar

onready var Level = get_node("Level")

func _ready():
	pass

func _process(delta):
	Level.text = String(self.value)
