--- Gestion client des menus goule.
-- @author Starnix
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module cl_ghoulmenu


surface.CreateFont("tkg_font_1", {
	font = "Bookman Old Style",
	extended = false, 
	size = ScreenScale( 9 ),
	weight = 450, 
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
});

surface.CreateFont("exit_text", {
	font = "GazetteLTStd-Roman",
	size = ScreenScale( 9 ), 
	weight = 30,
})


local function RespX(x) return x/1920*ScrW() end
local function RespY(y) return y/1080*ScrH() end

local goule_osaka_info_background = Material( "tkg_osaka/osaka_menu_goule_background_3.png")
local rinkaku_icon = Material( "tkg_osaka/rinkaku_icon.png")
local bikaku_icon = Material( "tkg_osaka/bikaku_icon.png")
local koukaku_icon = Material( "tkg_osaka/koukaku_icon.png")

local exit_menu = Material( "tkg_osaka/exit_menu_1.png")
local exit_menu_1 = Material( "tkg_osaka/exit_menu_2.png")

local bar = Material( "tkg_osaka/bar.png")
local WPos = ScrW()/2 - ScrW()/6
local HPos = ScrH()/3 - ScrH()/2 + 10


net.Receive("TKGOsaka_MenuCreate", function()
	local informations = net.ReadTable()
	local rerolls = tonumber(informations[3])
	print(informations[3])
	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW(), ScrH())
	frame:Center()
	frame:SetTitle("")
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame:MakePopup()
	frame.Paint = function(s,w,h)
		surface.SetDrawColor( 255,255,255,255 )
		surface.SetMaterial( goule_osaka_info_background )
		surface.DrawTexturedRect( RespX(0), RespY(0), RespX(ScrW()), RespY(ScrH()))
		draw.SimpleText(informations[1].." RC", "tkg_font_1", RespX(120), RespY(273), color_white )
		draw.SimpleText(informations[2], "tkg_font_1", RespX(130), RespY(353), color_white ) --Kagune
		draw.SimpleText(rerolls.." rerolls restant", "tkg_font_1", RespX(90), RespY(823), color_white ) --Rerolls
		if informations[2] == "Ukaku" then
			surface.SetDrawColor( 255,255,255,255 )
			surface.SetMaterial( rinkaku_icon )
			surface.DrawTexturedRect( RespX(0), RespY(0), RespX(ScrW()), RespY(ScrH()))
		elseif informations[2] == "Rinkaku" then
			surface.SetDrawColor( 255,255,255,255 )
			surface.SetMaterial( rinkaku_icon )
			surface.DrawTexturedRect( RespX(0), RespY(0), RespX(ScrW()), RespY(ScrH()))
		elseif informations[2] == "Koukaku" then
			surface.SetDrawColor( 255,255,255,255 )
			surface.SetMaterial( koukaku_icon )
			surface.DrawTexturedRect( RespX(0), RespY(0), RespX(ScrW()), RespY(ScrH()))
		elseif informations[2] == "Bikaku" then
			surface.SetDrawColor( 255,255,255,255 )
			surface.SetMaterial( bikaku_icon )
			surface.DrawTexturedRect( RespX(0), RespY(0), RespX(ScrW()), RespY(ScrH()))
		end

	end

	

	local DPanel = vgui.Create( "DPanel", frame)
	DPanel:SetPos( RespX(160), RespY(0) ) -- Set the position of the panel
	DPanel:SetSize( ScrW(), ScrH() ) -- Set the size of the panel
	DPanel.Paint = nil

	local Menu = vgui.Create( "DPanel", frame)
	Menu:SetPos( RespX(160), RespY(0) ) -- Set the position of the panel
	Menu:SetSize( ScrW(), ScrH() ) -- Set the size of the panel
	Menu.Paint = nil

	local kagune_preview = vgui.Create( "DAdjustableModelPanel", frame )
	kagune_preview:Dock(FILL)
	kagune_preview:SetModel( informations[4] )
	kagune_preview:SetLookAng( Angle( 0, 0, 0 ) )
	kagune_preview:SetCamPos( Vector( -70, 0, 30 ) )
	kagune_preview:SetFOV(150)

	local Menu = vgui.Create( "DPanel", frame)
	Menu:SetPos( RespX(0), RespY(0) ) -- Set the position of the panel
	Menu:SetSize( 400, ScrH() ) -- Set the size of the panel
	Menu.Paint = nil

	local close_goule_menu = vgui.Create( "DImageButton", frame )
	close_goule_menu:SetPos(RespX(5), RespY(995))				
	close_goule_menu:SetImage( "tkg_osaka/exit_menu_1.png" )
	close_goule_menu:SetColor(Color(240, 240, 240, 255))
	close_goule_menu:SetSize(RespX(380),RespY(71)) 
	close_goule_menu.DoClick = function()
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
		if timer.Exists( "TKGOsaka_RerollTimer" ) then timer.Remove( "TKGOsaka_RerollTimer" ) end
		frame:Remove()
	end

	local leave = vgui.Create( "DLabel", frame )
	leave:SetPos( RespX(60), RespY(1010) )
	leave:SetFont("exit_text")
	leave:SetSize(RespX(150),RespY(40))
	leave:SetColor(Color(255, 255, 255))
	leave:SetText( "Fermer" )

	close_goule_menu.OnCursorEntered = function()
		surface.PlaySound("osaka_sound_tkg/osaka_souris.mp3")
		close_goule_menu:SetImage( "tkg_osaka/exit_menu_2.png" )
		leave:SetColor(Color(255, 0, 0))
	end
	close_goule_menu.OnCursorExited = function()
		close_goule_menu:SetImage( "tkg_osaka/exit_menu_1.png" )
		leave:SetColor(Color(255, 255, 255))
	end
	
	local Bouton_reroll = vgui.Create( "DImageButton", frame )
	Bouton_reroll:SetPos(RespX(-45), RespY(833))				
	Bouton_reroll:SetImage( "tkg_osaka/bouton_tkg_1.png" )	
	Bouton_reroll:SetColor(Color(255, 255, 255, 70))
	Bouton_reroll:SetSize(RespX(495),RespY(95))
	Bouton_reroll.DoClick = function()
		if rerolls != 0 then rerolls = rerolls-1 end
		
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
		net.Start("TKGOsaka_Reroll")
		net.SendToServer()
	end

	local DLabel = vgui.Create( "DLabel", frame )
	DLabel:SetPos( RespX(70), RespY(858) )
	DLabel:SetFont("tkg_font_1")
	DLabel:SetSize(RespX(220),RespY(40))
	DLabel:SetColor(Color(255, 255, 255))
	DLabel:SetText( "Reroll son kagune" )

	Bouton_reroll.OnCursorEntered = function()
		surface.PlaySound("osaka_sound_tkg/osaka_souris.mp3")
		Bouton_reroll:SetImage( "tkg_osaka/bouton_tkg_2.png" )
		Bouton_reroll:SetColor(Color(245, 245, 245, 255))
		DLabel:SetColor(Color(255, 0, 0))
	end  
	Bouton_reroll.OnCursorExited = function()
		Bouton_reroll:SetImage( "tkg_osaka/bouton_tkg_1.png" )
		Bouton_reroll:SetColor(Color(255, 255, 255, 70))
		DLabel:SetColor(Color(255, 255, 255))
	end

	net.Receive("TKGOsaka_Reroll", function()

		local kaguneRerolled = net.ReadString()
		local materialRerolled = net.ReadString()
		informations[2] = kaguneRerolled
		isBarDrawingText = true
		if isBarDrawingText then
			kagune_preview:SetModel( materialRerolled )
			DPanel.Paint = function(s,w,h)
				draw.RoundedBox(4, ScrW()/2.95, ScrH()/1.165, ScrW()/3, ScrH()/13.5, Color(52, 73, 94, 255))
				surface.SetDrawColor( 255,255,255,255 )
				surface.SetMaterial( bar )
				surface.DrawTexturedRect( ScrW()/3, ScrH()/1.5, ScrW()/2.9, ScrH()/2.2)
				draw.SimpleText("Vous avez reroll un "..kaguneRerolled, "TKGOsaka_HUDBarFont", ScrW()/2.3, ScrH()/1.135, Color(255, 255, 255, 255))
			end
			timer.Create( "TKGOsaka_RerollTimer", 3, 1, function()
				isBarDrawingText = false 
				DPanel.Paint = nil
			end )
		end
	end)


end)