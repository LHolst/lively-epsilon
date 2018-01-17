Missions = Mission or {}

-- Your mission is to find a station and dock there

-- config:
--   * onVisit
Missions.visit = function(self, station, config)
    if not isEeStation(station) then error("from needs to be a Station, " .. type(station) .. " given.", 2) end
    config = config or {}
    if not isTable(config) then error("Expected config to be a table, but " .. type(config) .. " given.", 2) end

    local cronId = Util.randomUuid()

    local mission
    mission = Mission:new({
        onAccept = config.onAccept,
        onDecline = config.onDecline,
        onStart = function(self)
            if not Mission.isBrokerMission(mission) then error("Mission can not be started, because it is supposed to have been transformed into a broker Mission", 2) end

            if isFunction(config.onStart) then config.onStart(self) end

            Cron.regular(cronId, function()
                if not station:isValid() then self:fail() end
                if mission:getPlayer():isDocked(station) then
                    if isFunction(config.onVisit) then config.onVisit(mission) end
                    self:success()
                end
            end, 0.5)
        end,
        onSuccess = config.onSuccess,
        onFailure = config.onFailure,
        onEnd = function()
            Cron.abort(cronId)

            if isFunction(config.onEnd) then config.onEnd(self) end
        end,
    })
    return mission
end