function love.load()
	background = love.graphics.newImage("Images/vietnambackground.png")
	enemies = {
		{ x = 400, y = 400, health = 100, knockedback = false, knockbacktime = 0 },
		{ x = 600, y = 400, health = 100, knockedback = false, knockbacktime = 0 }
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
	-- player.x/y is now the single source of truth for "where are we in the world"
	player = { x = 0, y = 0, health = 100 }
end

function enemymove(enemy, dt)
	-- chase the player's actual world position, not a fixed screen point
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
	elseif distance > 0 then
		enemy.x = enemy.x + (dx / distance) * 80 * dt
		enemy.y = enemy.y + (dy / distance) * 80 * dt
	end
end

function drawenemy(enemy)
	if enemy.health > 0 then
		local screenX = enemy.x - player.x + screenWidth / 2
		local screenY = enemy.y - player.y + screenHeight / 2
		love.graphics.setColor(0, 1, 0)
		love.graphics.rectangle("fill", screenX, screenY, 70, 70)
		love.graphics.setColor(0, 0, 0)
		love.graphics.setFont(font)
		love.graphics.print(tostring(enemy.health), screenX, screenY)
	end
end

function love.mousepressed(mouseX, mouseY, button)
	if button == 1 and cooldown <= 0 and autofire == false then
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
			lifetime = 1.5
		})
	end
end

function love.draw()
	squareSize = 75
	squareX = (screenWidth - squareSize) / 2
	squareY = (screenHeight - squareSize) / 2
	imageScale = math.min(squareSize / mothuel:getWidth(), squareSize / mothuel:getHeight())
	 imageWidth = mothuel:getWidth() * imageScale
	 imageHeight = mothuel:getHeight() * imageScale
	
	-- background converted through the same world->screen transform as everything else
	local bgScreenX = backgroundWorldX - player.x + screenWidth / 2
	local bgScreenY = backgroundWorldY - player.y + screenHeight / 2
	love.graphics.draw(background, bgScreenX, bgScreenY, 0, 50, 50)

	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", squareX, squareY, squareSize, squareSize)
	love.graphics.draw(mothuel, squareX + (squareSize - imageWidth) / 2, squareY + (squareSize - imageHeight) / 2, 0, imageScale, imageScale)
	-- health bar
	love.graphics.setColor(1, 0, 0)
	love.graphics.rectangle("fill", screenWidth - 20 - 300, 10, 300 * (player.health / 100), 60)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle ("line", screenWidth - 20 - 300, 10, 300, 60)
	love.graphics.setColor(1, 1, 1)
	for _, shot in ipairs(playershots) do
		local screenX = shot.x - player.x + screenWidth / 2
		local screenY = shot.y - player.y + screenHeight / 2
		love.graphics.circle("fill", screenX, screenY, 12)
	end

	love.graphics.setColor(0, 0, 0)
	love.graphics.print(tostring(player.x), 10, 10)
	love.graphics.print(tostring(player.y), 10, 30)

	for _, enemy in ipairs(enemies) do
		drawenemy(enemy)
	end


	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(cursor, mouseX, mouseY, 0, 0.12, 0.12, cursor:getWidth() / 2, cursor:getHeight() / 2)
end

function love.update(dt)
	mouseX, mouseY = love.mouse.getPosition()
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
		if love.keyboard.isDown("1") then autofire = true end
	if cooldown <= 0 and autofire == true then
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
			lifetime = 1.5
		})
	end
	for _, enemy in ipairs(enemies) do
		enemymove(enemy, dt)
	end
	local moveX, moveY = 0, 0
	if love.keyboard.isDown("w") then moveY = moveY - 1 end
	if love.keyboard.isDown("s") then moveY = moveY + 1 end
	if love.keyboard.isDown("a") then moveX = moveX - 1 end
	if love.keyboard.isDown("d") then moveX = moveX + 1 end

	local moveLength = math.sqrt(moveX * moveX + moveY * moveY)
	if moveLength > 0 then
		local moveSpeed = 300 * dt
		player.x = player.x + moveX / moveLength * moveSpeed
		player.y = player.y + moveY / moveLength * moveSpeed
	end

	if love.keyboard.isDown("escape") then
		love.event.quit()
	end

	cooldown = cooldown - dt
	for _, enemy in ipairs(enemies) do
		local playerHalfSize = 75 / 2
		if enemy.health > 0
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
					enemy.health = enemy.health - 10
					table.remove(playershots, index)
					break
				end
			end
		end
	end
end