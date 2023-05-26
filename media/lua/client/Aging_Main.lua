AgingMod = {}
AgingMod.age = 0
AgingMod.climateManager = getClimateManager()



AgingMod.DesaturateColor = function(age, r, g, b)


    local avgColor = (r+g+b)/3

    local desaturation = (age/1000)*avgColor        -- Way lower than the creation menu one since it's gonna happen every year
    local L = 0.299 * r + 0.587 * g + 0.144 * b

    r = r + desaturation * (L - r)
    g = g + desaturation * (L - g)
    b = b + desaturation * (L - b)


    if age > 40 and (r < desaturation or g < desaturation or b < desaturation) then
        r = 0.85
        g = 0.85
        b = 0.85
    end

    print("New color: r="..tostring(r)..",g="..tostring(g)..",b="..tostring(b))


    return ImmutableColor.new(r,g,b,1)

end

AgingMod.SetHairColor = function(age)
    print("Setting new hair color")
    local player = getPlayer()
    local humanVisual = player:getHumanVisual()
    local baseHairColor = humanVisual:getHairColor()
    local modifiedColor = AgingMod.DesaturateColor(age, baseHairColor:getRedFloat(), baseHairColor:getGreenFloat(), baseHairColor:getBlueFloat())

    humanVisual:setHairColor(modifiedColor)
	humanVisual:setBeardColor(modifiedColor)
	humanVisual:setNaturalHairColor(modifiedColor)
	humanVisual:setNaturalBeardColor(modifiedColor)
    player:resetModel()
	sendVisual(player)
	triggerEvent("OnClothingUpdated", player)

end

AgingMod.UpdateAge = function()


    -----------------
    -- DEBUG
    local t = getGameTime()
    t:setYear(t:getYear() + 1)



    ------------------




    print("Checking if we need to advance age")
    local ageData = getPlayer():getModData()["AgeMod"]
    local gameTime = getGameTime()

    local currentYear = gameTime:getYear()
    local currentMonth = gameTime:getMonth()
    local currentDay = gameTime:getDay()


    print("Starting year: " .. tostring(ageData.startingYear))

    print("Current year: " .. tostring(currentYear))
    print("Current age: " .. tostring(ageData.age))

    local oldAge = tonumber(ageData.age)

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
                --AgingMod.SetHairColor(ageData.age)

            end
        elseif yearDiff > 1 then
            ageData.age = ageData.age + yearDiff - 1

            -- Bit of a hacky way to handle it but I'm too dumb to think of something better
            ageData.startingYear = currentYear
        end
    end


    print("New age: " .. tostring(ageData.age))
    -- Since it's gonna continue adding onto the desaturation, in case the player logs off for more than a year in game,
    -- we want to keep track of that to set their correct hair color
    for i=oldAge, ageData.age, 1 do
        AgingMod.SetHairColor(i)
    end
end

AgingMod.Setup = function()
    -- TODO Ask player to set age if they did not
    print("Setting up age mod")
    local player = getPlayer()
    local ageData = player:getModData()["AgeMod"]

    if ageData == nil or ageData == 0 then

        local gameTime = getGameTime()
        player:getModData()["AgeMod"] = {}
        ageData = player:getModData()["AgeMod"]
        ageData.age = AgingMod.age
        ageData.startingDay = gameTime:getDay()
        ageData.startingMonth = gameTime:getMonth()
        ageData.startingYear = gameTime:getYear()

        print("Starting year: " .. tostring(ageData.startingYear))
    end
    --AgingMod.UpdateAge()
    Events.EveryTenMinutes.Add(AgingMod.UpdateAge)


end


Events.OnGameStart.Add(AgingMod.Setup)

Events.OnPlayerDeath.Add(function()
    Events.EveryTenMinutes.Remove(AgingMod.UpdateAge)
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
