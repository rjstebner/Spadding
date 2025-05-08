extends Timer

var images = []
# References to the TextureRect nodes for the images


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	images = [
		$image1,
		$image2,
		$image3,
		$image4,
		$image5
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    # Calculate the percentage of time left
	var percentage_left = (time_left / wait_time) * 100

    # Update visibility based on the percentage
	if percentage_left >= 80:
		set_images_visible(5)
	elif percentage_left >= 60:
		set_images_visible(4)
	elif percentage_left >= 40:
		set_images_visible(3)
	elif percentage_left >= 20:
		set_images_visible(2)
	elif percentage_left >= 3:
		set_images_visible(1)
	else:
		set_images_visible(0)

# Helper function to set the visibility of images
func set_images_visible(count: int) -> void:
	for i in range(images.size()):
		images[i].visible = i < count
		if count == 1:
			images[i].modulate = Color(1, 0, 0)  # Change color to red
		else:
			images[i].modulate = Color(1, 1, 1)  # Reset color to white