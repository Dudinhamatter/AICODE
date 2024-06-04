function love.conf(t)
  t.title = "Project"
  t.version = "11.4"
  t.console = true
  t.window.width = 640
  t.window.height = 480
  t.window.fullscreen = false
  --t.window.usedpiscale = true
  --t.window.vsync = 1
  --t.externalstorage=true
  t.accelerometerjoystick = false

  io.stdout:setvbuf('no')
end