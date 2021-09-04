local composer = require("composer"); 
local data = require("data")
composer.removeScene("scenes.menu")
composer.removeScene("scenes.game_over")
local scene = composer.newScene(); 
local json = require("json")
timer.resumeAll()

function scene:create(event)
	local sceneGroup = self.view;

	settings = loadSettings("settings.json"); -- загружаем параметры из файла
	
	if (settings) then
		record = settings.record;
	end

	local physics = require("physics")
	physics.start()
	physics.setGravity(0, 0)

	score = 0
	health = data.params.hp


	local audio1 = audio.loadSound( "sounds/soundtrack.mp3")

	--Plays the audio on any available channel (theres up to 32 channels)
	local audio1Channel = audio.play( audio1 , {loops = -1})

	local back = display.newImageRect("images/back.png", 1200,800)

	Obj = display.newImageRect( "images/scale_1200.png", 75, 75)
	Obj.x = 160
	Obj.y = 283
	physics.addBody( Obj, "dinamic", {isSensor = true})
	Obj.ID = "Obj"

	local win = display.newText("", display.contentCenterX, 50, native.systemFont, 20)
	win:setFillColor(65/255, 105/255, 238/255)
	local scoreText = display.newText("Пельменей съедено: 0", 70, 50)
	scoreText:setFillColor(65/255, 105/255, 238/255)
	local healthText = display.newText("Жизни: " .. health, 470, 50)
	healthText:setFillColor(65/255, 105/255, 238/255)
	local recor = display.newText("Рекорд: ".. record, 26, 80)
	recor:setFillColor(65/255, 105/255, 238/255)

	local function checkPelmen()
		if (score > record) then
			win.text = "Новый рекорд!"
			win:setFillColor(255, 165, 0)
			settings = {};
			settings.record = score;
			saveSettings(settings, "settings.json");

		end

		


	end

	local function spawnPelmen(args)
		local y = math.random(30, 80)
		local x = math.random(0, 480)
		local pelmen = display.newImageRect("images/pelmen.png",50, 40)
		pelmen.x = x
		pelmen.y = y
		physics.addBody( pelmen, "dinamic", {isSensor = true})
		pelmen:setLinearVelocity(0, 50)
		pelmen.rotation = math.random(0, 180)
		local function eat(self, event)
			if (event.phase == "began") then
				if (event.other.ID == "Obj") then
					score = score +1
					checkPelmen()
					scoreText.text = "Пельменей съедено: " .. score
					self:removeSelf()
					local nam = audio.loadSound( "sounds/eat-pelmen.mp3"  )
					local namChannel = audio.play( nam, {duration=1500} )
				end
			end
		end
		pelmen.collision = eat
		pelmen:addEventListener("collision", pelmen)
		sceneGroup:insert(pelmen);
	end

	local function spawnGoldPelmen(args)
		local y = math.random(30, 80)
		local x = math.random(0, 480)
		local pelmenG = display.newImageRect("images/pelmen.png",70, 50)
		pelmenG.x = x
		pelmenG.y = y
		physics.addBody( pelmenG, "dinamic", {isSensor = true})
		pelmenG:setLinearVelocity(0, 70)
		pelmenG.rotation = math.random(0, 180)
		pelmenG:setFillColor(255, 165, 0)
		local function eat(self, event)
			if (event.phase == "began") then
				if (event.other.ID == "Obj") then
					score = score + 5
					health = health + 1
					checkPelmen()
					scoreText.text = "Пельменей съедено: " .. score 
					healthText.text = "Жизни " .. health
					self:removeSelf()
					local nam = audio.loadSound( "sounds/eat-pelmen.mp3"  )
					local namChannel = audio.play( nam, {duration=3000} )
				end
			end
		end
		pelmenG.collision = eat
		pelmenG:addEventListener("collision", pelmen)
		sceneGroup:insert(pelmenG);
	end

	local function checkLive()
		if (health == 0) then
			audio.stop(audio1Channel)
			timer.cancelAll()
			composer.gotoScene("scenes.game_over")
		end
	end


	local function spawnCarrot(args)
		local y = math.random(30, 80)
		local x = math.random(0, 480)
		local carrot = display.newImageRect("images/carrots.png", 90, 30)
		carrot.x = x
		carrot.y = y
		physics.addBody( carrot, "dinamic", {isSensor = true})
		carrot:setLinearVelocity(0, 70)
		carrot.rotation = math.random(0, 180)
		local function eat(self, event)
			if (event.phase == "began") then
				if (event.other.ID == "Obj") then
					health = health - 1
					self:removeSelf()
					checkLive()
					healthText.text = "Жизни " .. health
					local nam = audio.loadSound( "sounds/bee.mp3"  )
					local namChannel = audio.play( nam, {duration=1500} )
				end
			end
		end
		carrot.collision = eat
		carrot:addEventListener("collision", carrot)
		sceneGroup:insert(carrot);
	end

	local function spawnBrocoli(args)
		local y = math.random(30, 80)
		local x = math.random(0, 480)
		local brocoli = display.newImageRect("images/brocoli.png", 50, 50)
		brocoli.x = x
		brocoli.y = y
		physics.addBody( brocoli, "dinamic", {isSensor = true})
		brocoli:setLinearVelocity(0, 70)
		brocoli.rotation = math.random(0, 180)
		local function eat(self, event)
			if (event.phase == "began") then
				if (event.other.ID == "Obj") then
					health = health - 1
					self:removeSelf()
					checkLive()
					healthText.text = "Жизни " .. health
					local nam = audio.loadSound( "sounds/bee2.mp3"  )
					local namChannel = audio.play( nam, {duration=1500} )
				end
			end
		end
		brocoli.collision = eat
		brocoli:addEventListener("collision", brocoli)
		sceneGroup:insert(brocoli);
	end


	local function Move(event)
		transition.moveTo(Obj, {x = event.x, y = x, time=500})
	end



	spawnTimerP = timer.performWithDelay( data.params.pelmenS, spawnPelmen, 0)
	spawnTimerA = timer.performWithDelay( data.params.carrotS, spawnCarrot, 0)
	spawnTimerS = timer.performWithDelay( data.params.brocoliS, spawnBrocoli, 0)
	spawnTimerG = timer.performWithDelay( data.params.goldS, spawnGoldPelmen, 0)


	back:addEventListener("tap", Move)

	sceneGroup:insert(back);
	sceneGroup:insert(healthText);
	sceneGroup:insert(scoreText);
	sceneGroup:insert(Obj);
	sceneGroup:insert(recor);
	sceneGroup:insert(win);

	function saveSettings(t, filename)
		local path = system.pathForFile(filename, system.ResourceDirectory);
		local file = io.open(path, "w");
		if (file) then
			local contents = json.encode(t);
			file:write(contents);
			io.close(file);
			return true
		else
			return false
		end
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


end



scene:addEventListener("create", scene);
return scene;