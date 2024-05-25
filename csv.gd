extends Node

var CSVs = []


func exportCSVs():
	pass

var currentLineNumber = 1
var SKUPosition
var MOPosition
var quantityPosition
func generateCSVs(fileName):
	var inputCSV = FileAccess.open("res://Input/"+fileName,FileAccess.READ)
	var MOs = {}
	while true:
		var currentLine = inputCSV.get_line()
		if currentLine == "":
			break
		currentLine = currentLine.replace('"',"")
		currentLine = currentLine.split(",")
		if currentLineNumber == 1:
			SKUPosition = currentLine.find("SKU")
			MOPosition = currentLine.find("MO #")
			quantityPosition = currentLine.find("Planned quantity")
		else:
			MOs[currentLine[MOPosition]] = {
				"SKU": currentLine[SKUPosition].split("-"),
				"quantity": currentLine[quantityPosition],
				"sort": currentLineNumber - 1
			}
		currentLineNumber += 1
	
	if MOs:
		var MSIList = []
		for key in MOs:
			if MOs[key]["SKU"].has("MSI"):
				var SKU = MOs[key]["SKU"]
				var MO = key
				var knife = "MSI"
				var material
				if SKU.has("AL"): material = "AL (Aluminum)"
				elif SKU.has("TI"): material = "TI (Titanium)"
				elif SKU.has("CU"): material = "CU (Copper)"
				elif SKU.has("BRS"): material = "BRS (Brass)"
				elif SKU.has("LEX"):
					if SKU.has("PNK"):
						material = "Pink Lexan"
					elif SKU.has("ORG"):
						material = "Orange Lexan"
					elif SKU.has("GRN"):
						material = "Green Lexan"
					elif SKU.has("ICE"):
						material = "Ice Blue Lexan"
					elif SKU.has("CLR"):
						material = 'Clear Lexan'
					elif SKU.has("SMK"):
						material = "Smoke Lexan"
					elif SKU.has("BRZ"):
						material = "Bronze Lexan"
					elif SKU.has("BLU"):
						material = "Blue Lexan"
				if not material:
					push_error("MISSING MATERIAL IN MSI: "+SKU)
				
				var texture
				if SKU.has('MM1'): texture = "MM1"
				elif SKU.has('MM2'): texture = 'MM2'
				elif SKU.has('WNG'): texture = 'Wings'
				elif SKU.has('OG1'): texture = 'OG1'
				elif SKU.has('DFT'): texture = 'Drift'
				elif SKU.has('GUN'): texture = 'Gunstock'
				if not texture:
					push_error("MISSING TEXTURE IN MSI: "+str(SKU))
				
				var FJ = 'FJ No'
				if SKU.has("FJ"):
					FJ = 'FJ Yes'
				
				var clip
				if SKU.has("RH"): clip = 'RH (Right Handed)'
				elif SKU.has("LH"): clip = 'LH (Left Handed)'
				elif SKU.has("BH"): clip = 'BH (Both Handed)'
				elif SKU.has("NC"): clip = "NC (No Clip Hole)"
				if not clip:
					push_error("MISSING CLIP IN MSI: "+ str(SKU))
				
				var lanyard = 'w/ Lanyard'
				if SKU.has("NH"):
					lanyard = 'No Lanyard'
				MSIList[MOs[key]["sort"]] = [MO,knife,material,texture,FJ,clip,lanyard]
