--- Gestion de la monnaie
-- @author Starnix
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module sv_money

--Module qui permet de gérer le système économique des joueurs & ainsi de séparer la monnaie CCG & goules.

local tableCategoriesFromjobs = {
	["Ghouls"] = "Goules",
	["Antique"] = "Goules",
	["Pierrots"] = "Goules",
	["Aogiri"] = "Goules",
	["Fuko"] = "Goules",
	["Rose"] = "Goules",
	["Okubo"] = "Goules",
	["Umbrella"] = "Goules",
	["Satsujin"] = "Goules",
	["Novae Terrae"] = "Goules",
	["Kanadé Café"] = "Goules",
	["Autres"] = "Goules",
	["Humain"] = "CCG",
	["CCG"] = "CCG",
	["Quinx"] = "CCG"
}

if !sql.TableExists("tkg_money") then
	sql.Query("CREATE TABLE tkg_money(SteamID64 int, MoneyCCG int, MoneyGoule int)")
end

hook.Add("OnPlayerChangedTeam", "OsakaTKG_MoneyTeamSaveGet", function(ply, teamNumberBefore, teamNumberAfter)
	local oldJob = ply:GetNWString("TKGOsaka_Job")
	local currentJob = tableCategoriesFromjobs[ply:getJobTable()["category"]]
	local money = checkMoney(currentJob, ply:SteamID64())
	if oldJob == "Goules" or oldJob == "CCG" then
		setMoney(ply:SteamID64(), ply:getDarkRPVar("money"), oldJob)
	end
	ply:SetNWString("TKGOsaka_Job", currentJob)
	ply:setDarkRPVar("money", money)
end)

hook.Add("PlayerDisconnected", "OsakaTKG_MoneyDisconnectSave", function(ply)
	local currentJob = tableCategoriesFromjobs[ply:getJobTable()["category"]]
	local steamID64 = ply:SteamID64()
	local money = ply:getDarkRPVar("money")
	local money = checkMoney(currentJob, steamID64)
	if oldJob == "Goules" or oldJob == "CCG" then
		setMoney(steamID64, money , currentJob)
	end
end)

--- Fonction permettant de récupérer la monnaie d'un joueur.
-- @param string teamValue Job du joueur
-- @param string steamIdPlayer SteamID du joueur.
function checkMoney(teamValue, steamIdPlayer)
	local money = 0
	if tableCategoriesFromjobs[teamValue] == "CCG" then
		if sql.QueryRow("SELECT * from tkg_money WHERE SteamID64 = '".. steamIdPlayer .. "'") == nil then
			sql.QueryRow("INSERT INTO tkg_money (SteamID64, MoneyCCG, MoneyGoule) VALUES ('"..steamIdPlayer.."', '0', '0')")
		else
			money = sql.QueryValue("SELECT MoneyCCG from tkg_money WHERE SteamID64 = '".. steamIdPlayer .. "'")
		end
	else
		if sql.QueryRow("SELECT * from tkg_money WHERE SteamID64 = '".. steamIdPlayer .. "'") == nil then
			sql.QueryRow("INSERT INTO tkg_money (SteamID64, MoneyCCG, MoneyGoule) VALUES ('"..steamIdPlayer.."', '0', '0')")
		else
			money = sql.QueryValue("SELECT MoneyGoule from tkg_money WHERE SteamID64 = '".. steamIdPlayer .. "'")
		end
	end

	return money
end

--- Fonction permettant de sauvegarder la monnaie du joueur via SQL.
-- @param string steamIdPlayer du joueur.
-- @param string Value nombre de monnaie à set.
-- @param string teamValue la catégorie job du joueur.
function setMoney(steamIdPlayer, value, teamValue)
	if teamValue == "CCG" then
		if sql.QueryRow("SELECT * from tkg_money WHERE SteamID64 = '".. steamIdPlayer .. "'") == nil then
			sql.QueryRow("INSERT INTO tkg_money (SteamID64, MoneyCCG, MoneyGoule) VALUES ('"..steamIdPlayer.."', '0', '0')")
		else
			sql.QueryValue("UPDATE tkg_money SET MoneyCCG = '".. value .."' WHERE SteamID64 = '".. steamIdPlayer .. "'")
		end
	else
		if sql.QueryRow("SELECT * from tkg_money WHERE SteamID64 = '".. steamIdPlayer .. "'") == nil then
			sql.QueryRow("INSERT INTO tkg_money (SteamID64, MoneyCCG, MoneyGoule) VALUES ('"..steamIdPlayer.."', '0', '0')")
		else
			sql.QueryValue("UPDATE tkg_money SET MoneyGoule = '".. value .."' WHERE SteamID64 = '".. steamIdPlayer .. "'")
		end
	end
end