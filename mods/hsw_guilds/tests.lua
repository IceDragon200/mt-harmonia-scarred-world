local Subject = assert(hsw_guilds.Guilds)

local case = foundation.com.Luna:new("hsw_guilds.Guilds")

case:describe("#initialize/0", function (t2)
  t2:test("can initialize a new Guilds instance", function (t3)
    local subject = Subject:new()

    t3:assert(subject)
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
