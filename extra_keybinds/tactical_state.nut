::mods_hookExactClass("states/tactical_state", function (o)
{
	o.ExtraKeybinds_onSwapToItem <- function ( _entityId, _item )
	{
		if (this.m.CurrentActionState != null)
		{
			::Tooltip.reload();
			::Tactical.TurnSequenceBar.deselectActiveSkill();
			::Tactical.getHighlighter().clear();
			this.m.CurrentActionState = null;
			this.m.SelectedSkillId = null;
			this.updateCursorAndTooltip();
		}

		return this.m.CharacterScreen.onEquipBagItem([
			_entityId,
			_item.getInstanceID()
		]);
	};
});
