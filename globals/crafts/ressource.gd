class_name Ressource

var organic: int = 0
var scrap: int = 0
var electronic: int = 0

func _init(organic:int, scrap:int, electronic:int) -> void:
	self.organic = organic
	self.scrap = scrap
	self.electronic = electronic

func have_at_least(other: Ressource) -> bool:
	return organic >= other.organic \
	and scrap >= other.scrap \
	and electronic >= other.electronic

func add(other: Ressource) -> void:
	organic += other.organic
	scrap += other.scrap
	electronic += other.electronic

func add_with_multiplier(other: Ressource, multiplier: int) -> void:
	organic += (other.organic * multiplier)
	scrap += (other.scrap * multiplier)
	electronic += (other.electronic * multiplier)

func remove(other: Ressource) -> void:
	organic -= other.organic
	scrap -= other.scrap
	electronic -= other.electronic
