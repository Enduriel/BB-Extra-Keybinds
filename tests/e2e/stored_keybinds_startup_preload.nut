// --preload for stored_keybinds_startup.nut: stores LowerCamera = "l/+" before the game's root_state.onInit, where MSU
// applies the stored settings, as if a previous session had saved it (comment #169133798).
::ClaudeProbe.Mod.queue(">mod_msu", ">mod_extra_keybinds", function() {
	local data = ::MSU.Mod.PersistentData.hasFile("ModSettings") ? ::MSU.Mod.PersistentData.readFile("ModSettings") : {};
	if (!("mod_extra_keybinds" in data)) data.mod_extra_keybinds <- {};
	data.mod_extra_keybinds.LowerCamera <- "l/+";
	::MSU.Mod.PersistentData.createFile("ModSettings", data);
	::logInfo("PROBE preload stored = l/+");
});
