::ExtraKeybinds.HooksMod.hook("scripts/states/tactical_state", function (q)
{
	q.ExtraKeybinds_onSwapToItem <- function ( _entityId, _item )
	{
		if (this.m.CurrentActionState != null)
		{
			::Tooltip.reload();
			::Tactical.TurnSequenceBar.deselectActiveSkill();
			::Tactical.getHighlighter().clear();
			this.m.CurrentActionState = null;
			this.m.SelectedSkillID = null;
			this.updateCursorAndTooltip();
		}
		local result = this.m.CharacterScreen.onEquipBagItem([
			_entityId,
			_item.getInstanceID()
		]);
		return result != null && !("error" in result); // this is very stupid
	};
});
