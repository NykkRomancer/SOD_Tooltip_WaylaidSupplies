local function TTWS_FormatMoney(value)
    local money_string = "|cffffffff0|r|cffeda55fc|r"
    local isNegative = value < 0

	value = abs(value)
	local gold = floor(value / COPPER_PER_GOLD)
	local silver = floor((value % COPPER_PER_GOLD) / COPPER_PER_SILVER)
	local copper = floor(value % COPPER_PER_SILVER)

	if value ~= 0 then
        money_string = ""
        -- add gold
        if gold > 0 then
            money_string = money_string .. "|cffffffff" .. gold .. "|r|cffffd70ag|r"
        end

        -- add silver
        if silver > 0 then
            if gold > 0 then
                money_string = money_string .. " "
            end
            money_string = money_string .. "|cffffffff" .. silver .. "|r|cffc7c7cfs|r"
        end
        -- add copper
        if copper > 0 then
            if gold > 0 or silver > 0 then
                money_string = money_string .. " "
            end
            money_string = money_string .. "|cffffffff" .. copper .. "|r|cffeda55fc|r"
        end

        if isNegative then
            money_string = "-" .. money_string
        end
    end

    return money_string
end

local itemList = {}

for _, data in pairs(NykkRomancer.SOD_WaylaidSupplies) do
    itemList[data.Item.ID] = {
        Qty = data.Item.Quantity,
        Rep = data.Reputation,
        Val = data.Money / data.Item.Quantity,
    }
end

local function AddCustomText(tooltip, itemID)
    if itemList[itemID] then
        tooltip:AddDoubleLine("|cff69ccf0Waylaid Supplies (|r|cff0070ffx" .. itemList[itemID].Qty .. "|r|cff69ccf0)|r", TTWS_FormatMoney(itemList[itemID].Val))
    elseif NykkRomancer.SOD_WaylaidSupplies[itemID] then
        tooltip:AddDoubleLine("|cff0070ffReputation Value (|r|cff69ccf0" .. NykkRomancer.SOD_WaylaidSupplies[itemID].Reputation .. "|r|cff0070ff)|r", TTWS_FormatMoney(NykkRomancer.SOD_WaylaidSupplies[itemID].Money))
    end
end

GameTooltip:HookScript("OnTooltipSetItem", function(self)
    local name, link = self:GetItem();
    if link then
        local itemID = select(1, GetItemInfoInstant(link));
        AddCustomText(self, itemID);
    end
end)

ItemRefTooltip:HookScript("OnTooltipSetItem", function(self)
    local name, link = self:GetItem();
    if link then
        local itemID = select(1, GetItemInfoInstant(link));
        AddCustomText(self, itemID);
    end
end)
