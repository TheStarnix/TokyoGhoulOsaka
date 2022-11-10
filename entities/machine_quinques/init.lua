AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "imgui.lua" )

include('shared.lua')
util.AddNetworkString("TKGOsaka_QuinqueCreate")
util.AddNetworkString("TKGOsaka_QuinqueSlotsOpen")
util.AddNetworkString("TKGOsaka_QuinqueFabrication")

ENT.isLaunched = false
local selfEntity = self
local ownerPlayer = nil

function ENT:Initialize()

	selfEntity = self

	self:SetModel( "models/quinque_creator_osaka/hokai_tkg_osaka/quinque_creator_osaka_tkg_by_hokai.mdl" )

	-- Physics stuff
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Init physics only on server, so it doesn't mess up physgun beam
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
	
	-- Make prop to fall on spawn
	self:PhysWake()
	
end

function ENT:Touch(entity)

	if entity:IsPlayer() || entity:IsWorld() || entity:GetClass() != "poche_rc" || self.isLaunched == true then return end
	
	local typePoche = entity:GetNWString("type")
	local rcNumber = entity:GetNWInt("rcnumber")
	local bypassLimit = entity:GetNWBool("bypasslimit")
	
	if isstring(typePoche) && isnumber(rcNumber) && isbool(bypassLimit) && rcNumber >= 1000 then
		entity:Remove()
		self:EmitSound("weapons/aug/aug_clipin.wav")
		self:SetNWEntity("machine_link", entity)
		self:SetNWString("machine_link_string", typePoche)
		self:SetNWInt("machine_link_rcnumber", rcNumber)
		self:SetNWBool("machine_link_bypassLimit", bypasslimit)
		print("YAY")
		self.isLaunched = true
	end
	
end

function ENT:Use( ply )
	print(ccgRCLimit[team.GetName(ply:Team())])
	print(self:GetNWBool("bypasslimit"))
	print((self:GetNWInt("machine_link_rcnumber")+500))
	if !ply:IsPlayer() || !self.isLaunched then return end
	if !isnumber(ccgRCLimit[team.GetName(ply:Team())]) then
		ply:PrintMessage(HUD_PRINTCENTER, "Vous devez être un CCG pour paramétrer la quinque !")
		return
	end
	if !self:GetNWBool("bypasslimit") && ((self:GetNWInt("machine_link_rcnumber")-500) > ccgRCLimit[team.GetName(ply:Team())]) then
		ply:PrintMessage(HUD_PRINTCENTER, "Vous n'avez pas le grade requis pour avoir une quinque de ".. self:GetNWInt("machine_link_rcnumber").. " RC !")
		return
	else
		net.Start("TKGOsaka_QuinqueCreate")
		net.Send(ply)
		ownerPlayer = ply
	end

end

hook.Add( "PlayerDisconnected", "TKGOsaka_quinqueleave", function(ply)
    if ply == ownerPlayer then
    	selfEntity.isLaunched = false
    end
end )

net.Receive("TKGOsaka_QuinqueSlotsOpen", function(len, ply)
	local slot = net.ReadUInt(5)
	local randomNumber = math.random(1,4)
	if selfEntity:GetNWString("machine_link_string") == "Ukaku" then
		selfEntity:SetNWString("machine_link_string", "Distante")
		-- Lorsqu'il y aura plusieurs quinques distantes: selfEntity:SetNWString("machine_link_string", rerollsQuinques[tostring(randomNumber)][1]))
	elseif selfEntity:GetNWString("machine_link_string") == "Bikaku" || selfEntity:GetNWString("machine_link_string") == "Rinkaku" || selfEntity:GetNWString("machine_link_string") == "Koukaku" then
		if randomNumber == 3 then randomNumber = 2 end
		selfEntity:SetNWString("machine_link_string", rerollsQuinques[tostring(randomNumber)][1])
	end


	if slot > 10 then 
		ply:PrintMessage(HUD_PRINTTALK, "Le slot de votre quinque doit être <= à 10 !")
		return
	else
		if sql.QueryRow("SELECT * from tkg_ccglist WHERE SteamID64 = '".. ply:SteamID() .. "' AND Numeroquinque = '"..slot.."'") == nil then
			print("AA")
			sql.QueryRow("INSERT INTO tkg_ccglist (SteamID64, RCQuinque, Numeroquinque, Nom, Type, Model) VALUES ('"..ply:SteamID().."', '"..selfEntity:GetNWInt("machine_link_rcnumber").."', '"..slot.."', '"..selfEntity:GetNWString("machine_link_name").."', '"..selfEntity:GetNWString("machine_link_string").."','"..listeQuinques[tostring(randomNumber)][2].."')")
		else
			print("BB")
			sql.Query("UPDATE tkg_ccglist SET RCQuinque =".. selfEntity:GetNWInt("machine_link_rcnumber") ..",Nom = '"..selfEntity:GetNWString("machine_link_name").."', Type = '"..selfEntity:GetNWString("machine_link_string").."', Model = '"..listeQuinques[tostring(randomNumber)][2].."' WHERE SteamID64='"..ply:SteamID().."' AND Numeroquinque="..slot.."")
		end

	end
	selfEntity.isLaunched = false
	
end)

net.Receive("TKGOsaka_QuinqueCreate", function()
	local name = net.ReadString()
	selfEntity:SetNWString("machine_link_name", name)
	print("Name:"..selfEntity:GetNWString("machine_link_name"))
	selfEntity.isLaunched = true

	net.Start("TKGOsaka_QuinqueFabrication")
		net.WriteUInt(5, 4) --Timer
		net.WriteUInt(selfEntity:GetNWInt("machine_link_rcnumber"), 16) --RC
		net.WriteString(selfEntity:GetNWString("machine_link_string")) --Type
	net.Send(ownerPlayer)

	timer.Create( "TKGOsaka_QuinqueFabrication", 5, 1, function() 
		-- Couleur rouge -> verte du props à changer ICI.
		print("REUSSI !")
		
		local SQLQuery = sql.QueryRow("SELECT * from tkg_ccglist WHERE SteamID64 = '".. ownerPlayer:SteamID() .. "'")
		net.Start("TKGOsaka_QuinqueSlotsOpen")
			net.WriteString(selfEntity:GetNWString("machine_link_string"))
			net.WriteUInt(selfEntity:GetNWInt("machine_link_rcnumber"), 16)
			net.WriteBool(selfEntity:GetNWBool("machine_link_bypassLimit"))
			if SQLQuery != nil then
				net.WriteTable(SQLQuery)
			end
		net.Send(ownerPlayer)
	end)
end)