module(... , package.seeall)

function bolasCaindoConta(bolaImagem,numero,tempo)
	W = display.contentWidth
	H = display.contentHeight
	function jogarBolas()
		posX = math.random(55,W-55)
		bola = display.newImageRect(bolaImagem,110,110)
		bola.x = posX
		bola.y = -80
		physics.addBody(bola,"dynamic",{density = 5,bounce = 0.3,radius = 55,friction = 1})
		canoFrente = display.newImage("pipeFront2.png",800,1150)
	end
	timer.performWithDelay(tempo*1000,jogarBolas,numero)
end
function bolasCaindo(bolaImagem,numero,tempo)
	W = display.contentWidth
	H = display.contentHeight
	function jogarBolas()
		posX = math.random(55,W-55)
		bola = display.newImageRect(bolaImagem,110,110)
		bola.x = posX
		bola.y = -80
		physics.addBody(bola,"dynamic",{density = 5,bounce = 0.3,radius = 55,friction = 1})
	end
	timer.performWithDelay(tempo*1000,jogarBolas,numero)
end
function somAoColidir(objeto,somObjeto)
	function somAoColidirAux(e)
		if e.phase == "began" then
			audio.play(somObjeto)
		end
	end
	objeto:addEventListener("collision",somAoColidirAux)
end

function marcarPontos(sensorMarcador)
	texto = display.newText("Pontos: 0",120,100,system.nativeFont,50)
	texto:setFillColor(0.5,0.5,1)
	pontos = 0
	function marcarPontosAux(e)
		if e.phase == "ended" then
			pontos = pontos + 1
			print(pontos)
			texto.text = "Pontos: " .. pontos
		end
	end
	sensor:addEventListener("collision",marcarPontosAux)
end
function sensorPontos(x,y,comp,alt,ang,inv,r,g,b) -- r, g e b - 0.0->1.0
   sensor = display.newRect(x,y,comp,alt)
   sensor:setFillColor(r,g,b)
   sensor.rotation = ang 
   sensor.alpha = inv -- 0-1, onde zero  é transparente e  1 sem transparência
   physics.addBody(sensor,"static",{isSensor = true})
   marcarPontos(sensor)
end 

function empurrarObjetosDinamicos(e)
	if e.phase == "began" then
		toque = display.newRect(e.x,e.y,60,5)
		physics.addBody(toque,"kinematic",{friction = .5,density = .2, bounce = 1})
		display.getCurrentStage():setFocus(e.target, e.id);
	end
	if e.phase == "moved" or e.phase == "stationary" then
		toque.x = e.x
		toque.y = e.y
	end
	if e.phase == "ended" then
		toque:removeSelf()
		display.getCurrentStage():setFocus();
	end
end
function lifeInside(figura)
   return graphics.newOutline( 2, figura )
end
function ativaToque()
	Runtime:addEventListener("touch",empurrarObjetosDinamicos)
end
