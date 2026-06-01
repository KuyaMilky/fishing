extends Node

# Animation manager - handles mining, fishing, and UI animations

var tween: Tween

func play_mining_animation(character: Node3D, pickaxe: Node3D) -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(pickaxe, "rotation:x", PI / 4, 0.3)
	tween.tween_property(pickaxe, "scale", Vector3.ONE * 1.1, 0.2)
	tween.tween_callback(func(): tween.tween_property(pickaxe, "scale", Vector3.ONE, 0.2))

func play_fishing_animation(rod: Node3D) -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(rod, "rotation:z", PI / 3, 0.4)
	tween.tween_property(rod, "rotation:z", -PI / 3, 0.4)

func play_float_up_animation(item: Node3D) -> void:
	if tween:
		tween.kill()
	
	var start_pos = item.global_position
	var end_pos = start_pos + Vector3.UP * 2
	
	tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(item, "global_position", end_pos, 0.8)
	tween.tween_callback(func(): item.queue_free())

func play_ui_pop_in(node: Node) -> void:
	if tween:
		tween.kill()
	
	node.scale = Vector2.ZERO
	tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", Vector2.ONE, 0.3)
