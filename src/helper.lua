function read_proto_base(base)
    return {
        type = base.type,
        name = base.name,
        order = base.order,
        localised_name = read_localised_string(base.localised_name),
        localised_description = read_localised_string(base.localised_description),
        factoriopedia_description = read_localised_string(base.factoriopedia_description),
        group = base.group,
        subgroup = base.subgroup,
        hidden = base.hidden,
        hidden_in_factoriopedia = base.hidden_in_factoriopedia,
        parameter = base.parameter,
    }
end

function read_localised_strings(names)
    if names == nil then
        return {}
    end
    local result = {}
    for i, name in ipairs(names) do
        result[i] = read_localised_string(name)
    end
    return result
end

function read_localised_string(name)
    return name
end

function read_name_or_empty(data)
    if data == nil then
        return ''
    end
    return data.name
end

function read_spoil_ticks(data)
    local ticks = {}
    for _, q in pairs(prototypes.quality) do
        ticks[q.level] = data.get_spoil_ticks(q)
    end
    return ticks
end

function merge_tables(...)
    local result = {}
    for _, t in ipairs({...}) do
        for k, v in pairs(t) do
            result[k] = v
        end
    end
    return result
end

function read_string_array(arr)
    if arr == nil then
        return {}
    end
    local result = {}
    for i, v in ipairs(arr) do
        result[i] = v
    end
    return result
end

function read_names_from_prototype_array(arr)
    if arr == nil then
        return {}
    end
    local result = {}
    for i, v in ipairs(arr) do
        if v ~= nil then
            result[i] = v.name
        else
            result[i] = ''
        end
    end
    return result
end

function read_string_bool_dict(dict)
    if dict == nil then
        return {}
    end
    local result = {}
    for k, v in pairs(dict) do
        if v then
            result[k] = true
        else
            result[k] = false
        end
    end
    return result
end

-- function to get a value from key in a table or default value if key is not present
function get_value_or_default(object, key, default)
    if object == nil or not object.valid then
        return default
    end
    local success, value = pcall(function() return object[key] end)
    if not success then
        return default
    end
    return value
end
