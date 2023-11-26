::ExtraKeybinds.HooksMod.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function (q)
{
	q.ExtraKeybinds_onQueryEntityItemSwaps <- function( _entityId )
	{
		local entity = this.findEntityByID(this.m.CurrentEntities, _entityId).entity;
		if (entity != null && entity.isPlayerControlled())
		{
			local items = entity.getItems().m.Items[::Const.ItemSlot.Bag]
			local ret = array(items.len());
			foreach (i, item in items) // can be null
			{
				if (item == null || item.getSlotType() == ::Const.ItemSlot.Bag) continue;
				local currentItem = entity.getItems().getItemAtSlot(item.getSlotType()) // can be null
				local blockedItem = entity.getItems().getItemAtSlot(item.getBlockedSlotType()) // can be null
				local needsExtraSlot = [currentItem, blockedItem].filter(@(_, _i) _i != null).len() == 2;
				local isUsable = !(needsExtraSlot && !entity.getItems().hasEmptySlot(::Const.ItemSlot.Bag));
				if (::Hooks.hasMod("mod_legends"))
					isUsable = isUsable && item.isChangeableInBattle(entity) && (currentItem == null || currentItem.isChangeableInBattle(entity) && (blockedItem == null || blockedItem.isChangeableInBattle(entity)))
				else
					isUsable = isUsable && item.isChangeableInBattle() && (currentItem == null || currentItem.isChangeableInBattle() && (blockedItem == null || blockedItem.isChangeableInBattle()))
				ret[i] = {
					id = item.getID(),
					idx = i,
					instanceId = item.getInstanceID(),
					imagePath = "ui/items/" + item.getIcon(),
					isUsable = isUsable,
					isAffordable = entity.getItems().isActionAffordable([item, currentItem, blockedItem])
				};
			}
			return ret;
		}
		return null;
	}

	q.ExtraKeybinds_swapToItem <- function( _data )
	{
		// _data = {entityId, idx}
		local entityEntry = this.findEntityByID(this.m.CurrentEntities, _data.entityId);
		if (entityEntry == null || !entityEntry.entity.isPlayerControlled()) return;

		local item = entityEntry.entity.getItems().getItemAtBagSlot(_data.idx);
		if (item == null) return;

		::Tactical.State.ExtraKeybinds_onSwapToItem(_data.entityId, item);
	}
});
