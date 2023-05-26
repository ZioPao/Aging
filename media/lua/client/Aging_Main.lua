AgingMod = {}
AgingMod.age = 0
AgingMod.climateManager = getClimateManager()



AgingMod.DesaturateColor = function(age, r, g, b)

    local desaturation = age/100
    local L = 0.299 * r + 0.587 * g + 0.144 * b

    r = r + desaturation * (L - r)
    g = g + desaturation * (L - g)
    b = b + desaturation * (L - b)

    return ImmutableColor.new(r,g,b,1)

end


AgingMod.SetHairColor = function(age)
    local humanVisual = getPlayer():getHumanVisual()
    local baseHairColor = humanVisual:getHairColor()
    local modifiedColor = AgingMod.DesaturateColor(age, baseHairColor.r, baseHairColor.g, baseHairColor.b)

	humanVisual:setHairColor(modifiedColor)
	humanVisual:setBeardColor(modifiedColor)
	humanVisual:setNaturalHairColor(modifiedColor)
	humanVisual:setNaturalBeardColor(modifiedColor)

end

AgingMod.UpdateAge = function()
    local dayInfo = AgingMod.climateManager:getCurrentDay()
    local ageData = getPlayer():getModData()["AgeMod"]

    local currentYear = dayInfo:getYear()
    local currentMonth = dayInfo:getMonth()
    local currentDay = dayInfo:getDay()

    -- 01/05/1993
    --02/06/1994
    local yearDiff = currentYear - ageData.startingYear -- 1
    if yearDiff >= 0 then
        local monthDiff = currentMonth - ageData.startingMonth -- 4 - 5, -1
        if monthDiff >= 0 then
            local dayDiff = currentDay - ageData.startingDay -- 
            if dayDiff >= 0 then
                ageData.age = ageData.age + yearDiff
                ageData.startingYear = currentYear
                AgingMod.SetHairColor(ageData.age)

            end
        elseif yearDiff > 1 then
            ageData.age = ageData.age + yearDiff - 1
            AgingMod.SetHairColor(ageData.age)

            -- Bit of a hacky way to handle it but I'm too dumb to think of something better
            ageData.startingYear = currentYear
        end
    end





end


AgingMod.Setup = function()
    -- TODO Ask player to set age if they did not

    local player = getPlayer()
    local ageData = player:getModData()["AgeMod"]
    local dayInfo = AgingMod.climateManager:getCurrentDay()

    if ageData == nil or ageData == 0 then

        player:getModData()["AgeMod"] = {}
        ageData = player:getModData()["AgeMod"]
        ageData.age = AgingMod.age
        ageData.startingDay = dayInfo:getDay()
        ageData.startingMonth = dayInfo:getMonth()
        ageData.startingYear = dayInfo:getYear()
    end

    Events.EveryDays.Add(AgingMod.UpdateAge)


end


Events.OnGameStart.Add(AgingMod.Setup)
Events.OnPlayerDeath(function()
    Events.EveryDays.Remove(AgingMod.UpdateAge)
end)


local og_ISCharacterScreenRender = ISCharacterScreen.render
function ISCharacterScreen:render()
    og_ISCharacterScreenRender(self)

    local z = 60

    local ageData = getPlayer():getModData()["AgeMod"]

    if ageData then
        self:drawTextRight("Age", self.xOffset, z, 1,1,1,1, UIFont.Small)
        local ageStr = tostring(ageData.age)
        self:drawText(ageStr, self.xOffset + 10, z, 1,1,1,0.5, UIFont.Small)
    end




    -- self:drawTextRight(getText("IGUI_char_Weight"), self.xOffset, z, 1,1,1,1, UIFont.Small);
    -- local weightStr = tostring(round(self.char:getNutrition():getWeight(), 0))
    -- self:drawText(weightStr, self.xOffset + 10, z, 1,1,1,0.5, UIFont.Small);



end
