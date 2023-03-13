extends Popup


var tasks    = []
var Complete = []
var rng = RandomNumberGenerator.new()

var possible_tasks = [
	'Исследовать Карьер'
]

onready var Text_Node = get_node('Text')

func _ready():
	var date = OS.get_date()
	rng.seed = int('%s%s%s' % [date.day, date.month, date.year])
	
	var x = rng.randf_range(-10.0, 10.0)
	
	tasks = ['Раскопать Карьер', 'Распросить Людей в Деревне', 'Исследовать Лес', 'Исследовать Город', 'Поговорить с Городом']
	
	for i in len(tasks):
		Complete.append(0)
	
func _on_Quest_visibility_changed():
	var text = 'Задания\n '
	
	for i in len(tasks):
		if not Complete[i]:
			text += '%s.%s\n' % [i+1, tasks[i]]
	Text_Node.text = text
	#print('Complete: %s\nChecked: %s' % [Complete, Checked])
