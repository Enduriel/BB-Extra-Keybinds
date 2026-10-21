// MSU can't parse a key combination whose key is "+" (what the numpad's + key is called): sorting it throws "empty
// array". MSU applies the stored keybinds in root_state.onInit, so one such stored keybind stops the game from starting.
// This hook is queued before MSU's, so it runs first and drops those combinations from our stored keybinds.
::ExtraKeybinds.removeUnparsableStoredKeybinds <- function()
{
	if (!::MSU.Mod.PersistentData.hasFile("ModSettings"))
		return;
	local persistentData = ::MSU.Mod.PersistentData.readFile("ModSettings");
	if (!(::ExtraKeybinds.ID in persistentData))
		return;

	local changed = false;
	foreach (settingID, value in persistentData[::ExtraKeybinds.ID])
	{
		if (typeof value != "string" || value == "")
			continue;
		local valid = split(value, "/").filter(function( _, _combination ) {
			try
			{
				::MSU.Key.sortKeyString(_combination);
				return true;
			}
			catch (error)
			{
				::logWarning(format("Extra Keybinds: removing the stored key combination '%s' from '%s', MSU can't handle it", _combination, settingID));
				return false;
			}
		});
		local newValue = valid.len() == 0 ? "" : valid.reduce(@(_a, _b) _a + "/" + _b);
		if (newValue != value)
		{
			persistentData[::ExtraKeybinds.ID][settingID] = newValue;
			changed = true;
		}
	}
	if (changed)
		::MSU.Mod.PersistentData.createFile("ModSettings", persistentData);
}

::ExtraKeybinds.HooksMod.hook("scripts/root_state", function (q)
{
	q.onInit = @(__original) function()
	{
		__original();
		::ExtraKeybinds.removeUnparsableStoredKeybinds();
	}
});
