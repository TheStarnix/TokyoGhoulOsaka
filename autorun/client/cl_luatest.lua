--- Gestion client des menus staff.
-- @author Starnix
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module cl_staffmenu

local function RespX(x) return x/1920*ScrW() end
local function RespY(y) return y/1080*ScrH() end
sound = nil

net.Receive("TKGOsaka_MusicPanel", function()
	local frame, menuButton, dPanel = OsakaTKG.Menu("Option des musiques", 135)
	local DScrollPanel = vgui.Create( "DScrollPanel", dPanel )
	DScrollPanel:Dock( FILL )

	numberOfFiles = file.Find( "addons/osaka_tkg/sound/osaka_custom_musics/*", "GAME" )

	PrintTable(numberOfFiles)
	for k,v in ipairs(numberOfFiles) do
		local DButton = DScrollPanel:Add( "DButton" )
		DButton:SetText( "#" .. k .. ": " .. v)
		DButton:Dock( TOP )
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			print(v)
			sound = CreateSound( game.GetWorld(), "osaka_custom_musics/"..v) -- create the new sound, parented to the worldspawn (which always exists)
		end
	end
	
end)

net.Receive("TKGOsaka_MusicL", function()
	print("oké")
	print(sound)
	sound:SetSoundLevel( 0 ) -- play everywhere
	sound:Play()
end)
net.Receive("TKGOsaka_MusicS", function()
	print("okéé")
	sound:Stop()
end)