require "physics"
physics.start()

bola = display.newImage("bola1.png",60,60)
physics.addBody(bola)

chao = display.newImage("chao.png",200,500)
physics.addBody(chao)