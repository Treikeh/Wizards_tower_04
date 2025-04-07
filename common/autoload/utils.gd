extends Node


## Loads data from a csv file into a JSON like format where every row becomes a dict.
## The first colum becomes the key to the the row dict and every other colum becomes a smaler dict within.
## The output is very similar to the "Hash" output from [url]https://csvjson.com/csv2json[/url]
func load_data_from_csv(file_path: String) -> Dictionary[String, Dictionary]:
	var dict: Dictionary[String, Dictionary] = {}
	var file := FileAccess.open(file_path, FileAccess.READ)
	
	# Get all columns categories
	var columns := Array(file.get_csv_line())
	
	# Go through every row and add the data to the dict
	while not file.eof_reached():
		# Get data on current row
		var data_set := Array(file.get_csv_line())
		
		# Convert data from an array to dict with colum as key
		var value_dict: Dictionary = {}
		# Start at the "2" array spot to avoid adding the row key to the value dict
		for i: int in range(1, columns.size()):
			value_dict[columns[i]] = data_set[i]
		
		# Add data to dict with the first colum value as key
		dict[data_set[0]] = value_dict
	
	file.close()
	return dict
