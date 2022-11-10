include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

local alreadyReceived = false
net.Receive("TKGOsaka_ConfigPochePanel", function()
	if alreadyReceived then return end
	alreadyReceived = true

	local frame, menuButton, dPanel, closeButton = OsakaTKG.Menu("Paramètres de la poche RC", 83, alreadyReceived)
	local varTypePoche, varRcChoice, varSlider = nil

	local confirmButton = vgui.Create("XeninUI.ButtonV2", dPanel)
	confirmButton:SetPos( 85, 380 )				-- Set the position
	confirmButton:SetSize( 300, 50 )			-- Set the size
	confirmButton:SetText("Confirmer !")
	confirmButton:SetSolidColor(Color(56, 103, 214))
	confirmButton:SetEnabled(false)
	confirmButton.DoClick = function()
		frame:Close()
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
		net.Start("TKGOsaka_ConfigPochePanel")
			net.WriteString(varTypePoche)
			net.WriteUInt(varRcChoice, 16)
			net.WriteBool(varSlider)
		net.SendToServer()
		alreadyReceived = false
	end

	local typePoche = vgui.Create("DComboBox", dPanel)
	typePoche:SetPos( 165, 10 )
	typePoche:SetSize(150,20)
	typePoche:SetFont( "OsakaMenuGlobalFont" )
	typePoche:SetValue("Type de poche RC:")
	typePoche:AddChoice("Ukaku")
	typePoche:AddChoice("Bikaku")
	typePoche:AddChoice("Koukaku")
	typePoche:AddChoice("Rinkaku")
	typePoche.OnSelect = function(self, value)
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
		if value == 1 then
			varTypePoche = "Ukaku"
		elseif value == 1 then
			varTypePoche = "Bikaku"
		elseif value == 1 then
			varTypePoche = "Koukaku"
		else
			varTypePoche = "Rinkaku"
		end
		
		print("varTypePoche:"..tostring(varTypePoche))
		if varRcChoice != nil then confirmButton:SetEnabled(true) end
	end

	local rcChoice = vgui.Create( "XeninUI.SliderPad", dPanel )
	rcChoice:SetPos( 30, 70 )				-- Set the position
	rcChoice:SetSize( 350, 50 )			-- Set the size
	rcChoice:SetMin( 1000 )				 	-- Set the minimum number you can slide to
	rcChoice:SetMax( 25000 )				-- Set the maximum number you can slide to
	rcChoice:SetWrap(true)
	rcChoice:SetFraction(0.5)
	rcChoice:SetValue(3000)
	rcChoice:SetColor(Color(192, 57, 43))
	rcChoice.OnValueChanged = function(self)
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
		varRcChoice = self:GetValue()
		if varTypePoche != nil then confirmButton:SetEnabled(true) end
	end
	local rcChoiceText = vgui.Create("DLabel", rcChoice)
	rcChoiceText:SetText("Nombre de RC de la poche")
	rcChoiceText:SetFont("OsakaDescriptionDuelsFont")
	rcChoiceText:SetPos(0,0)
	rcChoiceText:SetWrap(true)
	rcChoiceText:SetSize(300,15)

	closeButton.DoClick = function()
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
		frame:Remove()
		alreadyReceived = false
	end


	local checkbox = vgui.Create( "XeninUI.Checkbox.Slider", dPanel ) -- Create the checkbox
	checkbox:SetPos( 30, 180 ) -- Set the position
	function checkbox:OnStateChanged(value)
		varSlider = value
		print("VARSLIDER:"..tostring(varSlider))
	end
	varSlider = false


	local checkboxText = vgui.Create("DLabel", dPanel)
	checkboxText:SetText("Autoriser le dépassement de limite de RC malgré le rang de l'inspecteur")
	checkboxText:SetFont("OsakaDescriptionDuelsFont")
	checkboxText:SetPos(30,150)
	checkboxText:SetWrap(true)
	checkboxText:SetSize(450,30)

	
end)