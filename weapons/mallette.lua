
SWEP.PrintName 		      = "Malette CCG"
SWEP.Category             = "Tokyo Ghoul RP - CCG"
SWEP.Author 		      = "Hokai" 
SWEP.Instructions 	      = "" 
 
SWEP.Slot					= 0
SWEP.SlotPos				= 4
SWEP.Spawnable				= true
SWEP.ViewModel				= Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel				= "models/hokai/quinques/malletteccg.mdl"
SWEP.ViewModelFOV			= 54
SWEP.UseHands				= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Force			= 10
SWEP.Primary.Delay			= 1,5
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 3		
SWEP.DrawAmmo				= false
SWEP.HitDistance			= 65

function SWEP:SetupDataTables() 
end

function SWEP:UpdateNextIdle()
	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() )
end

function SWEP:PrimaryAttack( right )
end

function SWEP:SecondaryAttack()
    self:SetNextSecondaryFire( CurTime() + 2.0 )
end

function SWEP:DealDamage()
end

function SWEP:OnDrop()
	self:Remove() -- You can't drop fists
end

function SWEP:Deploy()
end
