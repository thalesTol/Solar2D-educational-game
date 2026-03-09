require "physics"
physics.start()

bola = display.newImage("bola1.png",300,120)
physics.addBody(bola)

chao = display.newImage("chao.png",300,400)
physics.addBody(chao,"static")