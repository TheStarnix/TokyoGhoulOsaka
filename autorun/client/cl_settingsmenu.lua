--- Gestion client des menus staff.
-- @author Starnix
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module cl_settingsmenu


local function RespX(x) return x/1920*ScrW() end
local function RespY(y) return y/1080*ScrH() end

concommand.Add("TKGOsaka_Menu", function( ply, cmd, args )
    local frame, menuButton, dPanel = OsakaTKG.Menu("Paramètres", 180)
	menuButton.DoClick = function()
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
		local dMenu = vgui.Create("DMenu", frame)
		dMenu:AddOption("Menu STAFF", function()
			if table.HasValue(adminRanks, ply:GetUserGroup()) then 
				frame:Close()
				LocalPlayer():ConCommand( "say !osakamenu" )
			end
			
		end):SetIcon( "icon16/computer.png" )
		dMenu:AddOption( "Menu Goule", function()
			frame:Close()
			LocalPlayer():ConCommand( "say !goule" )
		end):SetIcon( "icon16/group.png" )
		dMenu:SetPos(frame:CursorPos())
	end

	local checkBoxParticles = vgui.Create("DCheckBoxLabel", dPanel)
	checkBoxParticles:SetPos( RespX(10), RespY(40) )
	checkBoxParticles:SetText("Particules TokyoGhoul")
	checkBoxParticles:SetFont( "OsakaMenuGlobalFont" )
	checkBoxParticles:SetConVar("tkg_particles")
	checkBoxParticles:SetValue( GetConVar( "tkg_particles" ):GetBool() )
	checkBoxParticles:SizeToContents()
	function checkBoxParticles:OnChange()
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
	end
	local checkBoxDuels = vgui.Create("DCheckBoxLabel", dPanel)
	checkBoxDuels:SetPos( RespX(10), RespY(65) )
	checkBoxDuels:SetText("Accepter les duels des joueurs")
	checkBoxDuels:SetFont( "OsakaMenuGlobalFont" )
	checkBoxDuels:SetConVar("tkg_duels")
	checkBoxDuels:SetValue( GetConVar( "tkg_duels" ):GetBool() )
	checkBoxDuels:SizeToContents()
	function checkBoxDuels:OnChange()
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
	end

	local close_goule_menu = vgui.Create( "DImageButton", frame )
	close_goule_menu:SetPos(RespX(75), RespY(435))				
	close_goule_menu:SetImage( "tkg_osaka/exit_menu_1.png" )
	close_goule_menu:SetColor(Color(240, 240, 240, 255))
	close_goule_menu:SetSize(RespX(330),RespY(71)) 
	close_goule_menu.DoClick = function()
		surface.PlaySound("osaka_sound_tkg/osaka_select.mp3")
		RunConsoleCommand("say", "!hudconfig")
		frame:Remove()
	end

	local leave = vgui.Create( "DLabel", frame )
	leave:SetPos( RespX(135), RespY(450) )
	leave:SetFont("Font_1")
	leave:SetSize(RespX(350),RespY(40))
	leave:SetColor(Color(255, 255, 255))
	leave:SetText( "Configuration hud" )

	close_goule_menu.OnCursorEntered = function()
		surface.PlaySound("osaka_sound_tkg/osaka_souris.mp3")
		close_goule_menu:SetImage( "tkg_osaka/exit_menu_2.png" )
		leave:SetColor(Color(255, 0, 0))
	end
	close_goule_menu.OnCursorExited = function()
		close_goule_menu:SetImage( "tkg_osaka/exit_menu_1.png" )
		leave:SetColor(Color(255, 255, 255))
	end


end)