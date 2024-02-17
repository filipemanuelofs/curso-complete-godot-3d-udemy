extends RigidBody3D


## Impulso dado ao foguete
@export_range(750.0, 1500.0) var thrust: float = 1000.0

## Torque 
@export var torque_thrust: float = 100.0

var tween: Tween
var is_transitioning: bool = false

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var right_booster_particles: GPUParticles3D = $RightBoosterParticles
@onready var left_booster_particles: GPUParticles3D = $LeftBoosterParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		booster_particles.emitting = true
		if not rocket_audio.playing:
			rocket_audio.play()
	else:
		booster_particles.emitting = false
		rocket_audio.stop()
		
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		right_booster_particles.emitting = true
	else:
		right_booster_particles.emitting = false
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
		left_booster_particles.emitting = true
	else:
		left_booster_particles.emitting = false
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_body_entered(body: Node) -> void:
	if not is_transitioning:
		if "Goal" in body.get_groups():
			complete_level(body.file_path)
			
		if "Hazard" in body.get_groups():
			crash_sequence()


func crash_sequence() -> void:
	print("level fail")
	right_booster_particles.emitting = false
	left_booster_particles.emitting = false
	explosion_particles.emitting = true
	explosion_audio.play()
	set_process(false)
	is_transitioning = true
	tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)


func complete_level(next_level_file: String) -> void:
	print("level complete")
	success_particles.emitting = true
	success_audio.play()
	set_process(false)
	is_transitioning = true
	tween = create_tween()
	tween.tween_interval(1.5)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)
	)
	
