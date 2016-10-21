function love.conf(t)
	t.console=true
	t.window.title = "Island Generator"
	t.window.resizable = false
	t.window.fullscreen = false
	t.window.borderless = true
	t.window.width=512
	t.window.height=512

	t.modules.audio = false
	t.modules.joystick =false
	t.modules.mouse =false
	t.modules.physics = false
	t.modules.sound = false
	t.modules.thread = false
end
