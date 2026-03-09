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