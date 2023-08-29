extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotation+=3


func _on_button_pressed():
	set_process(not is_processing()) #sets the is_processing() state to false if true, true if false

