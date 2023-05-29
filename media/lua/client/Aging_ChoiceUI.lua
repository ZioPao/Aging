AgingMod_ChoiceUI = ISPanel:derive("AgingMod_ChoiceUI")

-- TODO Players shouldn't be able to close this




-----------------------------------

function AgingMod_ChoiceUI:close()
	instance:setVisible(false)
	instance:removeFromUIManager()
	AgingMod_ChoiceUI.instance = nil
end

function AgingMod_ChoiceUI:initialise()
	ISPanel.initialise(self)
    self:create()
end

function AgingMod_ChoiceUI:setVisible(visible)
    self.javaObject:setVisible(visible)
end

function AgingMod_ChoiceUI:onOptionMouseDown(button, x, y)

    local workerData = FetchWorkerData()

	if button.internal == "CANCEL" then
		instance:closeOpenPanels()
		instance:close()
    elseif workerData then

		if button.internal == "IDENTIFICATION" and workerData.identificationCard then
			instance.identificationPanel = instance:openPanel(instance.identificationPanel, identificationCardForm)
		elseif button.internal == "DRIVERSLICENSE" and workerData.driversLicense then
			instance.driversLicensePanel = instance:openPanel(instance.driversLicensePanel, driversLicenseForm)
		elseif button.internal == "VEHICLEREGISTRATION" and workerData.vehicleRegistration then
			instance.vehicleRegistrationPanel = instance:openPanel(instance.vehicleRegistrationPanel, vehicleRegistrationForm)
        elseif button.internal == "EMPLOYMENTCONTRACT" and workerData.employmentContract then
			instance.employmentContractPanel = instance:openPanel(instance.employmentContractPanel, employmentContractForm)
        elseif button.internal == "MEDICALLICENSE" and workerData.medicalLicense then
			instance.medicalLicensePanel = instance:openPanel(instance.medicalLicensePanel, medicalLicenseForm)
        elseif button.internal == "PROPERTYDEED" and workerData.propertyDeed then
			instance.propertyDeedPanel = instance:openPanel(instance.propertyDeedPanel, propertyDeedForm)
        elseif button.internal == "OPENBROADCASTMENU" and workerData.broadcastAlarm then
            -- Special case I guess. Opens it on the right side or something
            instance.broadcastMenu = PZRPGovOps_SoundsListViewer.OnOpenPanel()
		end
	end
end


function AgingMod_ChoiceUI:create()
	instance = AgingMod_ChoiceUI.instance
	local yOffset = 10

    local labelString = "Select your age"
	self.mainLabel = ISLabel:new((self.width - getTextManager():MeasureStringX(UIFont.Large, labelString)) / 2, yOffset, 25, labelString, 1, 1, 1, 1, UIFont.Large, true)
	yOffset = yOffset + 30


	self.ageEntry = ISTextEntryBox:new("", 10, yOffset, self.width - 20, 25)
	self.ageEntry:initialise()
	self.ageEntry:instantiate()
	self.ageEntry:setOnlyNumbers(true)
	self:addChild(self.ageEntry)


    self.saveBtn = ISButton:new(10, self.height - 35, self.width - 20, 25, "Save", self, instance.onOptionMouseDown)
    self.saveBtn.internal = "SAVE"
    self.saveBtn:initialise()
    self.saveBtn:instantiate()
    self:addChild(self.saveBtn)

end

function AgingMod_ChoiceUI.OpenPanel()

    local pnl = AgingMod_ChoiceUI:new(50, 200, 425, 700)
    pnl:initialise()
    pnl:addToUIManager()
    pnl.instance:setKeyboardFocus()
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
    AgingMod_ChoiceUI.instance = o
    return o
end
