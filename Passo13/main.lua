require "physics"
physics.start()

require "vida"

vida.objetosCaindo("bola.png",20,1) 

barreira1 = display.newImage("barreira1.png",250,500)
physics.addBody(barreira1,"static",{outline=graphics.newOutline (2,"barreira1.png"),friction = 0.2})
somBarreira1  = audio.loadSound("som1.wav")
vida.somAoColidir(barreira1,somBarreira1)

barreira2 = display.newImage("barreira2.png",530,650)
physics.addBody(barreira2,"static",{outline=graphics.newOutline (2,"barreira2.png"),friction = 0.3})
somBarreira2  = audio.loadSound("som2.wav")
vida.somAoColidir(barreira2,somBarreira2)

barreira3 = display.newImage("barreira3.png",220,950)
physics.addBody(barreira3,"static",{outline=graphics.newOutline (2,"barreira3.png"),friction = 0.3})
somBarreira3  = audio.loadSound("som3.wav")
vida.somAoColidir(barreira3,somBarreira3)

vida.empurra(1,1)

