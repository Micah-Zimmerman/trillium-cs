function love.load()
	x = 200
	y = 200
	enemyx = 400
	enemyy = 400
	mothuel = love.graphics.newImage("Images/mothuel.png")
	cursor = love.graphics.newImage("Images/cursor.png")
	shots = {}
	love.mouse.setVisible(false)
	font = love.graphics.newFont(20)
	enemyhealth = 100
	enemyhealthdisplay = tostring(enemyhealth)
	text = "Health: " .. enemyhealthdisplay
	cooldown = 0
end

function love.update(dt)
	local moveX = 0
	local moveY = 0
	if love.keyboard.isDown("w") then
		moveY = moveY + 1
	end
	if love.keyboard.isDown("s") then
		moveY = moveY - 1
	end
	if love.keyboard.isDown("a") then
		moveX = moveX + 1
	end
	if love.keyboard.isDown("d") then
		moveX = moveX - 1
	end
	local moveLength = math.sqrt(moveX * moveX + moveY * moveY)
	if moveLength > 0 then
		local moveSpeed = 10
		enemyx = enemyx + moveX / moveLength * moveSpeed
		enemyy = enemyy + moveY / moveLength * moveSpeed
	end
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
	cooldown = cooldown - dt
	local shotSpeed = 500
	for index = #shots, 1, -1 do
		local shot = shots[index]
		shot.lifetime = shot.lifetime - dt
		if shot.lifetime <= 0 then
			table.remove(shots, index)
		else
			shot.x = shot.x + shot.directionX * shotSpeed * dt
			shot.y = shot.y + shot.directionY * shotSpeed * dt
			if shot.x >= enemyx and shot.x <= enemyx + 100 and shot.y >= enemyy and shot.y <= enemyy + 100 then
				enemyhealth = enemyhealth - 10
				enemyhealthdisplay = tostring(enemyhealth)
				table.remove(shots, index)
			end
		end
	end
	text = "Health: " .. enemyhealthdisplay
end

function love.mousepressed(mouseX, mouseY, button)
	if button == 1 and cooldown <= 0 then
		cooldown = 1
		local sourceX = math.ceil(love.graphics.getWidth() / 2) + 12.5
		local sourceY = math.ceil(love.graphics.getHeight() / 2) + 12.5
		local deltaX = mouseX - sourceX
		local deltaY = mouseY - sourceY
		local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
		local directionX = 0
		local directionY = 0
		if distance > 0 then
			directionX = deltaX / distance
			directionY = deltaY / distance
		end
		table.insert(shots, {
			x = sourceX,
			y = sourceY,
			directionX = directionX,
			directionY = directionY,
			lifetime = 1.5
		})
	end
end

function love.draw()
	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()
	local squareSize = 75
	local squareX = math.ceil(screenWidth / 2) - 25
	local squareY = math.ceil(screenHeight / 2) - 25
	local imageScale = math.min(squareSize / mothuel:getWidth(), squareSize / mothuel:getHeight())
	local imageWidth = mothuel:getWidth() * imageScale
	local imageHeight = mothuel:getHeight() * imageScale

	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", squareX, squareY, squareSize, squareSize)
	love.graphics.draw(mothuel, squareX + (squareSize - imageWidth) / 2, squareY + (squareSize - imageHeight) / 2, 0, imageScale, imageScale)
	if enemyhealth > 0 then
		love.graphics.setColor(0, 1, 0)
		love.graphics.rectangle("fill", enemyx, enemyy, 100, 100)
		love.graphics.setColor(0, 0, 0)
		love.graphics.setFont(font)
		love.graphics.print(text, enemyx, enemyy)
	end
	love.graphics.setColor(1, 1, 1)
	for _, shot in ipairs(shots) do
		love.graphics.circle("fill", shot.x, shot.y, 12)
	end

	-- cursor
	local mouseX, mouseY = love.mouse.getPosition()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(cursor, mouseX, mouseY, 0, 0.12, 0.12, cursor:getWidth() / 2, cursor:getHeight() / 2)
end
