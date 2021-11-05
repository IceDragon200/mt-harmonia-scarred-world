local Luna = assert(foundation.com.Luna)
local case = Luna:new("hsw.WorkbenchRecipeRegistry")
local subject = hsw.WorkbenchRecipeRegistry

case:describe("#register_recipe/2", function (t2)
  t2:test("can register a new recipe", function (t3)
    local reg = subject:new()

    reg:register_recipe("test:my_recipe", {
      description = "Test Recipe",

      input_items = {
        {
          name = "mod:item1",
          amount = 1,
        },
        {
          name = "mod:item2",
          -- this test ensures that ingredients will automatically set amount to 1
          -- when possible
        },
      },
      output_items = {
        {
          name = "mod:result_item",
          amount = 1,
        }
      },

      bench = {
        bench_class = "any",
        level = 1,
      },
      tool = {
        tool_class = "hammer",
        level = 2,
      },
      tool_uses = 2,
    })

    -- that recipes are indexed
    reg:index_recipes()

    local recipe = reg:get_recipe("test:my_recipe")

    t3:assert(recipe:matches_tool({
      tool_class = "hammer",
      level = 2,
    }), "expected same level tool to work")

    t3:assert(recipe:matches_tool({
      tool_class = "hammer",
      level = 3,
    }), "expected higher level tool to work")

    t3:refute(recipe:matches_tool({
      tool_class = "hammer",
      level = 1,
    }), "expected lower level tool to not work")

    t3:refute(recipe:matches_tool({
      tool_class = "knife",
      level = 2,
    }), "expected incorrect tool_class to not work")

    t3:assert(recipe:matches_bench({
      bench_class = "wood",
      level = 1,
    }), "expected same level bench to work")

    t3:assert(recipe:matches_bench({
      bench_class = "wood",
      level = 2,
    }), "expected higher level bench to work")

    t3:assert(recipe:matches_item_stacks({
      ItemStack("mod:item1"),
      ItemStack("mod:item2"),
    }), "expected forward recipe ingredients to work")

    t3:assert(recipe:matches_item_stacks({
      ItemStack("mod:item2"),
      ItemStack("mod:item1"),
    }), "expected reverse recipe ingredients to work")

    local mrecipe =
      reg:find_recipe(
        {
          bench_class = "wood",
          level = 1,
        },
        {
          tool_class = "hammer",
          level = 2,
        },
        {
          ItemStack("mod:item1"),
          ItemStack("mod:item2"),
        }
      )

    t3:assert_eq(mrecipe, recipe)

    mrecipe =
      reg:find_recipe(
        {
          bench_class = "wood",
          level = 1,
        },
        {
          tool_class = "hammer",
          level = 2,
        },
        {
          ItemStack("mod:item2"),
          ItemStack("mod:item1"),
        }
      )

    t3:assert_eq(mrecipe, recipe)

    mrecipe =
      reg:find_recipe(
        {
          bench_class = "wood",
          level = 1,
        },
        {
          tool_class = "hammer",
          level = 2,
        },
        {
          ItemStack("mod:item1"),
          ItemStack("mod:item2"),
          ItemStack("mod:item3"),
        }
      )

    t3:refute(mrecipe)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
