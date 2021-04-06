game.ReplicatedStorage:WaitForChild('Utils'):WaitForChild('Table')

local TableUtilTest = {}

function TableUtilTest:testCopyBasicTable()
	local tableOriginal = {name='Lex'}
	local sut = require(game.ReplicatedStorage.Utils.Table)

	local copiedTable = sut.copyTable(tableOriginal)
	copiedTable.name = 'John'

	assert(tableOriginal.name == "Lex", "Original table has been modified")
	assert(copiedTable.name == "John", "Updated table has not been modified")
end

function TableUtilTest:testCopyNestedTable()
	local tableOriginal = {items={Hat=1}}
	local sut = require(game.ReplicatedStorage.Utils.Table)

	local copiedTable = sut.copyTable(tableOriginal)
	copiedTable.items.Hat = 10

	assert(tableOriginal.items.Hat == 1, "Original table has been modified")
	assert(copiedTable.items.Hat == 10, "Updated table has not been modified")
end

return TableUtilTest