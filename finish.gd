extends Area2D
@export var game_over_label: RichTextLabel

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if game_over_label == null: return
		game_over_label.visible = true
