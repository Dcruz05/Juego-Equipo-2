extends Control

var musica_menu
var boton_bocina


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boton_bocina = $botonBocina
	musica_menu =$musicaMenu
	musica_menu.play()
	pass # Replace with function body.
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_2_pressed() -> void:
	pass # Replace with function body.




func _on_boton_bocina_pressed() -> void:
	if musica_menu.playing:
		musica_menu.stop()
		
	else:
		musica_menu.play()
		
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	#carga la escena del primer nivel
	
	musica_menu.stop()
	get_tree().change_scene_to_file("res://Scenes/Levels/level_one.tscn")
	
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()  # Cierra el juego
	pass # Replace with function body.
