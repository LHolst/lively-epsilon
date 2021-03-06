insulate("Util", function()
    require "lively_epsilon"
    require "test.mocks"

    describe("size()", function()
        it("correctly determines size of an empty table", function()
            assert.is.same(Util.size({}), 0)
        end)

        it("correctly determines size of a table with numerical index", function()
            assert.is.same(Util.size({42, "foobar", {}}), 3)
        end)

        it("correctly determines size of a table with object index", function()
            assert.is.same(Util.size({
                foo = 42,
                bar = "baz",
                baz = {}
            }), 3)
        end)

        it("correctly determines size of a table with mixed indices", function()
            assert.is.same(Util.size({
                foo = 42,
                bar = "baz",
                baz = {},
                42,
            }), 4)
        end)
    end)

    describe("isNumericTable()", function()
        it("returns true on empty table", function()
            assert.is_true(Util.isNumericTable({}))
        end)

        it("returns true on table that only contains numerical indices", function()
            assert.is_true(Util.isNumericTable({1, 2, 3, 4}))
        end)

        it("returns false on table that only contains string indices", function()
            assert.is_false(Util.isNumericTable({one = 1, two = 2, three = 3}))
        end)

        it("returns false on table that contains mixed indices", function()
            assert.is_false(Util.isNumericTable({42, foo = "bar", 2, 3, "bar", baz = 42}))
        end)
    end)

    describe("random()", function()
        it("returns nil if list is empty", function()
            assert.is_nil(Util.random({}))
        end)

        it("returns an element from a non-empty list with numerical index", function()
            local thing = { foo = "bar" }

            assert.is.equal(Util.random({thing}), thing)
        end)

        it("returns an element from a non-empty list with index", function()
            local thing = { foo = "bar" }

            assert.is.equal(Util.random({foo = thing}), thing)
        end)

        it("returns all items from the list at random", function()
            local thing1 = { foo = "bar" }
            local thing2 = { baz = "bar" }

            local testDummy = {thing1, thing2 }

            local thing1Seen = false
            local thing2Seen = false

            for i=1,16,1 do
                local result = Util.random(testDummy)
                if result == thing1 then thing1Seen = true elseif result == thing2 then thing2Seen = true end
            end

            assert.is_true(thing1Seen)
            assert.is_true(thing2Seen)
        end)

        it("allows to filter elements", function()
            local thing1 = { foo = "bar" }
            local thing2 = { baz = "bar" }
            local thing3 = { blu = "bla" }

            local testDummy = {thing1, thing2, thing3 }

            local thing1Seen = false
            local thing2Seen = false
            local thing3Seen = false

            for i=1,16,1 do
                local result = Util.random(testDummy, function(k, v)
                    return k ~= 3
                end)
                if result == thing1 then thing1Seen = true elseif result == thing2 then thing2Seen = true elseif result == thing3 then thing3Seen = true end
            end

            assert.is_true(thing1Seen)
            assert.is_true(thing2Seen)
            assert.is_false(thing3Seen)
        end)
    end)

    describe("randomSort()", function()
        it("randomly sorts a numeric list", function()
            local input = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
            local output = Util.randomSort(input)

            assert.is_table(output)
            assert.is_same(16, Util.size(output))
            assert.contains_value(8, output)
            assert.is_true(Util.isNumericTable(output))
            assert.not_same(input, output)
        end)
        it("returns different results each time in a numeric list", function()
            local input = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
            local output1 = Util.randomSort(input)
            local output2 = Util.randomSort(input)

            assert.not_same(output1, output2)
        end)
        it("randomly sorts a named list", function()
            local input = {a=1, b=2, c=3, d=4, e=5, f=6, g=7, h=8, i=9, j=10, k=11, l=12, m=13, n=14, o=15, p=16}
            local output = Util.randomSort(input)

            assert.is_table(output)
            assert.is_same(16, Util.size(output))
            assert.contains_value(8, output)
            assert.is_true(Util.isNumericTable(output))
            assert.not_same(input, output)
        end)
        it("returns different results each time in a numeric list", function()
            local input = {a=1, b=2, c=3, d=4, e=5, f=6, g=7, h=8, i=9, j=10, k=11, l=12, m=13, n=14, o=15, p=16}
            local output1 = Util.randomSort(input)
            local output2 = Util.randomSort(input)

            assert.not_same(output1, output2)
        end)
        it("fails if no table is given", function()
            assert.has_error(function() Util.randomSort() end)
        end)
    end)

    describe("onVector", function()
        it("returns point 1 when ratio is 0", function()
            local x, y = Util.onVector(1000, 2000, 3000, 4000, 0)
            assert.is_same({1000, 2000}, {x, y})
        end)
        it("returns point 2 when ratio is 1", function()
            local x, y = Util.onVector(1000, 2000, 3000, 4000, 1)
            assert.is_same({3000, 4000}, {x, y})
        end)
        it("returns a point between point 1 and point 2", function()
            local x, y = Util.onVector(1000, 2000, 3000, 4000, 0.5)
            assert.is_same({2000, 3000}, {x, y})
        end)
        it("works with two objects", function()
            local ship1 = eeCpuShipMock():setPosition(1000, 2000)
            local ship2 = eeCpuShipMock():setPosition(3000, 4000)
            local x, y = Util.onVector(ship1, ship2, 0.5)
            assert.is_same({2000, 3000}, {x, y})
        end)
        it("works with an object and coordinates", function()
            local ship = eeCpuShipMock():setPosition(1000, 2000)
            local x, y = Util.onVector(ship, 3000, 4000, 0.5)
            assert.is_same({2000, 3000}, {x, y})
        end)
        it("works with coordinate and an object", function()
            local ship = eeCpuShipMock():setPosition(3000, 4000)
            local x, y = Util.onVector(1000, 2000, ship, 0.5)
            assert.is_same({2000, 3000}, {x, y})
        end)
    end)

    describe("randomUuid()", function()
        it("should return a 16 digit hex", function()
            local uuid = Util.randomUuid()
            assert.not_nil(uuid:match("^([0-9a-f]+)$"))
            assert.equal(uuid:len(), 16)
        end)

        it("should not return the same uuid twice", function()
            local uuid = Util.randomUuid()
            local uuid2 = Util.randomUuid()
            assert.not_equal(uuid, uuid2)
        end)
    end)

    describe("deepCopy()", function()
        it("should copy primitive types", function()
            local thing = {
                foo = "bar",
                baz = 42
            }
            local copied = Util.deepCopy(thing)

            thing.foo = "fake"
            thing.baz = 12
            thing.blu = "some"

            assert.equal("bar", copied.foo)
            assert.equal(42, copied.baz)
            assert.is_nil(copied.blu)
        end)

        it("should not copy objects from Empty Epsilon", function()
            -- Copying them would cause the object to exists twice in memory.
            -- This would cause an inconsistent state and might cause the game to crash
            -- because of access to invalid memory segments.

            require "test.mocks"

            local thing = {
                foo = "bar",
                station = eeStationMock()
            }
            local copied = Util.deepCopy(thing)

            thing.station.foo = "bar"

            assert.same("bar", copied.station.foo)
        end)
    end)

    describe("mkString()", function()
        describe("with lastSeparator parameter", function()
            it("should return an empty string if table is empty", function()
                local table = {}

                assert.equal(Util.mkString(table, ", ", " and "), "")
            end)

            it("should return a string for a single value", function()
                local table = { "one" }

                assert.equal(Util.mkString(table, ", ", " and "), "one")
            end)

            it("should return a string for two values", function()
                local table = { "one", "two" }

                assert.equal(Util.mkString(table, ", ", " and "), "one and two")
            end)

            it("should return a string for three values", function()
                local table = { "one", "two", "three" }

                assert.equal(Util.mkString(table, ", ", " and "), "one, two and three")
            end)

            it("should fail when using an associative table", function()
                local table = { a = "one", c = "two", b = "three" }

                assert.has_error(function()
                    Util.mkString(table, ", ", " and ")
                end)
            end)
        end)

        it("should return a string if lastSeparator is left out", function()
            local table = { "one", "two", "three" }

            assert.equal(Util.mkString(table, ", "), "one, two, three")
        end)
    end)

    describe("mergeTables()", function()
        it("returns a new table where all items and from the second are present", function()
            local a = {a = 1, b = 2}
            local b = {c = 3, d = 4}

            local merged = Util.mergeTables(a, b)
            assert.is_same({a = 1, b = 2, c = 3, d = 4}, merged)
            -- ensure the original tables are not overridden
            assert.not_same(a, merged)
            assert.not_same(b, merged)
        end)
        it("the second table overrides the first one", function()
            local a = {a = 1, b = 2}
            local b = {b = 3, c = 4}

            local merged = Util.mergeTables(a, b)
            assert.is_same({a = 1, b = 3, c = 4}, merged)
        end)
        it("can merge three tables", function()
            local a = {a = 1, b = 2}
            local b = {b = 3, c = 4}
            local c = {c = 5, d = 6}

            local merged = Util.mergeTables(a, b, c)
            assert.is_same({a = 1, b = 3, c = 5, d = 6}, merged)
            -- ensure the original tables are not overridden
            assert.not_same(a, merged)
            assert.not_same(b, merged)
            assert.not_same(c, merged)
        end)
        it("fails if the first argument is not a table", function()
            assert.has_error(function() Util.mergeTables(42, {a = 1}) end)
        end)
        it("fails if the second argument is not a table", function()
            assert.has_error(function() Util.mergeTables({a = 1}, 42) end)
        end)
    end)

    describe("map()", function()
        it("maps values and retains keys", function()
            local input = {a=1, b=2, c=3}
            local output = Util.map(input, function(value) return value+1 end)

            assert.is_same({a=2, b=3, c=4}, output)
            assert.not_same(input, output) -- it should not change in-place
        end)
        it("maps a numberic table", function()
            local input = {1, 2, 3, 4}
            local output = Util.map(input, function(value) return value+1 end)

            assert.is_same({2, 3, 4, 5}, output)
            assert.not_same(input, output) -- it should not change in-place
        end)
        it("fails when first argument is not a table", function()
            assert.has_error(function()
                Util.map(42, function() end)
            end)
        end)
        it("fails when second argument is not a function", function()
            assert.has_error(function()
                Util.map({}, 42)
            end)
        end)
    end)
end)