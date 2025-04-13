AgingMod_ChoiceUI = ISPanel:derive("AgingMod_ChoiceUI")
AgingMod_ChoiceUI.instance = nil


-- IN GAME UI, if it's an already spawned character

-----------------------------------
function AgingMod_ChoiceUI:onTextChangeAge()

    local age = self.parent.ageEntry:getInternalText()
    if age and age ~= "" then
        age = tonumber(age)
        --AgingMod.age = age


        local check = age > 17 and age < 101
        self.parent.ageEntry:setValid(check)
        self.parent.saveBtn:setEnable(true)

    else
        self.parent.saveBtn:setEnable(false)
    end
end


function AgingMod_ChoiceUI:close()
    if self.isChoiceReady then
        self.instance:setVisible(false)
        self.instance:removeFromUIManager()
        AgingMod_ChoiceUI.instance = nil
    end
end

function AgingMod_ChoiceUI:initialise()
	ISPanel.initialise(self)
    self:create()
end

function AgingMod_ChoiceUI:setVisible(visible)
    self.javaObject:setVisible(visible)
end

function AgingMod_ChoiceUI:onOptionMouseDown(button, x, y)

	if button.internal == "SAVE" then
        --print("Saving")

        local age = tonumber(self.ageEntry:getText())
        AgingMod.age = age
        print("AgingMod: set " .. tostring(age))

        -- 25 is the starting point in case there's no other value
        for i=25, age, 1 do
            AgingMod.SetHairColor(i)
        end

        AgingMod.Setup()
        self.instance.isChoiceReady = true
        self.instance:close()
    end
end


function AgingMod_ChoiceUI:create()
	--instance = AgingMod_ChoiceUI.instance
	local yOffset = 10

    local labelString = "Select your age"
	self.mainLabel = ISLabel:new((self.width - getTextManager():MeasureStringX(UIFont.Large, labelString)) / 2, yOffset, 25, labelString, 1, 1, 1, 1, UIFont.Large, true)
    self.mainLabel:initialise()
    self.mainLabel:instantiate()
    self:addChild(self.mainLabel)
    yOffset = yOffset + 30


    local baseAge = "25"
	self.ageEntry = ISTextEntryBox:new(baseAge, 10, yOffset, self.width - 20, 25)
	self.ageEntry:initialise()
	self.ageEntry:instantiate()
    self.ageEntry:setMaxTextLength(2)
    self.ageEntry.onTextChange = self.onTextChangeAge
	self.ageEntry:setOnlyNumbers(true)
	self:addChild(self.ageEntry)


    self.saveBtn = ISButton:new(10, self.height - 35, self.width - 20, 25, "Save", self, AgingMod_ChoiceUI.onOptionMouseDown)
    self.saveBtn.internal = "SAVE"
    self.saveBtn:initialise()
    self.saveBtn:instantiate()
    self.saveBtn:setEnable(true)
    self:addChild(self.saveBtn)

end

function AgingMod_ChoiceUI.OpenPanel()
	local UI_SCALE = getTextManager():getFontHeight(UIFont.Small) / 14

    local pnl = AgingMod_ChoiceUI:new(50, 200, 250 * UI_SCALE, 150 * UI_SCALE)
    pnl:initialise()
    pnl:addToUIManager()
    pnl:bringToTop()
    --pnl.instance:setKeyboardFocus()
    return pnl
end


--****************************--

function AgingMod_ChoiceUI:new(x, y, width, height)
    local o = {}
    o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self

    o.width = width
    o.height = height

    o.variableColor={r=0.9, g=0.55, b=0.1, a=1}
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    o.backgroundColor = {r=0, g=0, b=0, a=0.8}
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5}
    o.moveWithMouse = true

    o.isChoiceReady = false
    AgingMod_ChoiceUI.instance = o
    return o
end
