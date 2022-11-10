ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Poche RC"
ENT.Category 		= "TKG Le réveil d'Osaka"
ENT.Author = "Starnix"
ENT.Instructions = "Utilisez le menu contextuel (C) & faîtes clic droit sur la poche RC pour éditer celle-ci."

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Editable = true

ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true

function ENT:Initialize()

	self:SetModel( "models/quinque_creator_osaka/hokai_tkg_osaka/poche_rc_osaka.mdl" )

	-- Physics stuff
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Init physics only on server, so it doesn't mess up physgun beam
	if ( SERVER ) then self:PhysicsInit( SOLID_VPHYSICS ) end
	
	-- Make prop to fall on spawn
	self:PhysWake()
	
end