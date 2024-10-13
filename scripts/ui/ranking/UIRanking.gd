extends Control

func _ready() -> void:
	if ScoreManager.rank == 1:
		$PlaceLabel.text = "You are in the lead!"
	else:
		$PlaceLabel.text = "You are in %s. Place" % (ScoreManager.rank)
	$PointsLabel.text = "You have %s out of 20 Points" % (ScoreManager.points)
	pass 

func _on_received_ranking(place: int, points: int) -> void:
	pass
