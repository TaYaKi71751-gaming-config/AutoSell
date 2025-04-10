local slots = {"Head", "Neck", "Shoulder", "Back", "Chest", "Shirt", "Wrist", "Waist", "Legs", "Feet", "Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "MainHand", "SecondaryHand"}

-- Function to get item level of a specific item (either equipped or in the bag)
local function GetItemLevel(itemLink)
    if itemLink then
					   local itemLevel = GetDetailedItemLevelInfo(itemLink)
        return itemLevel
    end
    return nil
end
local function GetItemEquipLoc(itemLink)
    if itemLink then
				    local _,_,_,_,_,_,_,_,itemEquipLoc = GetItemInfo(itemLink)
								return itemEquipLoc
				end
end
local function GetItemSellPrice(itemLink)
    if itemLink then
				    local _,_,_,_,_,_,_,_,_,_,itemSellPrice = GetItemInfo(itemLink)
								return itemSellPrice
				end
end
local function GetItemRarity(itemLink)
    if itemLink then
				    local _,_,itemRarity = GetItemInfo(itemLink)
								return itemRarity
				end
end

local function AutoSell()
    local delay = 0
    for _, slotName in ipairs(slots) do
        local slotID = GetInventorySlotInfo(slotName.."Slot") -- Get the ID for the specific equipment slot
        local itemLink = GetInventoryItemLink("player", slotID) -- Get the item link for the equipped item in that slot
        -- If the slot has an item equipped
        if itemLink then
            local currentItemLevel = GetItemLevel(itemLink)
												local currentItemEquipLoc = GetItemEquipLoc(itemLink)
            
            -- Check all items in the player's bags to see if any item has a higher item level
            for bag = 0, 4 do
                for slotInBag = 1, C_Container.GetContainerNumSlots(bag) do
                    local bagItemLink = C_Container.GetContainerItemLink(bag, slotInBag)  -- Get the item link from the bag slot
                    
                    -- Check if the bag slot has an item and get the item level if valid
                    if bagItemLink then
                        local bagItemLevel = GetItemLevel(bagItemLink)
																								local bagItemEquipLoc = GetItemEquipLoc(bagItemLink)
																								local bagItemSellPrice = GetItemSellPrice(bagItemLink)
																								local bagItemRarity = GetItemRarity(bagItemLink)
																								if bagItemSellPrice ~= 0 and bagItemEquipLoc == "INVTYPE_NON_EQUIP_IGNORE" then
																								end
                        if bagItemSellPrice ~= 0 and bagItemLevel and bagItemEquipLoc and bagItemEquipLoc ~= "INVTYPE_NON_EQUIP_IGNORE" and bagItemRarity < 2 then
																								    delay = delay + 0.5
																									   C_Timer.After(delay, function()
																													C_Container.UseContainerItem(bag, slotInBag)  -- Sell item
																												end)
																								end
                        -- If the bag item has a higher item level, equip it
                        if bagItemSellPrice ~= 0 and bagItemLevel and bagItemEquipLoc and bagItemEquipLoc ~= "INVTYPE_NON_EQUIP_IGNORE" and bagItemLevel <= currentItemLevel then
																								    delay = delay + 0.5
																									   C_Timer.After(delay, function()
																													C_Container.UseContainerItem(bag, slotInBag)  -- Sell item
																												end)
                        end
                    end
                end
            end
        end
    end
end
local frame = CreateFrame("Frame")
frame:RegisterEvent("MERCHANT_SHOW")


frame:SetScript("OnEvent", function(self, event)
    if event == "MERCHANT_SHOW" then
				    AutoSell()
    end
end)
