require "OptionScreens/CharacterCreationMain"
require "OptionScreens/CharacterCreationHeader"

local function SetHairColor(age)
    print("Setting hair to age " .. tostring(age))
    local hairColors = MainScreen.instance.desc:getCommonHairColor()
    local hairColors1 = {}
    local info = ColorInfo.new()


    local desaturation = age/80
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


        if r > 1 then r = 1 end
        if g > 1 then g = 1 end
        if b > 1 then b = 1 end


        --print("Current color: R=" .. r .. ", G=" .. g .. ", B=" .. b)
        table.insert(hairColors1, { r=r, g=g, b=b})
    end
    CharacterCreationMain.instance.colorPickerHair:setColors(hairColors1, math.min(#hairColors1, 10), math.ceil(#hairColors1 / 10))
    -- TODO Force apply hair!
    CharacterCreationMain.instance.colorPickerHair.index = 1
    CharacterCreationMain.instance.colorPickerHair:picked(true)

end



local og_CharacterCreationMainCreateHairTypeBtn = CharacterCreationMain.createHairTypeBtn
function CharacterCreationMain:createHairTypeBtn()
    og_CharacterCreationMainCreateHairTypeBtn(self)
    --SetHairColor(25)
    print("Forcing index 1 for hair color")
    CharacterCreationMain.instance.colorPickerHair.index = 1
    CharacterCreationMain.instance:removeChild( CharacterCreationMain.instance.colorPickerHair)
	CharacterCreationMain.instance:addChild( CharacterCreationMain.instance.colorPickerHair)
    CharacterCreationMain.instance.colorPickerHair:picked(true)

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
    print("Running creation header")
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