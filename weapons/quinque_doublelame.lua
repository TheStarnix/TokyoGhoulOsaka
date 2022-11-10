-- Variables that are used on both client and server
SWEP.Category				= "Tokyo Ghoul RP - CCG" 
SWEP.Author				= "Starnix, Hokai & DefconGaming"
SWEP.Purpose				= "Quinque très forte en mêlée"
SWEP.Instructions				= ""
SWEP.PrintName				= "Quinque doublelames"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 4				-- Slot in the weapon selection menu
SWEP.SlotPos				= 21			-- Position in the slot
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.HoldType 				= configQuinque_Doublelames["holdtype"]		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/starnix/vm_quinques/quinquedoublelame_1.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/starnix/quinques/quinquedoublelame1.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= true
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Delay = configQuinque_Doublelames["cd_PRM"]
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "None"

SWEP.Secondary.Delay = configQuinque_Doublelames["cd_SCR"]
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "None"
SWEP.Secondary.IronFOV = 0

//Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-1.267, -15.895, -7.205)
SWEP.IronSightsAng = Vector(70, -27.234, 70)
SWEP.SightsPos = Vector(-1.267, -15.895, -7.205)
SWEP.SightsAng = Vector(70, -27.234, 70)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-25.577, 0, 0)


SWEP.Slash = 1
SWEP.NameForMultipleQuinques = "Doublelames"

local IRONSIGHT_TIME = 0.3
local selfEntity = self
local timerNextPRM = 0
local timerNextSCR = 0
local timerNextULT = 0

function SWEP:Think()

	if self.Owner:KeyReleased( IN_ATTACK2 ) || self.Owner:KeyReleased( IN_SPEED ) || !self.Owner:GetNWBool("TKGOsaka_GuardIsUp") then
		self:SetIronsights(false, self.Owner)
		if self.Owner:GetNWBool("TKGOsaka_GuardIsUp") then
			self.Owner:SetNWBool("TKGOsaka_GuardIsUp", false)
			if SERVER then
				self.Owner:GodDisable()
			end
		end
	end

	if self.Owner:KeyDown(IN_ATTACK2) || self.Owner:KeyDown(IN_SPEED) then
		self:IronSight()
	end
end


function SWEP:GetViewModelPosition(pos, ang)

	if (not self.IronSightsPos) then return pos, ang end

	local bIron = self.Weapon:GetNWBool("Ironsights")

	if (bIron != self.bLastIron) then
		self.bLastIron = bIron
		self.fIronTime = CurTime()

	end

	local fIronTime = self.fIronTime or 0

	if (not bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then
		return pos, ang
	end

	local Mul = 1.0

	if (fIronTime > CurTime() - IRONSIGHT_TIME) then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

		if not bIron then Mul = 1 - Mul end
	end

	local Offset	= self.IronSightsPos

	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 		self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 		self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), 	self.IronSightsAng.z * Mul)
	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
end

function SWEP:SetIronsights(b)
	self.Weapon:SetNWBool("Ironsights", b)
end

function SWEP:GetIronsights()
	return self.Weapon:GetNWBool("Ironsights")
end


function SWEP:Deploy()
	selfEntity = self

	self:SetIronsights(false, self.Owner)					-- Set the ironsight false
	self:SetHoldType(self.HoldType)
	
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )

	self.Weapon:SetNWBool("Reloading", false)
	
	if !self.Owner:IsNPC() and self.Owner != nil then 
		if self.ResetSights and self.Owner:GetViewModel() != nil then
			self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration() 
		end
	end
	self.Owner:SetNWInt("TKGOsaka_DLamesPassif", 0)

	if CLIENT then
		OsakaTKG.CarriedQuinques = OsakaTKG.CarriedQuinques or {}
		net.Start("TKGOsaka_QuinqueDMGSet")
			net.WriteBool(OsakaTKG.CarriedQuinques[self.NameForMultipleQuinques] != nil)
			net.WriteUInt(OsakaTKG.CarriedQuinques[self.NameForMultipleQuinques] or 0, 5)
		net.SendToServer()
	end
	
end

function SWEP:PrimaryAttack()
	print("TIMER:".. CurTime() - (timerNextPRM + configQuinque_Doublelames["cd_PRM"]))
	self:SetNextPrimaryFire(CurTime() + configQuinque_Doublelames["cd_PRM"])
	timerNextPRM = CurTime()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	local dLamesPassif = self.Owner:GetNWInt("TKGOsaka_DLamesPassif")
	self.Owner:SetNWInt("TKGOsaka_DLamesPassif", dLamesPassif+1)
	local vm = self.Owner:GetViewModel()
	if self.Slash == 1 then
			--if CLIENT then return end
			vm:SetSequence(vm:LookupSequence("midslash1"))
			self.Slash = 2
		else
			--if CLIENT then return end
			vm:SetSequence(vm:LookupSequence("midslash2"))
			self.Slash = 1
		end --if it looks stupid but works, it aint stupid!

	local traceline = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * configQuinque_Doublelames["PRM_hitDistance"],
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( SERVER && IsValid( traceline.Entity ) && ( traceline.Entity:IsNPC() || traceline.Entity:IsPlayer() || traceline.Entity:Health() > 0 ) ) then
		self.Owner:EmitSound("WeaponFrag.Throw")
		if SERVER && traceline.Entity:IsPlayer() then
			self.Owner:SetNWFloat("TKGOsaka_timeult", self.Owner:GetNWFloat("TKGOsaka_timeult")+0.05)
			if self.Owner:GetNWFloat("TKGOsaka_timeult") < configQuinque_Doublelames["cd_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[DLames] Vous êtes à ".. string.format("%.2f",self.Owner:GetNWFloat("TKGOsaka_timeult")/configQuinque_Doublelames["cd_ULT"]*100) .. "% de pouvoir utiliser votre R")
			elseif self.Owner:GetNWFloat("TKGOsaka_timeult") == configQuinque_Doublelames["cd_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[DLames] Vous pouvez utiliser votre R!")
			end
		end
		local infodamage = DamageInfo()
		local attacker = self.Owner
		infodamage:SetAttacker( attacker )
		infodamage:SetInflictor( self )
		--Pour avoir un nombre décimal aléatoire, on multiplie par 100 les limites afin d'avoir un nombre entier. On divise le résultat du random par 100 pour retrouver notre nombre décimal.
		--Oui, le math.random ne prend pas en compte les décimaux...
		local random = math.random(configQuinque_Doublelames["dmg_PRM_min"]*100, configQuinque_Doublelames["dmg_PRM_max"]*100)
		local damage = (random/100) * self.Owner:GetNWInt("TKGOsaka_QuinquesDMG")
		if dLamesPassif == 10 then
			infodamage:SetDamage(damage*configQuinque_Doublelames["passive"])
			notification.AddLegacy( "DLames -> Passif: +"..configQuinque_Doublelames["passive"].."dégâts.", NOTIFY_GENERIC, 2 )
		else
			infodamage:SetDamage(damage)
		end
		
		infodamage:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 )
		traceline.Entity:TakeDamageInfo( infodamage )
	end
	if dLamesPassif == 10 then
		if CLIENT then
			notification.AddLegacy( "DLames -> Passif: +"..configQuinque_Doublelames["passive"].."% de dégâts.", NOTIFY_GENERIC, 2 )
		end
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + configQuinque_Doublelames["cd_SCR"])
	--POUR RECUPERER LE TIMER: print(timerNextSCR + configQuinque_Doublelames["cd_SCR"] - CurTime())
	--Le print affichera le nombre de secondes (à mettre dans un think ou jsp quoi)
	timerNextSCR = CurTime()
	self.Owner:SetNWBool("TKGOsaka_GuardIsUp", true)
	self:IronSight()
	if SERVER then
		self.Owner:GodEnable()
	end
	timer.Simple(configQuinque_Doublelames["time_guard"], function()
		if self.Owner == nil || !self.Owner:GetNWBool("TKGOsaka_GuardIsUp") then return end
		self.Owner:SetNWBool("TKGOsaka_GuardIsUp", false)
		if SERVER then
			self.Owner:GodDisable()
		end
	end)
end

function SWEP:Reload()
	if self.Owner:GetNWFloat("TKGOsaka_timeult") < configQuinque_Doublelames["cd_ULT"] then return end
	timerNextULT = CurTime()
	local traceline = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * configQuinque_Doublelames["dash"],
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )
	if ( SERVER && IsValid( traceline.Entity ) && ( traceline.Entity:IsNPC() || traceline.Entity:IsPlayer() || traceline.Entity:Health() > 0 ) ) then
		self.Owner:SetSequence( "idle" )
		self.Owner:SetNWFloat("TKGOsaka_timeult",0)
		local infodamage = DamageInfo()
		local attacker = self.Owner
		infodamage:SetAttacker( attacker )
		infodamage:SetInflictor( self )
		local damage = configQuinque_Doublelames["dash_dmg"] * self.Owner:GetNWInt("TKGOsaka_QuinquesDMG")
		infodamage:SetDamage(damage)
		traceline.Entity:TakeDamageInfo( infodamage )
		if self.Owner:IsOnGround() then
			self.Owner:SetVelocity((self.Owner:GetPos():GetNormal() + Vector(1,1,1)) + self.Owner:GetForward() * (9000*(Vector( self.Owner:GetPos():GetNormal() ):Distance(traceline.Entity:GetForward()))) )
		else
			self.Owner:SetVelocity((self.Owner:GetPos():GetNormal() + Vector(1,1,1)) + self.Owner:GetForward() * (1500*(Vector( self.Owner:GetPos():GetNormal() ):Distance(traceline.Entity:GetForward())))) 
		end
	elseif SERVER then
		self.Owner:SetSequence( "idle" )
		self.Owner:SetNWFloat("TKGOsaka_timeult",0)
		if self.Owner:IsOnGround() then
			print("OK")
			print(self.Owner:GetPos():GetNormal())
			print((self.Owner:GetPos():GetNormal() + Vector(1,1,1)) + self.Owner:GetForward() * 700)
			print("___")
			self.Owner:SetVelocity((self.Owner:GetPos():GetNormal() + Vector(1,1,1)) + Vector(0,10,0) * (self.Owner:GetForward() * 500))
		else
			self.Owner:SetVelocity((self.Owner:GetPos():GetNormal() + Vector(1,1,1)) + Vector(0,1,0) * (self.Owner:GetForward() * 500))
		end
	end
end

function SWEP:Holster()
	
	if CLIENT and IsValid(self.Owner) and not self.Owner:IsNPC() then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			if (!vm:GetBoneCount()) then return end
			for i=0, vm:GetBoneCount() do
				vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
				vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
				vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
			end
		end
	end
	self.Owner:SetNWBool("GuardIsUp", false)
	return true
end

function SWEP:IronSight()
	if self.Owner:KeyDown(IN_ATTACK) then 
		self.Owner:SetFOV( 0, 0.3 )
		self.DrawCrosshair = true
		self:SetIronsights(false, self.Owner)
		self.SwayScale 	= 1.0
		self.BobScale 	= 1.0
		return
	end
	--Mains & épées légèrement en arrière -> animation lorsque le joueur cours.
	if self.Owner:KeyDown(IN_SPEED) and !self.Weapon:GetNWBool("Reloading") and !self.Owner:KeyDown(IN_ATTACK2) and !self.Owner:KeyDown(IN_ATTACK) then
		self.IronSightsPos = self.RunSightsPos
		self.IronSightsAng = self.RunSightsAng
		self:SetIronsights(true, self.Owner)
		self.Owner:SetFOV( 0, 0.3 )
	elseif self.Owner:KeyReleased (IN_SPEED) and !self.Owner:KeyDown(IN_ATTACK2) then	-- Animation où les mains & épées reviennent à leur place si le joueur ne cours plus.
		self:SetIronsights(false, self.Owner)
		self.Owner:SetFOV( 0, 0.3 )
	elseif self.Owner:GetNWBool("TKGOsaka_GuardIsUp", true) then 
		self.Owner:SetFOV( self.Secondary.IronFOV, 0.3 )
		self.IronSightsPos = self.SightsPos					-- Bring it up
		self.IronSightsAng = self.SightsAng					-- Bring it up
		self:SetIronsights(true, self.Owner)
		self.DrawCrosshair = false
		self.SwayScale 	= 0.05
		self.BobScale 	= 0.05
		-- Set the ironsight true
	elseif self.Owner:GetNWBool("TKGOsaka_GuardIsUp", false) then --Si le clic droit n'est plus utilisé
		self.Owner:SetFOV( 0, 0.3 )
		self.DrawCrosshair = true
		self:SetIronsights(false, self.Owner)
		self.SwayScale 	= 1.0
		self.BobScale 	= 1.0
	end
end

net.Receive("TKGOsaka_QuinqueDMGSet", function(len, ply)
	local hasValue = net.ReadBool()
	if hasValue then
		local slotNumber = net.ReadUInt(5)
		local SQLQuery = sql.QueryRow("SELECT RCQuinque from tkg_ccglist WHERE SteamID64 = '".. ply:SteamID() .. "' AND Numeroquinque = '"..slotNumber.."'")
		selfEntity.Owner:SetNWInt("TKGOsaka_QuinquesDMG", SQLQuery["RCQuinque"])
	else
		selfEntity.Owner:SetNWInt("TKGOsaka_QuinquesDMG", 0)
	end
end)