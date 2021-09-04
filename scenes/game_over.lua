local composer = require("composer"); -- вызов библиотеки Composer
local widget = require("widget");
composer.removeScene("scenes.play")
local scene = composer.newScene(); -- создаём новую сцену
function scene:show(event)
	local sceneGroup = self.view;
	

	local audio1 = audio.loadSound( "wasted.mp3")

	--Plays the audio on any available channel (theres up to 32 channels)
	local audio1Channel = audio.play( audio1 )


	local buttons = display.newGroup();
	gm = display.newText(buttons, "Game Over", display.contentCenterX, 70, "Impact", 87);
	gm:setFillColor(100/255, 0/255, 0/255)
	local back = display.newImageRect("images/maxresdefault.jpg", 1200,800)
	restartButton = widget.newButton {
		shape = 'roundedRect',
		raidus = 10,
		width = 250, height = 80,
		left =  display.contentCenterX-display.contentCenterX/2, top = 220,
		fontSize = 24,
		fillColor = { default={ 0,0.5,0 }, over={ 0,0.2,0 } },
		labelColor = { default={ 1 }, over={ 1 } },
		label = "Начать заново",
		onPress =  function(event)
			composer.gotoScene("scenes.play")
		end
		
	}

	tomenuButton = widget.newButton {
		shape = 'roundedRect',
		raidus = 10,
		width = 250, height = 80,
		left = display.contentCenterX-display.contentCenterX/2, top = 125,
		fontSize = 24,
		fillColor = { default={ 0,0.5,0 }, over={ 0,0.2,0 } },
		labelColor = { default={ 1 }, over={ 1 } },
		label = "Меню",
		onPress =  function(event)
			composer.gotoScene("scenes.menu")
		end
		
	}

	buttons:insert(restartButton)
	buttons:insert(tomenuButton)
	sceneGroup:insert(back)
	sceneGroup:insert(buttons)

end
scene:addEventListener("show", scene);
return scene;