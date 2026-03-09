module(... , package.seeall)
function vidaInsideFiguraSt(figura)
--St = padrão ->  
-- density = 1                [1.0 = água:  mais leves (boia na água) <1, mais pesados (afunda na água) >1]
-- friction(atrito>0) = 0.3   [0.0 = sem fricção, 1.0 = fricção forte]
-- bounce (restitution) = 0.2 [0.0 = sem bounce , >=1.0, quica eternamente (sem perda)] 
 contorno =  {outline = graphics.newOutline( 2, figura )}
 return contorno
end

function bolasCaindo(bolaImagem,numero,tempo)
	W = display.contentWidth
	H = display.contentHeight
	function jogarBolas()
		posX = math.random(55,W-55)
		bola = display.newImageRect(bolaImagem,110,110)
		bola.x = posX
		bola.y = -80
		physics.addBody(bola,"dynamic",{density = 1,bounce = 0.3,radius = 55,friction = 1})
	end
	timer.performWithDelay(tempo*1400,jogarBolas,numero)
end
function somAoColidir(objeto,somObjeto)
	function somAoColidirAux(e)
		if e.phase == "began" then
			audio.play(somObjeto)
		end
	end
	objeto:addEventListener("collision",somAoColidirAux)
end