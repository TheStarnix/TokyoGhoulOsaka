--- Gestion des menus
-- @author Starnix
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module sv_menus

--- Fonction permettant de synthétiser des informations sur UN joueur
-- @param player Entity où on va chercher les informations
-- @param informations Table où l'on va insérer les informations du joueur.
function updateLocalInformations(player)
	local LocalData = sql.QueryRow("SELECT * from tkg_players WHERE SteamID64 = '"..player:SteamID64().."'")
	informations = {}

	table.insert(informations, LocalData["RC"]) -- Ajout des RC du joueur dans la table informations qui sera affichée dans le GUI
	table.insert(informations, listeKagune[LocalData["Kagune"]]["name"]) -- Ajout du nom du kagune du joueur dans la table informations qui sera affichée dans le GUI
	table.insert(informations, LocalData["Rerolls"]) -- Ajout des rerolls du joueur dans la table informations qui sera affichée dans le GUI
	table.insert(informations, listeKagune[LocalData["Kagune"]]["model"]) -- Ajout du model du kagune du joueur dans la table informations qui sera affichée dans le GUI
	
	return informations
end

--Si un joueur dit la commande, ça lui ouvre le menu. 
hook.Add("PlayerSay", "TKGOsaka_TkgRC", function(ply, text)

	-- MENU ADMINISTRATEUR
	if (string.sub(text, 1, 11) == "!osakamenu") then

		if !(adminRanks[ply:GetUserGroup()]) then return end
		Data = sql.Query("SELECT * from tkg_players") or {}
		DataCCG = sql.Query("SELECT * from tkg_ccglist") or {}

		net.Start("TKGOsaka_Menu")
			net.WriteTable(Data)
			net.WriteTable(rerolls)
			net.WriteTable(listeKagune)
			net.WriteTable(DataCCG)
		net.Send(ply)

		return "" --Pour n'afficher aucune commande dans le chat.

	-- MENU GOULE
	elseif (string.sub(text, 1, 7) == "!goule") then

		if sql.QueryRow("SELECT * from tkg_players WHERE SteamID64 = '".. ply:SteamID64() .. "'") == nil then
			ply:PrintMessage(HUD_PRINTTALK, "Vous devez être une goule afin d'ouvrir ce menu !")
			return ""
		end
		updateLocalInformations(ply)

		net.Start("TKGOsaka_MenuCreate")
			net.WriteTable(informations)
		net.Send(ply)

		return "" -- Pour n'afficher aucune commande dans le chat.*

	end
end)

-- Fonction qui agit lorsqu'un joueur réalise un reroll.
net.Receive("TKGOsaka_Reroll", function(len, ply)
	local rerollNumber = sql.QueryValue("SELECT Rerolls from tkg_players WHERE SteamID64='"..ply:SteamID64().."'") -- On récupère le nombre de rerolls du joueur
	if rerollNumber == "0" then -- Si le joueur n'a plus de rerolls, on l'avertit.
		ply:PrintMessage(HUD_PRINTTALK, "Tu ne peux plus reroll !")
		return
	end

	local kaguneRerolled = tostring(math.random(1,4)) -- On choisit un kagune au hasard

	net.Start("TKGOsaka_Reroll")
		net.WriteString(listeKagune[kaguneRerolled]["name"]) -- On envoie au joueur le nom du Kagune tiré au hasard 
		net.WriteString(listeKagune[kaguneRerolled]["model"]) -- On envoie au joueur le model du Kagune tiré au hasard
	net.Send(ply)

	--blogs_rerolls(ply, rerolls[tostring(kagune)][1])
	sql.Query("UPDATE tkg_players SET Rerolls =".. rerollNumber-1 ..",Kagune = "..kaguneRerolled.." WHERE SteamID64='"..ply:SteamID64().."'") -- On enlève un reroll au joueur et on met à jour le Kagune du joueur.
end)

-- Fonction qui agit lorsqu'un changement d'infos est demandé.
net.Receive("TKGOsaka_MenuChange", function(len, ply)
	-- Le menu peut seulement être ouvert par un staff
	if !(adminRanks[ply:GetUserGroup()]) then return end

	local dataReceived = net.ReadTable()
	local isCCG = net.ReadBool()
	local getAll = sql.QueryRow("SELECT * from tkg_players WHERE SteamID64 = '".. ply:SteamID64() .. "'")

	if isCCG then
		if dataReceived[3] != nil then
			sql.Query("UPDATE tkg_ccglist SET RCQuinque ='".. dataReceived[2].."',Nom = '"..dataReceived[4].."',Type = '"..dataReceived[5].."' WHERE SteamID64='"..dataReceived[1].."' AND Numeroquinque = '"..dataReceived[3].."'") 
		else
			sql.Query("DELETE FROM tkg_ccglist WHERE SteamID64='"..dataReceived[1].."' AND Numeroquinque = '"..dataReceived[2].."'")
		end
	else
		if dataReceived[3] != nil then
			if player.GetBySteamID64(dataReceived[1]) != false then
				playerbysteamid:SetNWInt("RCNumber", tonumber(dataReceived[2]))
			end
			sql.Query("UPDATE tkg_players SET RC ='".. dataReceived[2].."',Rerolls = '"..dataReceived[3].."',Kagune = '"..dataReceived[4].."' WHERE SteamID64='"..dataReceived[1].."'") 
		else
			sql.Query("DELETE FROM tkg_players WHERE SteamID64='"..dataReceived[1].."'")
		end
	end
	
end)