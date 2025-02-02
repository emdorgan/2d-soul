extends PathFollow2D

@export var speed: float = 500
@export var paths: Array[Path2D]

var current_path_index: int = 0
const TOLERANCE: float = 0.01

func _ready():
	# Start following the first path
	switch_path(paths[current_path_index])

func _process(delta):
	if not get_parent() is Path2D:
		return

	progress += speed * delta

	if is_at_end_of_path():
		current_path_index += 1
		if current_path_index >= paths.size():
			current_path_index = 0  # Loop back to the first path
		switch_path(paths[current_path_index])

func is_at_end_of_path() -> bool:
	return abs(progress_ratio - 1.0) < TOLERANCE

func switch_path(new_path: Path2D):
	get_parent().remove_child(self)
	new_path.add_child(self)

	progress = 0
