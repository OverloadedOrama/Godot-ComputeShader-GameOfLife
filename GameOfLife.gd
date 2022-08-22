extends TextureRect


func _ready() -> void:
	compute()


#func _process(delta: float) -> void:
#	compute()


func compute() -> void:
	var og_image := texture.get_image()
	og_image.convert(Image.FORMAT_RGBA8)
	var image_size := og_image.get_size()
	# We will be using our own RenderingDevice to handle the compute commands
	var rd := RenderingServer.create_local_rendering_device()

	# Create shader and pipeline
	var shader_file: RDShaderFile = preload("res://gol.glsl")
	var shader_spirv := shader_file.get_spirv()
	var shader := rd.shader_create_from_spirv(shader_spirv)
	var pipeline := rd.compute_pipeline_create(shader)

	# Data for compute shaders has to come as an array of bytes
	var pba := og_image.get_data()
#	print(pba)
#	print(og_image.data)

	# Create storage buffer
	# Data not needed, can just create with length
#	var storage_buffer := rd.storage_buffer_create(pba.size(), pba)
#	var texture_buffer := rd.texture_buffer_create(pba.size() / 4, RenderingDevice.DATA_FORMAT_R8G8B8A8_UINT, pba)
#	var texture_buffer := rd.uniform_buffer_create(pba.size(), pba)
	var tex_format := RDTextureFormat.new()
	tex_format.width = image_size.x
	tex_format.height = image_size.y
	tex_format.depth = 4
	tex_format.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	tex_format.usage_bits = RenderingDevice.TEXTURE_USAGE_STORAGE_BIT\
	| RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT\
	| RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	var tex_view := RDTextureView.new()
	var texture_buffer := rd.texture_create(tex_format, tex_view, [pba])

	# Create uniform set using the storage buffer
	var u := RDUniform.new()
	u.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	u.binding = 0
	u.add_id(texture_buffer)
	var uniform_set := rd.uniform_set_create([u], shader, 0)

	# Start compute list to start recording our compute commands
	var compute_list := rd.compute_list_begin()
	# Bind the pipeline, this tells the GPU what shader to use
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	# Binds the uniform set with the data we want to give our shader
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
#	rd.compute_list_dispatch(compute_list, 2, 1, 1)  # Dispatch 1x1x1 (XxYxZ) work groups
	rd.compute_list_dispatch(compute_list, image_size.x, image_size.y, 4)  # Dispatch 1x1x1 (XxYxZ) work groups
	#rd.compute_list_add_barrier(compute_list)
	rd.compute_list_end()  # Tell the GPU we are done with this compute task
	rd.submit()  # Force the GPU to start our commands
	rd.sync()  # Force the CPU to wait for the GPU to finish with the recorded commands

	# Now we can grab our data from the storage buffer
#	var byte_data := rd.buffer_get_data(texture_buffer)
	var byte_data := rd.texture_get_data(texture_buffer, 0)
#	print(byte_data)
	var image := Image.new()
	image.create_from_data(image_size.x, image_size.y, false, og_image.get_format(), byte_data)
	texture = ImageTexture.create_from_image(image)
#	for i in range(16):
#		print(byte_data.decode_float(i*4))


func _on_timer_timeout() -> void:
	compute()
