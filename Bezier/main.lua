--
-- @author debuss-a
--

require "bezier_curve"

function                                love.load()
  love.window.setIcon(love.image.newImageData('chart_curve.png'))
  
--  bz1 = BezierCurve.new({420, 40}, {120, 160})
--  bz1:setControlPoint({300, 220})
--  bz1:setControlPoint({220, 260})
--  bz1:setControlPoint({120, 240})
--  bz1:setControlPoint({35, 220})
--  bz1:setPrecision(0.1)
  
  bz2 = BezierCurve.new({100, 100}, {700, 100})
  bz2:setControlPoint({300, 100})
  bz2:setControlPoint({500, 100})
  bz2:setPrecision(0.01)
  bz2:setPointsColor(0, 255, 255)
  bz2:setControlPointsColor(0, 255, 255)
  
  bz3 = BezierCurve.new({100, 200}, {700, 200})
  bz3:setControlPoint({300, 200})
  bz3:setControlPoint({500, 200})
  bz3:setPrecision(0.01)
  bz3:setPointsColor(255, 0, 255)
  bz3:setControlPointsColor(255, 0, 255)
end

function                                love.draw()
--  bz1:draw()
  bz2:draw()
  bz3:draw()
end

function                                love.update(dt)
--  bz1:update(dt)
  bz2:update(dt)
  bz3:update(dt)
end

function                                love.textinput(t)
  
end

function                                love.keypressed(key, unicode)
end

function                                love.keyreleased(key)
  if key == "escape" then
    love.event.quit();
  end
end

function                                love.resize(w, h)
end