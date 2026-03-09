require "vida"
require "physics"
physics.start()
--physics.setDrawMode("hybrid")

vida.bolasCaindoConta("bola1.png",100,1)

canoAtras = display.newImage("pipeback3.png",800,1150)
canoFrente = display.newImage("pipeFront2.png",800,1150)
vida.sensorPontos (640,1130,390,10,-60,0,1,1,1)



chao = display.newImage("chao.png",300,400)
physics.addBody( chao,"static", { outline  = vida.lifeInside("chao.png"), bounce=0, friction=0.1,density = 3 } )

chao2 = display.newImage("chao2.png",580,650)
physics.addBody( chao2,"static", { outline = vida.lifeInside("chao2.png"), bounce=0, friction=0.1,density = 3 } )

chao3 = display.newImage("chao4.png",300,1100)
physics.addBody( chao3,"static", { outline = vida.lifeInside("chao3.png"), bounce=0, friction=0.1,density = 3 } )

torcida = display.newImage("torcida.png",360,1170)

somChao  = audio.loadSound("som1.wav")
somChao2 = audio.loadSound("som2.wav")
somChao3 = audio.loadSound("som4.wav")

vida.somAoColidir(chao,somChao)
vida.somAoColidir(chao2,somChao2)
vida.somAoColidir(chao3,somChao3)

vida.ativaToque()