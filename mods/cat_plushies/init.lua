    minetest.register_node("cat_plushies:chat_roux", {
        description = "Plushies of an orange cat",
    drawtype = "mesh",
        mesh = "chat.obj",
        tiles = {"cat.png"},
        paramtype2 = "facedir",
        paramtype="light",
        selection_box = {
            type= "fixed",
            fixed = {-0.3, -0.46, -0.4, 0.3, 0.3, 0.3}
        },
        collision_box = {
            type = "fixed",
            fixed = {-0.3, -0.46, -0.4, 0.3, 0.3, 0.3}
        },
        inventory_image = "orange_cat_icon.png",
        is_ground_content = false,
        groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
        flammable = 3, wool = 1}
    })

minetest.register_craft({
	output = "cat_plushies:chat_roux",
	recipe = {
		{"", "", ""},
		{"dye:orange", "farming:cotton", "default:paper"},
		{"", "default:paper", "farming:cotton"},
	}
})

    minetest.register_node("cat_plushies:chat_noir", {
        description = "Plushies of an black cat",
    drawtype = "mesh",
        mesh = "chat.obj",
        tiles = {"cat_2.png"},
        paramtype2 = "facedir",
        paramtype="light",
        selection_box = {
            type= "fixed",
            fixed = {-0.3, -0.46, -0.4, 0.3, 0.3, 0.3}
        },
        collision_box = {
            type = "fixed",
            fixed = {-0.3, -0.46, -0.4, 0.3, 0.3, 0.3}
        },
        inventory_image = "black_cat_icon.png",
        is_ground_content = false,
        groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
        flammable = 3, wool = 1}
    })
minetest.register_craft({
	output = "cat_plushies:chat_noir",
	recipe = {
		{"", "", ""},
		{"dye:black", "farming:cotton", "default:paper"},
		{"", "default:paper", "farming:cotton"},
	}
})

    minetest.register_node("cat_plushies:brown_bear", {
        description = "Plushies of an brown bear",
    drawtype = "mesh",
        mesh = "bear.obj",
        tiles = {"brown_bear.png"},
        paramtype2 = "facedir",
        paramtype="light",
        selection_box = {
            type= "fixed",
            fixed = {-0.3, -0.46, -0.4, 0.3, 0.3, 0.3}
        },
        collision_box = {
            type = "fixed",
            fixed = {-0.3, -0.46, -0.4, 0.3, 0.3, 0.3}
        },
        inventory_image = "brown_bear_icon.png",
        is_ground_content = false,
        groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
        flammable = 3, wool = 1}
    })

minetest.register_craft({
	output = "cat_plushies:brown_bear",
	recipe = {
		{"", "farming:cotton", ""},
		{"dye:brown", "farming:cotton", "default:paper"},
		{"farming:cotton", "default:paper", "farming:cotton"},
	}
})

    minetest.register_node("cat_plushies:polar_bear", {
        description = "Plushies of an polar bear",
    drawtype = "mesh",
        mesh = "bear.obj",
        tiles = {"polar_bear.png"},
        paramtype2 = "facedir",
        paramtype="light",
        selection_box = {
            type= "fixed",
            fixed = {-0.3, -0.46, -0.4, 0.3, 0.3, 0.3}
        },
        collision_box = {
            type = "fixed",
            fixed = {-0.3, -0.46, -0.4, 0.3, 0.3, 0.3}
        },
        inventory_image = "polar_bear_icon.png",
        is_ground_content = false,
        groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
        flammable = 3, wool = 1}
    })

minetest.register_craft({
	output = "cat_plushies:polar_bear",
	recipe = {
		{"", "farming:cotton", ""},
		{"dye:white", "farming:cotton", "default:paper"},
		{"farming:cotton", "default:paper", "farming:cotton"},
	}
})


    minetest.register_node("cat_plushies:black_hamster", {
        description = "Plushies of an black hamster",
    drawtype = "mesh",
        mesh = "hamster.obj",
        tiles = {"black_hamster.png"},
        paramtype2 = "facedir",
        paramtype="light",
        selection_box = {
            type= "fixed",
            fixed = {-0.3, -0.46, -0.4, 0.3, 0.3, 0.3}
        },
        collision_box = {
            type = "fixed",
            fixed = {-0.3, -0.46, -0.4, 0.3, 0.3, 0.3}
        },
        inventory_image = "haster_icon.png",
        is_ground_content = false,
        groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
        flammable = 3, wool = 1}
    })

minetest.register_craft({
	output = "cat_plushies:polar_bear",
	recipe = {
		{"", "", ""},
		{"dye:white", "dye:black", ""},
		{"farming:cotton", "default:paper", ""},
	}
})


    minetest.register_node("cat_plushies:poulpe", {
        description = "Plushies of an Octopus",
    drawtype = "mesh",
        mesh = "poulpe.obj",
        tiles = {"poulpe.png"},
        paramtype2 = "facedir",
        paramtype="light",
        selection_box = {
            type= "fixed",
            fixed = {-0.3, -0.46, -0.4, 0.3, 0.3, 0.3}
        },
        collision_box = {
            type = "fixed",
            fixed = {-0.3, -0.46, -0.4, 0.3, 0.3, 0.3}
        },
        inventory_image = "poulpe_icon.png",
        is_ground_content = false,
        groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
        flammable = 3, wool = 1}
    })

minetest.register_craft({
	output = "cat_plushies:poulpe",
	recipe = {
		{"", "", ""},
		{"dye:white", "farming:cotton", ""},
		{"farming:cotton", "default:paper", ""},
	}
})



