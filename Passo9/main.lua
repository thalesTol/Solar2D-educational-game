require "physics"
physics.start()
physics.setDrawMode("hybrid")

bola = display.newImage("bola.png", 200,60)
physics.addBody(bola,{radius = 60,friction = 0.1,bounce=0.5})

barreira1 = display.newImage("barreira1.png",200,500)
physics.addBody(barreira1,"static",{outline = graphics.newOutline (2,"barreira1.png"),friction = 0.2})