::ExtraKeybinds <- {
	ID = "mod_extra_keybinds",
	Version = "2.1.0",
	Name = "Extra Keybinds"
}

::ExtraKeybinds.HooksMod <- ::Hooks.register(::ExtraKeybinds.ID, ::ExtraKeybinds.Version, ::ExtraKeybinds.Name);
::ExtraKeybinds.HooksMod.require("mod_msu >= 1.0.0-beta");
::ExtraKeybinds.HooksMod.conflictWith("mod_autopilot [Use Hackflow's 'Autopilot New' instead]");

::ExtraKeybinds.HooksMod.queue(">mod_msu", function(){
	::ExtraKeybinds.Mod <- ::MSU.Class.Mod(::ExtraKeybinds.ID, ::ExtraKeybinds.Version, ::ExtraKeybinds.Name);

	::ExtraKeybinds.activateSkill <- function( _skillId )
	{
		if (!this.m.TacticalScreen.isVisible()) return false;
		local entity = this.m.TacticalScreen.getTurnSequenceBarModule().getActiveEntity();
		if (entity == null || this.isInputLocked()) return false;

		if (!entity.getSkills().hasSkill(_skillId)) return false;
		this.setActionStateBySkillId(_skillId)
		return true;
	}

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("Recover", "q", ::MSU.Key.State.Tactical, function()
	{
		return ::ExtraKeybinds.activateSkill.call(this, "actives.recover");
	}, "Recover");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("KeybindBlocker", "q", ::MSU.Key.State.Tactical, function() {
		return true;
	}, "Keybind Blocker", ::MSU.Key.KeyState.Continuous | ::MSU.Key.KeyState.Press, "Blocks vanilla/other mods' keybinds that do not use MSU Keybinds.");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("Rotation", "t", ::MSU.Key.State.Tactical, function()
	{
		return ::ExtraKeybinds.activateSkill.call(this, "actives.rotation");
	}, "Rotation");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("Indomitable", "e", ::MSU.Key.State.Tactical, function()
	{
		return ::ExtraKeybinds.activateSkill.call(this, "actives.indomitable");
	}, "Indomitable");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("Shieldwall", "g", ::MSU.Key.State.Tactical, function()
	{
		return ::ExtraKeybinds.activateSkill.call(this, "actives.shieldwall");
	}, "Shieldwall");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("Adrenaline", "h", ::MSU.Key.State.Tactical, function()
	{
		return ::ExtraKeybinds.activateSkill.call(this, "actives.adrenaline");
	}, "Adrenaline");

	::MSU.Vanilla.Keybinds.update("tactical_toggleTreesButton", "y");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("RaiseCamera", "o", ::MSU.Key.State.Tactical, function()
	{
		if (!this.m.TacticalScreen.isVisible()) return false;
		this.topbar_options_onSwitchMapLevelUpButtonClicked();
		return true;
	});

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("LowerCamera", "l", ::MSU.Key.State.Tactical, function()
	{
		if (!this.m.TacticalScreen.isVisible()) return false;
		this.topbar_options_onSwitchMapLevelDownButtonClicked();
		return true;
	});

	::ExtraKeybinds.swapItemKeybind <- function( _idx )
	{
		if (!this.m.TacticalScreen.isVisible()) return false;
		local entity = this.m.TacticalScreen.getTurnSequenceBarModule().getActiveEntity();
		if (entity == null || !entity.isPlayerControlled()) return false;
		local item = entity.getItems().getItemAtBagSlot(_idx);
		if (item == null) return false;
		return this.ExtraKeybinds_onSwapToItem(entity.getID(), item);
	}

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("SwapItem0", "f1", ::MSU.Key.State.Tactical, function()
	{
		return ::ExtraKeybinds.swapItemKeybind.call(this, 0);
	}, "Swap Item 1");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("SwapItem1", "f2", ::MSU.Key.State.Tactical, function()
	{
		return ::ExtraKeybinds.swapItemKeybind.call(this, 1);
	}, "Swap Item 2");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("SwapItem2", "f3", ::MSU.Key.State.Tactical, function()
	{
		return ::ExtraKeybinds.swapItemKeybind.call(this, 2);
	}, "Swap Item 3");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("SwapItem3", "f4", ::MSU.Key.State.Tactical, function()
	{
		return ::ExtraKeybinds.swapItemKeybind.call(this, 3);
	}, "Swap Item 4");

	local page = ::ExtraKeybinds.Mod.ModSettings.addPage("General");

	local button = page.addButtonSetting("ResetItemKeybinds", null, "Reset Item Keybinds", "Due to some limitations of the current MSU Keybinds implementations, some keys aren't detected by the current keybind setting system, click this to reset the item swap keybinds to their default values.")
	button.addCallback(function()
	{
		::ExtraKeybinds.Mod.Keybinds.update("SwapItem0", "f1");
		::ExtraKeybinds.Mod.Keybinds.update("SwapItem1", "f2");
		::ExtraKeybinds.Mod.Keybinds.update("SwapItem2", "f3");
		::ExtraKeybinds.Mod.Keybinds.update("SwapItem3", "f4");
	});

	::include("extra_keybinds/tooltip_events");
	::include("extra_keybinds/turn_sequence_bar");
	::include("extra_keybinds/tactical_state");
	::Hooks.registerJS("ui/mods/extra_keybinds/turnsequencebar_module.js");
	::Hooks.registerCSS("ui/mods/extra_keybinds/css/turnsequencebar_module.css");
});
