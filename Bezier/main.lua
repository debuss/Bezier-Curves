--
-- @author debuss-a
--

require "bezier_curve"

function                                love.load()
  love.window.setIcon(love.image.newImageData('chart_curve.png'))

  bz = BezierCurve.new({100, 300}, {700, 300});
  bz:setControlPoint({300, 500})
  bz:setControlPoint({500, 100})
  bz:setPrecision(0.001)
  bz:setPointsColor(0, 0, 255)
  bz:setControlPointsColor(0, 0, 255)
end

function                                love.draw()
  bz:draw()
end

function                                love.update(dt)
  bz:update(dt)
end

function love.mousereleased(x, y, button)
   if button == 2 then
     bz:setControlPoint({x, y})
   end
end

function                                love.keyreleased(key)
  if key == "escape" then
    love.event.quit();
  end
end
