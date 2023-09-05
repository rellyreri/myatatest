extends CanvasLayer

func _ready():
	$Label.text = str(EventBus.playerhealth)
	EventBus.connect("environment_damage",healthUpdate)

func healthUpdate(_damage):
	$Label.text = str(EventBus.playerhealth)
