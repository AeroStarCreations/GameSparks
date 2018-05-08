-- This file contains all functions that should be accessible 
-- in multiple files

local v = {}

----
-- Returns a table as a formatted string
----
function v.tableToString( t )
 
    local printTable_cache = {}
    local result = ""
 
    local function sub_tableToString( t, indent )
 
        local r = ""

        if ( printTable_cache[tostring(t)] ) then
            r = r .. indent .. "*" .. tostring(t) .. "\n"
        else
            printTable_cache[tostring(t)] = true
            if ( type( t ) == "table" ) then
                for pos,val in pairs( t ) do
                    if ( type(val) == "table" ) then
                        r = r .. indent .. "[" .. pos .. "] => " .. tostring( t ) .. " {\n"
                        r = r .. sub_tableToString( val, indent .. string.rep( " ", string.len(pos)+8 ) )
                        r = r .. indent .. string.rep( " ", string.len(pos)+6 ) .. "}\n"
                    elseif ( type(val) == "string" ) then
                        r = r .. indent .. "[" .. pos .. '] => "' .. val .. '"\n'
                    else
                        r = r .. indent .. "[" .. pos .. "] => " .. tostring(val) .. "\n"
                    end
                end
            else
                r = r .. indent .. tostring(t) .. "\n"
            end
        end

        return r
    end
 
    if ( type(t) == "table" ) then
        result = result .. tostring(t) .. " {\n"
        result = result .. sub_tableToString( t, "  " )
        result = result .. "}"
    else
        result = result .. sub_tableToString( t, "  " )
    end

    return result
end

----
-- Prints a table to the console
----
function v.printTable( t )
    print( v.tableToString( t ) )
end

return v