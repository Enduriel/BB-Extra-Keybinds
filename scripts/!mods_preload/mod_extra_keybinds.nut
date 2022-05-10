::ExtraKeybinds <- {
	ID = "mod_extra_keybinds",
	Version = "0.1.0",
	Name = "Extra Keybinds"
}

::mods_registerMod(::ExtraKeybinds.ID, ::ExtraKeybinds.Version, ::ExtraKeybinds.Name);

::mods_queue(null, "mod_msu(>=1.0.0-beta)", function()
{
	::ExtraKeybinds.Mod <- ::MSU.Class.Mod(::ExtraKeybinds.ID, ::ExtraKeybinds.Version, ::ExtraKeybinds.Name);

	::ExtraKeybinds.activateSkill <- function( _skillId )
	{
		local entity = this.m.TurnSequenceBar.getTurnSequenceBarModule().getActiveEntity();
		if (entity == null || !this.isInputLocked()) return false;

		if (!entity.getSkills().hasSkill(_skillId)) return false;
		this.setActionStateBySkillId(_skillId)
		return true;
	}

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("Recover", "q", ::MSU.Key.State.Tactical, function()
	{
		::ExtraKeybinds.activateSkill.call(this, "actives.recover");
	}, "Recover");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("Rotation", "t", ::MSU.Key.State.Tactical, function()
	{
		::ExtraKeybinds.activateSkill.call(this, "actives.rotation");
	}, "Rotation");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("Indomitable", "e", ::MSU.Key.State.Tactical, function()
	{
		::ExtraKeybinds.activateSkill.call(this, "actives.indomitable");
	}, "Indomitable");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("Shieldwall", "g", ::MSU.Key.State.Tactical, function()
	{
		::ExtraKeybinds.activateSkill.call(this, "actives.shieldwall");
	}, "Shieldwall");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("Adrenaline", "h", ::MSU.Key.State.Tactical, function()
	{
		::ExtraKeybinds.activateSkill.call(this, "actives.adrenaline");
	}, "Adrenaline");

	// ::MSU.Vanilla.Keybinds.update("tactical_toggleTreesButton", "y");

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("RaiseCamera", "o", ::MSU.Key.State.Tactical, function()
	{
		this.topbar_options_onSwitchMapLevelUpButtonClicked();
	});

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("LowerCamera", "l", ::MSU.Key.State.Tactical, function()
	{
		this.topbar_options_onSwitchMapLevelDownButtonClicked();
	});

	::ExtraKeybinds.swapItemKeybind <- function( _idx )
	{
		local entity = this.m.TacticalScreen.getTurnSequenceBarModule().getActiveEntity();
		if (entity == null || !entity.isPlayerControlled()) return;
		local item = entity.getItems().getItemAtBagSlot(_idx);
		if (item == null) return;
		this.ExtraKeybinds_onSwapToItem(entity.getID(), item)
	}

	// make sure we're in the normal tactical screen (not character screen etc)
	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("SwapItem0", "f1", ::MSU.Key.State.Tactical, function()
	{
		::ExtraKeybinds.swapItemKeybind.call(this, 0);
	});

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("SwapItem1", "f2", ::MSU.Key.State.Tactical, function()
	{
		::ExtraKeybinds.swapItemKeybind.call(this, 1);
	});

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("SwapItem2", "f3", ::MSU.Key.State.Tactical, function()
	{
		::ExtraKeybinds.swapItemKeybind.call(this, 2);
	});

	::ExtraKeybinds.Mod.Keybinds.addSQKeybind("SwapItem3", "f4", ::MSU.Key.State.Tactical, function()
	{
		::ExtraKeybinds.swapItemKeybind.call(this, 3);
	});

	::include("extra_keybinds/tooltip_events");
	::include("extra_keybinds/turn_sequence_bar");
	::include("extra_keybinds/tactical_state");
	::mods_registerJS("extra_keybinds/turnsequencebar_module.js");
	::mods_registerCSS("extra_keybinds/css/turnsequencebar_module.css");
});
