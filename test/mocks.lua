local noop = function() end

function eeShipTemplateBasedMock()
    local callSign = Util.randomUuid()
    local isValid = true

    return {
        getCallSign = function() return callSign end,
        isValid = function() return isValid end,
        destroy = function() isValid = false end,
        setCommsScript = noop,
    }
end

function eeStationMock()
    local mock = eeShipTemplateBasedMock()
    mock.typeName = "SpaceStation"
    return mock
end

function eeCpuShipMock()
    local mock = eeShipTemplateBasedMock()
    mock.typeName = "CpuShip"
    return mock
end

function eePlayerMock()
    local callSign = Util.randomUuid()

    return {
        typeName = "PlayerSpaceship",
        getCallSign = function() return callSign end,
        isValid = function() return true end,
        addCustomButton = noop,
        addCustomMessage = noop,
    }
end

function personMock()
    return {
        getFormalName = function() return "Johnathan Doe" end,
        getNickName = function() return "John" end
    }
end

function missionMock()
    return Mission:new()
end

function missionWithBrokerMock(broker, player)
    local mission = missionMock()
    Mission:withBroker(mission, "Hello World")
    mission:setPlayer(player or eePlayerMock())
    mission:setMissionBroker(broker or eeStationMock())

    return mission
end

function acceptedMissionWithBrokerMock(broker, player)
    local mission = missionWithBrokerMock(broker, player)
    mission:accept()
    return mission
end

function declinedMissionWithBrokerMock(broker, player)
    local mission = missionWithBrokerMock(broker, player)
    mission:decline()
    return mission
end

function startedMissionWithBrokerMock(broker, player)
    local mission = acceptedMissionWithBrokerMock(broker, player)
    mission:start()
    return mission
end

function failedMissionWithBrokerMock(broker, player)
    local mission = startedMissionWithBrokerMock(broker, player)
    mission:fail()
    return mission
end

function successfulMissionWithBrokerMock(broker, player)
    local mission = startedMissionWithBrokerMock(broker, player)
    mission:success()
    return mission
end

function commsScreenMock()
    return Comms.screen("Hi there, stranger.")
end
function commsScreenReplyMock()
    return Comms.reply("Click me", nil)
end

function narrativeMock(name)
    return {
        name = name or Util.randomUuid()
    }
end