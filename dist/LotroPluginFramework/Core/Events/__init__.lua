__LPF_CLASSES__.Events = class()

function __LPF_CLASSES__.Events:Constructor()
    return self
end

--[[
    Safely add a listener without overwriting any existing ones
]]
function __LPF_CLASSES__.Events:AddListener(object, event, callback)
    if object[event] == nil then
        object[event] = callback
    else
        if type(object[event]) == "table" then
            table.insert(object[event], callback)
        else
            object[event] = { object[event], callback }
        end
    end
    return callback
end

--[[
    Safely remove a listener without clobbering any extras
]]
function __LPF_CLASSES__.Events:RemoveListener(object, event, callback)
    if object[event] == callback then
        object[event] = nil
    else
        if type(object[event]) == "table" then
            local size = #object[event]
            for i = 1, size do
                if object[event][i] == callback then
                    table.remove(object[event], i)
                    break
                end
            end
        end
    end
end

--[[
    Safely execute a listener whether it be an array of functions or a single one
]]
function __LPF_CLASSES__.Events:ExecuteListener(object, event, args)
    if type(object[event]) == "function" then
        object[event](object, args)
    else
        if type(object[event]) == "table" then
            local size = #object[event]
            for i = 1, size do
                if type(object[event][i]) == "function" then
                    object[event][i](object, args)
                end
            end
        end
    end
end