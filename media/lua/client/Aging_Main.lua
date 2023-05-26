AgingMod = {}
AgingMod.age = 0


Events.OnGameStart.Add(function()

    -- TODO Ask player to set age if they did not


    local player = getPlayer()
    local ageData = player:getModData()["AgeMod"]
    
    if ageData == nil or ageData == 0 then
        player:getModData()["AgeMod"] = AgingMod.age
    end
end)



local og_ISCharacterScreenRender = ISCharacterScreen.render
function ISCharacterScreen:render()
    og_ISCharacterScreenRender(self)

    local z = 60

    self:drawTextRight("Age", self.xOffset, z, 1,1,1,1, UIFont.Small)
    local ageStr = tostring(getPlayer():getModData()["AgeMod"])
    self:drawText(ageStr, self.xOffset + 10, z, 1,1,1,0.5, UIFont.Small)


    -- self:drawTextRight(getText("IGUI_char_Weight"), self.xOffset, z, 1,1,1,1, UIFont.Small);
    -- local weightStr = tostring(round(self.char:getNutrition():getWeight(), 0))
    -- self:drawText(weightStr, self.xOffset + 10, z, 1,1,1,0.5, UIFont.Small);



end




-- local og_ISPlayerStatsUIRender = ISPlayerStatsUI.render
-- function ISPlayerStatsUI:render()
--     og_ISPlayerStatsUIRender(self)


-- end