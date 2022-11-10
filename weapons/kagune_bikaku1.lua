SWEP.PrintName = "Kagune Bikaku1" -- The name of the weapon
SWEP.Category = "Tokyo Ghoul RP - Goule" --This is required or else your weapon will be placed under "Other"
SWEP.Author = "Starnix"
SWEP.Purpose = "Kagune mêlée à sorts de contrôles puissants"
SWEP.Instructions = "Passif: vitesse, Clic Gauche: poings, Clic droit: éjecter un joueur, Ultime: Repousser dans une zone."
SWEP.WorldModel = ("models/player/bikaku/bikaku.mdl")
SWEP.ViewModel = "models/weapons/c_arms.mdl"

SWEP.Slot = 3
SWEP.SlotPos = 40
SWEP.Base = "weapon_fists"
SWEP.Spawnable = true
SWEP.AdminOnly = true


SWEP.DoDrawCrosshair = true
SWEP.ViewModelFOV = 54
SWEP.UseHands = true
SWEP.m_WeaponDeploySpeed = configKagune_Bikaku["cd_Bikaku_deploy"]
SWEP.HitDistance = configKagune_Bikaku["bikaku_hitDistance"]
SWEP.DrawAmmo = false

SWEP.Primary.Delay = configKagune_Bikaku["cd_Bikaku_PRM"]
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "None"

SWEP.Secondary.Delay = configKagune_Bikaku["cd_Bikaku_SCR"]
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "None"
timereload = 0

function SWEP:Initialize()
	self:SetHoldType( configKagune_Bikaku["Bikaku_holdtype"] )
end

function SWEP:Deploy()
	self.Owner:GetViewModel():SendViewModelMatchingSequence(self.Owner:GetViewModel():LookupSequence("fists_draw"))
	self:SetNextPrimaryFire(CurTime() + configKagune_Bikaku["cd_Bikaku_deploy"])
    self:SetNextSecondaryFire(CurTime() + configKagune_Bikaku["cd_Bikaku_deploy"])
    self.Owner:SetNWFloat("TKGOsaka_timeult", 0)

end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + configKagune_Bikaku["cd_Bikaku_PRM"])
	local ply = self.Owner
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:GetViewModel():SendViewModelMatchingSequence(self.Owner:GetViewModel():LookupSequence("fists_left"))
	self:EmitSound("WeaponFrag.Throw")
	local jumpcharge = self.Owner:GetNWInt("TKGOsaka_jumpcharge")

	if self.Owner:IsOnGround() && jumpcharge != 0 then --Partie du saut sur le mur.
		self.Owner:PrintMessage(HUD_PRINTCENTER, "JUMP >> Réinitialisation")
		self.Owner:SetNWInt("TKGOsaka_jumpcharge", 0)
	end

	local traceline = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * configKagune_Bikaku["bikaku_hitDistance"],
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
		if SERVER then

			local HealthPercent = (self.Owner:Health()/self.Owner:GetMaxHealth())*100

			if HealthPercent > 15 then
				local randomNumber = math.random( 1, configKagune_Bikaku["bikaku_maxchance"] )
				if randomNumber == 1 then
					if ply:GetRunSpeed() >= configKagune_Bikaku["bikaku_maxpassive"] then return end
					self.Owner:PrintMessage(HUD_PRINTCENTER, "[BIKAKU] Vous avez reçu un boost de vitesse.")
					print("Speed augmentée ! "..ply:GetRunSpeed() .. "=> " .. ply:GetRunSpeed()+configKagune_Bikaku["bikaku_passive"])
					ply:SetRunSpeed(ply:GetRunSpeed()+configKagune_Bikaku["bikaku_passive"])
				end
			end

			ply:SetNWFloat("TKGOsaka_timeult", self.Owner:GetNWFloat("TKGOsaka_timeult")+0.1)
			if self.Owner:GetNWFloat("TKGOsaka_timeult") < configKagune_Bikaku["cd_Bikaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[BIKAKU] Vous êtes à ".. string.format("%.2f",self.Owner:GetNWFloat("TKGOsaka_timeult")/configKagune_Bikaku["cd_Bikaku_ULT"]*100) .. "% de pouvoir utiliser votre R")
			elseif self.Owner:GetNWFloat("TKGOsaka_timeult") == configKagune_Bikaku["cd_Bikaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[BIKAKU] Vous pouvez utiliser votre R!")
			end
		end

		local infodamage = DamageInfo()
		local attacker = self.Owner
		infodamage:SetAttacker( attacker )
		infodamage:SetInflictor( self )
		--Pour avoir un nombre décimal aléatoire, on multiplie par 100 les limites afin d'avoir un nombre entier. On divise le résultat du random par 100 pour retrouver notre nombre décimal.
		--Oui, le math.random ne prend pas en compte les décimaux...
		local random = math.random(configKagune_Bikaku["dmg_Bikaku_PRM_min"]*100, configKagune_Bikaku["dmg_Bikaku_SCR_min"]*100)
		local damage = (random/100) * ply:GetNWInt("RCNumber")
		print("Damage:"..damage)
		print("RC:"..ply:GetNWInt("RCNumber"))
		print("Random:"..random)
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
		print("OKE MEC")
		if jumpcharge < charge_walljump then --Partie du saut sur le mur.
			self.Owner:SetNWInt("TKGOsaka_jumpcharge", jumpcharge + 1)
			self.Owner:SetVelocity((self.Owner:GetPos():GetNormal() + Vector(1,1,1)) + vector_up * 500)
			self.Owner:PrintMessage(HUD_PRINTCENTER, "JUMP >> " .. jumpcharge .. "/2")
		end
	end

end

function SWEP:SecondaryAttack()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:GetViewModel():SendViewModelMatchingSequence(self.Owner:GetViewModel():LookupSequence("fists_right"))
	//self:EmitSound(soundbikaku[math.random(#soundbikaku)]))
	self:SetNextSecondaryFire(CurTime() + 1)
	local ply = self.Owner

	local traceline = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * configKagune_Bikaku["bikaku_hitDistance"],
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( SERVER && IsValid( traceline.Entity ) && ( traceline.Entity:IsNPC() || traceline.Entity:IsPlayer() || traceline.Entity:Health() > 0 ) ) then
		if SERVER && traceline.Entity:IsPlayer() then
			ply:SetNWFloat("TKGOsaka_timeult", self.Owner:GetNWFloat("TKGOsaka_timeult")+0.1)
			if self.Owner:GetNWFloat("TKGOsaka_timeult") < configKagune_Bikaku["cd_Bikaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[BIKAKU] Vous êtes à ".. string.format("%.2f",self.Owner:GetNWFloat("TKGOsaka_timeult")/configKagune_Bikaku["cd_Bikaku_ULT"]*100) .. "% de pouvoir utiliser votre R")
			elseif self.Owner:GetNWFloat("TKGOsaka_timeult") == configKagune_Bikaku["cd_Bikaku_ULT"] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, "[BIKAKU] Vous pouvez utiliser votre R!")
			end
		end
		//Son quand une personne est touchée
		local infodamage = DamageInfo()
		local attacker = self.Owner
		infodamage:SetAttacker( attacker )
		infodamage:SetInflictor( self )
		--Pour avoir un nombre décimal aléatoire, on multiplie par 100 les limites afin d'avoir un nombre entier. On divise le résultat du random par 100 pour retrouver notre nombre décimal.
		--Oui, le math.random ne prend pas en compte les décimaux...
		local random = math.random(configKagune_Bikaku["dmg_Bikaku_SCR_min"]*100, configKagune_Bikaku["dmg_Bikaku_SCR_max"]*100)
		local damage = (random/100) * ply:GetNWInt("RCNumber")
		infodamage:SetDamage(damage)
		infodamage:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 )
		traceline.Entity:TakeDamageInfo( infodamage )
		traceline.Entity:SetVelocity((traceline.Entity:GetPos():GetNormal() *500) + vector_up * 500)
		
	else
		--Son quand aucune personne n'est touchée
	end

end

function SWEP:Reload()
	if self.Owner:GetNWFloat("TKGOsaka_timeult") < configKagune_Bikaku["cd_Bikaku_ULT"] then return end
	self.Owner:SetNWFloat("TKGOsaka_timeult",0)

	for k, v in pairs(ents.FindInSphere(self.Owner:GetPos(), 180)) do
		local valid = false

		if v:IsPlayer() or v:IsNPC() then
			if v != self.Owner then 
				pos = (v:GetPos() - self.Owner:GetPos() + (vector_up * 35))
				v:SetVelocity(pos * Vector(5, 5, 8))
				valid = true
			end
		else
			if IsValid(v:GetPhysicsObject()) then 
				v:GetPhysicsObject():SetVelocity(((v:GetPos() - self.Owner:GetPos()):GetNormal() * Vector(500, 500, 500))) 
				valid = true
			end
		end
	end	

end