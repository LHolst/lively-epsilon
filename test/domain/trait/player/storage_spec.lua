insulate("Player", function()
    require "lively_epsilon"
    require "test.mocks"

    local product1 = productMock()
    local product2 = productMock()
    local product3 = productMock()

    describe("withStorage()", function()
        it("creates a valid storage", function()
            local player = eePlayerMock()

            Player:withStorage(player)
            assert.is_true(Player:hasStorage(player))
            assert.is_number(player:getMaxStorageSpace())
        end)
        it("allows to configure the maxStorage", function()
            local player = eePlayerMock()

            Player:withStorage(player, {maxStorage = 1000})

            assert.is_true(Player:hasStorage(player))
            assert.is_same(1000, player:getMaxStorageSpace())
        end)
        it("fails if first argument is a number", function()
            assert.has_error(function() Player:withStorage(42) end)
        end)
        it("fails if second argument is a number", function()
            assert.has_error(function() Player:withStorage(eePlayerMock(), 42) end)
        end)
    end)

    describe("getStoredProducts()", function()
        it("returns all the products that are currently stored", function()
            local player = eePlayerMock()
            Player:withStorage(player)

            assert.is_same({}, player:getStoredProducts())

            player:modifyProductStorage(product1, 1)
            assert.is_same(1, Util.size(player:getStoredProducts()))
            assert.contains_value(product1, player:getStoredProducts())

            player:modifyProductStorage(product1, 1)
            assert.is_same(1, Util.size(player:getStoredProducts()))
            assert.contains_value(product1, player:getStoredProducts())

            player:modifyProductStorage(product2, 1)
            assert.is_same(2, Util.size(player:getStoredProducts()))
            assert.contains_value(product2, player:getStoredProducts())

            player:modifyProductStorage(product2, -1)
            assert.is_same(1, Util.size(player:getStoredProducts()))
            assert.contains_value(product1, player:getStoredProducts())
            assert.not_contains_value(product2, player:getStoredProducts())
        end)
    end)

    describe("getProductStorage(), getEmptyProductStorage(), getMaxProductStorage()", function()
        it("returns the correct value", function()
            local player = eePlayerMock()
            Player:withStorage(player, {maxStorage = 100})

            assert.is_same(0, player:getProductStorage(product1))
            assert.is_same(100, player:getMaxProductStorage(product1))
            assert.is_same(100, player:getEmptyProductStorage(product1))
            assert.is_same(0, player:getProductStorage(product2))
            assert.is_same(100, player:getMaxProductStorage(product2))
            assert.is_same(100, player:getEmptyProductStorage(product2))
            assert.is_same(0, player:getProductStorage(product3))
            assert.is_same(100, player:getMaxProductStorage(product3))
            assert.is_same(100, player:getEmptyProductStorage(product3))

            player:modifyProductStorage(product1, 10)

            assert.is_same(10, player:getProductStorage(product1))
            assert.is_same(100, player:getMaxProductStorage(product1))
            assert.is_same(90, player:getEmptyProductStorage(product1))
            assert.is_same(0, player:getProductStorage(product2))
            assert.is_same(90, player:getMaxProductStorage(product2))
            assert.is_same(90, player:getEmptyProductStorage(product2))
            assert.is_same(0, player:getProductStorage(product3))
            assert.is_same(90, player:getMaxProductStorage(product3))
            assert.is_same(90, player:getEmptyProductStorage(product3))

            player:modifyProductStorage(product2, 10)

            assert.is_same(10, player:getProductStorage(product1))
            assert.is_same(90, player:getMaxProductStorage(product1))
            assert.is_same(80, player:getEmptyProductStorage(product1))
            assert.is_same(10, player:getProductStorage(product2))
            assert.is_same(90, player:getMaxProductStorage(product2))
            assert.is_same(80, player:getEmptyProductStorage(product2))
            assert.is_same(0, player:getProductStorage(product3))
            assert.is_same(80, player:getMaxProductStorage(product3))
            assert.is_same(80, player:getEmptyProductStorage(product3))

            player:modifyProductStorage(product2, -5)

            assert.is_same(10, player:getProductStorage(product1))
            assert.is_same(95, player:getMaxProductStorage(product1))
            assert.is_same(85, player:getEmptyProductStorage(product1))
            assert.is_same(5, player:getProductStorage(product2))
            assert.is_same(90, player:getMaxProductStorage(product2))
            assert.is_same(85, player:getEmptyProductStorage(product2))
            assert.is_same(0, player:getProductStorage(product3))
            assert.is_same(85, player:getMaxProductStorage(product3))
            assert.is_same(85, player:getEmptyProductStorage(product3))
        end)
        it("works correctly with sized products", function()
            local product1 = productMock()
            local product2 = productMock()
            local product3 = productMock()
            product1.getSize = function() return 1 end
            product2.getSize = function() return 2 end
            product3.getSize = function() return 4 end

            local player = eePlayerMock()
            Player:withStorage(player, {maxStorage = 100})

            assert.is_same(0, player:getProductStorage(product1))
            assert.is_same(100, player:getMaxProductStorage(product1))
            assert.is_same(100, player:getEmptyProductStorage(product1))
            assert.is_same(0, player:getProductStorage(product2))
            assert.is_same(50, player:getMaxProductStorage(product2))
            assert.is_same(50, player:getEmptyProductStorage(product2))
            assert.is_same(0, player:getProductStorage(product3))
            assert.is_same(25, player:getMaxProductStorage(product3))
            assert.is_same(25, player:getEmptyProductStorage(product3))

            player:modifyProductStorage(product1, 10)

            assert.is_same(10, player:getProductStorage(product1))
            assert.is_same(100, player:getMaxProductStorage(product1))
            assert.is_same(90, player:getEmptyProductStorage(product1))
            assert.is_same(0, player:getProductStorage(product2))
            assert.is_same(45, player:getMaxProductStorage(product2))
            assert.is_same(45, player:getEmptyProductStorage(product2))
            assert.is_same(0, player:getProductStorage(product3))
            assert.is_same(22, player:getMaxProductStorage(product3))
            assert.is_same(22, player:getEmptyProductStorage(product3))

            player:modifyProductStorage(product2, 10)

            assert.is_same(10, player:getProductStorage(product1))
            assert.is_same(80, player:getMaxProductStorage(product1))
            assert.is_same(70, player:getEmptyProductStorage(product1))
            assert.is_same(10, player:getProductStorage(product2))
            assert.is_same(45, player:getMaxProductStorage(product2))
            assert.is_same(35, player:getEmptyProductStorage(product2))
            assert.is_same(0, player:getProductStorage(product3))
            assert.is_same(17, player:getMaxProductStorage(product3))
            assert.is_same(17, player:getEmptyProductStorage(product3))

            player:modifyProductStorage(product2, -5)

            assert.is_same(10, player:getProductStorage(product1))
            assert.is_same(90, player:getMaxProductStorage(product1))
            assert.is_same(80, player:getEmptyProductStorage(product1))
            assert.is_same(5, player:getProductStorage(product2))
            assert.is_same(45, player:getMaxProductStorage(product2))
            assert.is_same(40, player:getEmptyProductStorage(product2))
            assert.is_same(0, player:getProductStorage(product3))
            assert.is_same(20, player:getMaxProductStorage(product3))
            assert.is_same(20, player:getEmptyProductStorage(product3))

            player:modifyProductStorage(product3, 5)

            assert.is_same(10, player:getProductStorage(product1))
            assert.is_same(70, player:getMaxProductStorage(product1))
            assert.is_same(60, player:getEmptyProductStorage(product1))
            assert.is_same(5, player:getProductStorage(product2))
            assert.is_same(35, player:getMaxProductStorage(product2))
            assert.is_same(30, player:getEmptyProductStorage(product2))
            assert.is_same(5, player:getProductStorage(product3))
            assert.is_same(20, player:getMaxProductStorage(product3))
            assert.is_same(15, player:getEmptyProductStorage(product3))
        end)
        it("they fail when called without argument", function()
            local player = eePlayerMock()
            Player:withStorage(player)

            assert.has_error(function() player:getProductStorage() end)
            assert.has_error(function() player:getMaxProductStorage() end)
            assert.has_error(function() player:getEmptyProductStorage() end)
        end)
    end)

    describe("getStorageSpace(), getEmptyStorageSpace(), getMaxStorageSpace()", function()
        it("returns the correct value", function()
            local player = eePlayerMock()
            Player:withStorage(player, {maxStorage = 100})

            assert.is_same(0, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(100, player:getEmptyStorageSpace())

            player:modifyProductStorage(product1, 10)

            assert.is_same(10, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(90, player:getEmptyStorageSpace())

            player:modifyProductStorage(product2, 10)

            assert.is_same(20, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(80, player:getEmptyStorageSpace())

            player:modifyProductStorage(product2, -5)

            assert.is_same(15, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(85, player:getEmptyStorageSpace())
        end)
        it("returns the correct values for sized products", function()
            local product1 = productMock()
            local product2 = productMock()
            local product3 = productMock()
            product1.getSize = function() return 1 end
            product2.getSize = function() return 2 end
            product3.getSize = function() return 4 end

            local player = eePlayerMock()
            Player:withStorage(player, {maxStorage = 100})

            assert.is_same(0, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(100, player:getEmptyStorageSpace())

            player:modifyProductStorage(product1, 10)

            assert.is_same(10, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(90, player:getEmptyStorageSpace())

            player:modifyProductStorage(product2, 10)

            assert.is_same(30, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(70, player:getEmptyStorageSpace())

            player:modifyProductStorage(product2, -5)

            assert.is_same(20, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(80, player:getEmptyStorageSpace())

            player:modifyProductStorage(product3, 5)

            assert.is_same(40, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(60, player:getEmptyStorageSpace())
        end)
    end)

    describe("modifyProductStorage()", function()
        it("it allows to overload the storage so that important mission items are not lost", function()
            local player = eePlayerMock()
            Player:withStorage(player, {maxStorage = 100})

            assert.is_same(0, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(100, player:getEmptyStorageSpace())
            assert.is_same(0, player:getProductStorage(product1))
            assert.is_same(100, player:getMaxProductStorage(product1))
            assert.is_same(100, player:getEmptyProductStorage(product1))
            assert.is_same(0, player:getProductStorage(product2))
            assert.is_same(100, player:getMaxProductStorage(product2))
            assert.is_same(100, player:getEmptyProductStorage(product2))

            player:modifyProductStorage(product1, 999)

            assert.is_same(999, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(0, player:getEmptyStorageSpace())
            assert.is_same(999, player:getProductStorage(product1))
            assert.is_same(100, player:getMaxProductStorage(product1))
            assert.is_same(0, player:getEmptyProductStorage(product1))
            assert.is_same(0, player:getProductStorage(product2))
            assert.is_same(0, player:getMaxProductStorage(product2))
            assert.is_same(0, player:getEmptyProductStorage(product2))
        end)

        it("it keeps sure the storage level will not be negative", function()
            local player = eePlayerMock()
            Player:withStorage(player, {maxStorage = 100})

            assert.is_same(0, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(100, player:getEmptyStorageSpace())
            assert.is_same(0, player:getProductStorage(product1))
            assert.is_same(100, player:getMaxProductStorage(product1))
            assert.is_same(100, player:getEmptyProductStorage(product1))
            assert.is_same(0, player:getProductStorage(product2))
            assert.is_same(100, player:getMaxProductStorage(product2))
            assert.is_same(100, player:getEmptyProductStorage(product2))

            player:modifyProductStorage(product1, -10)

            assert.is_same(0, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(100, player:getEmptyStorageSpace())
            assert.is_same(0, player:getProductStorage(product1))
            assert.is_same(100, player:getMaxProductStorage(product1))
            assert.is_same(100, player:getEmptyProductStorage(product1))
            assert.is_same(0, player:getProductStorage(product2))
            assert.is_same(100, player:getMaxProductStorage(product2))
            assert.is_same(100, player:getEmptyProductStorage(product2))
        end)

        it("fails if no product is given", function()
            local player = eePlayerMock()
            Player:withStorage(player)

            assert.has_error(function() player:modifyProductStorage(nil, 10) end)
        end)

        it("fails if no amount is given", function()
            local player = eePlayerMock()
            Player:withStorage(player)

            assert.has_error(function() player:modifyProductStorage(product1, nil) end)
        end)
    end)

    describe("setMaxStorageSpace()", function()
        it("allows to set the maximum storage space", function()
            local player = eePlayerMock()
            Player:withStorage(player, {maxStorage = 100})

            assert.is_same(0, player:getStorageSpace())
            assert.is_same(100, player:getMaxStorageSpace())
            assert.is_same(100, player:getEmptyStorageSpace())

            player:setMaxStorageSpace(120)

            assert.is_same(0, player:getStorageSpace())
            assert.is_same(120, player:getMaxStorageSpace())
            assert.is_same(120, player:getEmptyStorageSpace())
        end)
    end)

end)