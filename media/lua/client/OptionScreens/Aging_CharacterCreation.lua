require "OptionScreens/CharacterCreationMain"
require "OptionScreens/CharacterCreationHeader"

local function SetHairColor(age)
    --print("Setting hair to age " .. tostring(age))
    local hairColors = MainScreen.instance.desc:getCommonHairColor()
    local hairColors1 = {}
    local info = ColorInfo.new()


    local desaturation = age/100
    --print("Desaturation: " .. tostring(desaturation))
    for i=1,hairColors:size() do
        local color = hairColors:get(i-1)
        -- we create a new info color to desaturate it (like in the game)
        info:set(color:getRedFloat(), color:getGreenFloat(), color:getBlueFloat(), 1)
        --		info:desaturate(0.5)

        --print(i)


        local r = info:getR() --+ greyScaler
        local g = info:getG() --+ greyScaler
        local b = info:getB() --+ greyScaler

        local L = 0.299 * r + 0.587 * g + 0.144 * b

        r = r + desaturation * (L - r)
        g = g + desaturation * (L - g)
        b = b + desaturation * (L - b)


        -- if age > 40 then
        --     r = (r+g+b)/3
        --     g = (r+g+b)/3
        --     b = (r+g+b)/3
        -- end

        if age > 40 and (r < desaturation or g < desaturation or b < desaturation) then
            --print("Invalid hair color")
        else

            --print("Current color: R=" .. r .. ", G=" .. g .. ", B=" .. b)
            table.insert(hairColors1, { r=r, g=g, b=b})
        end



        -- if r < 0.4 or g < 0.4 or b < 0.4 then
        --     r = 0.75
        --     g = 0.75
        --     b = 0.75
        -- end


    end

    if hairColors[1] == nil then
        table.insert(hairColors1, {r=0.8, g=0.8, b=0.8})
    end
    CharacterCreationMain.instance.colorPickerHair:setColors(hairColors1, math.min(#hairColors1, 10), math.ceil(#hairColors1 / 10))
    -- TODO Force apply hair!

    local color = CharacterCreationMain.instance.colorPickerHair.colors[1]
    CharacterCreationMain.instance.hairColorButton.backgroundColor = { r=color.r, g=color.g, b=color.b, a = 1 }
	local desc = MainScreen.instance.desc
	local immutableColor = ImmutableColor.new(color.r, color.g, color.b, 1)
	desc:getHumanVisual():setHairColor(immutableColor)
	desc:getHumanVisual():setBeardColor(immutableColor)
	desc:getHumanVisual():setNaturalHairColor(immutableColor)
	desc:getHumanVisual():setNaturalBeardColor(immutableColor)
	CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)


end



local og_CharacterCreationMainCreateHairTypeBtn = CharacterCreationMain.createHairTypeBtn
function CharacterCreationMain:createHairTypeBtn()
    og_CharacterCreationMainCreateHairTypeBtn(self)
    SetHairColor(25)
    -- print("Forcing index 1 for hair color")
    -- CharacterCreationMain.instance.colorPickerHair:picked(true)

    -- local color = self.colorPickerHair.colors[1]
    -- CharacterCreationMain.instance.hairColorButton.backgroundColor = { r=color.r, g=color.g, b=color.b, a = 1 }
	-- local desc = MainScreen.instance.desc
	-- local immutableColor = ImmutableColor.new(color.r, color.g, color.b, 1)
	-- desc:getHumanVisual():setNaturalHairColor(immutableColor)
	-- desc:getHumanVisual():setNaturalBeardColor(immutableColor)
	-- CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
end


function CharacterCreationHeader:onTextChangeAge()
    local age = CharacterCreationHeader.instance.ageEntry:getInternalText()
    if age and age ~= "" then
        age = tonumber(age)
        AgingMod.age = age


        local check = age > 17 and age < 101
        CharacterCreationHeader.instance.ageEntry:setValid(check)
        if check then
            SetHairColor(age)
        end
    else
        CharacterCreationHeader.instance.ageEntry:setValid(false)
    end
end

local og_CharacterCreationHeaderCreate = CharacterCreationHeader.create
function CharacterCreationHeader:create()

    og_CharacterCreationHeaderCreate(self)
    --print("Running creation header")
    local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
    local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
    local entryHgt = math.max(FONT_HGT_SMALL + 2 * 2, FONT_HGT_MEDIUM)
    local labelMaxWid = 0
    labelMaxWid = math.max(labelMaxWid, getTextManager():MeasureStringX(UIFont.Medium, getText("UI_characreation_forename")))
    labelMaxWid = math.max(labelMaxWid, getTextManager():MeasureStringX(UIFont.Medium, getText("UI_characreation_surname")))
    labelMaxWid = math.max(labelMaxWid, getTextManager():MeasureStringX(UIFont.Medium, getText("UI_characreation_gender")))

    
    self.ageEntry = ISTextEntryBox:new(tostring(25), self.genderCombo:getRight() + 6, self.surnameEntry:getBottom() + 6 + (entryHgt - 18) / 2, 115, entryHgt)
	self.ageEntry:initialise()
	self.ageEntry:instantiate()
    self.ageEntry:setOnlyNumbers(true)
    self.ageEntry:setMaxTextLength(2)
    self.ageEntry.onTextChange = CharacterCreationHeader.onTextChangeAge
    self.ageEntry:setValid(true)
	self:addChild(self.ageEntry)



    
end

local og_CharacterCreationMainOnOptionMouseDown = CharacterCreationMain.onOptionMouseDown
function CharacterCreationMain:onOptionMouseDown(button, x, y)
    if button.internal == "NEXT" then
        --print("Clicked PLAY")
        -- This is pretty shitty but hey not really my fault :) goddamn you tis
        if CharacterCreationHeader.instance.ageEntry.borderColor.a == 1 then
            AgingMod.age = CharacterCreationHeader.instance.ageEntry:getInternalText()
            og_CharacterCreationMainOnOptionMouseDown(self, button, x, y)
        -- else
        --     --print("Age is not valid!")
        end
    else
        og_CharacterCreationMainOnOptionMouseDown(self, button, x, y)
    end


end


