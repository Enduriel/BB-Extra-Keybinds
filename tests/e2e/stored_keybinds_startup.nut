// Reproduces: the game not starting because of the stored LowerCamera keybind "l/+" (comment #169133798), through the
// real startup. Mods: Modern Hooks, MSU, Extra Keybinds. Mode: menu, with --preload stored_keybinds_startup_preload.nut.
//
// A passing run reaches the main menu and prints:
//   PROBE preload stored = l/+
//   PROBE reached main menu = true
//   PROBE stored = l
//   PROBE value = l
//   PROBE keybind = l
// Without the fix the run never gets to PROBE_BEGIN: the log shows "empty array" from sortKeyCombinationsString.
local function p( k, f )
{
	local v;
	try { v = f(); } catch (e) { v = "ERROR: " + e; }
	::logInfo("PROBE " + k + " = " + v);
}
p("reached main menu", @() true);
p("stored", @() ::MSU.Mod.PersistentData.readFile("ModSettings").mod_extra_keybinds.LowerCamera);
p("value", @() ::getModSetting("mod_extra_keybinds", "LowerCamera").getValue());
p("keybind", @() ::MSU.System.Keybinds.KeybindsByMod.mod_extra_keybinds.LowerCamera.getKeyCombinations());
