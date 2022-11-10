--- Gestion client des menus staff.
-- @author Starnix
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module cl_settingsmenu

---Création d'un menu pour que le joueur choisisse le mode du duel.

surface.CreateFont( "OsakaDescriptionDuelsFont", {
	font = "montserrat-regular", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 15,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local isActive = true


local function RespX(x) return x/1920*ScrW() end
local function RespY(y) return y/1080*ScrH() end


function OsakaTKG.MenuEquilibre(plyTargeted)
	local frame, menuButton, dPanel = OsakaTKG.Menu("Duels - Equilibrés", 135)
	local armorSet = 300
	local healthSet = 3000
	local description = vgui.Create("DLabel", dPanel)
	description:SetPos(RespX(20),RespY(32))
	description:SetText("Les duels équilibrés permettent de réaliser un combat en un contre un avec un allié en utilisant toutes les armes possibles (kagunes, quinques, etc...).")
	description:SetFont("OsakaDescriptionDuelsFont")
	description:SetSize(RespX(450), RespY(40))
	description:SetWrap(true)

	local hpChoice = vgui.Create( "XeninUI.SliderPad", dPanel )
	hpChoice:SetPos( RespX(70), RespY(130) )				-- Set the position
	hpChoice:SetSize( RespX(350), RespY(50) )			-- Set the size
	hpChoice:SetMin( 1000 )				 	-- Set the minimum number you can slide to
	hpChoice:SetMax( 15000 )				-- Set the maximum number you can slide to
	hpChoice:SetWrap(true)
	hpChoice:SetFraction(0.5)
	hpChoice:SetValue(3000)
	hpChoice:SetColor(Color(192, 57, 43))
	hpChoice.OnValueChanged = function(self, value)
		healthSet = value
	end
	local hpText = vgui.Create("DLabel", hpChoice)
	hpText:SetText("Nombre de HP des deux combattants")
	hpText:SetFont("OsakaDescriptionDuelsFont")
	hpText:SetPos(RespX(0),RespY(0))
	hpText:SetWrap(true)
	hpText:SetSize(300,15)

	local armorChoice = vgui.Create( "XeninUI.SliderPad", dPanel )
	armorChoice:SetPos( RespX(70), RespY(190) )				-- Set the position
	armorChoice:SetSize( RespX(350), RespY(50) )			-- Set the size
	armorChoice:SetMin( 100 )				 	-- Set the minimum number you can slide to
	armorChoice:SetMax( 2000 )				-- Set the maximum number you can slide to
	armorChoice:SetWrap(true)
	armorChoice:SetFraction(0.5)
	armorChoice:SetValue(300)
	armorChoice:SetColor(Color(30, 144, 255))
	armorChoice.OnValueChanged = function(self, value)
		armorSet = value
	end

	local armorText = vgui.Create("DLabel", armorChoice)
	armorText:SetText("Nombre d'armure des deux combattants")
	armorText:SetFont("OsakaDescriptionDuelsFont")
	armorText:SetPos(RespX(0),RespY(0))
	armorText:SetWrap(true)
	armorText:SetSize(RespX(300),RespY(15))

	local confirmButton = vgui.Create("XeninUI.ButtonV2", dPanel)
	confirmButton:SetPos( RespX(90), RespY(380) )				-- Set the position
	confirmButton:SetSize( RespX(300), RespY(50) )			-- Set the size
	confirmButton:SetText("Confirmer !")
	confirmButton:SetSolidColor(Color(56, 103, 214))
	confirmButton.DoClick = function()
		frame:Close()
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
		net.Start("TKGOsaka_DuelRequest")
			net.WriteEntity(plyTargeted)
			net.WriteUInt(healthSet, 14)
			net.WriteUInt(armorSet, 14)
		net.SendToServer()
	end

end

function OsakaTKG.PopupAccept(sender, mode, hp, armor)

	//
	if IsValid(NotifDuel) then return end
    NotifDuel = vgui.Create("DFrame")
    NotifDuel:SetPos(RespX(1500),RespY(100))
    NotifDuel:SetSize(RespX(425),RespY(200))
    NotifDuel:ShowCloseButton(false)
    NotifDuel:SetDraggable(true)
    NotifDuel:SetTitle("")
    function NotifDuel:Paint(w, h)
        surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
        surface.SetMaterial(Material("tkg_osaka/duel_popup/duel_bar.png")) -- Use our cached material
        surface.DrawTexturedRect( -50, 0,    550, 150)
    end
    acceptButton = vgui.Create("DImageButton", NotifDuel)
    acceptButton:SetPos(RespX(20),RespY(60))
    acceptButton:SetImage("materials/tkg_osaka/duel_popup/accept.png")
    acceptButton:SetSize(RespX(24), RespY(24))
    acceptButton.DoClick = function()
		NotifDuel:Close()
		print("HPClient:"..hp)
		print("ARMClient:"..armor)
		net.Start("TKGOsaka_DuelAccepted")
			net.WriteEntity(sender)
			net.WriteBool(mode)
			net.WriteUInt(hp, 14)
			net.WriteUInt(armor, 14)
		net.SendToServer()
	end

    refuseButton = vgui.Create("DImageButton", NotifDuel)
    refuseButton:SetPos(RespX(390),RespY(60))
    refuseButton:SetImage("materials/tkg_osaka/duel_popup/cancel.png")
    refuseButton:SetSize(RespX(24), RespY(24))
    refuseButton.DoClick = function()
		NotifDuel:Close()
	end

    text = vgui.Create("DLabel", NotifDuel)
    text:SetPos(RespX(50),RespY(52))
    if mode then
    	text:SetText(sender:Nick().." vous a demandé en duel équilibré !")
    else
    	text:SetText(sender:Nick().." vous a demandé en duel !")
    end
    
    text:SetFont("OsakaDescriptionDuelsFont")
    text:SetSize(RespX(340),RespY(40))
    text:SetWrap(true)

end
function OsakaTKG.PopupOnDuel(enemy)
	if IsValid(NotifDuel) then return end

	local function RespX(x) return x/1920*ScrW() end
	local function RespY(y) return y/1080*ScrH() end

	isActive = true
	NotifDuel = vgui.Create("DFrame")
	NotifDuel:SetPos(RespX(1400),RespY(100))
	NotifDuel:SetSize(RespX(525),RespY(200))
	NotifDuel:ShowCloseButton(false)
	NotifDuel:SetDraggable(true)
	NotifDuel:SetTitle("")
	function NotifDuel:Paint(w, h)
        surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
        surface.SetMaterial(Material("tkg_osaka/duel_popup/duel_barinfo.png")) -- Use our cached material
        --surface.DrawTexturedRect( number x, number y, number width, number height )
        surface.DrawTexturedRect( -20, 0,    RespX(550), RespY(150)) -- A VERIF ICI  ! @HOKAI
	end
	refuseButton = vgui.Create("DImageButton", NotifDuel)
	refuseButton:SetPos(RespX(470),RespY(60))
	refuseButton:SetImage("materials/tkg_osaka/duel_popup/cancel.png")
	refuseButton:SetSize(RespX(24), RespY(24))
	refuseButton.DoClick = function()
    	isActive = false
		NotifDuel:Close()
		net.Start("TKGOsaka_DuelEnd")
			net.WriteEntity(enemy)
		net.SendToServer()
	end
	text = vgui.Create("DLabel", NotifDuel)
	text:SetPos(RespX(105),RespY(52))
	text:SetFont("OsakaDescriptionDuelsFont")
	text:SetSize(RespX(318),RespY(40))
	text:SetWrap(true)
	text:SetText(enemy:Nick().." est en duel contre vous !")

	textHP = vgui.Create("DLabel", NotifDuel)
	textHP:SetFont("OsakaDescriptionDuelsFont")
	textHP:SetWrap(true)
	textHP:SetPos(RespX(35),RespY(48))
	textHP:SetSize(RespX(50),RespY(30))
	iconHP = vgui.Create("DImage", NotifDuel)
	iconHP:SetPos(RespX(15),RespY(55))
	iconHP:SetImage("icon16/heart.png")
	iconHP:SetSize(RespX(16), RespY(16))

	textArmor = vgui.Create("DLabel", NotifDuel)
	textArmor:SetFont("OsakaDescriptionDuelsFont")
	textArmor:SetWrap(true)
	textArmor:SetPos(RespX(35),RespY(70))
	textArmor:SetSize(RespX(30),RespY(30))
	iconArmor = vgui.Create("DImage", NotifDuel)
	iconArmor:SetPos(RespX(15),RespY(77))
	iconArmor:SetImage("icon16/shield.png")
	iconArmor:SetSize(RespX(16), RespY(16))

	hook.Add( "HUDPaint", "TKGOsaka_PopupOnDuel", function()
		if !(isActive) then return end
	    
		textHP:SetText(enemy:Health())
		textArmor:SetText(enemy:Armor())

	end )
	

end

net.Receive("TKGOsaka_DuelRequest", function(len, ply)
	OsakaTKG.PopupAccept(net.ReadEntity(), net.ReadBool(), net.ReadUInt(14), net.ReadUInt(14))
end)

net.Receive("TKGOsaka_OnDuel", function(len, ply)
	local enemy = net.ReadEntity()
	OsakaTKG.PopupOnDuel(enemy)
	timer.Simple( 300, function()
		if isActive != false then
			NotifDuel:Close()
			net.Start("TKGOsaka_DuelEnd")
				net.WriteEntity(enemy)
			net.SendToServer()
			isActive = false
		end
		
	end)
end)

net.Receive("TKGOsaka_DuelEnd", function(len, ply)
	if !(IsValid(NotifDuel)) then return end
	isActive = false
	NotifDuel:Close()
end)