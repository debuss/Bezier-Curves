--- Bezier Curve Class
--  @author debuss-a

BezierCurve = {}
BezierCurve.__index = BezierCurve

--- Create a new Bezier Curve instance
-- @param s Start point coordinate in the form : {x, y}
-- @param f Finish point coordinate in the form : {x, y}
-- @return BezierCurve instance
function BezierCurve.new(s, f)
  local self = setmetatable({}, BezierCurve)

  -- Points
  --- start
  self.start = {x = s[1], y = s[2]}
  self.finish = {x = f[1], y = f[2]}
  self.control_points = {}

  -- Controls
  self.grabbable = true
  self.visible = true

  -- Drawing
  self.precision = 0.1
  self.points_color = {0, 0, 255}
  self.control_points_size = 30
  self.control_points_color = {255, 0, 0}

  return self
end

--- Add a control point to the curve
-- @param self Instance
-- @param control_point Control point coordinate in the form : {x, y}
function BezierCurve.setControlPoint(self, control_point)
  table.insert(self.control_points, {x = control_point[1], y = control_point[2]})
end

--- Set the precision of the curve
-- @param self Instance
-- @param precision Precision betwen 0 and 1<br>Default is 0.1
function BezierCurve.setPrecision(self, precision)
  if precision > 0 and precision <= 1 then
    self.precision = precision
  end
end

--- Set the start and end point color of the bezier curve<br>
-- These points need to be set as visible
-- @param self Instance
-- @param r Red
-- @param g Green
-- @param b Bleu
function BezierCurve.setPointsColor(self, r, g, b)
  self.points_color = {r, g, b}
end

--- Set the control points color of the bezier curve<br>
-- These points need to be set as visible
-- @param self Instance
-- @param r Red
-- @param g Green
-- @param b Bleu
function BezierCurve.setControlPointsColor(self, r, g, b)
  self.control_points_color = {r, g, b}
end

--- Set start, finish and control points draggability
-- @param self Instance
-- @param drag True or false
function BezierCurve.setDragged(self, drag)
  self.grabbable = drag
end

--- Set control points visibility
-- @param self Instance
-- @param visible True or false
function BezierCurve.setVisible(self, visible)
  self.visible = visible
end

--- Draw the bezier curve on screen
-- @param self Instance
function BezierCurve.draw(self)
  local px = self.start.x
  local py = self.start.y
  local function lerp(a, b, t)
    local x = a.x + (b.x - a.x) * t
    local y = a.y + (b.y - a.y) * t
    return {["x"] = x, ["y"] = y}
  end
  local function compute(loop, t)
    local to_return = {}
    for i, pt in pairs(loop) do
      if loop[i + 1] ~= nil then
        table.insert(to_return, lerp(pt, loop[i + 1], t))
      end
    end
    return to_return
  end

  if #self.control_points > 0 then
    for t = 0, 1, self.precision do
      local step = {}
      table.insert(step, lerp(self.start, self.control_points[1], t))
      for i, pt in pairs(self.control_points) do
        if self.control_points[i + 1] ~= nil then
          table.insert(step, lerp(pt, self.control_points[i + 1], t))
        end
      end
      table.insert(step, lerp(self.control_points[#self.control_points], self.finish, t))
      while #step > 1 do
        step = compute(step, t)
      end
      step = step[1]
      love.graphics.line(px, py, step.x, step.y)
      px = step.x
      py = step.y
    end
    love.graphics.line(px, py, self.finish.x, self.finish.y)

    if self.visible then
      love.graphics.setColor(self.control_points_color)
      for k, pt in pairs(self.control_points) do
        love.graphics.rectangle("fill", pt.x - self.control_points_size / 2, pt.y - self.control_points_size / 2, self.control_points_size, self.control_points_size)
        love.graphics.print(k, pt.x - 30, pt.y - 10)
      end
    end
  else
    love.graphics.line(self.start.x, self.start.y, self.finish.x, self.finish.y)
  end

  if self.visible then
    love.graphics.setColor(self.points_color)
    love.graphics.circle("line", self.start.x, self.start.y, self.control_points_size, 100)
    love.graphics.circle("line", self.finish.x, self.finish.y, self.control_points_size, 100)
    love.graphics.reset()
  end
end

--- Update bezier curve
-- @param self Instance
-- @param dt Delta Time
function BezierCurve.update(self, dt)
  local mousex, mousey = love.mouse.getPosition()

  love.mouse.setCursor()

  if (mousex - self.start.x) ^ 2 + (mousey - self.start.y) ^ 2 < self.control_points_size ^ 2 then
    love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
    if love.mouse.isDown(1) then
      self.start.x = mousex
      self.start.y = mousey
    end
  elseif (mousex - self.finish.x) ^ 2 + (mousey - self.finish.y) ^ 2 < self.control_points_size ^ 2 then
    love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
    if love.mouse.isDown(1) then
      self.finish.x = mousex
      self.finish.y = mousey
    end
  else
    local control_point_size_diff = self.control_points_size / 2
    for i, pt in pairs(self.control_points) do
      if mousex >= pt.x - control_point_size_diff and mousex <= pt.x + control_point_size_diff and mousey >= pt.y - control_point_size_diff and mousey <= pt.y + control_point_size_diff then
        love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
        if love.mouse.isDown(1) then
          pt.x = mousex
          pt.y = mousey
        end
        break
      end
    end
  end
end
