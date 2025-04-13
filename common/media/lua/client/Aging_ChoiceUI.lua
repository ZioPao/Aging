
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

    -- Compatibility with NRK Random Name
    if getActivatedMods():contains("NRK_RandomName") then
        local entryX = self.genderCombo:getX() - self.genderCombo:getWidth() - 6
        self.ageEntry = ISTextEntryBox:new(tostring(25), entryX, self.surnameEntry:getBottom() + 6 + (entryHgt - 18) / 2, self.genderCombo:getWidth(), entryHgt)

    else
        self.ageEntry = ISTextEntryBox:new(tostring(25), self.genderCombo:getRight() + 6, self.surnameEntry:getBottom() + 6 + (entryHgt - 18) / 2, 115, entryHgt)
    end


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

