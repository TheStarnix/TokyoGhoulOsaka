
AddCSLuaFile( "imgui.lua" )

local imgui = include("imgui.lua")
local timerIsActive = false
local timerSeconds = 0
local rcNumber = 0
local typeRC = ""
include('shared.lua')

function ENT:Draw()
	self:DrawModel()

	if timerIsActive &&imgui.Entity3D2D(self, Vector(-24, 98.5, 48.5), Angle(0, -90, 90), 0.1) then

				draw.SimpleText( tostring(timerSeconds).." secondes", "OsakaFontQuinque01", 280, 0, color_black )
				draw.SimpleText( tostring(rcNumber).." RC", "OsakaFontQuinque01", 280, 30, color_black )
				draw.SimpleText( typeRC, "OsakaFontQuinque01", 280, 60, color_black )
	 
	  

				imgui.End3D2D()
	end
end

local function RespX(x) return x/1920*ScrW() end 
local function RespY(y) return y/1080*ScrH() end

local alreadyReceived = false

net.Receive("TKGOsaka_QuinqueCreate", function()
	if alreadyReceived then return end
	local entity = net.ReadEntity()
	alreadyReceived = true

	local varText = ""
	
	local frame, menuButton, dPanel, closeButton = OsakaTKG.Menu("Paramètres de la Quinque", 66, alreadyReceived)
	local varTypePoche, varRcChoice, varSlider = nil

	local TextEntry = vgui.Create( "DTextEntry", frame ) -- create the form as a child of frame
	TextEntry:SetSize( RespX(250), RespY(50) )
	TextEntry:Center()
	TextEntry:SetMaximumCharCount(15)
	TextEntry:SetPlaceholderText( "Nom de ma Quinque" )
	TextEntry:SetPos(RespX(125),RespY(185)) 
	TextEntry.OnChange = function(self)
		if self:GetValue() != "Nom trop court !" then
			varText = self:GetValue()
		end
	end
	
	local confirmButton = vgui.Create("XeninUI.ButtonV2", dPanel)
	confirmButton:SetPos( RespX(85), RespY(380) )
	confirmButton:SetSize( RespX(300), RespY(50) )
	confirmButton:SetText("Confirmer !")
	confirmButton:SetSolidColor(Color(56, 103, 214))
	confirmButton.DoClick = function()
		if string.len(varText) <= 2 then
			TextEntry:SetValue("")
			TextEntry:SetPlaceholderText("Votre nom est trop court !")
		else
			surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
	        frame:Remove()
	        alreadyReceived = false
	        net.Start("TKGOsaka_QuinqueCreate")
	        	net.WriteString(varText)
			net.SendToServer()
		end
        
    end

	closeButton.DoClick = function()
        surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
        frame:Remove()
        alreadyReceived = false
    end

end)

net.Receive("TKGOsaka_QuinqueSlotsOpen", function()
	local typeQuinque = net.ReadString()
	local rcNumber = net.ReadUInt(16)
	local bypassLimit = net.ReadBool()
	local dataSQL = net.ReadTable()

	if dataSQL == nil then dataSQL = {} end
	--[[
		COMMENT RECUPERER LES INFOS SQL:
		dataSQL["RCQuinque"] -> nbr de RC sur la quinque du slot correspondant
		dataSQL["Numeroquinque"] -> slot
		dataSQL["Nom"] -> nom de la quinque du slot correspondant
		/!\ Fais attention, les informations peuvent être vides car il peut navoir aucune autre quinque DONC la table dataSQL peut être nil/vide. /!\
	]]--

local quinque_osaka_slot_background = Material( "tkg_osaka/osaka_menu_quinque_background.png")

	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW(), ScrH())
	frame:Center()
	frame:SetTitle("")
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame:MakePopup()
	frame.Paint = function(s,w,h)
		surface.SetDrawColor( 255,255,255,255 )
		surface.SetMaterial( quinque_osaka_slot_background )
		surface.DrawTexturedRect( RespX(0), RespY(0), RespX(ScrW()), RespY(ScrH()))
	end




	local DScrollPanel = vgui.Create( "XeninUI.ScrollPanel", frame )
	DScrollPanel:SetPos(RespX(20),RespY(313))
	DScrollPanel:SetSize(330,450)

	local sbar = DScrollPanel:GetVBar()
	function sbar:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
	end
	function sbar.btnUp:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(200, 100, 0, 0))
	end
	function sbar.btnDown:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(200, 100, 0, 0))
	end
	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(100, 200, 0, 0))
	end
	
	for i=1, 10 do
		local Bouton_Slot_Quinque = vgui.Create( "DImageButton", DScrollPanel )
		Bouton_Slot_Quinque:SetPos(RespX(25), RespY(833))				
		Bouton_Slot_Quinque:SetImage( "tkg_osaka/quinque_slot.png" )	
		Bouton_Slot_Quinque:SetColor(Color(255, 255, 255, 70))
		Bouton_Slot_Quinque:SizeToContents()
		Bouton_Slot_Quinque:Dock(TOP)
		Bouton_Slot_Quinque:DockMargin( 0, 0, 0, 25 )
		Bouton_Slot_Quinque.DoClick = function()
			surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
			net.Start("TKGOsaka_QuinqueSlotsOpen")
				net.WriteUInt(i, 5)
			net.SendToServer()
			frame:Close()
		end
	
		local DLabel = vgui.Create( "DLabel", Bouton_Slot_Quinque )
		DLabel:SetPos( RespX(25), RespY(13) )
		DLabel:SetFont("tkg_font_1")
		DLabel:SetSize(RespX(220),RespY(40))
		DLabel:SetColor(Color(255, 255, 255))
		DLabel:SetText( "Slot Quinque #" .. i )
	
		Bouton_Slot_Quinque.OnCursorEntered = function()
			surface.PlaySound("osaka_sound_tkg/osaka_souris.mp3")
			Bouton_Slot_Quinque:SetImage( "tkg_osaka/quinque_slot_hovered.png" )
			Bouton_Slot_Quinque:SetColor(Color(245, 245, 245, 255))
			DLabel:SetColor(Color(255, 0, 0))
		end  
		Bouton_Slot_Quinque.OnCursorExited = function()
			Bouton_Slot_Quinque:SetImage( "tkg_osaka/quinque_slot.png" )
			Bouton_Slot_Quinque:SetColor(Color(255, 255, 255, 70))
			DLabel:SetColor(Color(255, 255, 255))
		end
	end

	local close_ccg_menu = vgui.Create( "DImageButton", frame )
	close_ccg_menu:SetPos(RespX(5), RespY(995))				
	close_ccg_menu:SetImage( "tkg_osaka/exit_menu_1.png" )
	close_ccg_menu:SetColor(Color(240, 240, 240, 255))
	close_ccg_menu:SetSize(RespX(380),RespY(71)) 
	close_ccg_menu.DoClick = function()
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
		frame:Remove()
	end

	local leave = vgui.Create( "DLabel", frame )
	leave:SetPos( RespX(60), RespY(1010) )
	leave:SetFont("exit_text")
	leave:SetSize(RespX(150),RespY(40))
	leave:SetColor(Color(255, 255, 255))
	leave:SetText( "Fermer" )

	close_ccg_menu.OnCursorEntered = function()
		surface.PlaySound("osaka_sound_tkg/osaka_souris.mp3")
		close_ccg_menu:SetImage( "tkg_osaka/exit_menu_2.png" )
		leave:SetColor(Color(255, 0, 0))
	end
	close_ccg_menu.OnCursorExited = function()
		close_ccg_menu:SetImage( "tkg_osaka/exit_menu_1.png" )
		leave:SetColor(Color(255, 255, 255))
	end

end)

net.Receive("TKGOsaka_QuinqueFabrication", function()
	timerSeconds = net.ReadUInt(4)
	rcNumber = net.ReadUInt(16)
	typeRC = net.ReadString()
	timerIsActive = true
	timer.Create("TKGOsaka_TimerFabrication1", 1, timerSeconds, function()
		timerSeconds = timerSeconds-1
		if timerSeconds == 0 then
			timerIsActive = false
		end
	end)
end)