// Reproduces: extra_keybinds crashing with current Legends because isChangeableInBattle no longer takes the entity
// (comment #159237241). Mods: Modern Hooks, MSU, Legends 19.4.22 + its assets zip, Extra Keybinds. Mode: menu.
// Untested here: the swap menu itself in combat (needs a tactical fight); this checks the wrapper the menu uses.
//
// A passing run prints, for each item, the same value from our wrapper as from the item itself, e.g.:
//   PROBE isChangeable scripts/items/weapons/knife = true own=true params=1
//   PROBE isChangeable scripts/items/accessory/legend_accessory_dog = true own=true params=1
//   PROBE isChangeable scripts/items/accessory/special/arena_collar_item = true own=true params=1
//   PROBE isChangeable scripts/items/shields/wooden_shield = true own=true params=1
// (params=1 means no parameter besides "this": Legends 19.4.22 takes no entity.)
local function p( k, f )
{
	local v;
	try { v = f(); } catch (e) { v = "ERROR: " + e; }
	::logInfo("PROBE " + k + " = " + v);
}
p("legends loaded", @() ::Hooks.hasMod("mod_legends"));
foreach (script in ["scripts/items/weapons/knife", "scripts/items/accessory/legend_accessory_dog", "scripts/items/accessory/special/arena_collar_item", "scripts/items/shields/wooden_shield"])
{
	local s = script;
	p("isChangeable " + s, function() {
		local item = ::new(s);
		return ::ExtraKeybinds.isChangeableInBattle(item, "entity") + " own=" + item.isChangeableInBattle() + " params=" + item.isChangeableInBattle.getinfos().parameters.len();
	});
}
