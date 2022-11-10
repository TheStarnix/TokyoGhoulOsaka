SWEP.PrintName = "Kagune Ukaku1" -- The name of the weapon
SWEP.Category = "Tokyo Ghoul RP - Goule" --This is required or else your weapon will be placed under "Other"
SWEP.Author = "Starnix"
SWEP.Purpose = "Kagune distant"
SWEP.Instructions = "Passif: augmentation dégâts du prochain fragment, Clic Gauche: poings, Clic droit: envoi de fragments cristallisés, Ultime: Même chose mais en mitraillant."
SWEP.WorldModel = "models/player/ukaku.mdl"
SWEP.ViewModel = "models/weapons/c_arms.mdl"

SWEP.Slot = 3
SWEP.SlotPos = 40
SWEP.Base = "weapon_fists"
SWEP.Spawnable = true
SWEP.AdminOnly = true


SWEP.DoDrawCrosshair = true
SWEP.ViewModelFOV = 54
SWEP.UseHands = true
SWEP.DrawAmmo = true

SWEP.Primary.Delay = configKagune_Ukaku["cd_Ukaku_PRM"]
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Fragments"

SWEP.Secondary.Delay = configKagune_Ukaku["cd_Ukaku_SCR"]
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "Rechargement"

function SWEP:Initialize()
	self:SetHoldType( configKagune_Ukaku["Ukaku_holdtype"] )
end

function SWEP:Deploy()
	self.Owner:GetViewModel():SendViewModelMatchingSequence(self.Owner:GetViewModel():LookupSequence("fists_draw"))
	self:SetNextPrimaryFire(CurTime() + configKagune_Ukaku["cd_Ukaku_deploy"])
    self:SetNextSecondaryFire(CurTime() + configKagune_Ukaku["cd_Ukaku_deploy"])
end

function SWEP:PrimaryAttack()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:GetViewModel():SendViewModelMatchingSequence(self.Owner:GetViewModel():LookupSequence("fists_left"))
	self:EmitSound("WeaponFrag.Throw")
	self:SetNextPrimaryFire(CurTime() + configKagune_Ukaku["cd_Ukaku_PRM"])
	local jumpcharge = self.Owner:GetNWInt("TKGOsaka_jumpcharge")

	if self.Owner:IsOnGround() && jumpcharge != 0 then --Partie du saut sur le mur.
		self.Owner:PrintMessage(HUD_PRINTCENTER, "JUMP >> Réinitialisation")
		self.Owner:SetNWInt("TKGOsaka_jumpcharge", 0)
	end
	
	local traceline = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * configKagune_Ukaku["Ukaku_PRM_hitDistance"],
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

		if SERVER && traceline.Entity:IsPlayer() then
			self.Owner:SetNWFloat("TKGOsaka_timeult", self.Owner:GetNWFloat("TKGOsaka_timeult")+0.5)
			if self.Owner:GetNWFloat("TKGOsaka_timeult") < configKagune_Ukaku["cd_Ukaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[UKAKU] Vous êtes à ".. string.format("%.2f",self.Owner:GetNWFloat("TKGOsaka_timeult")/configKagune_Ukaku["cd_Ukaku_ULT"]*100) .. "% de pouvoir utiliser votre R")
			elseif self.Owner:GetNWFloat("TKGOsaka_timeult") == configKagune_Ukaku["cd_Ukaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[UKAKU] Vous pouvez utiliser votre R!")
			end
		end

		local infodamage = DamageInfo()
		local attacker = self.Owner
		infodamage:SetAttacker( attacker )
		infodamage:SetInflictor( self )
		/*Pour avoir un nombre décimal aléatoire, on multiplie par 100 les limites afin d'avoir un nombre entier. On divise le résultat du random par 100 pour retrouver notre nombre décimal.
		Oui, le math.random ne prend pas en compte les décimaux...*/
		local random = math.random(configKagune_Ukaku["dmg_Ukaku_PRM_min"]*1000, configKagune_Ukaku["dmg_Ukaku_PRM_max"]*100)
		local damage = (random/1000) * self.Owner:GetNWInt("RCNumber")
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
	if self.Owner:GetNWInt("TKGOsaka_ukakushardtime") == configKagune_Ukaku["Ukaku_numbermaxshards"] then
		timer.Create("TKGOsaka_shardsreload", configKagune_Ukaku["Ukaku_timemaxshards"], 1, function() self.Owner:SetNWInt("TKGOsaka_ukakushardtime", 0) end)
		self:SetNextSecondaryFire(CurTime() + configKagune_Ukaku["Ukaku_timemaxshards"]+0.05)
		self.Owner:SetNWInt("TKGOsaka_timereload", CurTime())
		self.Owner:PrintMessage(HUD_PRINTCENTER, "[UKAKU] RECHARGEMENT EN COURS ! Temps:"..configKagune_Ukaku["Ukaku_timemaxshards"].." secondes.")
	else
		self.Owner:SetNWInt("TKGOsaka_ukakushardtime", self.Owner:GetNWInt("TKGOsaka_ukakushardtime")+1)
		self:SetNextSecondaryFire(CurTime() + configKagune_Ukaku["cd_Ukaku_SCR"])
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	local traceline = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * configKagune_Ukaku["Ukaku_SCR_hitDistance"],
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )
	local randomNumber = math.random( 1, configKagune_Ukaku["Ukaku_maxchance"] )
	local damage = (math.random(configKagune_Ukaku["dmg_Ukaku_SCR_min"]*1000, configKagune_Ukaku["dmg_Ukaku_SCR_max"]*1000)/1000) * self.Owner:GetNWInt("RCNumber")
	if ( SERVER && IsValid( traceline.Entity ) && ( traceline.Entity:IsNPC() || traceline.Entity:IsPlayer() || traceline.Entity:Health() > 0 ) ) then
		if SERVER && traceline.Entity:IsPlayer() then
			self.Owner:SetNWFloat("TKGOsaka_timeult", self.Owner:GetNWFloat("TKGOsaka_timeult")+0.5)
			if self.Owner:GetNWFloat("TKGOsaka_timeult") < configKagune_Ukaku["cd_Ukaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[UKAKU] Vous êtes à ".. string.format("%.2f",self.Owner:GetNWFloat("TKGOsaka_timeult")/configKagune_Ukaku["cd_Ukaku_ULT"]*100) .. "% de pouvoir utiliser votre R")
			elseif self.Owner:GetNWFloat("TKGOsaka_timeult") == configKagune_Ukaku["cd_Ukaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[UKAKU] Vous pouvez utiliser votre R!")
			end

			if randomNumber == 1 then
				damage = configKagune_Ukaku["Ukaku_passive"] * damage
			end

		end

		--Son quand une personne est touchée
		local infodamage = DamageInfo()
		local attacker = self.Owner
		infodamage:SetAttacker( attacker )
		infodamage:SetInflictor( self )
		/*Pour avoir un nombre décimal aléatoire, on multiplie par 100 les limites afin d'avoir un nombre entier. On divise le résultat du random par 100 pour retrouver notre nombre décimal.
		Oui, le math.random ne prend pas en compte les décimaux...*/
		infodamage:SetDamage(damage)
		infodamage:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 )
		traceline.Entity:TakeDamageInfo( infodamage )
		
	elseif ( CLIENT && IsValid( traceline.Entity ) && ( traceline.Entity:IsNPC() || traceline.Entity:IsPlayer() || traceline.Entity:Health() > 0 ) ) then
		if randomNumber == 1 then
			notification.AddLegacy( "[UKAKU] Passif: Dégâts augmentés pour cette shard", NOTIFY_GENERIC	, 2 )
		end
	end

	if (SERVER) then
		local Shard = ents.Create("ukaku_shard")
		local eAng = self.Owner:EyeAngles()
		Shard:SetPos(self.Owner:GetShootPos())
		Shard:SetOwner(self.Owner)
		Shard:SetAngles(eAng - Angle( 90, 0, 0 ))
		Shard:Spawn()
		Shard:SetVelocity(-Shard:GetUp()*Lerp(100/100, 200, 2000))
	end
	

end

function SWEP:Reload()
	--if self.Owner:GetNWFloat("TKGOsaka_timeult") < configKagune_Ukaku["cd_Ukaku_ULT"] then return end
	--self.Owner:SetNWFloat("TKGOsaka_timeult",0)
	if self.Owner:IsOnGround() then
		--self.Owner:SetVelocity((self.Owner:GetPos():GetNormal() + Vector(1,1,1)) + self.Owner:GetForward() * -2400)
		print( self.Owner:EyeAngles():Forward())
	else
		self.Owner:SetVelocity((self.Owner:GetPos():GetNormal() + Vector(1,1,1)) + self.Owner:GetForward() * -450)
	end
	
end