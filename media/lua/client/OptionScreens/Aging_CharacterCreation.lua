function CharacterCreationHeader:onTextChangeAge()
    local age = CharacterCreationHeader.instance.ageEntry:getInternalText()
    if age and age ~= "" then
        age = tonumber(age)
        CharacterCreationHeader.instance.ageEntry:setValid(age > 18 and age < 100)
    else
        CharacterCreationHeader.instance.ageEntry:setValid(false)
    end
end



local og_CharacterCreationHeaderCreate = CharacterCreationHeader.create
function CharacterCreationHeader:create()

    og_CharacterCreationHeaderCreate(self)
    local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
    local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
	local entryHgt = math.max(FONT_HGT_SMALL + 2 * 2, FONT_HGT_MEDIUM)
	local labelMaxWid = 0
	labelMaxWid = math.max(labelMaxWid, getTextManager():MeasureStringX(UIFont.Medium, getText("UI_characreation_forename")))
	labelMaxWid = math.max(labelMaxWid, getTextManager():MeasureStringX(UIFont.Medium, getText("UI_characreation_surname")))
	labelMaxWid = math.max(labelMaxWid, getTextManager():MeasureStringX(UIFont.Medium, getText("UI_characreation_gender")))

    local entryX = self.avatarPanel:getRight() + 16 + labelMaxWid + 6
    self.ageEntry = ISTextEntryBox:new(tostring(ZombRand(19, 75)), self.genderCombo:getRight() + 6, self.surnameEntry:getBottom() + 6 + (entryHgt - 18) / 2, 115, entryHgt)
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
        print("Clicked PLAY")
        -- This is pretty shitty but hey not really my fault :) goddamn you tis
        if CharacterCreationHeader.instance.ageEntry.borderColor.a == 1 then
            AgingMod.age = CharacterCreationHeader.instance.ageEntry:getInternalText()
            og_CharacterCreationMainOnOptionMouseDown(self, button, x, y)
        else
            print("Age is not valid!")
        end
    else
        og_CharacterCreationMainOnOptionMouseDown(self, button, x, y)
    end


end




Events.OnGameStart.Add(function()


    print("Initialized world, printing current age")
    print(AgingMod.age)
    print("Fuck off now")


end)