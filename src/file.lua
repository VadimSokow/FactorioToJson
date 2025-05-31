function write_json_file(name, data)
    helpers.write_file(name, helpers.table_to_json(data))
end