extends Control

var inputDir = DirAccess.open("res://Input")
@onready var textBox = $"PanelContainer/MarginContainer/VBoxContainer/Text"
@onready var buttons = $"PanelContainer/MarginContainer/VBoxContainer/Buttons"
func _ready():
	if inputDir.get_files().size() == 0:
		textBox.text = "There are no files in Input"
		await createButtons("exit")
	else:
		for file in inputDir.get_files():
			if file.right(3) == "csv":
				files.append(file)
		fileSelection()
		await createButtons('fileSelect')

var selectedFile = 0
var files = []
func fileSelection():
	for file in files:
		if files.find(file) == selectedFile:
			textBox.text += "> "
		textBox.text += file + '\n'

func createButtons(function):
	var button = preload("res://interface_button.tscn")
	for node in buttons.get_children():
		node.queue_free()
	await get_tree().create_timer(.2)
	var buttonList = []
	match function:
		"exit": 
			buttonList = ['Exit']
		"fileSelect":
			buttonList = ['Next','Confirm']
		"CSVComplete":
			buttonList = ['Export','Preview']
		_: push_error("Invalid Function Name: "+function)
	for i in buttonList:
		var buttonNode = button.instantiate()
		buttonNode.find_child("Label").text = i
		buttonNode.name = i
		buttonNode.pressed.connect(buttonNode)
		buttons.add_child(buttonNode)


func buttonPressed(button):
	match button.name:
		"Exit": get_tree().quit()
		"Next": selectedFile = (selectedFile + 1) % files.size(); fileSelection()
		"Confirm": 
			textBox.text = "Creating CSV(s)... This may take a minute."
			await get_tree().create_timer(.2)
			CSV.generateCSVs(files[selectedFile])
			textBox.text = "CSV(s) Complete. Export them, or preview them first."
			createButtons("CSVComplete")
		"Export":
			CSV.exportCSVs()
		"Preview":
			get_tree().change_scene_to_file("res://preview.tscn")
		_: push_error("Invalid Button Name: "+button.name)
