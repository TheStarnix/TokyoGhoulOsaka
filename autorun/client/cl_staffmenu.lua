--- Gestion client des menus staff.
-- @author Starnix
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module cl_staffmenu

net.Receive("TKGOsaka_Menu", function()
	local Data = net.ReadTable()
	local DataRerolls = net.ReadTable()
	local DataKagunes = net.ReadTable()
	local DataCCG = net.ReadTable()
	local frame = vgui.Create("DFrame")
	local numberLine = 0
	local whatIsEdited = 0
	frame:SetSize(700, 700)
	frame:Center()
	frame:SetTitle("Osaka TKG I Menu")
	frame:SetDraggable(false)
	frame:ShowCloseButton(true)
	frame:MakePopup()

	background = vgui.Create("DPanel", frame)
	background:SetPos(0, 25)
	frame.Paint = function(s,w,h)
		draw.RoundedBox(5, 0, 0, w, h, Color(50, 50, 50))
		background:SetSize(w, h)
	end
	background:SetBackgroundColor(Color(60, 60, 60))

	---Variable pour le menu.
	local menu = vgui.Create("DPropertySheet", frame)
	menu:Dock(FILL)

	--- Variable générant le menu avec la liste des joueurs.
	local panelEditPlayers = vgui.Create("DPanel", menu)
	menu:AddSheet( "Goules", panelEditPlayers, "icon16/user_edit.png")
	panelEditPlayers:SetBackgroundColor(Color(60, 60, 60))

	--- Sous-Menu Goules où la liste des joueurs est exposée, avec les informations.
	local listOfPlayers = vgui.Create("DListView", panelEditPlayers)
	listOfPlayers:SetSize(677, 500)
	listOfPlayers:SetMultiSelect(true)
	listOfPlayers:AddColumn("SteamID64")
	listOfPlayers:AddColumn("RC")
	listOfPlayers:AddColumn("Rerolls")
	listOfPlayers:AddColumn("Kagune")
	listViewCreate(Data, listOfPlayers, nil, false)
	function listOfPlayers:DoDoubleClick( lineID, line )
		RC = Data[lineID]["RC"]
		Rerolls = Data[lineID]["Rerolls"]
		Kagune = Data[lineID]["Kagune"]
		numberLine = lineID
		local menuEdit = vgui.Create("DMenu", listOfPlayers)
		menuEdit:SetPos(listOfPlayers:CursorPos())
		local SubMenu1 = menuEdit:AddSubMenu( "Modifier" )
		SubMenu1:AddOption( "RC", function()
			Derma_StringRequest("Modifier le nombre de RC", "Cette personne possède ".. RC .. "RC. Choisissez la nouvelle valeur !",RC,
				function(text)
					sendEditedInformations(Data[lineID]["SteamID64"], text, Data[lineID]["Rerolls"], Data[lineID]["Kagune"], false, false)
					Data[lineID]["RC"] = text
					listViewCreate(Data, listOfPlayers, nil, false)
				end,
				nil,"Modifier","Annuler")
		end):SetIcon( "icon16/coins.png" )
		SubMenu1:AddOption( "Rerolls", function()
			Derma_StringRequest("Modifier le nombre de Rerolls", "Cette personne possède ".. Rerolls .. " rerolls. Choisissez la nouvelle valeur !",Rerolls,
				function(text)
					sendEditedInformations(Data[lineID]["SteamID64"], Data[lineID]["RC"],text, Data[lineID]["Kagune"], false, false)
					Data[lineID]["Rerolls"] = text
					listViewCreate(Data, listOfPlayers, nil, false)
				end,
				nil,"Modifier","Annuler")
		end):SetIcon( "icon16/briefcase.png" )
		SubMenu1:AddOption( "Kagune", function()
			Derma_StringRequest("Modifier le Kagune", "Cette personne possède le Kagune ".. Kagune .. ". Choisissez la nouvelle valeur !",Kagune,
				function(text)
					sendEditedInformations(Data[lineID]["SteamID64"], Data[lineID]["RC"], Data[lineID]["Rerolls"], text, false, false)
					Data[lineID]["Kagune"] = text
					listViewCreate(Data, listOfPlayers, nil, false)
				end,
				nil,"Modifier","Annuler")
		end):SetIcon( "icon16/bug.png" )
		local SubMenu2 = menuEdit:AddSubMenu( "Supprimer" )
		SubMenu2:AddOption( "Êtes-vous sûr?", function()
			sendEditedInformations(Data[lineID]["SteamID64"], "", "", "", "", true, false)
			table.remove(Data, lineID)
			listViewCreate(Data, listOfPlayers, nil, false)
		end):SetIcon( "icon16/accept.png" )
	end

	local researchButton = vgui.Create("DButton", panelEditPlayers)
	researchButton:SetText( "Recherche par SteamID" )
	researchButton:SetPos( 210, 500 )
	researchButton:SetSize( 250, 30 )					// Set the size
	researchButton.DoClick = function()				// A custom function run when clicked ( note the . instead of : )
		Derma_StringRequest("Recherche par SteamID", "Recherchez efficacement une personne.","",
			function(text)
				if text == "" then
					listViewCreate(Data, listOfPlayers, nil, false)
				else
					listViewCreate(Data, listOfPlayers, text, false)
				end
			end,
			nil,"Rechercher","Annuler")
	end
	researchButton:SetIcon("icon16/find.png")

	local selectOnlinePlayer = vgui.Create("DComboBox", panelEditPlayers)
	selectOnlinePlayer:SetPos( 210, 600 )
	selectOnlinePlayer:SetSize( 250, 30 )
	selectOnlinePlayer:SetValue("Chercher un joueur connecté")
	selectOnlinePlayer:AddChoice("Tous les joueurs")
	for k,v in ipairs(player.GetAll()) do
		selectOnlinePlayer:AddChoice(v:Nick())
	end

	selectOnlinePlayer.OnSelect = function (index, text, value)
		if value == "Tous les joueurs" then
			listViewCreate(Data, listOfPlayers, nil, false)
		else
			for k,v in ipairs(player.GetAll()) do
				if v:Nick() == value then
					listViewCreate(Data, listOfPlayers, v:SteamID(), false)
				end
			end
		end
	end

	--- Sous-Menu CCG où la liste des joueurs est exposée, avec les informations.
	local panelListCCG = vgui.Create("DPanel", menu)
	menu:AddSheet( "CCG", panelListCCG, "icon16/database_gear.png")
	panelListCCG:SetBackgroundColor(Color(60, 60, 60))

	local listOfCCG = vgui.Create("DListView", panelListCCG)
	listOfCCG:SetSize(677, 500)
	listOfCCG:SetMultiSelect(true)
	listOfCCG:AddColumn("SteamID64")
	listOfCCG:AddColumn("RC Quinque")
	listOfCCG:AddColumn("Numéro de quinque")
	listOfCCG:AddColumn("Nom quinque")
	listOfCCG:AddColumn("Type de quinque")
	listOfCCG:Clear()
	if #DataCCG != 0 then
		if #DataCCG > 28 then
			for k=1,28,1 do
				listOfCCG:AddLine(DataCCG[k]["SteamID64"], DataCCG[k]["RCQuinque"], DataCCG[k]["Numeroquinque"], DataCCG[k]["Nom"], DataCCG[k]["Type"])
			end
		else
			for k=1,#DataCCG,1 do
				listOfCCG:AddLine(DataCCG[k]["SteamID64"], DataCCG[k]["RCQuinque"], DataCCG[k]["Numeroquinque"], DataCCG[k]["Nom"], DataCCG[k]["Type"])
			end
		end
	end

	function listOfCCG:DoDoubleClick( lineID, line )
		RCQuinque = DataCCG[lineID]["RCQuinque"]
		Rang = DataCCG[lineID]["Rang"]
		Nom = DataCCG[lineID]["Nom"]
		Type = DataCCG[lineID]["Type"]
		numberLine = lineID
		local menuEdit = vgui.Create("DMenu", listOfCCG)
		menuEdit:SetPos(listOfCCG:CursorPos())
		local SubMenu1 = menuEdit:AddSubMenu( "Modifier" )
		SubMenu1:AddOption( "RC Quinque", function()
			Derma_StringRequest("Modifier le nombre de RC la quinque ".. Nom ..".", "Cette quinque possède ".. RCQuinque .. "RC. Choisissez la nouvelle valeur !",RCQuinque,
				function(text)
					sendEditedInformations(DataCCG[lineID]["SteamID64"], text, DataCCG[lineID]["Numeroquinque"], DataCCG[lineID]["Nom"], DataCCG[lineID]["Type"], false, true)
					DataCCG[lineID]["RCQuinque"] = text
					listViewCreate(DataCCG, listOfCCG, nil, true)
				end,
				nil,"Modifier","Annuler")
		end):SetIcon( "icon16/coins.png" )
		SubMenu1:AddOption( "Nom", function()
			Derma_StringRequest("Modifier le nom de la quinque", "Cette quinque possède le nom ".. Nom .. ". Choisissez la nouvelle valeur !",Nom,
				function(text)
					sendEditedInformations(DataCCG[lineID]["SteamID64"], DataCCG[lineID]["RCQuinque"], DataCCG[lineID]["Numeroquinque"], text, DataCCG[lineID]["Type"], false, true)
					DataCCG[lineID]["Nom"] = text
					listViewCreate(DataCCG, listOfCCG, nil, true)
				end,
				nil,"Modifier","Annuler")
		end):SetIcon( "icon16/bug.png" )
		SubMenu1:AddOption( "Type", function()
			Derma_StringRequest("Modifier le type de la quinque", "Cette quinque possède le type ".. Type .. ". Choisissez la nouvelle valeur !",Type,
				function(text)
					sendEditedInformations(DataCCG[lineID]["SteamID64"], DataCCG[lineID]["RCQuinque"], DataCCG[lineID]["Numeroquinque"], DataCCG[lineID]["Nom"], text, false, true)
					DataCCG[lineID]["Type"] = text
					listViewCreate(DataCCG, listOfCCG, nil, true)
				end,
				nil,"Modifier","Annuler")
		end):SetIcon( "icon16/bug.png" )
		local SubMenu2 = menuEdit:AddSubMenu( "Supprimer" )
		SubMenu2:AddOption( "Êtes-vous sûr?", function()
			sendEditedInformations(DataCCG[lineID]["SteamID64"], "", DataCCG[lineID]["Numeroquinque"], "", "", true, true)
			table.remove(DataCCG, lineID)
			listViewCreate(DataCCG, listOfCCG, nil, true)
		end):SetIcon( "icon16/accept.png" )
	end

	local researchButtonCCG = vgui.Create("DButton", panelListCCG)
	researchButtonCCG:SetText( "Recherche par SteamID" )
	researchButtonCCG:SetPos( 210, 500 )
	researchButtonCCG:SetSize( 250, 30 )					// Set the size
	researchButtonCCG.DoClick = function()				// A custom function run when clicked ( note the . instead of : )
		Derma_StringRequest("Recherche par SteamID", "Recherchez efficacement une personne.","",
			function(text)
				if text == "" then
					listViewCreate(DataCCG, listOfCCG, nil, false)
				else
					listViewCreate(DataCCG, listOfCCG, text, false)
				end
			end,
			nil,"Rechercher","Annuler")
	end
	researchButtonCCG:SetIcon("icon16/find.png")

	local selectOnlinePlayerCCG = vgui.Create("DComboBox", panelListCCG)
	selectOnlinePlayerCCG:SetPos( 210, 600 )
	selectOnlinePlayerCCG:SetSize( 250, 30 )
	selectOnlinePlayerCCG:SetValue("Chercher un joueur connecté")
	selectOnlinePlayerCCG:AddChoice("Tous les joueurs")
	for k,v in ipairs(player.GetAll()) do
		selectOnlinePlayerCCG:AddChoice(v:Nick())
	end

	selectOnlinePlayerCCG.OnSelect = function (index, text, value)
		if value == "Tous les joueurs" then
			listViewCreate(DataCCG, listOfCCG, nil, true)
		else
			for k,v in ipairs(player.GetAll()) do
				if v:Nick() == value then
					listViewCreate(DataCCG, listOfCCG, v:SteamID(), true)
				end
			end
		end
	end

end)

--- Fonction permettant de synthétiser ce qui doit être mit à jour sur UN joueur.
-- @param steamID string du joueur où les infos doivent être modifiées
-- @param RC number de cellules RC = puissance du joueur
-- @param classification char où la classification du joueur est marquée
-- @param rerolls number de fois qu'un joueur peut changer son Kagune
-- @param Kagune number renvoyant à un kagune spécifique. Voir la liste des Kagune. 
-- @param delete boolean: Est-ce que les informations doivent être supprimées?
-- @param isCCG boolean: Le joueur est-il CCG ? Les variables "classifications" "Kagune" et "rerolls" ne sont pas les mêmes.
function sendEditedInformations(steamID, RC, rerolls, Kagune, type, delete, isCCG)
	local sendTable = {}
	table.insert(sendTable, steamID)
	if not delete then
		table.insert(sendTable, RC)
		table.insert(sendTable, rerolls)
		table.insert(sendTable, Kagune)
		if type != nil then
			table.insert(sendTable, type)
		end
	else
		table.insert(sendTable, rerolls)
	end
	net.Start("TKGOsaka_MenuChange")
		net.WriteTable(sendTable)
		net.WriteBool(isCCG)
	net.SendToServer()
end

--- Fonction permettant de créer une liste avec un nombre de ligne défini
-- @param Dataview Voir WikiGMOD.
-- @param listview Voir WikiGMOD.
-- @param steamid String du joueur si on doit montrer les infos d'un seul joueur en particulier.
-- @param isCCG Boolean qui permet une manipulation différente en fonction du menu choisi (goule ou CCG)
function listViewCreate(Dataview, listview, steamid, isCCG)
	listview:Clear()
	maxNumber = #Dataview
	if #Dataview > 28 then
		maxNumber = 28
	end

	if steamid == nil then
		if #Dataview > 0 then
			for k=1,maxNumber,1 do
				if isCCG then
					listview:AddLine(Dataview[k]["SteamID64"], Dataview[k]["RCQuinque"], Dataview[k]["Numeroquinque"], Dataview[k]["Nom"], Dataview[k]["Type"])
				else
					listview:AddLine(Dataview[k]["SteamID64"], Dataview[k]["RC"], Dataview[k]["Rerolls"], Dataview[k]["Kagune"])
				end
				
			end
		end
	else
		//Recherche par steamID -> recréation de la listview avec seulement le texte entré alias le steamID.
		for k, v in pairs(Dataview) do
			if Dataview[k]["SteamID64"] == steamid then
				if isCCG then
					listview:AddLine(Dataview[k]["SteamID64"], Dataview[k]["RCQuinque"], Dataview[k]["Numeroquinque"], Dataview[k]["Nom"], Dataview[k]["Type"])
				else
					listview:AddLine(Dataview[k]["SteamID64"], Dataview[k]["RC"], Dataview[k]["Rerolls"], Dataview[k]["Kagune"])
					break
				end
			end
		end
	end
	
end