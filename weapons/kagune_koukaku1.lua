SWEP.PrintName = "Kagune Koukaku1" -- The name of the weapon
SWEP.Category = "Tokyo Ghoul RP - Goule" --This is required or else your weapon will be placed under "Other"
SWEP.Author = "Starnix"
SWEP.Purpose = "Kagune mêlée tank"
SWEP.Instructions = "Passif: tank, Clic Gauche: poings lents, Clic droit: attaque puissante, Ultime: Mur bloquant les attaques de devant."
SWEP.WorldModel = "models/player/kagune_koukakou/koukakou.mdl"
SWEP.ViewModel = "models/weapons/c_arms.mdl"

SWEP.Slot = 3
SWEP.SlotPos = 40
SWEP.Base = "weapon_fists"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.DoDrawCrosshair = true
SWEP.ViewModelFOV = 54
SWEP.UseHands = true
SWEP.m_WeaponDeploySpeed = configKagune_Koukaku["cd_Koukaku_deploy"]
SWEP.HitDistance = configKagune_Koukaku["Koukaku_hitDistance"]
SWEP.DrawAmmo = false

SWEP.Primary.Delay = configKagune_Koukaku["cd_Koukaku_PRM"]
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "None"

SWEP.Secondary.Delay = configKagune_Koukaku["cd_Ukaku_SCR"]
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "None"

function SWEP:Initialize()
	self:SetHoldType( configKagune_Koukaku["Koukaku_holdtype"] )
end

function SWEP:Deploy()
	self.Owner:GetViewModel():SendViewModelMatchingSequence(self.Owner:GetViewModel():LookupSequence("fists_draw"))
	self:SetNextPrimaryFire(CurTime() + configKagune_Koukaku["cd_Koukaku_deploy"])
    self:SetNextSecondaryFire(CurTime() + configKagune_Koukaku["cd_Koukaku_deploy"])
end

function SWEP:PrimaryAttack()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:GetViewModel():SendViewModelMatchingSequence(self.Owner:GetViewModel():LookupSequence("fists_left"))
	self:SetNextPrimaryFire(CurTime() + configKagune_Koukaku["cd_Koukaku_PRM"])
	local jumpcharge = self.Owner:GetNWInt("TKGOsaka_jumpcharge")

	if self.Owner:IsOnGround() && jumpcharge != 0 then --Partie du saut sur le mur.
		self.Owner:PrintMessage(HUD_PRINTCENTER, "JUMP >> Réinitialisation")
		self.Owner:SetNWInt("TKGOsaka_jumpcharge", 0)
	end

	local traceline = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * configKagune_Koukaku["Koukaku_hitDistance"],
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
			self.Owner:SetNWFloat("TKGOsaka_timeult", self.Owner:GetNWFloat("TKGOsaka_timeult")+0.5)
			if self.Owner:GetNWFloat("TKGOsaka_timeult") < configKagune_Koukaku["cd_Koukaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[KOUKAKU] Vous êtes à ".. string.format("%.2f",self.Owner:GetNWFloat("TKGOsaka_timeult")/configKagune_Koukaku["cd_Koukaku_ULT"]*100) .. "% de pouvoir utiliser votre R")
			elseif self.Owner:GetNWFloat("TKGOsaka_timeult") == configKagune_Koukaku["cd_Koukaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[KOUKAKU] Vous pouvez utiliser votre R!")
			end
		end

		local infodamage = DamageInfo()
		local attacker = self.Owner
		infodamage:SetAttacker( attacker )
		infodamage:SetInflictor( self )
		/*Pour avoir un nombre décimal aléatoire, on multiplie par 100 les limites afin d'avoir un nombre entier. On divise le résultat du random par 100 pour retrouver notre nombre décimal.
		Oui, le math.random ne prend pas en compte les décimaux...*/
		local random = math.random(configKagune_Koukaku["dmg_Koukaku_PRM_min"]*100, configKagune_Koukaku["dmg_Koukaku_PRM_max"]*100)
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
		if jumpcharge < charge_walljump then --Partie du saut sur le mur.
			self.Owner:SetNWInt("TKGOsaka_jumpcharge", jumpcharge + 1)
			self.Owner:SetVelocity((self.Owner:GetPos():GetNormal() + Vector(1,1,1)) + vector_up * 500)
			self.Owner:PrintMessage(HUD_PRINTCENTER, "JUMP >> " .. jumpcharge .. "/2")
		end

	end

end

function SWEP:SecondaryAttack()
	self.Owner:EmitSound("physics/metal/sawblade_stick1.wav")
	if (SERVER) then
		self:SetNextSecondaryFire(CurTime() + configKagune_Koukaku["cd_Koukaku_SCR"])
		self.Owner:SetArmor(configKagune_Koukaku["Koukaku_SCR_maxshield"]*self.Owner:Health())
		self.Owner:PrintMessage(HUD_PRINTTALK, "Vous avez été shield de ".. (configKagune_Koukaku["Koukaku_SCR_maxshield"]*self.Owner:Health()) .. "PV !")
	end

end

function SWEP:Reload()
	if self.Owner:GetNWFloat("TKGOsaka_timeult") < configKagune_Koukaku["cd_Koukaku_ULT"] then return end
	self.Owner:SetNWFloat("TKGOsaka_timeult",0)

	local traceline = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * configKagune_Koukaku["Koukaku_hitDistance"],
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )
	if ( SERVER && IsValid( traceline.Entity ) && ( traceline.Entity:IsNPC() || traceline.Entity:IsPlayer() || traceline.Entity:Health() > 0 ) ) then
		traceline.Entity:Freeze(true)
		traceline.Entity:EmitSound("ambient/energy/zap"..math.random(5, 9)..".wav")
		traceline.Entity:PrintMessage(HUD_PRINTCENTER, "[Koukaku] Vous avez été freeze pendant ".. configKagune_Koukaku["Koukaku_ult"] .. "s !")
		self.Owner:PrintMessage(HUD_PRINTCENTER, "[Koukaku] Vous avez freeze la personne pendant ".. configKagune_Koukaku["Koukaku_ult"] .. "s !")
		timer.Create( "TKGOsaka_KoukakuStun", configKagune_Koukaku["Koukaku_ult"], 1, function()
			traceline.Entity:Freeze(false)
		end )
		
	end

end

-- Hook utilisé afin de passer outre un certain nombre de dégâts si le joueur possède un Koukaku.
hook.Add("EntityTakeDamage", "TKGOsaka_KoukakuTakeDmg", function(target, dmginfo)
	if !(target:IsPlayer()) or !(target:IsValid()) then return end
	if target:GetActiveWeapon():GetClass() != "kagune_koukaku1" then return end
	local randomNumber = math.random( 1, configKagune_Koukaku["Koukaku_maxchance"] )
	if randomNumber == 1 then
		damagetaken = dmginfo:GetDamage()
		percent = (dmginfo:GetDamage()*configKagune_Koukaku["Koukaku_passive"])
		dmginfo:SetDamage(damagetaken-percent)
	end
end)
