::mods_hookExactClass("ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function (o)
{
	::logInfo("hooked turn_sequence_bar");
	o.ExtraKeybinds_onQueryEntityItemSwaps <- function( _entityId )
	{
		local entity = this.findEntityByID(this.m.CurrentEntities, _entityId).entity;
		if (entity != null && entity.isPlayerControlled())
		{
			local ret = [];
			foreach (i, item in entity.getItems().getAllItemsAtSlot(::Const.ItemSlot.Bag)) // can't be null
			{
				if (item.getSlotType() == ::Const.ItemSlot.Bag) continue;
				local currentItem = entity.getItems().getItemAtSlot(item.getSlotType()) // can be null
				local blockedItem = entity.getItems().getItemAtSlot(item.getBlockedSlotType()) // can be null
				ret.push({
					id = item.getID(),
					idx = i,
					instanceId = item.getInstanceID(),
					imagePath = "ui/items/" + item.getIcon(),
					isUsable = item.isChangeableInBattle() && (currentItem == null || currentItem.isChangeableInBattle() && (blockedItem == null || blockedItem.isChangeableInBattle()))
					isAffordable = entity.getItems().isActionAffordable([currentItem, item, blockedItem])
				});
			}
			return ret;
		}
		return null;
	}

	o.ExtraKeybinds_swapToItem <- function( _data )
	{
		// _data = {entityId, idx}
		local entityEntry = this.findEntityByID(this.m.CurrentEntities, _data.entityId);
		if (entityEntry == null || !entityEntry.entity.isPlayerControlled()) return;

		local item = entityEntry.entity.getItems().getItemAtBagSlot(_data.idx);
		if (item == null) return;

		::Tactical.State.ExtraKeybinds_onSwapToItem(_data.entityId, item);
	}
});
