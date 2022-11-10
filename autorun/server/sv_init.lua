--- Initialisation de l'addon TKG. 
-- @author Starnix
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module sv_init

-- Création si inexistante de la table tkg_players pour le Kagune
if !sql.TableExists("tkg_players") then
	sql.Query("CREATE TABLE tkg_players(SteamID64 int, RC int, Kagune int, Classification varchar(15), Rerolls int)") 
end

-- Création si inexistante de la table tkg_ccglist pour les Quinques.
if !sql.TableExists("tkg_ccglist") then
	sql.Query("CREATE TABLE tkg_ccglist(SteamID64 int, RCQuinque int, Numeroquinque int, Nom varchar(15), Type varchar(15), Model varchar(50))")
end

-- Ajout du joueur dans la table tkg_players pour le Kagune.
hook.Add("PlayerInitialSpawn", "TKGOsaka_Connect", function(ply)
	if sql.QueryRow("SELECT * from tkg_players WHERE SteamID64 = '".. ply:SteamID64() .. "'") == nil then
		sql.QueryRow("INSERT INTO tkg_players (SteamID64, RC, Kagune, Classification, Rerolls) VALUES ('"..ply:SteamID64().."', '"..math.random(1000, 1200).."', '"..math.random(1,4).."', 'C', '1')")
	end

	ply:SetNWInt("RCNumber", (sql.QueryValue("SELECT RC from tkg_players WHERE SteamID64 = '".. ply:SteamID64() .. "'")))
end)

-- Hook utilisé afin de changer la vitesse du joueur lorsqu'un Kagune est sorti.
hook.Add( "PlayerSwitchWeapon", "TKGOsaka_WeaponSwitch", function( ply, oldWeapon, newWeapon )
	if oldWeapon == NULL then return end
	if pathKagune[oldWeapon:GetClass()] then -- Si le joueur n'utilise plus son Kagune.
		ply:SetRunSpeed(350) -- On change la vitesse du joueur.
		ply:SetJumpPower(350) -- On change sa puissance de saut.
	end

	if newWeapon:GetClass() == "kagune_bikaku1" then -- Si le joueur utilise son Kagune Bikaku
		ply:SetRunSpeed(350+configKagune_Bikaku["bikaku_moovespeed"])
		ply:SetJumpPower(350+configKagune_Bikaku["bikaku_moovespeed"])
	elseif newWeapon:GetClass() == "kagune_rinkaku1" then -- Si le joueur utilise son Kagune Rinkaku
		ply:SetRunSpeed(350+configKagune_Rinkaku["Rinkaku_moovespeed"])
		ply:SetJumpPower(350+configKagune_Rinkaku["Rinkaku_moovespeed"])
	elseif newWeapon:GetClass() == "kagune_koukaku1" then -- Si le joueur utilise son Kagune Koukaku
		ply:SetRunSpeed(350+configKagune_Koukaku["Koukaku_moovespeed"])
		ply:SetJumpPower(350+configKagune_Koukaku["Koukaku_moovespeed"])
	elseif newWeapon:GetClass() == "kagune_ukaku1" then -- Si le joueur utilise son Kagune Ukaku
		ply:SetRunSpeed(350+configKagune_Ukaku["Ukaku_moovespeed"])
		ply:SetJumpPower(350+configKagune_Ukaku["Ukaku_moovespeed"])
	end
end )

-- Hook utilisé afin de donner le Kagune aux joueurs qui apparaissent.
hook.Add( "PlayerSpawn", "TKGOsaka_SpawnKagune", function(ply)
	if isnumber(ccgRCLimit[team.GetName(ply:Team())]) then return end --Si il est dans un des job CCG, on ne lui donne pas de Kagune.
	local kagune = sql.QueryValue("SELECT Kagune from tkg_players WHERE SteamID64 = '".. ply:SteamID64() .. "';")
	ply:Give(listeKagune[kagune]["swep_name"], true)
end)