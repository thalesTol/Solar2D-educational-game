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
	4 - plotaFiguraXY(figura, x,y)
	5 - objetosCaindoConta(bolaImagem,figuraFrente,posXF,posYF,quantidade,tempo)
	6 - objetosCaindoComGrupo(bolaImagem,figuraFrente,posXF,posYF,numero,tempo)
	7 - criarMarcadorDePontos(x,y,tamanho,contInicial,maxPlacar,r,g,b)
	8 - restart(imagemBotao,posX,posY,vetorImagens,vetorTimers)
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
		nil -> esta função não retorna nada.
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
		nil -> esta função não retorna nada.
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
	-- 1 - "touch" -> tipo de evento. Eventos existentes -> https://docs.coronalabs.com/api/event/index.html
	-- 2 - empurrarObjetosDinamicos -> função de callback ativada com o touch.
	Runtime:addEventListener("touch",empurrarObjetosDinamicos)
end

--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--
--xxxxxxxxxxxxxxxxxx somAoColidir xxxxxxxxxxxxxxxxxxxxxxxxxx--
--[[ 
     Resumo:
	    Esta função irá criar várias cópias de um objeto dinâmico circular em posições randômicas no eixo x, e posição -80 no eixo y (fora da tela)
     entrada:
        objeto -> nome do objeto que vai produzir o som ao sofrer uma colisão.
        somObjeto -> nome do arquivo de som. Ex: "barulho.mp3"
     retorno:
		nil -> esta função não retorna nada.
]]
function somAoColidir(objeto,somObjeto)
	function somAoColidirAux(event)
		-- como pode ver o evento de colisão também possui fases.
		-- mas diferente do toque, colisão possui apenas duas fazes: "began" e "ended".
		-- a fase "ended" somente ocorre quando a colisão entre dois corpos é finalizada.
		-- Obs1: na fase ended o event.x e event.y é sempre zero.
		-- Obs2: você pode usar event.other para referenciar ao outro objeto que colidiu com este.
		if event.phase == "began" then
			audio.play(somObjeto)
		end
	end
	-- nesse caso criamos um evento de colisão "collision".
	objeto:addEventListener("collision",somAoColidirAux)
end

--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--
--xxxxxxxxxxxxxxxxxx plotaFiguraXY xxxxxxxxxxxxxxxxxxxxxxxxxx--
--[[ 
     Resumo:
	    Esta função irá plotar uma imagem na tela com o ponto de referência superior esquerdo.
     entrada:
        objeto -> nome do objeto que vai produzir o som ao sofrer uma colisão.
		x -> posição x do objeto(ponto de referência esquerdo)
		y -> posição y do objeto (ponto de referência superior)
        somObjeto -> nome do arquivo de som. Ex: "barulho.mp3"
     retorno:
		objeto (imagem) -> esta função retorna a imagem criada na tela.
]]
function plotaFiguraXY(figura, x,y)
    local figura = display.newImage (figura,x,y)
    figura.anchorX = 0
    figura.anchorY = 0
    return figura
end 

--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--
--xxxxxxxxxxxxxxxxxx objetosCaindoComGrupo xxxxxxxxxxxxxxxxxxxxxxxxxx--
--[[ 
     Resumo:
	    Esta função irá criar várias cópias de um objeto dinâmico circular em posições randômicas no eixo x, e posição -80 no eixo y (fora da tela)
		Diferente da objetosCaindo, esta função recebe também a imagem da cesta que deseja que fique sempre na frente da bola quando uma passar na outra.
     entrada:
        bolaImagem -> nome do arquivo de imagem do objeto + extenção. Ex: "bola.png"
		figuraFrente -> nome do arquivo de imagem da cesta + extenção. Ex: "cesta.png"
		posXF -> posição da cesta no eixo X.
		posYF -> posição da cesta no eixo Y.
        quantidade -> numero de objetos que vão ser gerados. Ex: 10
        tempo (em milisegundos) -> intervalo de tempo que leva para criar cada objeto. Ex.: 1000
     retorno:
		grupo e timer -> esta função retorna o grupo que contém as bolas criadas e o timer que cria bolas
]]
function objetosCaindoComGrupo(bolaImagem,posXF,posYF,numero,tempo)
	-- Aqui criamos um grupo
	-- Um grupo é usado para priorizar a vizualização de objetos (imagens) na ordem em que o grupo foi criado.
	-- como queremos que a bola passe atrás da tabela da cesta, temos que criar um grupo para armazenar todas as bolas.
	-- esse grupo vai fazer com que as bolas que estejam dentro dele sejam mostradas na tela como
	-- se tivessem sido criadas junto com o grupo.
	
	local grupoBolas = display.newGroup()
	function jogarBolas()
		local posX = math.random(55,W-55)
		local bola = display.newImageRect(bolaImagem,110,110)
		bola.x = posX
		bola.y = -80
		physics.addBody(bola,"dynamic",{density = 5,bounce = 0.3,radius = 55,friction = 1})
		-- agora acrescentamos a bola no grupo criado
		grupoBolas:insert(bola)
	end
	local timerBolas = timer.performWithDelay(tempo*1000,jogarBolas,numero)
	
	return grupoBolas,timerBolas
end
-- Ao invés disso, poderiamos criar uma nova frente da cesta de basquete, toda vez que uma nova
-- bola fosse gerada. Função abaixo.
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--
--xxxxxxxxxxxxxxxxxx objetosCaindoConta xxxxxxxxxxxxxxxxxxxxxxxxxx--
--[[ 
     Resumo:
	    Esta função irá criar várias cópias de um objeto dinâmico circular em posições randômicas no eixo x, e posição -80 no eixo y (fora da tela)
		Diferente da objetosCaindo, esta função recebe também a imagem da cesta que deseja que fique sempre na frente da bola quando uma passar na outra.
     entrada:
        bolaImagem -> nome do arquivo de imagem do objeto + extenção. Ex: "bola.png"
		figuraFrente -> nome do arquivo de imagem da cesta + extenção. Ex: "cesta.png"
		posXF -> posição da cesta no eixo X.
		posYF -> posição da cesta no eixo Y.
        quantidade -> numero de objetos que vão ser gerados. Ex: 10
        tempo (em milisegundos) -> intervalo de tempo que leva para criar cada objeto. Ex.: 1000
     retorno:
		nil -> esta função não retorna nada.
]]
function objetosCaindoConta(bolaImagem,figuraFrente,posXF,posYF,quantidade,tempo)
	local bola = {}
	local i = 1
	function jogarBolas()
		posX = math.random(55,W-55)
		bola[i] = display.newImageRect(bolaImagem,110,110)
		bola[i].x = posX
		bola[i].y = -80
		physics.addBody(bola[i],"dynamic",{density = 5,bounce = 0.3,radius = 55,friction = 1})
		-- aqui criaremos novamente a cesta toda vez que uma nova bola for gerada. Assim a nova imagem da cesta
		-- ficará sempre na frente de todas as bolas.
		-- usamos aqui a função plotaFiguraXY, que colocar  a imagem com ponto de referência superior esquerdo.
		local sextaDeBasqueteFrente = plotaFiguraXY(figuraFrente,posXF,posYF)
		i = i+1
	end
	local timerBolas = timer.performWithDelay(tempo*1000,jogarBolas,quantidade)
end

--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--
--xxxxxxxxxxxxxxxxxx criarMarcadorDePontos xxxxxxxxxxxxxxxxxxxxxxxxxx--
--[[ 
     Resumo:
	    Esta função irá criar uma marcador de pontos (texto numérico), que irá gerar um texto de game over quando certo placar é atingido.
		Ela funciona juntamente com a função criarSensorDePontos que vai aumentar ou diminuir o seu valor.
     entrada:
        x -> posição do placar no eixo x (ponto de referência na direita). Ex: 720
		y -> posição do placar no eixo y (ponto de referência superior). Ex: 0
		tamanho -> tamanho, em pixels, do placar (número inteiro). Ex.: 80
		contInicial -> Pontuação inicial do placar (número). Ex.: 0
        maxPlacar -> Numero de pontos para que dê game over. (número). Ex.: 10
        r,g,b (0 - 255) -> valores em RGB, (vermelho, verde e azul) que variam de 0 a 255 cada. Ex.: 255,255,255 (branco)
     retorno:
		objeto -> o próprio marcador de pontos
]]
function criarMarcadorDePontos(x,y,tamanho,contInicial,maxPlacar,r,g,b)
	-- primeiro criamos um valor padrão de cor, guardando 3 números, representando cor branca em RGB.
	local cor = {255,255,255}
	--aqui verificamos se foram colocadas as 3 cores na função, caso elas existam, usar elas ao invés da padrão.
	if r and g and b then
		cor = {r,g,b}
	end
	-- a seguir usa-se "type" para verificar o tipo de dados que foi usado para a variável contInicial.
	-- nesse caso só queremos criar um marcador caso o valor inicial tenha sido colocado e seja um número.
	if type(contInicial)== "number" then -- type = "string", "number", "boolean", outros
		local textoPontos = display.newText(contInicial,x,y,system.nativeFontBold,tamanho)
		-- anchorX = 1 e anchorY = 0 implica ponto de referência no canto superior direito
		textoPontos.anchorX=1
		textoPontos.anchorY=0
		-- note que dividimos o valor de r, g e b por 255, fazemos isso para obtor o valor correto em rgb, visto
		-- que as cores no método setFillColor são trabalhadas com valores entre 0 e 1.
		textoPontos:setFillColor(cor[1]/255,cor[2]/255,cor[3]/255)
		-- abaixo criamos uma variável vinculada ao marcador e guardamos o valor do placar dentro dela.
		-- essa variável pertence ao marcador, podendo ser manipulada posteriormente.
		textoPontos.contagemAtual = contInicial
		-- abaixo está um função vinculada ao marcador de pontos, dessa forma podemos chamar essa função
		-- fora da biblioteca ou em outro local, fazendo uso do marcador que é retornado pela função.
		-- no caso dessa função, ela é utilizada pela função criarSensorDePontos através do textoPontos que
		-- é retornada mais abaixo.
		function textoPontos.atualizarValorMarcador(pontos)
			local gameOver = false
			-- aqui verificamos se a variável textoPontos.contagemAtual alcançou o valor do placar
			if textoPontos.contagemAtual >= maxPlacar then
				gameOver = "GAME OVER\n           "..maxPlacar
			end
			
			-- textoPontos.novoValor é uma variável recebida da função de sensor, criada logo abaixo da função criarMarcadorDePontos
			textoPontos.contagemAtual = textoPontos.contagemAtual + textoPontos.novoValor
			
			if gameOver then
				-- caso tenha alcançado o placar, modificamos o texto do marcador modificando a propriedade .text do marcador
				textoPontos.text = gameOver
				textoPontos.x = W/2 + textoPontos.width/2
				textoPontos.y = H/2 - textoPontos.height/2
			else
				-- senão modificamos para a nova pontuação
				textoPontos.text = textoPontos.contagemAtual
			end
		end
		
		return textoPontos
	end
end

--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--
--xxxxxxxxxxxxxxxxxx criarSensorDePontos xxxxxxxxxxxxxxxxxxxxxxxxxx--
--[[ 
     Resumo:
	    Esta função irá criar um sensor. Quando um objeto passar pelo sensor, o mesmo irá aumentar o valor
		do marcadorDePontos (obtido pela função criarMarcadorDePontos).
     entrada:
		marcadorDePontos -> objeto recebido pela função criarMarcadorDePontos.
        x -> posição do sensor no eixo x (ponto de referência no centro). Ex: 500
		y -> posição do sensor no eixo y (ponto de referência no centro). Ex: 1000
		comprimento -> comprimento do sensor. Ex.: 100
		altura -> altura do sensor. Ex.: 10
		rot -> rotação do sensor. Ex.: 45 (45 graus).
        alpha -> transparência do sensor, se colocar 0, ele será invisível, se colocar 1 ele será totalmente visível. Ex.: 0
		pontos -> valor a ser adicionado ou subtraido da pontuação do marcador. Ex.: 1
		som -> nome do arquivo de som + extenção, que será  reproduzido quando o sensor for acionado. Ex.: "ganhouPontos.mp3"
     retorno:
		objeto -> o próprio sensor.
]]
function criarSensorDePontos(marcadorDePontos,X,Y,comprimento,altura,rot,alpha,pontos,som)
	-- primeiramente estamos verificando se os argumentos da função estão preenchidos.
	-- caso não estejam, é colocado um valor padrão para os mesmos.
	-- Ex.: "local posX = X or 0" -> está verificando se existe um valor em X (se é nil ou não), senão coloca o valor 0 na variável posX.
	local posX = X or 0
	local posY = Y or 0
	local comp = comprimento or 50
	local alt = altura or 10
	local rotacao = rot or 0
	local nAlpha = alpha or 1
	local pontosAux = pontos or 0
	
	-- aqui verificamos se existe um marcadorDePontos. 
	if marcadorDePontos then
		local sensor = display.newRect(posX,posY,comp,alt)
		sensor.rotation = rotacao
		sensor.alpha = nAlpha
		-- aqui, na hora de criar a física do sensor, colocamos isSensor = true, que faz com que o sensor
		-- vire um sensor e os objetos possam passar através dele e mesmo assim a função de colisão ser acionada.
		physics.addBody(sensor,"static",{isSensor = true})
		
		somAoColidir(sensor,som)
		-- atualiza-se aqui qual valor será adicionado ou reduzido da pontuação do marcador.
		marcadorDePontos.novoValor = pontosAux
		-- agora acionamos uma função criada no marcador, que irá atualizar o valor mostrado no mesmo, de acordo com o 
		-- valor da variável pontosAux (marcadorDePontos.novoValor)
		sensor:addEventListener("collision",marcadorDePontos.atualizarValorMarcador)
		
		return sensor
	end
end

--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--
--xxxxxxxxxxxxxxxxxx restart xxxxxxxxxxxxxxxxxxxxxxxxxx--
--[[ 
     Resumo:
	    Esta função é usada para remover todos os objetos e cancelar todos os timers adicionados. Ao mesmo tempo que executa uma função
		específica logo após as remoções.
		Então ela reseta todos esses elementos no intuito de que sejam criados novamente através dessa função específica.
		Ela cria um botão que deve estar dentro e no final da função a ser executada, para que o mesmo seja criado novamente após a remoção.
     entrada:
		imagemBotao -> imagem a ser usada como botão de restart. Ex.: "restart.png"
        posX -> posição do botão no eixo x (ponto de referência no centro). Ex: 600
		posY -> posição do botão no eixo y (ponto de referência no centro). Ex: 100
		vetorImagens -> vetor contendo todos os objetos (imagens ou grupos de imagens) criados dentro da função. Ex.: {bolas,cestaFrente,cestaLado}
		vetorTimers -> vetor contendo todos os timers criados dentro da função. Ex.: {timerCriandoBolas,timerAumentandoPontos}
		funcaoStart -> a função a ser executada após as remoções
     retorno:
		objeto -> o próprio botão (para podermos alterar externamente a sua dimensão, posição, etc).
]]
function restart(imagemBotao,posX,posY,vetorImagens,vetorTimers,funcaoStart)
	local botaodeRestart = display.newImage(imagemBotao,posX,posY)
	local function restartarOApp()
		local loop = {}
		-- #vetorImagens -> é o tamanho do vetor "vetorImagens", está verificando se ele possui algum elemento
		if #vetorImagens > 0 then
			function loop.imagensAux(i,maxCount)
				if vetorImagens[i] then
					-- :removeSelf() -> essa função, aplicada em um objeto, irá remover o objeto atribuído. No caso: vetorImagens[i].
					vetorImagens[i]:removeSelf()
					vetorImagens[i] = nil
				end
				loop.imagens(i+1,maxCount)
			end
			function loop.imagens(cont,maxCount)
				if cont <= maxCount then
					loop.imagensAux(cont,maxCount) 
				end
			end
			
			loop.imagens(1,#vetorImagens)
		end
		-- #vetorTimers -> é o tamanho do vetor "vetorTimers", está verificando se ele possui algum elemento
		if #vetorTimers > 0 then
			function loop.timersAux(i,maxCount)
				if vetorTimers[i] then
					timer.cancel(vetorTimers[i])
					vetorTimers[i] = nil
				end
				loop.timers(i+1,maxCount)
			end
			function loop.timers(cont,maxCount)
				if cont <= maxCount then
					loop.timersAux(cont,maxCount) 
				end
			end
			loop.timers(1,#vetorTimers)
		end
		
		botaodeRestart:removeSelf()
		timer.performWithDelay(10,funcaoStart,1)
	end
	botaodeRestart:addEventListener("tap",restartarOApp)
	return botaodeRestart
end
