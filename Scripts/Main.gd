extends Node

#onready var bg_Shop = get_node("Backgrounds/Shop")
onready var bg_Map  = get_node("Backgrounds/Map")
onready var bg_b1   = get_node("Backgrounds/Battle1")
onready var bg_b2   = get_node("Backgrounds/Battle2")
onready var bg_b3   = get_node("Backgrounds/Battle3")
onready var bg_b4   = get_node("Backgrounds/Battle4")
onready var bg_b5   = get_node("Backgrounds/Battle5")
onready var Quest_list  = get_node("Quest_List")
onready var backgrounds = [bg_Map, bg_b1, bg_b2, bg_b3, bg_b4, bg_b5, Quest_list]

onready var back_arrow = get_node("Move/Back")
onready var Battle1_go = get_node("Move/Battle1")
onready var Battle2_go = get_node("Move/Battle2")
onready var Battle3_go = get_node("Move/Battle3")
onready var Battle4_go = get_node("Move/Battle4")
onready var Battle5_go = get_node("Move/Battle5")

onready var  B1_Moves = []
onready var  B2_Moves = []
onready var  B3_Moves = []
onready var  B4_Moves = []
onready var  B5_Moves = []
onready var Map_Moves = [back_arrow, Battle1_go, Battle2_go, Battle3_go, Battle4_go, Battle5_go]
onready var All_Moves = Map_Moves

onready var Str_node = get_node("Skills/Str_Bar")
onready var Int_node = get_node("Skills/Int_Bar")
onready var Cha_node = get_node("Skills/Cha_Bar")


onready var Character = get_node("Character")
onready var Money     = get_node("Money/Money_count/Count")

onready var Stat_List = {
	'Str': Str_node,
	'Int': Int_node,
	'Cha': Cha_node
}
onready var Stat_Levels = {
	'Str': Str_node.value,
	'Int': Int_node.value,
	'Cha': Cha_node.value
}

var Level_Names = {
	'Quests' : 'Quest List',
	'Map'    : 'Map',
	'Battle1': 'Forest',
	'Battle2': 'Mountain',
	'Battle3': 'Quarry',
	'Battle4': 'Museum',
	'Battle5': 'City'
}

var state      = '' 
var last_state = 'Map'
var map_level  =  0

func change_state(new_state):
	
	if state == new_state: return 0
	state = new_state
	#print('Last: %s\nCurrent: %s\nNew: %s\n' % [last_state, state, new_state])
	for node in backgrounds: node.hide()
	for node in All_Moves:   node.hide()
	
	match new_state:
		'Battle1': bg_b1.show()
		'Battle2': bg_b2.show()
		'Battle3': bg_b3.show()
		'Battle4': bg_b4.show()
		'Battle5': bg_b5.show()
		'Quests':  
			Quest_list.show()
		'Map':
			bg_Map.show()
			for node in Map_Moves: node.show()
			back_arrow.hide()
	
	
# warning-ignore:standalone_ternary
	(back_arrow.hide() if new_state in ['Map', 'Quests'] else back_arrow.show())
# warning-ignore:standalone_ternary
	( Character.hide() if new_state in [       'Quests'] else  Character.show())

func Upgrade_Stat(stat):
	var node  = Stat_List[stat]
	if Money.value < 1: return 0
	Money.value +=  -1 
	
	node.value += 1  
	Stat_Levels[stat] = node.value

func Complete_Quest(number):
	if Quest_list.Complete[number]: return 0
	Quest_list.Complete[number] = 1
	Money.value += 2

func Stat_Button(type):
	
	var skill_level = Stat_Levels[type]
	
	match state:
		'Shop': return 0
		'Map': Upgrade_Stat(type)
		
		'Battle1': match type: # Forest
			'Str': pass # Try to dig
			'Int': Complete_Quest(2) #
			'Cha': pass # Talk to person
			
		'Battle2': match type: # Mountain
			'Str': pass # Dig Diamonds
			'Int': pass # Find Diamonds
			'Cha': if Cha_node.value >= 2: Complete_Quest(4) #
			
		'Battle3': match type: # Quarry
			'Str': if Str_node.value >= 2: Complete_Quest(0) # Dig Diamonds
			'Int': pass # Analyze Equipmnet
			'Cha': pass # Talk to Workers
			
		'Battle4': match type: # Museum
			'Str': pass # 
			'Int': pass # 
			'Cha': pass # Talk to Guide
			
		'Battle5': match type: # Village
			'Str': pass # 
			'Int': if Int_node.value >= 2: Complete_Quest(3) # Get info on City
			'Cha': Complete_Quest(1) # Ask random people
	
	print('Used %s %s in %s!' % [type, skill_level, Level_Names[state] ])

func talk(textbox, text):
		textbox.text = text
		#add some show hide, buttons, texting

func _ready():
	change_state('Map')

func _on_Str_pressed(): Stat_Button('Str')
func _on_Int_pressed(): Stat_Button('Int')
func _on_Cha_pressed(): Stat_Button('Cha')

func _on_Battle1_pressed(): change_state('Battle1')
func _on_Battle2_pressed(): change_state('Battle2')
func _on_Battle3_pressed(): change_state('Battle3')
func _on_Battle4_pressed(): change_state('Battle4')
func _on_Battle5_pressed(): change_state('Battle5')

func _on_Back_pressed(): change_state('Map')

func _on_quest_pressed():
	
	if (state != 'Quests'):
		last_state = state  
		return change_state('Quests')
					   
	change_state(last_state)
