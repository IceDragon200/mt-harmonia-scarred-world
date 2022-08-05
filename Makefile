all:
	make -C mods/foundation
	make -C mods/nokore
	make -C mods/harmonia
	make -C mods/yatm

.PHONY: luacheck
luacheck: foundation.luacheck nokore.luacheck harmonia.luacheck yatm.luacheck hsw.luacheck

foundation.luacheck:
	make -C mods/foundation luacheck

nokore.luacheck:
	make -C mods/nokore luacheck

harmonia.luacheck:
	make -C mods/harmonia luacheck

yatm.luacheck:
	make -C mods/yatm luacheck

hsw.luacheck:
	luacheck mods/hsw_*
