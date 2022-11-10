--- Gestion client des cadavres
-- @author Hokai
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module cl_eatcorpses

-- Répertorisation des textures
local eat_frame_bar = Material( "tkg_osaka/eat_frame_bar.png")
local eat_frame_bar_1 = Material( "tkg_osaka/eat_frame_bar_1.png")
local eat_frame_time = Material( "tkg_osaka/eat_frame_time.png")

-- Fonction permettant de générer une barre remplie de sang afin de montrer le cooldown du cadavre.
hook.Add("HUDPaint", "TKGOsaka_EatRagdoll", function()
	if LocalPlayer():KeyDown( IN_USE ) && LocalPlayer():GetNWBool("IsEating", true ) and LocalPlayer():GetNWInt("CorpsDelay", 0 ) >= CurTime() then
		
			local ScrW = ScrW()
			local ScrH = ScrH()
			
			local WPos = ScrW/2 - ScrW/6
			local HPos = ScrH/3 - ScrH/35
			
			local W2Long = ScrW/2.5 - 10
			local H2Long = ScrH/2.5 - 10 
			
			local percents = ( 2 - ( LocalPlayer():GetNWInt("CorpsDelay", 0 ) - CurTime() ) )/2.3

				surface.SetDrawColor( 255,255,255,255 )
				surface.SetMaterial( eat_frame_bar_1 )
				surface.DrawTexturedRect( WPos, HPos, ScrW/2.9, ScrH/2.5)

				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( eat_frame_time )
				surface.DrawTexturedRect( WPos + 10, HPos + 5, W2Long*percents, H2Long)

				surface.SetDrawColor( 255,255,255,255 )
				surface.SetMaterial( eat_frame_bar )
				surface.DrawTexturedRect( WPos, HPos, ScrW/2.9, ScrH/2.5)
	end
end)