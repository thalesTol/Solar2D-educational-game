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
 figuraTeste = display.newImage (figura,5000,5000)
 largura = figuraTeste.width
 altura  = figuraTeste.height
 return display.newImage(figura,x+(largura/2),y+(altura/2))
end 

function objetosCaindoConta(bolaImagem,figuraFrente,posXF,posYF,numero,tempo)
Grupo = display.newGroup()
local bola = {}
local i = 1
local jaAdicionou = false
	W = display.contentWidth
	H = display.contentHeight
	function jogarBolas()
		posX = math.random(55,W-55)
		bola[i] = display.newImageRect(bolaImagem,110,110)
		bola[i].x = posX
		bola[i].y = -80
		physics.addBody(bola[i],"dynamic",{density = 5,bounce = 0.3,radius = 55,friction = 1})
		if jaAdicionou == false then
			sextaDeBasqueteFrente = display.newImage(figuraFrente,posXF,posYF)
		end
		jaAdicionou = true
		Grupo:insert(bola[i])
		Grupo:insert(sextaDeBasqueteFrente)
		i = i+1
		return
	end
	local timerBolas = timer.performWithDelay(tempo*1000,jogarBolas,numero)
	return Grupo,timerBolas
end

function objetosCaindo(objetoImagem,quantidade,tempo)
local objeto = {}
local i = 1
	W = display.contentWidth
	H = display.contentHeight
	function jogarObjetos()
		posX = math.random(15,W-15)
		objeto[i] = display.newImageRect(objetoImagem,110,110)
		objeto.x = posX
		objeto.y = -80
		physics.addBody(objeto,"dynamic",{density = 1,bounce = 0.3,radius = 55,friction = 1})
		i = i+1
	end
	timer.performWithDelay(tempo*1000,jogarObjetos,quantidade)
	return objeto
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
	local Grupao = display.newGroup()
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
	sensorMarcador:addEventListener("collision",marcarPontosAux)
	Grupao:insert(texto)
	return Grupao
end
function sensorPontos(x,y,comp,alt,ang,inv,r,g,b) -- r, g e b - 0.0->1.0
	local Grupo = display.newGroup()
   sensor = display.newRect(x,y,comp,alt)
   sensor:setFillColor(r,g,b)
   sensor.rotation = ang 
   sensor.alpha = inv -- 0-1, onde zero  é transparente e  1 sem transparência
   physics.addBody(sensor,"static",{isSensor = true})
   Grupo:insert(marcarPontos(sensor))
   return Grupo
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

function restart(imagemBotao,posX,posY,vetorImagens,vetorTimers)
	botaodeRestart = display.newImage(imagemBotao,posX,posY)
	function restartarOApp()
		if #vetorImagens > 0 then
			for i=1, #vetorImagens do
				--display.remove(vetorImagens[i])
				vetorImagens[i]:removeSelf()
				vetorImagens[i] = nil
			end
		end
		if #vetorTimers > 0 then
			for i=1,#vetorTimers do
				timer.cancel(vetorTimers[i])
				vetorTimers[i] = nil
			end
		end
		botaodeRestart:removeSelf()
		timer.performWithDelay(10,function() start() end,1)
	end
	botaodeRestart:addEventListener("tap",restartarOApp)
end
