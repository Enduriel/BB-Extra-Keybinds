::ExtraKeybinds.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function (q)
{
	q.general_queryUIElementTooltipData = @(__original) function( _entityId, _elementId, _elementOwner )
	{
		local ret = __original(_entityId, _elementId, _elementOwner);

		switch(_elementId)
		{
			case "tactical-screen.turn-sequence-bar-module.EndTurnAllButton":
				foreach (section in ret)
				{
					if (section.type == "title")
					{
						section.text = ::MSU.String.replace(section.text, "(R)", "(" + ::MSU.Vanilla.ModSettings.getSetting("tactical_toggleTreesButton").getValue() + ")");
						break;
					}
				}
				break;
			case "tactical-screen.topbar.options-bar-module.SwitchMapLevelUpButton":
				foreach (section in ret)
				{
					if (section.type == "title")
					{
						section.text = ::MSU.String.replace(section.text, "(+)", "(" + ::ExtraKeybinds.Mod.ModSettings.getSetting("RaiseCamera").getValue() + ")")
						break;
					}
				}
				break;
			case "tactical-screen.topbar.options-bar-module.SwitchMapLevelDownButton":
				foreach (section in ret)
				{
					if (section.type == "title")
					{
						section.text = ::MSU.String.replace(section.text, "(-)", "(" + ::ExtraKeybinds.Mod.ModSettings.getSetting("LowerCamera").getValue() + ")")
						break;
					}
				}
		}
		return ret;
	}

	q.tactical_queryUIItemTooltipData = @(__original) function( _entityId, _itemId, _itemOwner )
	{
		if (_itemOwner == "ExtraKeybinds")
		{
			local entity = ::Tactical.getEntityByID(_entityId);;
			if (entity != null)
			{
				local item = entity.getItems().getItemByInstanceID(_itemId);
				if (item != null)
				{
					local ret = this.tactical_helper_addHintsToTooltip(entity, entity, item, _itemOwner);
					local currentItem = entity.getItems().getItemAtSlot(item.getSlotType());
					local blockedItem = entity.getItems().getItemAtSlot(item.getBlockedSlotType())
					if (entity.getItems().isActionAffordable([item, currentItem, blockedItem]))
					{
						ret.push({
							id = 1,
							type = "hint",
							icon = "ui/icons/mouse_left_button.png",
							text = "Equip item ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + entity.getItems().getActionCost([
								item, currentItem, blockedItem
							]) + "[/color][/b] AP)"
						});
					}

					return ret;
				}
			}
			return null;
		}
		return __original(_entityId, _itemId, _itemOwner);

	}

});
