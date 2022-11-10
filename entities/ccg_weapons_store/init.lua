AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()

	self:SetModel( "models/starnix/locker/locker_ccg.mdl" )

	-- Application de la physique
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Init physics only on server, so it doesn't mess up physgun beam
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end

	self:PhysWake()
	
end

--Ouverture du menu s'il fait E dessus.
function ENT:Use(activator)
	if (activator:IsPlayer()) then
		local SQLQuery = sql.Query("SELECT * from tkg_ccglist WHERE SteamID64 = '".. activator:SteamID() .. "'")
		net.Start("TKGOsaka_CCGWeaponsOpen")
			if SQLQuery != nil then
				net.WriteTable(SQLQuery)
			end
		net.Send(activator)
	end
end

--Give du swep demandé. 
net.Receive("TKGOsaka_CCGWeaponsOpen", function(len, ply)
	local slotSelected = net.ReadUInt(5)
	local SQLQuery = sql.Query("SELECT * from tkg_ccglist WHERE SteamID64 = '".. ply:SteamID() .. "' AND Numeroquinque = '" .. slotSelected .."'")
	local Quinque = listeQuinquesSweps[SQLQuery[1]["Type"]] or nil
	if Quinque != nil then
		ply:Give(Quinque)
	end
end)