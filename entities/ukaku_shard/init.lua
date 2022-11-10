AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Size = 0.25

function ENT:Initialize()

	local shardmodel = {"models/props_wasteland/rockcliff01c.mdl",
						"models/props_wasteland/rockcliff01e.mdl",
						"models/props_wasteland/rockcliff01g.mdl",
						"models/props_c17/FurnitureDrawer001a_Shard01.mdl"}
	
	self:SetModel(shardmodel[ math.random( #shardmodel ) ])
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	self:SetModelScale( 0.05, 0 )
	self:SetColor( Color( 100, 0, 50, 255 ) )
	self:SetSolid( SOLID_BBOX )
	self:DrawShadow( false )
	self.NotStuck = true
	
	self:SetCollisionBounds(Vector(-self.Size, -self.Size, -self.Size), Vector(self.Size, self.Size, self.Size))
	
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	self.RemoveShard = CurTime() + 0.2
end

function ENT:Think()
	if self.RemoveShard < CurTime() then self:Remove() end
	if self.NotStuck then self:SetAngles(self:GetVelocity():Angle()) end
	self:NextThink(CurTime()) return true
end

function ENT:PhysicsCollide( data, physobj )
	if data.HitEntity:IsWorld() then
		phys:Wake()  
		phys:EnableGravity(false)
		self:SetMoveType( MOVETYPE_NONE )
		self:PhysicsInit( SOLID_NONE )
	end
end



















