local function RespX(x) return x/1920*ScrW() end
local function RespY(y) return y/1080*ScrH() end

local command = "!implants"
hook.Add("OnPlayerChat","hudconfig",function(ply, text) if string.Trim(text) == command then if ply == LocalPlayer() then

    local quinque_osaka_slot_background = Material( "tkg_osaka/osaka_menu_quinque_background_1.png")

	--Création de la frame pour afficher les quinques
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

	--[[

        --Création de la prévisualisation
        local quinquePreview = vgui.Create( "DModelPanel", frame )
        quinquePreview:SetModel( "" )
        quinquePreview:SetFOV(5)
        quinquePreview:SetSize(principalPanel:GetWide(), principalPanel:GetTall())
        quinquePreview:SetCamPos(Vector(-3275, 2435, -155))
        quinquePreview:Dock(FILL)

	]]--


	local DPanel = vgui.Create( "DPanel", frame)
	DPanel:SetPos( RespX(0), RespY(0) ) -- Set the position of the panel
	DPanel:SetSize( ScrW(), ScrH() ) -- Set the size of the panel
	DPanel.Paint = nil

	local quinque_preview = vgui.Create( "DAdjustableModelPanel", frame )
	quinque_preview:SetSize( ScrW(), ScrH() )
	quinque_preview:SetPos(0,0)
	quinque_preview:SetModel( "" )
	quinque_preview:SetLookAng( Angle( 0, 0, 0 ) )
	quinque_preview:SetCamPos( Vector( -50, 0, 0 ) )
	quinque_preview:SetFOV(150)

	local textName = vgui.Create( "DLabel", frame )
	textName:SetPos( RespX(1450), RespY(300) )
	textName:SetFont("tkg_font_1")
	textName:SetSize(RespX(350),RespY(200))
	textName:SetColor(Color(255, 255, 255))
	textName:SetText( "Nom: ???")

	local textType = vgui.Create( "DLabel", frame )
	textType:SetPos( RespX(1450), RespY(380) )
	textType:SetFont("tkg_font_1")
	textType:SetSize(RespX(350),RespY(200))
	textType:SetColor(Color(255, 255, 255))
	textType:SetText( "Type: ???")

	local textRc = vgui.Create( "DLabel", frame )
	textRc:SetPos( RespX(1450), RespY(460) )
	textRc:SetFont("tkg_font_1")
	textRc:SetSize(RespX(350),RespY(200))
	textRc:SetColor(Color(255, 255, 255))
	textRc:SetText( "Nombre de RC: ???")

	local textSlot = vgui.Create( "DLabel", frame )
	textSlot:SetPos( RespX(1450), RespY(535) )
	textSlot:SetFont("tkg_font_1")
	textSlot:SetSize(RespX(350),RespY(200))
	textSlot:SetColor(Color(255, 255, 255))
	textSlot:SetText( "Slot: ???")


	--Création d'un panel pour constater la place que prendra le menu de sélection des quinques
	local menuChoiceQuinques = vgui.Create( "DPanel", frame)
	menuChoiceQuinques:SetPos( 160, 0 ) -- Set the position of the panel
	menuChoiceQuinques:SetSize( ScrW(), ScrH() ) -- Set the size of the panel
	menuChoiceQuinques.Paint = nil

	--Création du menu de sélection des quinques
	local scrollPanel = vgui.Create( "XeninUI.ScrollPanel", frame )
	scrollPanel:SetPos(20,313)
	scrollPanel:SetSize(330,450)

	--Barres de séparation pour les quinques
	local sbar = scrollPanel:GetVBar()
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

	local imageGiveMenu = vgui.Create( "DImageButton", frame )
	imageGiveMenu:SetPos(RespX(5), RespY(950))				
	imageGiveMenu:SetImage( "tkg_osaka/exit_menu_1.png" )
	imageGiveMenu:SetColor(Color(240, 240, 240, 255))
	imageGiveMenu:SetSize(RespX(380),RespY(71)) 
	imageGiveMenu.DoClick = function()
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
		frame:Remove()
		alreadyReceived = false
		OsakaTKG.CarriedQuinques[dataSQL[slotSelected]["Type"]] = slotSelected
		PrintTable(OsakaTKG.CarriedQuinques)

		net.Start("TKGOsaka_CCGWeaponsOpen")
			net.WriteUInt(slotSelected,5)
		net.SendToServer()
	end
	imageGiveMenu:SetEnabled(false)
	
	--Création d'un nombre x de boutons pour les quinques où x est le nombre de quinques qu'il possède.
	for i=1, #dataSQL do 
		local boutonSlotQuinque = vgui.Create( "DImageButton", scrollPanel )
		boutonSlotQuinque:SetPos(RespX(25), RespY(833))				
		boutonSlotQuinque:SetImage( "tkg_osaka/quinque_slot.png" )	
		boutonSlotQuinque:SetColor(Color(255, 255, 255, 70))
		boutonSlotQuinque:SizeToContents()
		boutonSlotQuinque:Dock(TOP)
		boutonSlotQuinque:DockMargin( 0, 0, 0, 25 )
		boutonSlotQuinque.DoClick = function()
			surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
			quinque_preview:SetModel(dataSQL[i]["Model"])
			textName:SetText( "Nom: "..dataSQL[i]["Nom"])
			textType:SetText( "Type: "..dataSQL[i]["Type"])
			textRc:SetText( "Nombre de RC: "..dataSQL[i]["RCQuinque"])
			textSlot:SetText("Slot: "..dataSQL[i]["Numeroquinque"])
			imageGiveMenu:SetEnabled(true)
			slotSelected = i
		end
	
		local textSlot = vgui.Create( "DLabel", boutonSlotQuinque )
		textSlot:SetPos( RespX(25), RespY(13) )
		textSlot:SetFont("tkg_font_1")
		textSlot:SetSize(RespX(220),RespY(40))
		textSlot:SetColor(Color(255, 255, 255)) 
		textSlot:SetText( "Slot Quinque #" ..dataSQL[i]["Numeroquinque"] )
	
		boutonSlotQuinque.OnCursorEntered = function()
			surface.PlaySound("osaka_sound_tkg/osaka_souris.mp3")
			boutonSlotQuinque:SetImage( "tkg_osaka/quinque_slot_hovered.png" )
			boutonSlotQuinque:SetColor(Color(245, 245, 245, 255))
			textSlot:SetColor(Color(255, 0, 0))
		end  
		boutonSlotQuinque.OnCursorExited = function()
			boutonSlotQuinque:SetImage( "tkg_osaka/quinque_slot.png" )
			boutonSlotQuinque:SetColor(Color(255, 255, 255, 70))
			textSlot:SetColor(Color(255, 255, 255))
		end
	end

	local imageCloseMenu = vgui.Create( "DImageButton", frame )
	imageCloseMenu:SetPos(RespX(5), RespY(995))				
	imageCloseMenu:SetImage( "tkg_osaka/exit_menu_1.png" )
	imageCloseMenu:SetColor(Color(240, 240, 240, 255))
	imageCloseMenu:SetSize(RespX(380),RespY(71)) 
	imageCloseMenu.DoClick = function()
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
		frame:Remove()
		alreadyReceived = false
	end

	local textCloseMenu = vgui.Create( "DLabel", frame )
	textCloseMenu:SetPos( RespX(60), RespY(1010) )
	textCloseMenu:SetFont("exit_text")
	textCloseMenu:SetSize(RespX(150),RespY(40))
	textCloseMenu:SetColor(Color(255, 255, 255))
	textCloseMenu:SetText( "Fermer" )

	imageCloseMenu.OnCursorEntered = function()
		surface.PlaySound("osaka_sound_tkg/osaka_souris.mp3")
		imageCloseMenu:SetImage( "tkg_osaka/exit_menu_2.png" )
		textCloseMenu:SetColor(Color(255, 0, 0))
	end
	imageCloseMenu.OnCursorExited = function()
		imageCloseMenu:SetImage( "tkg_osaka/exit_menu_1.png" )
		textCloseMenu:SetColor(Color(255, 255, 255))
	end

	local textGiveMenu = vgui.Create( "DLabel", frame )
	textGiveMenu:SetPos( RespX(60), RespY(965) )
	textGiveMenu:SetFont("exit_text")
	textGiveMenu:SetSize(RespX(300),RespY(40))
	textGiveMenu:SetColor(Color(255, 255, 255))
	textGiveMenu:SetText( "Sélectionner la quinque" )

	imageGiveMenu.OnCursorEntered = function()
		surface.PlaySound("osaka_sound_tkg/osaka_souris.mp3")
		imageGiveMenu:SetImage( "tkg_osaka/exit_menu_2.png" )
		textGiveMenu:SetColor(Color(255, 0, 0))
	end
        imageGiveMenu.OnCursorExited = function()
            imageGiveMenu:SetImage( "tkg_osaka/exit_menu_1.png" )
            textGiveMenu:SetColor(Color(255, 255, 255))
        end
    end
end

end)