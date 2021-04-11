game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Table')

local TableUtilTest = {}

function TableUtilTest:copiesBasicTable()
	local tableOriginal = {name='Lex'}
	local sut = require(game.ReplicatedStorage.Utils.Table)
	local copiedTable = sut.copyTable(tableOriginal)

	copiedTable.name = 'John'

	assert(tableOriginal.name == "Lex", "Original table has been modified")
	assert(copiedTable.name == "John", "Updated table has not been modified")
end

function TableUtilTest:copiesNestedTable()
	local tableOriginal = {items={Hat=1}}
	local sut = require(game.ReplicatedStorage.Utils.Table)
	local copiedTable = sut.copyTable(tableOriginal)

	copiedTable.items.Hat = 10

	assert(tableOriginal.items.Hat == 1, "Original table has been modified")
	assert(copiedTable.items.Hat == 10, "Updated table has not been modified")
end

function TableUtilTest:comparesEqualTables()
	local sut = require(game.ReplicatedStorage.Utils.Table)

	local isEqual = sut.tablesEqual({a=1, b=2}, {a=1, b=2})

	assert(isEqual, "Tables aren't equal")
end

function TableUtilTest.comparesEqualArrays()
	local sut = require(game.ReplicatedStorage.Utils.Table)

	local isEqual = sut.tablesEqual({1, 2}, {1, 2})

	assert(isEqual, "Arrays aren't equal")
end

function TableUtilTest.comparesEqualNestedTables()
	local sut = require(game.ReplicatedStorage.Utils.Table)

	local isEqual = sut.tablesEqual({a={Hat=1}}, {a={Hat=1}})

	assert(isEqual, "Tables aren't equal")
end

return TableUtilTest
