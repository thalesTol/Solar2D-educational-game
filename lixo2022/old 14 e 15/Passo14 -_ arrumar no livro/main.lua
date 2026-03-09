require "physics"
physics.start()
--physics.setDrawMode("hybrid")
require "vida"

vida.objetosCaindoConta("bola.png","basketFrente.png",432,998,20,1) 

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

basketFundo  = vida.plotaFiguraXY("basketFundo.png",432,998)
basketFrente = vida.plotaFiguraXY("basketFrente.png",432,998)
tabela = vida.plotaFiguraXY("tabela.png",432,998)
physics.addBody(tabela,"static",{outline=graphics.newOutline (2,"tabela.png")})

cestaEsquerda = vida.plotaFiguraXY("cestaEsquerda.png",432,998)
physics.addBody(cestaEsquerda,"static",{outline=graphics.newOutline (2,"cestaEsquerda.png")})

cestaDireita = vida.plotaFiguraXY("cestaDireita.png",432,998)
physics.addBody(cestaDireita,"static",{outline=graphics.newOutline (2,"cestaDireita.png")})

vida.sensorPontos (432,998,300,10,0,0)


--physics.setDrawMode("hybrid")