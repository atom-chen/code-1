
FrameQueue = class("FrameQueue")

--间隔执行队列里面的数据
function FrameQueue:ctor(delay)
    self._queue = Queue.new()
    self._isRuning = false
    
    self._delay = delay or 0.3
end

function FrameQueue:finalize()
    TimerManager:remove(self.pop, self)
    self._isRuning = false
    self._queue:clear()
end

function FrameQueue:clear()
    self._queue:clear()
end

function FrameQueue:push(data)
    self._queue:push(data)
    
    if self._isRuning == false then
        self:run()
    end
end

function FrameQueue:pushParams(func, obj, ...)
    local data = {}
    data["obj"] = obj
    data["func"] = func
    data["args"] = {...}
    data["isParam"] = true
    self:push(data)
end

function FrameQueue:run()
   
    if self._isRuning ~= true then
        self:pop()
        TimerManager:add(self._delay * 1000, self.pop, self, -1)
    end
    
    self._isRuning = true
end

function FrameQueue:pop()
--    coroutine.yield(self._delay * 30)
    local data = self._queue:pop()
    if data ~= nil then
        local obj = data["obj"]
        local func = data["func"]
--        local args = data["args"]
        if data["isParam"] == true then
            func(obj, unpack(data["args"]))
        else
            func(obj, data["args"])
        end
        
    end
    
    --TODO有问题
     
    if self._queue:empty() == true then --队列是空的
        self._isRuning = false
        TimerManager:remove(self.pop, self)
    else
--        self:run()
    end
end