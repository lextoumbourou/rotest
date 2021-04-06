local TableUtils = {}
function TableUtils.copyTable(t)
	if type(t) ~= 'table' then
		return t
	end

	local res = {}
	for k, v in pairs(t) do
		res[TableUtils.copyTable(k)] = TableUtils.copyTable(v)
	end

	return res
end

return TableUtils
