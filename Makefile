all:
	make -C mods/foundation
	make -C mods/yatm

.PHONY: luacheck
luacheck: foundation.luacheck yatm.luacheck

foundation.luacheck:
	make -C mods/foundation luacheck

yatm.luacheck:
	make -C mods/yatm luacheck
