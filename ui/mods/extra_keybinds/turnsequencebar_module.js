var ExtraKeybinds = {
	ID : "mod_extra_keybinds",
	Skills : [
		"actives.recover",
		"actives.rotation",
		"actives.indomitable",
		"actives.shieldwall",
		"actives.adrenaline"
	]
};

ExtraKeybinds.TacticalScreenTurnSequenceBarModule_addSkillToList = TacticalScreenTurnSequenceBarModule.prototype.addSkillToList;
TacticalScreenTurnSequenceBarModule.prototype.addSkillToList = function (_entity, _skill, _label)
{
	ExtraKeybinds.TacticalScreenTurnSequenceBarModule_addSkillToList.call(this, _entity, _skill, _label);
	var keybindTextObject = this.mSkillsContainer.find('.l-skill > .skill > .text-layer > .numeration-label:last')
	if (keybindTextObject != undefined && ExtraKeybinds.Skills.indexOf(_skill.id) != -1)
	{
		keybindTextObject.html(keybindTextObject.html() + '/' + MSU.Key.capitalizeKeyString(MSU.getSettingValue(ExtraKeybinds.ID, MSU.capitalizeFirst(_skill.id.replace("actives.", "")))));
	}
}

// ExtraKeybinds.TacticalScreenTurnSequenceBarModule_onConnection = TacticalScreenTurnSequenceBarModule.prototype.onConnection;
// TacticalScreenTurnSequenceBarModule.prototype.onConnection = function (_handle)
// {
// 	ExtraKeybinds.TacticalScreenTurnSequenceBarModule_onConnection.call(this, _handle);
// 	this.mSwapItemsContainer = null;
// }

ExtraKeybinds.TacticalScreenTurnSequenceBarModule_createDIV = TacticalScreenTurnSequenceBarModule.prototype.createDIV;
TacticalScreenTurnSequenceBarModule.prototype.createDIV = function (_parentDiv)
{
	ExtraKeybinds.TacticalScreenTurnSequenceBarModule_createDIV.call(this, _parentDiv);
	this.mSwapItemsContainer = $('<div class="swap-items-container"/>');
	this.mSkillsContainer.before(this.mSwapItemsContainer);
}

ExtraKeybinds.TacticalScreenTurnSequenceBarModule_destroyDIV = TacticalScreenTurnSequenceBarModule.prototype.destroyDIV;
TacticalScreenTurnSequenceBarModule.prototype.destroyDIV = function ()
{
	this.mSwapItemsContainer.empty();
	this.mSwapItemsContainer.remove();
	this.mSwapItemsContainer = null;
	ExtraKeybinds.TacticalScreenTurnSequenceBarModule_destroyDIV.call(this);
}

ExtraKeybinds.TacticalScreenTurnSequenceBarModule_showStatsPanel = TacticalScreenTurnSequenceBarModule.prototype.showStatsPanel;
TacticalScreenTurnSequenceBarModule.prototype.showStatsPanel = function (_show, _instant)
{
	ExtraKeybinds.TacticalScreenTurnSequenceBarModule_showStatsPanel.call(this, _show, _instant);
	if (_instant !== undefined && typeof(_instant) == 'boolean')
	{
		this.mSwapItemsContainer.css({ opacity : _show ? 1 : 0 });
		if (_show) this.mSwapItemsContainer.removeClass('display-none').addClass('display-block');
		else this.mSwapItemsContainer.addClass('display-none').removeClass('display-block');
	}
	else
	{
		this.mSwapItemsContainer.velocity("finish", true).velocity({ opacity: _show ? 1 : 0 },
		{
			duration: _show ? this.mStatsPanelFadeInTime : this.mStatsPanelFadeOutTime,
			easing: 'swing',
			begin: function ()
			{
			if (_show)
				$(this).removeClass('display-none').addClass('display-block');
			},
				complete: function ()
			{
			if (!_show)
				$(this).removeClass('display-block').addClass('display-none');
			}
		});
	}
}
// id = item.getID(),
// idx = i,
// imagePath = "ui/icons/" + item.getIcon(),
// isUsable = item.isChangeableInBattle() && (currentItem == null || currentItem.isChangeableInBattle() && (blockedItem == null || blockedItem.isChangeableInBattle()))
// isAffordable = entity.getItems().isActionAffordable([currentItem, item, blockedItem])
ExtraKeybinds.TacticalScreenTurnSequenceBarModule_updateEntitySkills = TacticalScreenTurnSequenceBarModule.prototype.updateEntitySkills;
TacticalScreenTurnSequenceBarModule.prototype.updateEntitySkills = function (_entityData)
{
	ExtraKeybinds.TacticalScreenTurnSequenceBarModule_updateEntitySkills.call(this, _entityData);

	if (_entityData === null || typeof(_entityData) != 'object' || !('id' in _entityData)) return;

	var self = this;
	if ('isEnemy' in _entityData && _entityData.isEnemy)
	{
		this.ExtraKeybinds_showSwapItemsBar(false);
	}
	else
	{
		this.ExtraKeybinds_notifybackendQueryEntityItemSwaps(_entityData.id, function (_bagItems)
		{
			if (_bagItems === null || !jQuery.isArray(_bagItems) || _bagItems.length === 0)
			{
				self.ExtraKeybinds_showSwapItemsBar(false);
				return;
			}

			self.mSwapItemsContainer.empty();

			for (var i = 0; i < _bagItems.length; i++) {
				self.ExtraKeybinds_addSwapItemToList(_entityData.id, _bagItems[i]);
			}

			self.showEntitySkillbar(_bagItems.length > 0);
		})
	}
}

TacticalScreenTurnSequenceBarModule.prototype.ExtraKeybinds_addSwapItemToList = function (_entityId, _item)
{
	var swapItemLayout = $('<div class="l-swap-item"/>');
	this.mSwapItemsContainer.append(swapItemLayout);
	if (_item === null)
	{
		swapItemLayout.addClass('opacity-none')
		return;
	}
	swapItemLayout.bindTooltip({ contentType: 'ui-item', entityId: _entityId, itemId: _item.instanceId, itemOwner: "ExtraKeybinds" });

	swapItemLayout.append($('<div class="selected-outline"/>'))

	var swapItemContainer = $('<div class="swap-item"/>');
	swapItemLayout.append(swapItemContainer);
	swapItemContainer.data('item', {entityId : _entityId, idx : _item.idx});

	var imageLayer = $('<div class="image-layer"/>');
	swapItemContainer.append(imageLayer);
	var image = $('<img/>');
	image.attr('src', Path.GFX + _item.imagePath);
	imageLayer.append(image);

	var self = this;
	if (_item.isUsable && _item.isAffordable)
	{
		swapItemContainer.click(this, function(_event)
		{
			var self = _event.data;
			var data = $(this).data('item');
			self.ExtraKeybinds_notifybackendswapToItem(data)
		});
		swapItemLayout.mouseenter(this, function (_event) {
			$(this).removeClass('is-selected').addClass('is-selected');
		});
		swapItemLayout.mouseleave(this, function (_event)
		{
			$(this).removeClass('is-selected');
		});
	}
	else
	{
		swapItemLayout.attr('disabled', 'disabled')
	}

	if (_item.idx <= 4)
	{
		var textLayer = $('<div class="text-layer"/>');
		swapItemContainer.append(textLayer);
		var label = $('<div class="numeration-label text-font-very-small font-bold font-color-numeration-label"></div>');
		label.html(MSU.Key.capitalizeKeyString(MSU.getSettingValue(ExtraKeybinds.ID, "SwapItem" + _item.idx)));
		textLayer.append(label);
	}
}

TacticalScreenTurnSequenceBarModule.prototype.ExtraKeybinds_notifyItemTooltipsToHide = function ()
{
	// notify each item skill that it is about to get deleted - hide the tooltip
	this.mSwapItemsContainer.find('.l-swap-item').each(function(index, element) {
		var itemSkill = $(element);
		if (itemSkill.length > 0)
		{
			itemSkill.unbindTooltip();
		}
	});
};

TacticalScreenTurnSequenceBarModule.prototype.ExtraKeybinds_showSwapItemsBar = function (_show)
{
	if (!_show)
	{
		this.ExtraKeybinds_notifyItemTooltipsToHide();
	}

	var self = this;
	this.mSwapItemsContainer.velocity("finish", true).velocity({ opacity: _show ? 1 : 0 },
	{
		duration: _show ? this.mStatsPanelFadeInTime : this.mStatsPanelFadeOutTime,
		complete: function()
		{
			self.mSwapItemsContainer.empty();
		}
	});
}

TacticalScreenTurnSequenceBarModule.prototype.ExtraKeybinds_notifybackendQueryEntityItemSwaps = function (_entityId, _callback)
{
	SQ.call(this.mSQHandle, "ExtraKeybinds_onQueryEntityItemSwaps", _entityId, _callback);
}

TacticalScreenTurnSequenceBarModule.prototype.ExtraKeybinds_notifybackendswapToItem = function (_data)
{
	SQ.call(this.mSQHandle, "ExtraKeybinds_swapToItem", _data, null);
}
