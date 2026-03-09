require "physics"
physics.start()
--physics.setDrawMode("hybrid")
require "vida"


function start()
-- CRIANDO OBJETOS DA INTERFACE
local barreira1 = display.newImage("barreira1.png",250,500)
physics.addBody(barreira1,"static",{outline=graphics.newOutline (2,"barreira1.png"),friction = 0.2})
local somBarreira1  = audio.loadSound("som1.wav")
vida.somAoColidir(barreira1,somBarreira1)

local barreira2 = display.newImage("barreira2.png",530,650)
physics.addBody(barreira2,"static",{outline=graphics.newOutline (2,"barreira2.png"),friction = 0.3})
local somBarreira2  = audio.loadSound("som2.wav")
vida.somAoColidir(barreira2,somBarreira2)

local barreira3 = display.newImage("barreira3.png",220,950)
physics.addBody(barreira3,"static",{outline=graphics.newOutline (2,"barreira3.png"),friction = 0.3})
local somBarreira3  = audio.loadSound("som3.wav")
vida.somAoColidir(barreira3,somBarreira3)

local basketFundo  = vida.plotaFiguraXY("basketFundo.png",432,998)

-- 1 - Aqui acrescentamos a variável timersVida, pois a função objetosCaindoComGrupo retorna as bolas criadas para a primeira variável
--     e o timer que gera as bolas como segunda variável.
--     Fazemos isso pois queremos que o timer pare de gerar bolas quando reiniciarmos a aplicação.
--     e a função restart precisa receber a variável do timer para poder cancelar ele.
local objetosVida,timersVida = vida.objetosCaindoComGrupo("bola.png",432,998,20,1)

local basketFrente = vida.plotaFiguraXY("basketFrente.png",432,998)
local tabela = vida.plotaFiguraXY("tabela.png",432,998)
physics.addBody(tabela,"static",{outline=graphics.newOutline (2,"tabela.png")})
local cestaEsquerda = vida.plotaFiguraXY("cestaEsquerda.png",432,998)
physics.addBody(cestaEsquerda,"static",{outline=graphics.newOutline (2,"cestaEsquerda.png")})
local cestaDireita = vida.plotaFiguraXY("cestaDireita.png",432,998)
physics.addBody(cestaDireita,"static",{outline=graphics.newOutline (2,"cestaDireita.png")})
-- AÇÕES
local marcador = vida.criarMarcadorDePontos(display.contentWidth,0,80,0,3,255,255,0)

local sensordospontos = vida.criarSensorDePontos(marcador,475,1100,200,10,0,1,1,somSensor)
sensordospontos.x = 475 + sensordospontos.width/2
sensordospontos.y = 1100 + sensordospontos.height/2

vida.empurra(1,1)

-- REINICIAR
local botaoRestart = vida.restart("botao.png",600,100,{marcador,sensordospontos,cestaDireita,cestaEsquerda,basketFundo,basketFrente,tabela,barreira1,barreira2,barreira3,objetosVida},{timersVida},start)
end
start()