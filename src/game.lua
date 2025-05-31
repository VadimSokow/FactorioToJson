function read_game_data()
    local game = {}
    game['mods'] = script.active_mods
    game['features'] = read_features()
    return game
end

function read_features()
    local features = script.feature_flags
    return {
        quality = features['quality'],
        rail_bridges = features['rail_bridges'],
        space_travel = features['space_travel'],
        spoiling = features['spoiling'],
        freezing = features['freezing'],
        segmented_units = features['segmented_units'],
        expansion_shaders = features['expansion_shaders'],
    }
end
