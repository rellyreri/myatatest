extends Area3D

var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready()-> void:
	connect("body_entered",enteredArea)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func enteredArea(damage)-> void:
	damage = 1 #have to set damage variable here or else it outputs the object hitting the environmental damage
	EventBus.environment_damage.emit(damage)
	
