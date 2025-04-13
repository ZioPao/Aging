AgingMod = {}
AgingMod.age = 0
AgingMod.climateManager = getClimateManager()


local gameVer = getGameVersion()

AgingMod.isB41 = luautils.stringStarts(gameVer, "41")



---@param age number
---@param r number
---@param g number
---@param b number
function AgingMod.DesaturateColor(age, r, g, b)
    local avgColor = (r + g + b) / 3

    local desaturation = (age / 1000) *
    avgColor                                 -- Way lower than the creation menu one since it's gonna happen every year
    local L = 0.299 * r + 0.587 * g + 0.144 * b


    local addedGreyness = 0.007

    r = r + desaturation * (L - r) + addedGreyness
    g = g + desaturation * (L - g) + addedGreyness
    b = b + desaturation * (L - b) + addedGreyness

    -- Desaturation here is way lower, so we need to change it a bit on how to scale it
    --local switchToGreyValue = desaturation * 3
    --print(switchToGreyValue)

    -- CAP
    if r > 1 then
        r = 1
    end

    if g > 1 then
        g = 1
    end

    if b > 1 then
        b = 1
    end

    -- if age > 40 and (r < switchToGreyValue or g < switchToGreyValue or b < switchToGreyValue) then
    --     r = 0.85 + ZombRandFloat(-0.01, 0.01)
    --     g = 0.85 + ZombRandFloat(-0.01, 0.01)
    --     b = 0.85 + ZombRandFloat(-0.01, 0.01)
    -- end

    print("New color: r=" .. tostring(r) .. ",g=" .. tostring(g) .. ",b=" .. tostring(b))


    return ImmutableColor.new(r, g, b, 1)
end

function AgingMod.SetHairColor(age)


    -- TODO In-Game ui or during char creation.


    -- CHAR CREATION MODE

    local humanVisual = MainScreen.instance.desc:getHumanVisual()

    local hairColors = MainScreen.instance.desc:getCommonHairColor()
    local hairColors1 = {}
    local info = ColorInfo.new()
    local desaturation = age/100


    for i=1,hairColors:size() do
        local color = hairColors:get(i-1)
        -- we create a new info color to desaturate it (like in the game)
        info:set(color:getRedFloat(), color:getGreenFloat(), color:getBlueFloat(), 1)

        --print(i)
        local r = info:getR() --+ greyScaler
        local g = info:getG() --+ greyScaler
        local b = info:getB() --+ greyScaler

        local L = 0.299 * r + 0.587 * g + 0.144 * b

        r = r + desaturation * (L - r)
        g = g + desaturation * (L - g)
        b = b + desaturation * (L - b)

        if age > 40 and (r < desaturation or g < desaturation or b < desaturation) then
            --print("Invalid hair color")
        else

            --print("Current color: R=" .. r .. ", G=" .. g .. ", B=" .. b)
            table.insert(hairColors1, { r=r, g=g, b=b})
        end

    end

    if hairColors[1] == nil then
        table.insert(hairColors1, {r=0.8, g=0.8, b=0.8})
    end


    local colorPicker = CharacterCreationMain.instance.colorPickerHair
    colorPicker:setColors(hairColors1, math.min(#hairColors1, 10), math.ceil(#hairColors1 / 10))

    local color = colorPicker.colors[colorPicker.index]
    local modifiedColor = AgingMod.DesaturateColor(age, color.r, color.g, color.b)


    humanVisual:setHairColor(modifiedColor)
    humanVisual:setBeardColor(modifiedColor)
    humanVisual:setNaturalHairColor(modifiedColor)
    humanVisual:setNaturalBeardColor(modifiedColor)



    CharacterCreationMain.instance.avatarPanel:setSurvivorDesc(MainScreen.instance.desc)




    -- local player
    -- if AgingMod.isB41 then
    --     player = getPlayer()
    -- else
    --     player = MainScreen.instance.desc -- technically player desc but whatever
    -- end

    -- local humanVisual = player:getHumanVisual()
    -- local baseHairColor = humanVisual:getHairColor()

    -- if AgingMod.isB41 then
    --     baseHairColor = humanVisual:getHairColor()
    -- else
    --     local colPicker = CharacterCreationMain.instance.colorPickerHair
    --     local colors = colPicker.colors[colPicker.index]
    --     baseHairColor = ImmutableColor.new(colors.r, colors.g, colors.b, 1)
    -- end



    -- if AgingMod.isB41 then
    --     player:resetModel()
    --     sendVisual(player)
    --     triggerEvent("OnClothingUpdated", player)
    -- else
    --     CharacterCreationMain.instance.avatarPanel:setSurvivorDesc(player)
    -- end
end

---@param entry ISTextEntryBox
function AgingMod.ValidateAge(entry)
    local age = entry:getInternalText()

    if age and age ~= "" then
        age = tonumber(age)
        AgingMod.age = age

        local check = age > 17 and age < 101
        entry:setValid(check)
        if check then
            AgingMod.SetHairColor(age)
        end
    else
        entry:setValid(false)
    end
end

local function RunSetHairColor(oldAge, newAge)
    --print("New age: " .. tostring(ageData.age))
    -- Since it's gonna continue adding onto the desaturation, in case the player logs off for more than a year in game,
    -- we want to keep track of that to set their correct hair color
    for i = oldAge, newAge, 1 do
        AgingMod.SetHairColor(i)
    end
end



function AgingMod.UpdateAge()
    ---------------
    --DEBUG
    -- print("DEBUG AGE MOD")
    -- local t = getGameTime()
    -- t:setYear(t:getYear() + 1)
    ------------------

    --print("Checking if we need to advance age")
    local ageData = getPlayer():getModData()["AgeMod"]
    local gameTime = getGameTime()

    local currentYear = gameTime:getYear()
    local currentMonth = gameTime:getMonth()
    local currentDay = gameTime:getDay()


    --print("Starting year: " .. tostring(ageData.startingYear))
    --print("Current year: " .. tostring(currentYear))
    --print("Current age: " .. tostring(ageData.age))

    local oldAge = tonumber(ageData.age)

    -- 01/05/1993
    --02/06/1994
    local yearDiff = currentYear - ageData.startingYear        -- 1
    if yearDiff > 0 then
        local monthDiff = currentMonth - ageData.startingMonth -- 4 - 5, -1
        if monthDiff >= 0 then
            local dayDiff = currentDay - ageData.startingDay   --
            if dayDiff >= 0 then
                print("daydiff >= 0")
                ageData.age = ageData.age + yearDiff
                ageData.startingYear = currentYear
                RunSetHairColor(oldAge, ageData.age)
            end
        elseif yearDiff > 1 then
            --print("yearDiff >= 0")

            ageData.age = ageData.age + yearDiff - 1

            -- Bit of a hacky way to handle it but I'm too dumb to think of something better
            ageData.startingYear = currentYear
            RunSetHairColor(oldAge, ageData.age)
        end
    end

    -- for i=oldAge, ageData.age, 1 do
    --     AgingMod.SetHairColor(i)
    -- end
end

function AgingMod.Setup()
    print("Setting up age mod")
    local player = getPlayer()
    local ageData = player:getModData()["AgeMod"]


    if ageData and ageData.age and ageData.age ~= 0 then
        Events.EveryDays.Add(AgingMod.UpdateAge)
    else
        print("Nil or age = 0")
        player:getModData()["AgeMod"] = {}
        local gameTime = getGameTime()
        ageData = player:getModData()["AgeMod"]
        ageData.startingDay = gameTime:getDay()
        ageData.startingMonth = gameTime:getMonth()
        ageData.startingYear = gameTime:getYear()

        if AgingMod.age ~= 0 then
            print("Different than 0")
            ageData.age = AgingMod.age
            Events.EveryDays.Add(AgingMod.UpdateAge)
        elseif AgingMod.age == 0 or AgingMod.age == nil then
            print("Starting panel!")
            AgingMod_ChoiceUI.OpenPanel()
        end
    end
end

---------------

Events.OnGameStart.Add(AgingMod.Setup)

Events.OnPlayerDeath.Add(function()
    Events.EveryDays.Remove(AgingMod.UpdateAge)
end)


local og_ISCharacterScreenRender = ISCharacterScreen.render
function ISCharacterScreen:render()
    og_ISCharacterScreenRender(self)

    local z = 60

    local ageData = getPlayer():getModData()["AgeMod"]

    if ageData then
        self:drawTextRight("Age", self.xOffset, z, 1, 1, 1, 1, UIFont.Small)
        local ageStr = tostring(ageData.age)
        self:drawText(ageStr, self.xOffset + 10, z, 1, 1, 1, 0.5, UIFont.Small)
    end




    -- self:drawTextRight(getText("IGUI_char_Weight"), self.xOffset, z, 1,1,1,1, UIFont.Small);
    -- local weightStr = tostring(round(self.char:getNutrition():getWeight(), 0))
    -- self:drawText(weightStr, self.xOffset + 10, z, 1,1,1,0.5, UIFont.Small);
end
