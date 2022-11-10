SWEP.PrintName = "Kagune Rinkaku1" -- The name of the weapon
SWEP.Category = "Tokyo Ghoul RP - Goule" --This is required or else your weapon will be placed under "Other"
SWEP.Author = "Starnix"
SWEP.Purpose = "Kagune mêlée puissant"
SWEP.Instructions = "Passif: régénération, Clic Gauche: poings, Clic droit: attaque puissante, Ultime: Régénération."
SWEP.WorldModel = "models/player/rinkaku/rinkaku.mdl"
SWEP.ViewModel = "models/weapons/c_arms.mdl"

SWEP.Slot = 3
SWEP.SlotPos = 40
SWEP.Base = "weapon_fists"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.DoDrawCrosshair = true
SWEP.ViewModelFOV = 54
SWEP.UseHands = true
SWEP.m_WeaponDeploySpeed = configKagune_Rinkaku["cd_Rinkaku_deploy"]
SWEP.HitDistance = configKagune_Rinkaku["Rinkaku_hitDistance"]
SWEP.DrawAmmo = false

SWEP.Primary.Delay = configKagune_Rinkaku["cd_Rinkaku_PRM"]
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "None"

SWEP.Secondary.Delay = configKagune_Rinkaku["cd_Rinkaku_SCR"]
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "None"

game.AddParticles( "particles/tkg_bloodeffect.pcf" )
PrecacheParticleSystem( "blood_REE" )


function SWEP:Initialize()
	self:SetHoldType( configKagune_Rinkaku["Rinkaku_holdtype"] )
end

function SWEP:Deploy()
	self.Owner:GetViewModel():SendViewModelMatchingSequence(self.Owner:GetViewModel():LookupSequence("fists_draw"))
	--Cooldowns des attaques
	self:SetNextPrimaryFire(CurTime() + configKagune_Rinkaku["cd_Rinkaku_deploy"])
    self:SetNextSecondaryFire(CurTime() + configKagune_Rinkaku["cd_Rinkaku_deploy"])
end

function SWEP:PrimaryAttack()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:GetViewModel():SendViewModelMatchingSequence(self.Owner:GetViewModel():LookupSequence("fists_left"))
	self:SetNextPrimaryFire(CurTime() + configKagune_Rinkaku["cd_Rinkaku_PRM"])
	local jumpcharge = self.Owner:GetNWInt("TKGOsaka_jumpcharge") --Stock le nombre de sauts du joueur. La limite est dans la config.

	if self.Owner:IsOnGround() && jumpcharge != 0 then --Partie du saut sur le mur.
		self.Owner:PrintMessage(HUD_PRINTCENTER, "JUMP >> Réinitialisation")
		self.Owner:SetNWInt("TKGOsaka_jumpcharge", 0)
	end

	local randomNumber = math.random( 1, configKagune_Rinkaku["Rinkaku_maxchance"] )
	if randomNumber == 1 then
		local health = configKagune_Rinkaku["Rinkaku_passive"]*self.Owner:GetMaxHealth()
		self.Owner:SetHealth(self.Owner:Health()+health)
		self.Owner:EmitSound( "physics/flesh/flesh_bloody_impact_hard1.wav" )
		if CLIENT then
			notification.AddLegacy( "Rinkaku -> Passif: +"..health.."PV.", NOTIFY_GENERIC, 2 )
		end
		
	end
	

	local traceline = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * configKagune_Rinkaku["Rinkaku_hitDistance"],
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )
		traceline = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )

	if ( SERVER && IsValid( traceline.Entity ) && ( traceline.Entity:IsNPC() || traceline.Entity:IsPlayer() || traceline.Entity:Health() > 0 ) ) then
		self.Owner:EmitSound("WeaponFrag.Throw")
		if SERVER && traceline.Entity:IsPlayer() then
			self.Owner:SetNWFloat("TKGOsaka_timeult", self.Owner:GetNWFloat("TKGOsaka_timeult")+0.05)
			if self.Owner:GetNWFloat("TKGOsaka_timeult") < configKagune_Rinkaku["cd_Rinkaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[RINKAKU] Vous êtes à ".. string.format("%.2f",self.Owner:GetNWFloat("TKGOsaka_timeult")/configKagune_Rinkaku["cd_Rinkaku_ULT"]*100) .. "% de pouvoir utiliser votre R")
			elseif self.Owner:GetNWFloat("TKGOsaka_timeult") == configKagune_Rinkaku["cd_Rinkaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[RINKAKU] Vous pouvez utiliser votre R!")
			end
		end
		local infodamage = DamageInfo()
		local attacker = self.Owner
		infodamage:SetAttacker( attacker )
		infodamage:SetInflictor( self )
		/*Pour avoir un nombre décimal aléatoire, on multiplie par 100 les limites afin d'avoir un nombre entier. On divise le résultat du random par 100 pour retrouver notre nombre décimal.
		Oui, le math.random ne prend pas en compte les décimaux...*/
		local random = math.random(configKagune_Rinkaku["dmg_Rinkaku_PRM_min"]*100, configKagune_Rinkaku["dmg_Rinkaku_PRM_max"]*100)
		local damage = (random/100) * self.Owner:GetNWInt("RCNumber")
		infodamage:SetDamage(damage)
		infodamage:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 )
		traceline.Entity:TakeDamageInfo( infodamage )
	elseif traceline.Entity:IsWorld() then
		local walltraceline = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 10,
			filter = self.Owner,
			mask = MASK_SHOT_HULL
		} )
		walltraceline = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 10,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
		if !(walltraceline.Entity:IsWorld()) then return end
		if jumpcharge < charge_walljump then
			self.Owner:SetNWInt("TKGOsaka_jumpcharge", jumpcharge + 1)
			self.Owner:SetVelocity((self.Owner:GetPos():GetNormal() + Vector(1,1,1)) + vector_up * 500)
			self.Owner:PrintMessage(HUD_PRINTCENTER, "JUMP >> " .. jumpcharge .. "/2")
		end
	end

end

function SWEP:SecondaryAttack()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:GetViewModel():SendViewModelMatchingSequence(self.Owner:GetViewModel():LookupSequence("fists_right"))
	self:SetNextSecondaryFire(CurTime() + 1)
	local traceline = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * configKagune_Rinkaku["Rinkaku_hitDistance"],
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )
	

	if ( SERVER && IsValid( traceline.Entity ) && ( traceline.Entity:IsNPC() || traceline.Entity:IsPlayer() || traceline.Entity:Health() > 0 ) ) then

		if SERVER && traceline.Entity:IsPlayer() then
			self.Owner:SetNWFloat("TKGOsaka_timeult", self.Owner:GetNWFloat("TKGOsaka_timeult")+0.1)
			if self.Owner:GetNWFloat("TKGOsaka_timeult") < configKagune_Rinkaku["cd_Rinkaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[RINKAKU] Vous êtes à ".. string.format("%.2f",self.Owner:GetNWFloat("TKGOsaka_timeult")/configKagune_Rinkaku["cd_Rinkaku_ULT"]*100) .. "% de pouvoir utiliser votre R")
			elseif self.Owner:GetNWFloat("TKGOsaka_timeult") == configKagune_Rinkaku["cd_Rinkaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[RINKAKU] Vous pouvez utiliser votre R!")
			end
			traceline.Entity:EmitSound( "physics/flesh/flesh_squishy_impact_hard"..math.random(1, 4)..".wav" )
		end
		local infodamage = DamageInfo()
		local attacker = self.Owner
		infodamage:SetAttacker( attacker )
		infodamage:SetInflictor( self )
		/*Pour avoir un nombre décimal aléatoire, on multiplie par 100 les limites afin d'avoir un nombre entier. On divise le résultat du random par 100 pour retrouver notre nombre décimal.
		Oui, le math.random ne prend pas en compte les décimaux...*/
		local random = math.random(configKagune_Rinkaku["dmg_Rinkaku_SCR_min"]*100, configKagune_Rinkaku["dmg_Rinkaku_SCR_max"]*100)
		local damage = (random/100) * self.Owner:GetNWInt("RCNumber")
		print("Damage:"..damage)
		print("RC:"..self.Owner:GetNWInt("RCNumber"))
		print("Random:"..random)
		infodamage:SetDamage(damage)
		infodamage:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 )
		traceline.Entity:TakeDamageInfo( infodamage )
		
	elseif ( CLIENT && IsValid( traceline.Entity ) && ( traceline.Entity:IsNPC() || traceline.Entity:IsPlayer() || traceline.Entity:Health() > 0 ) ) then
		if GetConVar( "tkg_particles" ):GetBool() then
			ParticleEffect( "blood_REE", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ) ) 
		end
	end

end

function SWEP:Reload()
	if self.Owner:GetNWFloat("TKGOsaka_timeult") < configKagune_Rinkaku["cd_Rinkaku_ULT"] then return end
	self.Owner:SetNWFloat("TKGOsaka_timeult",0)
	local health = configKagune_Rinkaku["Rinkaku_ult"]*self.Owner:GetMaxHealth()
	self.Owner:SetHealth(self.Owner:Health()+health)
	notification.AddLegacy( "Rinkaku -> Régénération: "..health.."PV.", NOTIFY_GENERIC, 2 )
	self.Owner:EmitSound( "physics/flesh/flesh_bloody_impact_hard1.wav" )
end