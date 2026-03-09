module(... , package.seeall)
function vidaInsideFiguraSt(figura)
--St = padrão ->  
-- density = 1                [1.0 = água:  mais leves (boia na água) <1, mais pesados (afunda na água) >1]
-- friction(atrito>0) = 0.3   [0.0 = sem fricção, 1.0 = fricção forte]
-- bounce (restitution) = 0.2 [0.0 = sem bounce , >=1.0, quica eternamente (sem perda)] 
 contorno =  {outline = graphics.newOutline( 2, figura )}
 return contorno
end
function plotaFiguraXY(figura, x,y)
 figuraTeste = display.newImage (figura,(2*x)+5000,(2*y)+5000)
 largura = figuraTeste.width
 altura  = figuraTeste.height
 return display.newImage(figura,x+(largura/2),y+(altura/2))
end 

function objetosCaindoConta(bolaImagem,figuraFrente,posXF,posYF,numero,tempo)
	W = display.contentWidth
	H = display.contentHeight
	function jogarBolas()
		posX = math.random(55,W-55)
		bola = display.newImageRect(bolaImagem,110,110)
		bola.x = posX
		bola.y = -80
		physics.addBody(bola,"dynamic",{density = 5,bounce = 0.3,radius = 55,friction = 1})
		figuraDaFrente = plotaFiguraXY(figuraFrente,posXF,posYF)
		--display.newImage(figuraFrente,posXF,posYF)
		
	end
	timer.performWithDelay(tempo*1000,jogarBolas,numero)
end

function objetosCaindo(objetoImagem,quantidade,tempo)
	W = display.contentWidth
	H = display.contentHeight
	function jogarObjetos()
		posX = math.random(15,W-15)
		objeto = display.newImageRect(objetoImagem,110,110)
		objeto.x = posX
		objeto.y = -80
		physics.addBody(objeto,"dynamic",{density = 1,bounce = 0.3,radius = 55,friction = 1})
	end
	timer.performWithDelay(tempo*1000,jogarObjetos,quantidade)
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
function sensorPontos(x,y,comp,alt,ang,inv)        --,r,g,b) -- r, g e b - 0.0->1.0
   sensor = display.newRect(x+(comp/2),y+(alt/2),comp,alt)
   --sensor:setFillColor(r,g,b)
   sensor.rotation = ang 
   sensor.alpha = inv -- 0-1, onde zero  é transparente e  1 sem transparência
   physics.addBody(sensor,"static",{isSensor = true})
   marcarPontos(sensor)
end 


function empurra(w,h)
	function empurrarObjetosDinamicos(event)
	if event.phase == "began" then
		toque = display.newRect(event.x,event.y,w,h)
		physics.addBody(toque,"kinematic",{friction = .5,density = .2, bounce = 1})
		display.getCurrentStage():setFocus(event.target, event.id);
	end
	if event.phase == "moved" or event.phase == "stationary" then
		toque.x = event.x
		toque.y = event.y
	end
	if event.phase == "ended" then
		toque:removeSelf()
		display.getCurrentStage():setFocus();
	end
	end
	Runtime:addEventListener("touch",empurrarObjetosDinamicos)
end
