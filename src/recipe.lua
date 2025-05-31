require('file')
require('game')
require('reader')

local data

function extract_to_json(command)
    if data ~= nil then
        game.player.print('recipe extraction is already in progress')
        return
    end
    game.player.print('recipe extraction is in process')

    data = {}

    data['game'] = read_game_data()
    data['fluids'] = read_fluids()
    data['items'] = read_items()
    data['recipes'] = read_recipes()

    -- translate localised strings
    -- TODO: translate with: https://lua-api.factorio.com/latest/classes/LuaPlayer.html#request_translations

    -- write data to a json file
    write_json_file('extract.json', data)

    -- write a completion message
    game.player.print('recipe extraction is complete')

    data = nil
end
