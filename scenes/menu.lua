local composer = require("composer"); -- вызов библиотеки Composer
local widget = require("widget");
local data = require("data")
local json = require("json")
composer.removeScene("scenes.play")
local scene = composer.newScene(); -- создаём новую сцену

function scene:show(event)
	local sceneGroup = self.view;
	-- наш код здесь

	settings = loadSettings("settings.json"); -- загружаем параметры из файла
	
	if (settings) then
		recordd = settings.record;
	end

	local back = display.newImageRect("images/maxresdefault.jpg", 1200,800)
	local buttons = display.newGroup();
	record = display.newText(buttons, "Record: ".. recordd, 430, 30, native.systemFont, 20);
	real = display.newText(buttons, "Real pelmen", display.contentCenterX, 40, native.systemFont, 30);
	game = display.newText(buttons, "The game", display.contentCenterX, 80, native.systemFont, 47);
	chose = display.newText(buttons, "Выберите уровень сложности", display.contentCenterX, 140, native.systemFont, 27);
	real:setFillColor(65/255, 105/255, 238/255)
	game:setFillColor(65/255, 105/255, 238/255)
	chose:setFillColor(65/255, 105/255, 238/255)
	record:setFillColor(5/255, 255/255, 138/255)
	easyButton = widget.newButton {
		shape = 'roundedRect',
		raidus = 10,
		width = 160, height = 90,
		left = -20, top = 185,
		fontSize = 24,
		fillColor = { default={ 0,0.5,0 }, over={ 0,0.2,0 } },
		labelColor = { default={ 1 }, over={ 1 } },
		label = "Легко",
		onPress =  function(event)
			data.params.hp = 10
			data.params.pelmenS = 3000
			data.params.alcoS = 2500
			data.params.sigaS = 2500
			data.params.goldS = 15000

			composer.gotoScene("scenes.play")
		end
		
	}

	middleButton = widget.newButton {
		shape = 'roundedRect',
		raidus = 10,
		width = 160, height = 90,
		left = 160, top = 185,
		fontSize = 24,
		fillColor = { default={ 0.7,0.3,0 }, over={ 0.4,0.1,0 } },
		labelColor = { default={ 1 }, over={ 1 } },
		label = "Средне",
		onPress =  function(event)
			data.params.hp = 5
			data.params.pelmenS = 5000
			data.params.alcoS = 2000
			data.params.sigaS = 2000
			data.params.goldS = 20000

			composer.gotoScene("scenes.play")
		end
		
	}

	hardButton = widget.newButton {
		shape = 'roundedRect',
		raidus = 10,
		width = 160, height = 90,
		left = 340, top = 185,
		fontSize = 24,
		fillColor = { default={ 0.8,0,0 }, over={ 0.5,0,0 } },
		labelColor = { default={ 1 }, over={ 1 } },
		label = "Сложно",
		onPress =  function(event)
			data.params.hp = 3
			data.params.pelmenS = 7000
			data.params.alcoS = 1800
			data.params.sigaS = 1800
			data.params.goldS = 30000

			composer.gotoScene("scenes.play")
		end
	}
	buttons:insert(easyButton)
	buttons:insert(middleButton)
	buttons:insert(hardButton)
	sceneGroup:insert(back)
	sceneGroup:insert(buttons)
	
end

function loadSettings(filename)
		local path = system.pathForFile(filename, system.ResourceDirectory);
		local contents = "";
		local myTable = {};
		local file = io.open(path, "r");
		if file then
			 local contents = file:read( "*a" );
			 myTable = json.decode(contents);
			 io.close(file);
			 return myTable;
		end
		return nil
	end


scene:addEventListener("show", scene);
return scene;