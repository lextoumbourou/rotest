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

function TableUtils.tablesEqual(t1, t2)
	if (t1 == nil or t2 == nil) and t1 ~= t2 then
		return false
	end

	for i, v in pairs(t1) do
		if (typeof(v) == "table") then
			if (TableUtils.tablesEqual(v, t2[i]) == false) then
				return false
			end
		else
			if (v ~= t2[i]) then
				return false
			end
		end
	end

	for i, v in pairs(t2) do
		if (typeof(v) == "table") then
			if (TableUtils.tablesEqual(v, t1[i]) == false) then
				return false
			end
		else
			if (v ~= t1[i]) then
				return false
			end
		end
	end

	return true
end


return TableUtils
