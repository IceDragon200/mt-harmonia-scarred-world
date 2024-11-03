local table_merge = assert(foundation.com.table_merge)

local mod = assert(hsw_farming)

--- @namespace hsw_farming

--- @spec #register_multistage_crop(
---   basename: String,
---   stages: 1..,
---   base_def: Table,
---   override_defs: Table
-- ): void
function mod:register_multistage_crop(basename, stages, base_def, override_defs)
  assert(basename, "expected a basename for crop")
  assert(stages and stages > 0, "expected stages and must be greater than 0")

  for i = 1,stages do
    local def = table_merge(
      { basename = mod:make_name(basename), base_description = base_def.description },
      base_def,
      override_defs[i] or {}
    )
    mod:register_node(basename .. "_" .. i, def)
  end
end

--- @spec #register_food_item(basename: String, def: Table): void
function mod:register_food_item(basename, def)
  mod:register_craftitem(basename, def)
end
