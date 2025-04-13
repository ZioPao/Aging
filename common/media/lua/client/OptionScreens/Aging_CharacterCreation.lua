-- require "OptionScreens/CharacterCreationMain"
-- require "OptionScreens/CharacterCreationHeader"




-- local CharCreationClass
-- if AgingMod.isB41 then
--     ---@class CharacterCreationHeader
--     CharCreationClass = CharacterCreationHeader.instance
-- else
--     ---@class CharacterCreationAvatar
--     CharCreationClass = CharacterCreationAvatar
-- end


-- local function SetHairColor(age)
--     --print("Setting hair to age " .. tostring(age))
--     local hairColors = MainScreen.instance.desc:getCommonHairColor()
--     local hairColors1 = {}
--     local info = ColorInfo.new()


--     local desaturation = age/100
--     --print("Desaturation: " .. tostring(desaturation))
--     for i=1,hairColors:size() do
--         local color = hairColors:get(i-1)
--         -- we create a new info color to desaturate it (like in the game)
--         info:set(color:getRedFloat(), color:getGreenFloat(), color:getBlueFloat(), 1)

--         --print(i)
--         local r = info:getR() --+ greyScaler
--         local g = info:getG() --+ greyScaler
--         local b = info:getB() --+ greyScaler

--         local L = 0.299 * r + 0.587 * g + 0.144 * b

--         r = r + desaturation * (L - r)
--         g = g + desaturation * (L - g)
--         b = b + desaturation * (L - b)

--         if age > 40 and (r < desaturation or g < desaturation or b < desaturation) then
--             --print("Invalid hair color")
--         else

--             --print("Current color: R=" .. r .. ", G=" .. g .. ", B=" .. b)
--             table.insert(hairColors1, { r=r, g=g, b=b})
--         end

--     end

--     if hairColors[1] == nil then
--         table.insert(hairColors1, {r=0.8, g=0.8, b=0.8})
--     end
--     CharacterCreationMain.instance.colorPickerHair:setColors(hairColors1, math.min(#hairColors1, 10), math.ceil(#hairColors1 / 10))

--     local color = CharacterCreationMain.instance.colorPickerHair.colors[1]
--     CharacterCreationMain.instance.hairColorButton.backgroundColor = { r=color.r, g=color.g, b=color.b, a = 1 }
-- 	local desc = MainScreen.instance.desc
-- 	local immutableColor = ImmutableColor.new(color.r, color.g, color.b, 1)
-- 	desc:getHumanVisual():setHairColor(immutableColor)
-- 	desc:getHumanVisual():setBeardColor(immutableColor)
-- 	desc:getHumanVisual():setNaturalHairColor(immutableColor)
-- 	desc:getHumanVisual():setNaturalBeardColor(immutableColor)


--     -- ugly

--     if isB41 then
-- 	    CharCreationClass.avatarPanel:setSurvivorDesc(desc)
--     else
-- 	    -- CharCreationClass:setSurvivorDesc(desc)
--         CharacterCreationMain.instance.avatarPanel:setSurvivorDesc(desc)
--     end

-- end



-- local og_CharacterCreationMainCreateHairTypeBtn = CharacterCreationMain.createHairTypeBtn
-- function CharacterCreationMain:createHairTypeBtn()
--     og_CharacterCreationMainCreateHairTypeBtn(self)
--     SetHairColor(25)
--     -- print("Forcing index 1 for hair color")
--     -- CharacterCreationMain.instance.colorPickerHair:picked(true)

--     -- local color = self.colorPickerHair.colors[1]
--     -- CharacterCreationMain.instance.hairColorButton.backgroundColor = { r=color.r, g=color.g, b=color.b, a = 1 }
-- 	-- local desc = MainScreen.instance.desc
-- 	-- local immutableColor = ImmutableColor.new(color.r, color.g, color.b, 1)
-- 	-- desc:getHumanVisual():setNaturalHairColor(immutableColor)
-- 	-- desc:getHumanVisual():setNaturalBeardColor(immutableColor)
-- 	-- CharacterCreationHeader.instance.avatarPanel:setSurvivorDesc(desc)
-- end


-- function CharCreationClass:onTextChangeAge()
--     local age = CharCreationClass.ageEntry:getInternalText()
--     if age and age ~= "" then
--         age = tonumber(age)
--         AgingMod.age = age

--         local check = age > 17 and age < 101
--         CharCreationClass.ageEntry:setValid(check)
--         if check then
--             SetHairColor(age)
--         end
--     else
--         CharCreationClass.ageEntry:setValid(false)
--     end
-- end

-- -- TODO This should be in the main class for B42
-- local og_CharacterCreationHeaderCreate = CharCreationClass.create
-- function CharCreationClass:create()

--     og_CharacterCreationHeaderCreate(self)
--     --print("Running creation header")
--     local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
--     local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
--     local entryHgt = math.max(FONT_HGT_SMALL + 2 * 2, FONT_HGT_MEDIUM)
--     local labelMaxWid = 0
--     labelMaxWid = math.max(labelMaxWid, getTextManager():MeasureStringX(UIFont.Medium, getText("UI_characreation_forename")))
--     labelMaxWid = math.max(labelMaxWid, getTextManager():MeasureStringX(UIFont.Medium, getText("UI_characreation_surname")))
--     labelMaxWid = math.max(labelMaxWid, getTextManager():MeasureStringX(UIFont.Medium, getText("UI_characreation_gender")))

--     -- Compatibility with NRK Random Name
--     if getActivatedMods():contains("NRK_RandomName") then
--         local entryX = self.genderCombo:getX() - self.genderCombo:getWidth() - 6
--         self.ageEntry = ISTextEntryBox:new(tostring(25), entryX, self.surnameEntry:getBottom() + 6 + (entryHgt - 18) / 2, self.genderCombo:getWidth(), entryHgt)

--     else
--         self.ageEntry = ISTextEntryBox:new(tostring(25), self.genderCombo:getRight() + 6, self.surnameEntry:getBottom() + 6 + (entryHgt - 18) / 2, 115, entryHgt)
--     end


-- 	self.ageEntry:initialise()
-- 	self.ageEntry:instantiate()
--     self.ageEntry:setOnlyNumbers(true)
--     self.ageEntry:setMaxTextLength(2)
--     self.ageEntry.onTextChange = CharacterCreationHeader.onTextChangeAge
--     self.ageEntry:setValid(true)
-- 	self:addChild(self.ageEntry)



    
-- end

-- local og_CharacterCreationMainOnOptionMouseDown = CharacterCreationMain.onOptionMouseDown
-- function CharacterCreationMain:onOptionMouseDown(button, x, y)
--     if button.internal == "NEXT" then
--         --print("Clicked PLAY")
--         -- This is pretty shitty but hey not really my fault :) goddamn you tis
--         if CharCreationClass.ageEntry.borderColor.a == 1 then
--             AgingMod.age = CharCreationClass.ageEntry:getInternalText()
--             og_CharacterCreationMainOnOptionMouseDown(self, button, x, y)
--         -- else
--         --     --print("Age is not valid!")
--         end
--     else
--         og_CharacterCreationMainOnOptionMouseDown(self, button, x, y)
--     end

-- end