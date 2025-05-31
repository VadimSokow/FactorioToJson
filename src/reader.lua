require('helper')

-- FLUID READER --

function read_fluids()
    local fluids = {}
    for name, fluid in pairs(prototypes.fluid) do
        local base = read_proto_base(fluid)
        local fluid_properties = {
            default_temperature = fluid.default_temperature,
            max_temperature = fluid.max_temperature,
            heat_capacity = fluid.heat_capacity,
            base_color = fluid.base_color,
            flow_color = fluid.flow_color,
            gas_temperature = fluid.gas_temperature,
            emissions_multiplier = fluid.emissions_multiplier,
            fuel_value = fluid.fuel_value,
        }
        fluids[name] = merge_tables(base, fluid_properties)
    end
    return fluids
end

-- ITEM READER --

function read_items()
    local items = {}
    for name, item in pairs(prototypes.item) do
        local base = read_proto_base(item)
        local basic = read_item_basic(item)
        items[name] = merge_tables(base, basic)
    end
    return items
end

function read_item_basic(data)
    return {
        place_result = read_name_or_empty(data.place_result),
        place_as_equipment_result = read_name_or_empty(data.place_as_equipment_result),
        place_as_tile_result = read_name_or_empty(data.place_as_tile_result),
        stackable = data.stackable,
        stack_size = data.stack_size,
        fuel_category = data.fuel_category,
        burnt_result = read_name_or_empty(data.burnt_result),
        fuel_value = data.fuel_value,
        fuel_acceleration_multiplier = data.fuel_acceleration_multiplier,
        fuel_top_speed_multiplier = data.fuel_top_speed_multiplier,
        fuel_emissions_multiplier = data.fuel_emissions_multiplier,
        fuel_acceleration_multiplier_quality_bonus = data.fuel_acceleration_multiplier_quality_bonus,
        fuel_top_speed_multiplier_quality_bonus = data.fuel_top_speed_multiplier_quality_bonus,
        -- TODO: FLAGS
        rocket_launch_products = read_products(data.rocket_launch_products),
        can_be_mod_opened = data.can_be_mod_opened,
        spoil_ticks = read_spoil_ticks(data),
        spoil_result = read_name_or_empty(data.spoil_result),
        plant_result = read_name_or_empty(data.plant_result),
        -- TODO: spoil_to_trigger_result
        -- TODO: destroyed_by_dropping_trigger
        weight = data.weight,
        ingredient_to_weight_coefficient = data.ingredient_to_weight_coefficient,
        fuel_glow_color = data.fuel_glow_color,
        -- TODO: default_import_location
        -- TODO: factoriopedia_alternative
        -- TODO: ammo_category
        magazine_size = data.magazine_size,
        reload_time = data.reload_time,
        -- TODO: equipment_grid
        -- TODO: resistances
        -- TODO: collision_box
        -- TODO: drawing_box
        provides_flight = data.provides_flight,
        -- TODO: capsule_action
        radius_color = data.radius_color,
        -- TODO: attack_parameters
        inventory_size = data.inventory_size,
        -- TODO: item_filters
        -- TODO: item_group_filters
        -- TODO: item_subgroup_filters
        filter_mode = data.filter_mode,
        -- TODO: localised_filter_message
        default_label_color = data.default_label_color,
        draw_label_for_cursor_render = data.draw_label_for_cursor_render,
        speed = data.speed,
        -- TODO: module_effects
        category = data.category,
        tier = data.tier,
        requires_beacon_alt_mode = data.requires_beacon_alt_mode,
        -- TODO: beacon_tint
        -- TODO: rails
        -- TODO: support
        manual_length_limit = data.manual_length_limit,
        always_include_tiles = data.always_include_tiles,
        skip_fog_of_war = data.skip_fog_of_war,
        entity_filter_slots = data.entity_filter_slots,
        tile_filter_slots = data.tile_filter_slots,
        durability_description_key = data.durability_description_key,
        factoriopedia_durability_description_key = data.factoriopedia_durability_description_key,
        durability_description_value = data.durability_description_value,
        infinite = data.infinite,
        valid = data.valid,
        object_name = data.object_name,
    }
end

function read_products(data)
    local products = {}
    local count = 1
    for _, product in pairs(data) do
        local entry = {
            name = product.name,
            type = product.type,
            amount = product.amount,
            probability = product.probability,
        }
        products[count] = entry
        count = count + 1
    end
    return products
end

-- RECIPE READER --

function read_recipes()
    local recipes = {}
    for name, recipe in pairs(prototypes.recipe) do
        local base = read_proto_base(recipe)
        local props = {
            enabled = recipe.enabled,
            category = recipe.category,
            additional_categories = read_string_array(get_value_or_default(recipe, 'additional_categories', nil)),
            ingredients = read_ingredients(recipe.ingredients),
            products = read_products(recipe.products),
            main_product = read_products({recipe.main_product})[1],
            hidden_from_flow_stats = recipe.hidden_from_flow_stats,
            hidden_from_player_crafting = recipe.hidden_from_player_crafting,
            always_show_made_in = recipe.always_show_made_in,
            energy = recipe.energy,
            request_paste_multiplier = recipe.request_paste_multiplier,
            overload_multiplier = recipe.overload_multiplier,
            maximum_productivity = recipe.maximum_productivity,
            allow_inserter_overload = recipe.allow_inserter_overload,
            allow_as_intermediate = recipe.allow_as_intermediate,
            allow_intermediates = recipe.allow_intermediates,
            show_amount_in_title = recipe.show_amount_in_title,
            always_show_products = recipe.always_show_products,
            emissions_multiplier = recipe.emissions_multiplier,
            allow_decomposition = recipe.allow_decomposition,
            unlock_results = recipe.unlock_results,
            hide_from_signal_gui = recipe.hide_from_signal_gui,
            hide_from_flow_stats = recipe.hide_from_flow_stats,
            hide_from_player_crafting = recipe.hide_from_player_crafting,
            trash = read_names_from_prototype_array(recipe.trash),
            preserve_products_in_machine_output = recipe.preserve_products_in_machine_output,
            is_parameter = recipe.is_parameter,
            allowed_effects = read_string_bool_dict(recipe.allowed_effects),
            allowed_module_categories = read_string_bool_dict(recipe.allowed_module_categories),
            effect_limitation_messages = read_localised_strings(recipe.effect_limitation_messages),
            -- TODO: surface_conditions
            -- TODO: alternative_unlock_methods
            -- TODO: crafting_machine_tints
            -- TODO: factoriopedia_alternative
             result_is_always_fresh = get_value_or_default(recipe, 'result_is_always_fresh', nil),
             reset_freshness_on_craft = get_value_or_default(recipe, 'reset_freshness_on_craft', nil),
            valid = recipe.valid,
            object_name = recipe.object_name,
        }
        recipes[name] = merge_tables(base, props)
    end
    return recipes
end

function read_ingredients(ingredients)
    local read_fluid = function(data)
        if data.type ~= 'fluid' then
            return {}
        end
        return {
            minimum_temperature = data.minimum_temperature,
            maximum_temperature = data.maximum_temperature,
            fluidbox_index = data.fluidbox_index,
            fluidbox_multiplier = data.fluidbox_multiplier,
        }
    end

    local list = {}
    for _, ingredient in pairs(ingredients) do
        list[#list + 1] = {
            type = ingredient.type,
            name = ingredient.name,
            amount = ingredient.amount,
            ignored_by_stats = ingredient.ignored_by_stats,
            fluid_properties = read_fluid(ingredient),
        }
    end
    return list
end
