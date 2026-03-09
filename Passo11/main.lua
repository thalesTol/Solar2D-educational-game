require "physics"
physics.start()

require "vida"

--bola = display.newImage("bola.png",200,60)
--physics.addBody(bola,{radius=60,friction=0.3,bounce=0.4})

vida.objetosCaindo("bola.png",20,1) 

barreira1 = display.newImage("barreira1.png",250,500)
physics.addBody(barreira1,"static",{outline=graphics.newOutline (2,"barreira1.png"),friction = 0.2})

barreira2 = display.newImage("barreira2.png",530,650)
physics.addBody(barreira2,"static",{outline=graphics.newOutline (2,"barreira2.png"),friction = 0.3})

barreira3 = display.newImage("barreira3.png",220,950)
physics.addBody(barreira3,"static",{outline=graphics.newOutline (2,"barreira3.png"),friction = 0.3})


