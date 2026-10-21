// Reproduces: the game not starting because of the stored LowerCamera keybind "l/+" (comment #169133798), and checks
// the isChangeableInBattle signature handling for Legends (comment #159237241).
// Mods: Modern Hooks, MSU, Extra Keybinds. Mode: menu.
//
// A passing run prints:
//   PROBE MSU sortKeyString('+') = ERROR: empty array
//   PROBE save 1 (UI Apply) = ERROR: empty array
//   PROBE value after save 1 = l/+
//   PROBE keybind registered after save 1 = false
//   PROBE stored after save 1 = l
//   PROBE save 2 (UI OK) = ok
//   PROBE stored after save 2 = l/+
//   PROBE import without our cleanup = ERROR: empty array
//   PROBE import after our cleanup = ok
//   PROBE stored after cleanup = l
//   PROBE value after cleanup = l
//   PROBE keybind after cleanup = l
//   PROBE isChangeable vanilla item = true
//   PROBE isChangeable no-arg = no-arg
//   PROBE isChangeable entity-arg = got entity
//   PROBE isChangeable default-arg = got entity
local function p( k, f )
{
	local v;
	try { v = f(); } catch (e) { v = "ERROR: " + e; }
	::logInfo("PROBE " + k + " = " + v);
}
local modID = ::ExtraKeybinds.ID;
local setting = ::getModSetting(modID, "LowerCamera");
local stored = function() {
	local data = ::MSU.Mod.PersistentData.readFile("ModSettings");
	return modID in data && "LowerCamera" in data[modID] ? data[modID].LowerCamera : "(none)";
};
local store = function( _value ) {
	local data = ::MSU.Mod.PersistentData.hasFile("ModSettings") ? ::MSU.Mod.PersistentData.readFile("ModSettings") : {};
	if (!(modID in data)) data[modID] <- {};
	data[modID].LowerCamera <- _value;
	::MSU.Mod.PersistentData.createFile("ModSettings", data);
};
// MSU removes the keybind before re-adding it with the new keys, so a throw in between leaves it removed
local keybind = ::MSU.System.Keybinds.KeybindsByMod[modID].LowerCamera;
local hasKeybind = @() "LowerCamera" in ::MSU.System.Keybinds.KeybindsByMod[modID];
local resetValue = function() {
	setting.set("l", false, false, false, true, false);
	if (!hasKeybind())
	{
		keybind.KeyCombinations = ["l"];
		::MSU.System.Keybinds.add(keybind, false);
	}
};
local reset = function() {
	resetValue();
	store("l");
};

p("MSU sortKeyString('+')", @() ::MSU.Key.sortKeyString("+"));

// What the settings screen sends when "+" (numpad +) is added to the keybind: first Apply, then OK.
reset();
local changes = {};
changes[modID] <- { LowerCamera = { type = "string", value = "l/+" } };
p("save 1 (UI Apply)", function() { ::MSU.System.ModSettings.updateSettingsFromJS(changes); return "ok"; });
p("value after save 1", @() setting.getValue());
p("keybind registered after save 1", hasKeybind);
p("stored after save 1", stored);
p("save 2 (UI OK)", function() { ::MSU.System.ModSettings.updateSettingsFromJS(changes); return "ok"; });
p("stored after save 2", stored);

// The next start: MSU's root_state.onInit imports the stored settings.
resetValue();
p("import without our cleanup", function() { ::MSU.System.ModSettings.importPersistentSettings(); return "ok"; });
resetValue();
store("l/+");
p("import after our cleanup", function() {
	::ExtraKeybinds.removeUnparsableStoredKeybinds();
	::MSU.System.ModSettings.importPersistentSettings();
	return "ok";
});
p("stored after cleanup", stored);
p("value after cleanup", @() setting.getValue());
p("keybind after cleanup", @() ::MSU.System.Keybinds.KeybindsByMod[modID].LowerCamera.getKeyCombinations());
reset();

p("isChangeable vanilla item", @() ::ExtraKeybinds.isChangeableInBattle(::new("scripts/items/weapons/knife"), "entity"));
p("isChangeable no-arg", @() ::ExtraKeybinds.isChangeableInBattle({ isChangeableInBattle = function() { return "no-arg"; } }, "entity"));
p("isChangeable entity-arg", @() ::ExtraKeybinds.isChangeableInBattle({ isChangeableInBattle = function( _entity ) { return "got " + _entity; } }, "entity"));
p("isChangeable default-arg", @() ::ExtraKeybinds.isChangeableInBattle({ isChangeableInBattle = function( _entity = null ) { return "got " + _entity; } }, "entity"));
