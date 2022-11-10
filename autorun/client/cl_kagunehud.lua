/*


	local tkg_weapon_osaka = Material( "tkg_osaka/weapon_hud/tkg_kaguneinterface_weapon_2.png") 
	local tkg_weapon_osaka_clique_gauche = Material( "tkg_osaka/weapon_hud/tkg_weaponinterface_clique_gauche.png")
	local tkg_weapon_osaka_clique_droit = Material( "tkg_osaka/weapon_hud/tkg_weaponinterface_clique_droit.png")
	local tkg_weapon_osaka_clique_r = Material( "tkg_osaka/weapon_hud/tkg_weaponinterface_r.png")  


	local tkg_weapon_osaka_clique_droit_icon_ukaku = Material( "tkg_osaka/weapon_hud/clique_droit_icon_ukaku.png")
	local tkg_weapon_osaka_clique_droit_icon = Material( "tkg_osaka/weapon_hud/clique_droit_icon.png")
	local tkg_weapon_osaka_clique_r_icon = Material( "tkg_osaka/weapon_hud/touche_r_icon.png")
	local tkg_weapon_osaka_clique_gauche_icon = Material( "tkg_osaka/weapon_hud/clique_gauche_icon.png")  


    local function RespX(pixels, base)
        base = base or 1920
        return ScrW()/(base/pixels)
      end
      
      local function RespY(pixels, base)
        base = base or 1080
        return ScrH()/(base/pixels)
      end


      local kagune_hud_osaka = {
		"kagune_bikaku1",
		"kagune_koukaku1",
		"kagune_rinkaku1",
		"kagune_ukaku1",
	}

    local weapon_kagune_ukaku = {
		"kagune_ukaku1",
	}



hook.Add("HUDPaint", "TKGOsaka_KaguneHUD", function()      
	if LocalPlayer():Alive() then
		if LocalPlayer():Health() > 1 then 
			ply = LocalPlayer()
			wep = ply:GetActiveWeapon()
			if table.HasValue( kagune_hud_osaka, wep:GetClass() ) then
					surface.SetMaterial( tkg_weapon_osaka ) 
					surface.SetDrawColor( 255, 255, 255, 255 ) 
					surface.DrawTexturedRect( RespX(1540), RespY(680), RespX(410), RespY(410) )



						if input.IsMouseDown( MOUSE_LEFT ) then
							surface.SetMaterial( tkg_weapon_osaka_clique_gauche ) 
							surface.SetDrawColor( 255, 255, 255, 255 ) 
							surface.DrawTexturedRect( RespX(1540), RespY(680), RespX(410), RespY(410) )
						end

						if input.IsMouseDown( MOUSE_RIGHT ) then
							surface.SetMaterial( tkg_weapon_osaka_clique_droit ) 
							surface.SetDrawColor( 255, 255, 255, 255 )  
							surface.DrawTexturedRect( RespX(1540), RespY(680), RespX(410), RespY(410) )
						end 

						if input.IsKeyDown( KEY_R ) then
							
							surface.SetMaterial( tkg_weapon_osaka_clique_r ) 
							surface.SetDrawColor( 255, 255, 255, 255 ) 
							surface.DrawTexturedRect( RespX(1540), RespY(680), RespX(410), RespY(410) )
						end

 
                    if table.HasValue( weapon_kagune_ukaku, wep:GetClass() ) then
						surface.SetMaterial( tkg_weapon_osaka_clique_droit_icon_ukaku ) 
						surface.SetDrawColor( 255, 255, 255, 255 ) 
						surface.DrawTexturedRect( RespX(1540), RespY(680), RespX(410), RespY(410) )
					else
						surface.SetMaterial( tkg_weapon_osaka_clique_droit_icon ) 
						surface.SetDrawColor( 255, 255, 255, 255 ) 
						surface.DrawTexturedRect( RespX(1540), RespY(680), RespX(410), RespY(410) )
					end


						surface.SetMaterial( tkg_weapon_osaka_clique_gauche_icon ) 
						surface.SetDrawColor( 255, 255, 255, 255 ) 
						surface.DrawTexturedRect( RespX(1540), RespY(680), RespX(410), RespY(410) )
	
						surface.SetMaterial( tkg_weapon_osaka_clique_r_icon ) 
						surface.SetDrawColor( 255, 255, 255, 255 ) 
						surface.DrawTexturedRect( RespX(1540), RespY(680), RespX(410), RespY(410) )

			end
		end
	end
        end)

*/