require "physics"
physics.start()
--physics.setDrawMode("hybrid")
require "vida"

--vida.objetosCaindo("bola.png",20,1) 

local barreira1 = display.newImage("barreira1.png",250,500)
physics.addBody(barreira1,"static",{outline=graphics.newOutline (2,"barreira1.png"),friction = 0.2})
somBarreira1  = audio.loadSound("som1.wav")
vida.somAoColidir(barreira1,somBarreira1)

local barreira2 = display.newImage("barreira2.png",530,650)
physics.addBody(barreira2,"static",{outline=graphics.newOutline (2,"barreira2.png"),friction = 0.3})
somBarreira2  = audio.loadSound("som2.wav")
vida.somAoColidir(barreira2,somBarreira2)

local barreira3 = display.newImage("barreira3.png",220,950)
physics.addBody(barreira3,"static",{outline=graphics.newOutline (2,"barreira3.png"),friction = 0.3})
somBarreira3  = audio.loadSound("som3.wav")
vida.somAoColidir(barreira3,somBarreira3)

vida.empurra(1,1)

-- 1 - primeiro Criamos o fundo e frente da cesta de basquete sem física
-- pois queremos que a bola passe dentro da cesta
local basketFundo  = vida.plotaFiguraXY("basketFundo.png",432,998)

-- 3 - Aqui modificamos a função de bolas caindo
-- temos que colocar uma variável antes da função, para que o grupo das bolas que vão ser criadas, 
-- esteja entre a parte de trás e a da frente da cesta. Isso é necessário pois as imagens criadas após 
-- a anterior vão aparecer na frente. Então as bolas, que forem criadas antes da frente da cesta, 
-- vão passar atrás dela, dando a impressão de que elas estão passando dentro da cesta.
-- a função que retorna o grupoDeBolas a ser criado se chama objetosCaindoComGrupo, pois ela coloca todas
-- as bolas que vão ser criadas em um único grupo.
local bolas,timerBolas = vida.objetosCaindoComGrupo("bola.png",432,998,20,1) 
-- a função anterior era a seguinte:
-- vida.objetosCaindo("bola.png",20,1) 
-- como pode ver elas não retornavam o grupo, e como as bolas eram criadas após um intervalo de tempo,
-- elas acabavam sendo criadas depois da frente da cesta.
-- após isso voltemos para a parte de baixo do código


local basketFrente = vida.plotaFiguraXY("basketFrente.png",432,998)
-- 2 - percebemos que a frente da cesta ficou atras da bola, oque não queríamos
-- para resolver isso, devemos modificar a função que gera as bolas
-- para que a parte da frente da cesta fique na frente das bolas criadas
-- que uma nova bola for gerada, portanto vamos retirar a função que estava no inicio do código e colocar uma nova entre a parte de trás da cesta e a da frente:



-- 4 - após mudar a função de objetos caindo e fazermos o teste,
-- percebemos que a bola simplesmente passa direto pela cesta, sem bater na tabela
-- portanto, criaremos uma tabela para a cesta e acrescentaremos física apenas
-- na tabela:
local tabela = vida.plotaFiguraXY("tabela.png",432,998)
physics.addBody(tabela,"static",{outline=graphics.newOutline (2,"tabela.png")})

-- 5 - percebemos que a bola está passando pelos cantos da cesta, oque não é agradável
-- para um efeito mais real, iremos acrescentar os lados direito e esquerdo 
-- da cesta e acrescentar colisão neles
local cestaEsquerda = vida.plotaFiguraXY("cestaEsquerda.png",432,998)
physics.addBody(cestaEsquerda,"static",{outline=graphics.newOutline (2,"cestaEsquerda.png")})
local cestaDireita = vida.plotaFiguraXY("cestaDireita.png",432,998)
physics.addBody(cestaDireita,"static",{outline=graphics.newOutline (2,"cestaDireita.png")})



-- 6 - Feito isso, temos uma cesta funcionando de forma agradável
-- agora vamos acrescentar o sensor de pontos na cesta.
-- primeiro, vamos escolher qual som será tocado toda vez que algo passar pela cesta
-- Abaixo lemos o som que será feito quando uma bola passar pelo sensor de pontos:
local somSensor = audio.loadSound("ponto.wav")



-- Aqui abaixo criamos o marcador de pontos que aparecerá na tela 
-- e escolhemos com qual pontuação receberemos a mensagem de Fim de Jogo.
-- (x,y,tamanho,contagem inicial,placar maximo,r,g,b)
local marcador = vida.criarMarcadorDePontos(display.contentWidth,0,80,0,3,255,255,0)

-- Agora criamos o sensor de pontos que será colocado na mesma posição da cesta, ele será invisível
-- A função tem os seguintes argumentos:
-- (PosiçãoX, PosiçãoY, largura, altura, rotação, alpha, som)
-- onde a posição x e y são do sensor, assim como o comprimento, largura e altura
-- e o alpha vai definir se o sensor será visível na tela, variando de 0 a 1
local sensordospontos = vida.criarSensorDePontos(marcador,475,1100,200,10,0,1,1,somSensor)
sensordospontos.x = 475 + sensordospontos.width/2
sensordospontos.y = 1100 + sensordospontos.height/2

