function love.load()
	x = 200
	y = 200
	enemyx = 400
	enemyy = 400
	mothuel = love.graphics.newImage("Images/mothuel.png")
	cursor = love.graphics.newImage("Images/cursor.png")
end

function love.update(dt)
	local key = love.keyboard.isDown("w") and "w" or love.keyboard.isDown("s") and "s" or love.keyboard.isDown("a") and "a" or love.keyboard.isDown("d") and "d" or love.keyboard.isDown("escape") and "escape" or nil
	if key == "w" then
		enemyy = enemyy + 10
	end
	if key == "s" then
		enemyy = enemyy - 10
	end
	if key == "a" then
		enemyx = enemyx + 10
	end
	if key == "d" then
		enemyx = enemyx - 10
	end
	if key == "escape" then
		love.event.quit()
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
	love.graphics.setColor(1, 0, 0)
	love.graphics.rectangle("fill", enemyx, enemyy, 100, 100)
	-- cursor
	local mouseX, mouseY = love.mouse.getPosition()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(cursor, mouseX, mouseY, 0, 0.12, 0.12)
end
