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