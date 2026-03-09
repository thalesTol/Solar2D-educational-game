require "physics"
physics.start()

bola = display.newImage("bola.png",300,120)
physics.addBody(bola)

chao = display.newImage("chao.png",300,400)
physics.addBody(chao,"static",{outline = graphics.newOutline( 2, "chao.png" )})