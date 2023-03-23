BUILD_DIR:=${CURDIR}/_build
TMP_DIR=${CURDIR}/tmp

export BUILD_DIR

all: build

.PHONY: build
build:
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

.PHONY: prepare.release
prepare.release:
	rm -rf "${TMP_DIR}"
	mkdir -p "${TMP_DIR}/hsw/mods"

	make -C mods/foundation prepare.release TMP_DIR="${TMP_DIR}/hsw/mods"
	make -C mods/nokore prepare.release TMP_DIR="${TMP_DIR}/hsw/mods"
	make -C mods/harmonia prepare.release TMP_DIR="${TMP_DIR}/hsw/mods"
	make -C mods/yatm prepare.release TMP_DIR="${TMP_DIR}/hsw/mods"

	cp -r --parents mods/harmonia_prelude "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_prelude "${TMP_DIR}/hsw"
	cp -r --parents mods/mt_prelude "${TMP_DIR}/hsw"
	cp -r --parents mods/nokore_prelude "${TMP_DIR}/hsw"
	cp -r --parents mods/yatm_prelude "${TMP_DIR}/hsw"

	cp -r --parents mods/hsw_block_anchor "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_campaign "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_environment "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_equipment "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_farming "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_guilds "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_hud "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_materials "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_milestones "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_nanosuit "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_recipes "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_shadow "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_stats "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_tools "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_watla "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_waypoints "${TMP_DIR}/hsw"
	cp -r --parents mods/hsw_workbench "${TMP_DIR}/hsw"

	mkdir -p "${TMP_DIR}/mobkit"

	cp -r --parents mods/mobkit/*.lua "${TMP_DIR}/hsw"
	cp -r --parents mods/mobkit/LICENSE "${TMP_DIR}/hsw"
	cp -r --parents mods/mobkit/*.conf "${TMP_DIR}/hsw"
	cp -r --parents mods/mobkit/*.md "${TMP_DIR}/hsw"
	cp -r --parents mods/mobkit/*.txt "${TMP_DIR}/hsw"
	cp -r --parents mods/mobkit/*.png "${TMP_DIR}/hsw"

	cp LICENSE "${TMP_DIR}/hsw"
	cp game.conf "${TMP_DIR}/hsw"
	cp README.md "${TMP_DIR}/hsw"
	cp settingtypes.txt "${TMP_DIR}/hsw"

${BUILD_DIR}:
	mkdir -p ${BUILD_DIR}

%.tar.gz: ${BUILD_DIR} prepare.release
	tar -czf "${BUILD_DIR}/$@" --directory "${TMP_DIR}/hsw/mods" $(@:.tar.gz=)

%.zip: prepare.release
	zip -r "${BUILD_DIR}/$@" "${TMP_DIR}/hsw/mods/$(@:.zip=)"

.PHONY: release.modpacks.tar.gz
release.modpacks.tar.gz: foundation.tar.gz harmonia.tar.gz nokore.tar.gz yatm.tar.gz

.PHONY: release.modpacks.zip
release.modpacks.zip: foundation.zip harmonia.zip nokore.zip yatm.zip

.PHONY: release.modpacks
release.modpacks: release.modpacks.tar.gz release.modpacks.zip

.PHONY: release.game
release.game: ${BUILD_DIR} prepare.release
	tar -czf "${BUILD_DIR}/hsw.tar.gz" --directory "${TMP_DIR}" "hsw"
	zip -r "${BUILD_DIR}/hsw.zip" "${TMP_DIR}/hsw"
