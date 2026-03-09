module(... , package.seeall)

-- Aqui requisitamos ao sistema a largura e o comprimento da tela e armazenamos nas variáveis locais (à biblioteca) W e H.
-- Observe que não precisamos criar variáveis globais.
local W = display.contentWidth
local H = display.contentHeight

--===========================================================--
--======================== ÍNDICE ===========================--
--===========================================================--
--[[
	1 - objetosCaindo(objetoImagem,quantidade,tempo)
	2 - empurra(w,h)
	3 - somAoColidir(objeto,somObjeto)
]]
--===========================================================--

--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--
--xxxxxxxxxxxxxxxxxx objetosCaindo xxxxxxxxxxxxxxxxxxxxxxxxxx--
--[[ 
     Resumo:
	    Esta função irá criar várias cópias de um objeto dinâmico circular em posições randômicas no eixo x, e posição -80 no eixo y (fora da tela)
     entrada:
        objetoImagem -> nome do arquivo de imagem do objeto + extenção. Ex: "bola.png"
        quantidade -> numero de objetos que vão ser gerados. Ex: 10
        tempo (em milisegundos) -> intervalo de tempo que leva para criar cada objeto. Ex.: 1000
     retorno:
		nil -> esta função retorna nada.
]]
function objetosCaindo(objetoImagem,quantidade,tempo)
	
	function jogarObjetos()
		-- Aqui sorteamos um valor entre 15 e W-15 e guardamos na variável posX
		-- caso o aparelho tenha uma largura de 720 pixels, seria uma posição entre 15 e 705.
		local posX = math.random(15,W-15)
		-- agora criamos uma imagem com largura e altura de 110 pixels. Caso a imagem original seja maior ou menor que 110 pixels,
		-- ela será redimensionada para esse tamanho.
		local objeto = display.newImageRect(objetoImagem,110,110)
		-- aqui colocamos o posição inicial da imagem no eixo x (objeto.x = posX) e no eixo y (objeto.y = -80)
		-- lembrando que as coordenadas da imagem são no centro da mesma.
		-- caso deseje mudar o ponto de origem das coordenadas, pode-se muda-lo utilizando anchorX e anchorY.
		-- Exemplo de mudança para o canto superior esquerdo da imagem (bastante usado):
		-- objeto.anchorX = 0
		-- objeto.anchorY = 0
		-- Assim os quatro cantos(anchorX,anchorY) são: (0,0) (0,1), (1,0), (1,1)
		objeto.x = posX
		objeto.y = -80
		-- finalmente colocamos física na figura gerada
		--    objeto    -> É o próprio objeto que queremos colocar a física
		--    "dynamic" -> É o tipo de física que o objeto vai ter(padrão). Nesse caso queremos que o objeto seja afetado pela gravidade e nao fique fixo.
        --                 Se desejar que a física	não seja afetada pela gravidade e fique fixo, use "static".
		--    density   -> Aqui colocamos a densidade do objeto. Qualquer valor positivo. o padrão é 1, caso você não coloque nada.
		--                 Esse valor padrão baseia-se em um no peso para a água.
		--                 O valor da densidade é multiplicado pela área do formato do objeto para determinação sua massa.
		--    bounce    -> Determina o quanto da velocidade será retornada ao objeto ao colidir com algo. o padrão é 0.2
		--    radius    -> Determina o raio da física do objeto, isso que determina que a física será circular, ao invés de retangular (que é o padrão).
		--    friction  -> Atrito do objeto, pode ser qualquer valor positivo. o padrão é 0. o valor 1 representa um atrito forte.
		physics.addBody(objeto,"dynamic",{density = 1,bounce = 0.3,radius = 55,friction = 1})
	end
	-- aqui criamos um timer, um evento que irá executar uma função n vezes em um determinado intervalo de tempo em milisegundos.
	-- tempo*1000 -> Aqui entramos com o intervalo de tempo. Multiplicamos por 1000 para permitir entrar com o tempo em segundos.
	-- jogarObjetos -> função que será disparada a cada intervalo.
	-- quantidade-> número de vezes que a função será disparada. 
	--              Obs.: Se colocar o valor em -1, ela será disparada infinitas vezes.
	timer.performWithDelay(tempo*1000,jogarObjetos,quantidade)
end
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--


--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--
--xxxxxxxxxxxxxxxxxxxxxxxx empurra xxxxxxxxxxxxxxxxxxxxxxxxxx--
--[[ 
     Resumo:
	    Esta função irá um retangulo no ponto em que a tela for pressionada, este retangulo irá colidir com os objetos da tela enquanto
		enquanto for mantido pressionado.
        w -> lagura do retangulo criado. Ex: 10
        h -> altura do retangulo criado. Ex: 5
     retorno:
		nil -> esta função retorna nada.
]]
function empurra(w,h)
	-- primeiro criamos uma variável local para o retângulo
	local retangulo = {}
	function empurrarObjetosDinamicos(event)
		-- O evento de toque possui três fases: inicio do toque (pressionar), movimento do dedo durante o toque, fim do toque (ocorre ao soltar o dedo)
		-- Eventos: "began","moved","ended"
		if event.phase == "began" then
			retangulo = display.newRect(event.x,event.y,w,h)
			physics.addBody(retangulo,"kinematic",{friction = .5,density = .2, bounce = 1})
			-- a linha a seguir é uma forma de fazer o listener "focar" no evento de toque.
			-- ao colocar esse foco, evitamos que o programa ative outro evento ou desative 
			-- até que o toque seja solto da tela.
			-- Ex.: ao pressionar um botão, se colocarmos foco no botão ele continuará pressionado mesmo se o dedo for arrastado para fora dele,
			-- desta forma você garante que ocorrerá o evento novamente quando soltar o dedo da tela.
			display.getCurrentStage():setFocus(event.target, event.id);
		elseif event.phase == "moved" then
			-- aqui atualizamos a posição do retângulo toda vez que o dedo se mover.
			-- event.x é a posição x da tela em que seu dedo está posicionado (nesse caso event é o toque).
			-- event.y é a posição y da tela em que seu dedo está posicionado.
			retangulo.x = event.x
			retangulo.y = event.y
		elseif event.phase == "ended" then
			-- aqui removemos o retangulo da tela
			retangulo:removeSelf()
			-- aqui retiramos o foco do toque
			display.getCurrentStage():setFocus();
		end
	end
	-- Aqui será criado um listener: Um sistema que recebe um evento e executa uma função de callback do mesmo.
	-- Nesse caso estamos recebendo o evento de toque "touch".
	-- Quando ocorrer o toque ele ativará a função empurrarObjetosDinamicos.
	-- 1 - "touch" -> tipo de evento
	-- 2 - empurrarObjetosDinamicos -> função de callback ativada com o touch.
	Runtime:addEventListener("touch",empurrarObjetosDinamicos)
end

--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--
--xxxxxxxxxxxxxxxxxx somAoColidir xxxxxxxxxxxxxxxxxxxxxxxxxx--
--[[ 
     Resumo:
	    Esta função vai fazer com que um objeto produza som toda vez que outro objeto colidir com ele.
     entrada:
        objeto -> nome do objeto que vai produzir o som ao sofrer uma colisão.
        somObjeto -> variável que armazenou o som a ser emitido.
     retorno:
		nil -> esta função retorna nada.
]]
function somAoColidir(objeto,somObjeto)
	function somAoColidirAux(colisao)
		-- como pode ver o evento de colisão também possui fases.
		-- mas diferente do toque, colisão possui apenas duas fazes: "began" e "ended".
		-- a fase "ended" somente ocorre quando a colisão entre dois corpos é finalizada.
		if colisao.phase == "began" then
			audio.play(somObjeto)
		end
	end
	-- nesse caso criamos um evento de colisão "collision".
	objeto:addEventListener("collision",somAoColidirAux)
end


