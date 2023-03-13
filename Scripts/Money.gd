extends Label

onready var Level = get_node("Count")

func _ready():
	pass

func _process(delta):
	self.text = String(Level.value)
