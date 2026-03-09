require "physics"
physics.start()
--physics.setDrawMode("hybrid")

bola = display.newImage("bola.png",300,120)
physics.addBody(bola,{radius = 60,friction = 1})

chao = display.newImage("chao.png",300,400)
physics.addBody(chao,"static",{outline = graphics.newOutline( 2, "chao.png" ),friction = 0.1})