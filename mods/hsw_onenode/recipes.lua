local mod = assert(hsw_onenode)

local mat_body = mod:make_name("mat_body")
local form1 = mod:make_name("block_form_1")
local form2 = mod:make_name("block_form_2")
local form3 = mod:make_name("block_form_3")

core.register_craft{
  type = "shapeless",
  output = form1,
  recipe = {
    mat_body, mat_body, mat_body,
    mat_body, mat_body, mat_body,
    mat_body, mat_body, mat_body,
  }
}

core.register_craft{
  type = "shapeless",
  output = mat_body .. " 9",
  recipe = {
    form1,
  }
}

-- Form2 and up are crafted using workbenches

-- core.register_craft{
--   type = "shapeless",
--   output = form2,
--   recipe = {
--     form1, form1, form1,
--     form1, form1, form1,
--     form1, form1, form1,
--   }
-- }

-- core.register_craft{
--   type = "shapeless",
--   output = form3,
--   recipe = {
--     form2, form2, form2,
--     form2, form2, form2,
--     form2, form2, form2,
--   }
-- }
