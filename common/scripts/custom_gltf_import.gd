@tool
extends EditorScenePostImport

func _post_import(scene: Node) -> Object:
	_remove_children(scene)
	return scene


func  _remove_children(scene: Node) -> void:
	if scene == null:
		return
	
	for node in scene.get_children():
		# Check for -nochild tag
		if node.name.contains("-nochild"):
			# Remove children for nodes with -nochild tag
			for child in node.get_children():
				node.remove_child(child)
		_remove_children(node)
