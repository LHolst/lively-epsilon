-- this file includes the whole library
--
-- it tries to handle dependencies and makes sure higher order modules are included
-- before modules that depend on it.

local myPackages = {
    "src/lively_epsilon/cron.lua",
    "src/lively_epsilon/util.lua",
    "utils.lua",
    "src/lively_epsilon/utility/ee.lua",
    "src/lively_epsilon/utility/log.lua",
    "src/lively_epsilon/utility/lua.lua",
    "src/lively_epsilon/utility/traits.lua",
    "src/lively_epsilon/utility/comms.lua",

    "src/lively_epsilon/domain/product.lua",
    "src/lively_epsilon/domain/person.lua",
    "src/lively_epsilon/domain/player.lua",

    "src/lively_epsilon/domain/trait/shipTemplateBased/storage_rooms.lua",
    "src/lively_epsilon/domain/trait/shipTemplateBased/comms.lua",

    "src/lively_epsilon/domain/station.lua",
    "src/lively_epsilon/domain/trait/station/merchant.lua",
    "src/lively_epsilon/comms/merchant.lua",
    "src/lively_epsilon/domain/trait/station/missions.lua",
    "src/lively_epsilon/comms/missions.lua",
    "src/lively_epsilon/domain/trait/station/production.lua",

    "src/lively_epsilon/domain/ship.lua",
    "src/lively_epsilon/domain/trait/ship/crew.lua",
    "src/lively_epsilon/domain/trait/ship/miner.lua",
    "src/lively_epsilon/domain/trait/ship/patrol.lua",
    "src/lively_epsilon/domain/trait/ship/trader.lua",

    "src/lively_epsilon/chit_chat.lua",

    "src/lively_epsilon/missions/side_missions.lua",
    "src/lively_epsilon/missions/generator.lua",
    "src/lively_epsilon/missions/generator_transport.lua",

    "resources/personNames.lua",
    "resources/products.lua"
}

if package ~= nil and package.path ~= nil then
    -- when running tests

    for _, package in pairs(myPackages) do
        local name = package:match("^(.+).lua$")

        require(name)
    end
else
    -- within empty epsilon

    for _, package in pairs(myPackages) do
        require(package)
    end
end




