function love.load()
	background = love.graphics.newImage("Images/vietnambackground.png")
	enemies = {
		{ x = 400, y = 400, health = 100, knockedback = false, knockbacktime = 0, height = 10, width = 10 },
		{ x = 500, y = 400, health = 100, knockedback = false, knockbacktime = 0, height = 10, width = 10 },
		{ x = 600, y = 400, health = 100, knockedback = false, knockbacktime = 0, height = 10, width = 10 }
	}
	mothuel = love.graphics.newImage("Images/mothuel.png")
	cursor = love.graphics.newImage("Images/cursor.png")
	playershots = {}
	enemyshots = {}
	love.mouse.setVisible(false)
	font = love.graphics.newFont(15)
	cooldown = 0
	backgroundWorldX = 1600 * -2.5
	backgroundWorldY = 900 * -2.5
	autofire = false
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
	player = { x = 0, y = 0, health = 100 }
	wavecleared = false
	paused = false
	shop = false
	autofirecooldown = 0
	exitButtonWidth = 100
	exitButtonHeight = 50
	exitButtonX = screenWidth - exitButtonWidth - 40
	exitButtonY = screenHeight - exitButtonHeight - 40
	debugMenu = false
	debugMenuCooldown = 0
	spawnTimer = 1
end
function enemyspawn()
	local spawnDistance = math.random(300, 500)
	local angle = math.random() * 2 * math.pi
	local spawnX = player.x + math.cos(angle) * spawnDistance
	local spawnY = player.y + math.sin(angle) * spawnDistance
	table.insert(enemies, { x = spawnX, y = spawnY, health = 100, knockedback = false, knockbacktime = 0, height = 10, width = 10 })
end
function enemymove(enemy, dt)
	if not paused then
		local dx = player.x - (enemy.x + 35)
		local dy = player.y - (enemy.y + 35)
		local distance = math.sqrt(dx * dx + dy * dy)
		if enemy.knockedback then
			enemy.x = enemy.x + enemy.knockbackDirectionX * 400 * dt
			enemy.y = enemy.y + enemy.knockbackDirectionY * 400 * dt
			enemy.knockbacktime = enemy.knockbacktime - dt
			if enemy.knockbacktime <= 0 then
				enemy.knockedback = false
			end
		elseif distance > 0 and enemy.height == 70 then
			enemy.x = enemy.x + (dx / distance) * 80 * dt
			enemy.y = enemy.y + (dy / distance) * 80 * dt
		end
		if enemy.height < 70 then
			enemy.height = enemy.height + 20 * dt
			enemy.width = enemy.width + 20 * dt
			if enemy.height > 70 then
				enemy.height = 70
			end
			if enemy.width > 70 then
				enemy.width = 70
			end
		end
	end
end

function love.mousepressed(mouseX, mouseY, button)
	if not paused and button == 1 and cooldown <= 0 and autofire == false then
		cooldown = .5
		local sourceX = love.graphics.getWidth() / 2
		local sourceY = love.graphics.getHeight() / 2
		local deltaX = mouseX - sourceX
		local deltaY = mouseY - sourceY
		local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
		local directionX, directionY = 0, 0
		if distance > 0 then
			directionX = deltaX / distance
			directionY = deltaY / distance
		end
		table.insert(playershots, {
			x = player.x,
			y = player.y,
			damage = 100,
			directionX = directionX,
			directionY = directionY,
			lifetime = 1.5
		})
	end
	if shop and not debugMenu then
		if mouseX >= exitButtonX and mouseX <= exitButtonX + exitButtonWidth and mouseY >= exitButtonY and mouseY <= exitButtonY + exitButtonHeight then
			shop = false
			paused = false
			enemyspawn()
		end
	end
	if debugMenu then
		if mouseX >= 10 and mouseX <= 10 + font:getWidth("Kill em all") * 1.5 + 20 and mouseY >= 50 and mouseY <= 50 + font:getHeight("Kill em all") * 1.5 + 20 then
			for _, enemy in ipairs(enemies) do
				enemy.health = 0
			end
		end
		if mouseX >= 10 and mouseX <= 10 + font:getWidth("Spawn Enemy") * 1.5 + 20 and mouseY >= 50 + font:getHeight("Kill em all") * 1.5 + 30 and mouseY <= 50 + font:getHeight("Kill em all") * 1.5 + 30 + font:getHeight("Spawn Enemy") * 1.5 + 20 then
			enemyspawn()
		end
	end
end
function love.draw()
	squareSize = 75
	squareX = (screenWidth - squareSize) / 2
	squareY = (screenHeight - squareSize) / 2
	imageScale = math.min(squareSize / mothuel:getWidth(), squareSize / mothuel:getHeight())
	 imageWidth = mothuel:getWidth() * imageScale
	 imageHeight = mothuel:getHeight() * imageScale
	local bgScreenX = backgroundWorldX - player.x + screenWidth / 2
	local bgScreenY = backgroundWorldY - player.y + screenHeight / 2
	love.graphics.draw(background, bgScreenX, bgScreenY, 0, 50, 50)	
	if not paused then
		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle("fill", squareX, squareY, squareSize, squareSize)	
		love.graphics.draw(mothuel, squareX + (squareSize - imageWidth) / 2, squareY + (squareSize - imageHeight) / 2, 0, imageScale, imageScale)
	end
	-- health bar
	love.graphics.setColor(1, 0, 0)
	love.graphics.rectangle("fill", screenWidth - 20 - 300, 10, 300 * (player.health / 100), 60)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle ("line", screenWidth - 20 - 300, 10, 300, 60)
	love.graphics.setColor(1, 1, 1)
	function drawenemy(enemy)
		if enemy.health > 0 then
			local screenX = enemy.x - player.x + screenWidth / 2
			local screenY = enemy.y - player.y + screenHeight / 2
			love.graphics.setColor(0, 1, 0)
			love.graphics.rectangle("fill", screenX, screenY, enemy.width, enemy.height)
			love.graphics.setColor(0, 0, 0)
			love.graphics.setFont(font)
			love.graphics.print(tostring(enemy.health), screenX, screenY)
		end
	end
	if not paused then
		for _, shot in ipairs(playershots) do
			local screenX = shot.x - player.x + screenWidth / 2
			local screenY = shot.y - player.y + screenHeight / 2
			love.graphics.circle("fill", screenX, screenY, 12)
		end
	end

	love.graphics.setColor(0, 0, 0)
	love.graphics.print(tostring(player.health), screenWidth - 300, 10, 0, 4, 4)
	if not paused then
		love.graphics.print(tostring(player.x), 10, 10)
		love.graphics.print(tostring(player.y), 10, 30)
	end

	for _, enemy in ipairs(enemies) do
		drawenemy(enemy)
	end
		if shop then
		local function drawExitButton()
			love.graphics.setColor(1, 0, 0)
			love.graphics.rectangle("fill", exitButtonX, exitButtonY, exitButtonWidth, exitButtonHeight)
			love.graphics.setColor(1, 1, 1)
			love.graphics.print("Exit", exitButtonX + 25, exitButtonY + 15, 0, 1.5, 1.5)
			love.graphics.setColor(0, 0, 0)
		end
		local function drawShopLabel(label, x, y, scale)
			local shopbuttonWidth = screenWidth / 4
			local shopbuttonHeight = font:getHeight() * scale
			love.graphics.setColor(1, 1, 1)
			love.graphics.rectangle("fill", x - 10, y - 8, shopbuttonWidth + 20, shopbuttonHeight + 16)
			love.graphics.setColor(0, 0, 0)
			love.graphics.print(label, x, y, 0, scale, scale)
		end
		local function drawArtifactLabel(labelnumber)
			local artifactLabelWidth = screenWidth / 6
			local artifactLabelHeight = screenHeight / 2.2
			love.graphics.setColor(1, 1, 1)
			love.graphics.rectangle("fill", (labelnumber - 1) * (screenWidth / 6 + 40) + screenWidth / 3, 160, artifactLabelWidth, artifactLabelHeight)
			love.graphics.setColor(0, 0, 0)
		end
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 30, 30, screenWidth - 60, screenHeight - 60)
		love.graphics.setColor(1, 1, 1)
		drawShopLabel("Shop", screenWidth / 2 - 90, 40, 3) 
		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle("line", 30, 30, screenWidth - 60, screenHeight - 60)
		drawArtifactLabel(1)
		drawArtifactLabel(2)
		drawArtifactLabel(3)
		drawShopLabel("Damage()", 40, 40, 2)
		drawShopLabel("Reload()", 40, 40 + (screenHeight - 80) / 8, 2)
		drawShopLabel("Speed()", 40, 40 + 2 * (screenHeight - 80) / 8, 2)
		drawShopLabel("Bullet Speed()", 40, 40 + 3 * (screenHeight - 80) / 8, 2)
		drawShopLabel("Health()", 40, 40 + 4 * (screenHeight - 80) / 8, 2)
		drawShopLabel("Luck()", 40, 40 + 5 * (screenHeight - 80) / 8, 2)
		drawShopLabel("Bullet Penetration()", 40, 40 + 6 * (screenHeight - 80) / 8, 2)
		drawShopLabel("Artifact Strength()", 40, 40 + 7 * (screenHeight - 80) / 8, 2)
		drawExitButton()
	end
	if debugMenu then
		local function drawDebugButton(label, x, y)
			local labelWidth = font:getWidth(label) * 1.5 + 20
			local labelHeight = font:getHeight(label) * 1.5 + 20
			love.graphics.setColor(1, 1, 1)
			love.graphics.rectangle("fill", x, y, labelWidth, labelHeight)
			love.graphics.setColor(0, 0, 0)
			love.graphics.print(label, x + 10, y + 10, 0, 1.5, 1.5)
		end
		drawDebugButton("Kill em all", 10, 50)
		drawDebugButton("Spawn Enemy", 10, 50 + font:getHeight("Kill em all") * 1.5 + 30)
		drawDebugButton(tostring(#enemies) .. " Enemies", 10, 50 + 2 * (font:getHeight("Kill em all") * 1.5 + 30))
		love.graphics.setColor(0, 0, 0)
		local debugMenuTitleHeight = font:getHeight("Dev Menu")
		local debugMenuTitleWidth = font:getWidth("Dev Menu") 
		love.graphics.rectangle("fill", 0, 0, debugMenuTitleWidth * 2 + 20, debugMenuTitleHeight * 2 + 20)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("Dev Menu", 10, 10, 0, 2, 2)
		love.graphics.setColor(0, 0, 0)
	end
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(cursor, mouseX, mouseY, 0, 0.12, 0.12, cursor:getWidth() / 2, cursor:getHeight() / 2)
end

function love.update(dt)
	mouseX, mouseY = love.mouse.getPosition()
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
	if not paused and love.keyboard.isDown("1") and not autofire and autofirecooldown <= 0 then autofire = true autofirecooldown = 1 end
	if not paused and love.keyboard.isDown("1") and autofire and autofirecooldown <= 0 then autofire = false autofirecooldown = 1 end
	autofirecooldown = autofirecooldown - dt
	debugMenuCooldown = debugMenuCooldown - dt
	if not paused and cooldown <= 0 and autofire == true then
		cooldown = .5
		local sourceX = love.graphics.getWidth() / 2
		local sourceY = love.graphics.getHeight() / 2
		local deltaX = mouseX - sourceX
		local deltaY = mouseY - sourceY
		local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
		local directionX, directionY = 0, 0
		if distance > 0 then
			directionX = deltaX / distance
			directionY = deltaY / distance
		end
		table.insert(playershots, {
			x = player.x,
			y = player.y,
			directionX = directionX,
			directionY = directionY,
			lifetime = 1.5,
			damage = 100
		})
	end
	for _, enemy in ipairs(enemies) do
		enemymove(enemy, dt)
	end
	if spawnTimer <= 0 and not paused and not debugMenu then
		enemyspawn()
		spawnTimer = math.random(0.00000001, .1)
	else
		spawnTimer = spawnTimer - dt
	end
	local moveX, moveY = 0, 0
	if not paused and love.keyboard.isDown("w") then moveY = moveY - 1 end
	if not paused and love.keyboard.isDown("s") then moveY = moveY + 1 end
	if not paused and love.keyboard.isDown("a") then moveX = moveX - 1 end
	if not paused and love.keyboard.isDown("d") then moveX = moveX + 1 end

	local moveLength = math.sqrt(moveX * moveX + moveY * moveY)
	if moveLength > 0 then
		local moveSpeed = 300 * dt
		player.x = player.x + moveX / moveLength * moveSpeed
		player.y = player.y + moveY / moveLength * moveSpeed
	end

	if love.keyboard.isDown("escape") then		
		if not debugMenu and debugMenuCooldown <= 0 then
			debugMenu = true
			debugMenuCooldown = 0.5
		elseif debugMenu and debugMenuCooldown <= 0 then
			debugMenu = false
			debugMenuCooldown = 0.5
		end
		
	end

	cooldown = cooldown - dt
	for _, enemy in ipairs(enemies) do
		local playerHalfSize = 75 / 2
		if not paused and enemy.health > 0
			and player.x - playerHalfSize < enemy.x + 70
			and player.x + playerHalfSize > enemy.x
			and player.y - playerHalfSize < enemy.y + 70
			and player.y + playerHalfSize > enemy.y
			and not enemy.knockedback then
			player.health = player.health - 10
			enemy.knockedback = true
			enemy.knockbacktime = 0.5
			local knockbackX = enemy.x + 35 - player.x
			local knockbackY = enemy.y + 35 - player.y
			local knockbackLength = math.sqrt(knockbackX * knockbackX + knockbackY * knockbackY)
			if knockbackLength > 0 then
				enemy.knockbackDirectionX = knockbackX / knockbackLength
				enemy.knockbackDirectionY = knockbackY / knockbackLength
			else
				enemy.knockbackDirectionX = 1
				enemy.knockbackDirectionY = 0
			end
		end
	end
	local playershotSpeed = 500
	for index = #playershots, 1, -1 do
		local playershot = playershots[index]
		playershot.lifetime = playershot.lifetime - dt
		if playershot.lifetime <= 0 then
			table.remove(playershots, index)
		else
			playershot.x = playershot.x + playershot.directionX * playershotSpeed * dt
			playershot.y = playershot.y + playershot.directionY * playershotSpeed * dt
			for _, enemy in ipairs(enemies) do
				if enemy.health > 0
					and playershot.x >= enemy.x and playershot.x <= enemy.x + 70
					and playershot.y >= enemy.y and playershot.y <= enemy.y + 70 then
					enemy.health = enemy.health - playershot.damage
					table.remove(playershots, index)
					break
				end
			end
		end
	end
	wavecleared = true
	for _, enemy in ipairs(enemies) do
		if enemy.health > 0 then
			wavecleared = false
			break
		end
	end

	paused = wavecleared
	shop = wavecleared
end