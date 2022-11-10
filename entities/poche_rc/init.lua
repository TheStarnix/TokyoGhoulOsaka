AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
util.AddNetworkString("TKGOsaka_ConfigPochePanel")

function ENT:Use(activator)
	if self:GetNWBool("isOriginal") then return end
	if (activator:IsPlayer()) then 
		net.Start("TKGOsaka_ConfigPochePanel")
			net.WriteEntity(self)
		net.Send(activator)
	end
end

function ENT:Think()
	net.Receive("TKGOsaka_ConfigPochePanel", function()
		local typePoche = net.ReadString()
		local rcnumber = net.ReadUInt(16)
		local isbypass = net.ReadBool()
		if rcnumber <= 1000 then return end
		self:SetNWString("type",typePoche)
		self:SetNWInt("rcnumber",rcnumber)
		self:SetNWBool("bypasslimit", isbypass)
	end)
end
