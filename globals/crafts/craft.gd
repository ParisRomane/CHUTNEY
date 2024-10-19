class_name Craft

var cost: Ressource
var effect: Callable
var args: Array[Object]

func _init(cost: Ressource, effect: Callable, args: Array[Object]) -> void:
	self.cost = cost
	self.effect = effect
	
func make(with: Ressource, target: Ship) -> bool: # replace object with ship class
	if with.have_at_least(cost):
		with.remove(cost)
		effect.bindv(args)
		effect.call()
		return true
	return false
