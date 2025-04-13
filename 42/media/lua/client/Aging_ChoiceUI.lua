require "OptionScreens/CharacterCreationMain"

-- Adds age Entry


local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6

local og_CharacterCreationMain_createNameAndGender = CharacterCreationMain.createNameAndGender
function CharacterCreationMain:createNameAndGender()
    og_CharacterCreationMain_createNameAndGender(self)

    local lbl = ISLabel:new(0, self.genderCombo:getBottom() + UI_BORDER_SPACING, FONT_HGT_MEDIUM, getText("UI_characreation_age"), 1, 1, 1, 1, UIFont.Medium, false)
	lbl:initialise()
	lbl:instantiate()
	self.characterPanel:addChild(lbl)
	table.insert(self.characterPanel.repos2Table, lbl)

    self.ageEntry = ISTextEntryBox:new(tostring(25), 0, self.genderCombo:getBottom() + UI_BORDER_SPACING, 0, BUTTON_HGT)
    self.ageEntry:initialise()
	self.ageEntry:instantiate()
	self.characterPanel:addChild(self.ageEntry)
	table.insert(self.characterPanel.comboResizeTable, self.ageEntry)
	table.insert(self.characterPanel.repos3Table, self.ageEntry)



    self.ageEntry:setOnlyNumbers(true)
    self.ageEntry:setMaxTextLength(2)
    self.ageEntry.onTextChange = function()
		AgingMod.ValidateAge(self.ageEntry)
	end
    self.ageEntry:setValid(true)

    self.yOffset = self.ageEntry:getBottom() + UI_BORDER_SPACING
end