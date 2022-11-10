--- Gestion des menus
-- @author Starnix
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module sv_menus

-- Fonction qui agit lorsqu'un joueur réalise un reroll.

local alreadyTimer = false

net.Receive("TKGOsaka_DuelRequest", function(len, ply)
	local plyTargeted = net.ReadEntity()
	if plyTargeted:GetInfoNum("tkg_duels", 1) == 0 then
		ply:PrintMessage(HUD_PRINTTALK, "Ce joueur n'accepte pas les duels !")
		return
	end
	local healthSet = net.ReadUInt(14)
	local armorSet = net.ReadUInt(14)
	alreadyTimer = false
	print("health:"..healthSet)
	print("armor:"..armorSet)
	if healthSet != 0 && armorSet != 0 && healthSet >= 1000 && healthSet <= 15000 && armorSet >= 100 && armorSet <= 2000 then
		--blogs_duelrequested(ply,ply2,healthSet,armorSet)
		net.Start("TKGOsaka_DuelRequest")
			net.WriteEntity(ply)
			net.WriteBool(true)
			net.WriteUInt(healthSet, 14)
			net.WriteUInt(armorSet, 14)
		net.Send(plyTargeted)
	elseif healthSet != 0 && armorSet != 0 then
		ply:PrintMessage(HUD_PRINTTALK, "Les valeurs d'armure doivent être 100>=ARMURE<=2000 & 1000>=HP<=15000.")
		print(tostring(healthSet)..","..tostring(armorSet)..","..tostring(plyTargeted))
	else
		net.Start("TKGOsaka_DuelRequest")
			net.WriteEntity(ply)
			net.WriteBool(false)
		net.Send(plyTargeted)
	end
			ply:PrintMessage(HUD_PRINTTALK, "Vous avez demandé en duel ".. plyTargeted:Nick())

	

end)

net.Receive("TKGOsaka_DuelAccepted", function(len,ply)
	local plyRequest = net.ReadEntity()
	local mode = net.ReadBool()
	local hp = net.ReadUInt(14)
	local armor = net.ReadUInt(14)
	plyRequest:SetNWInt("TKGOsaka_DuelHP", plyRequest:Health())
	plyRequest:SetNWInt("TKGOsaka_DuelArmor", plyRequest:Armor())
	ply:SetNWInt("TKGOsaka_DuelHP", ply:Health())
	ply:SetNWInt("TKGOsaka_DuelArmor", ply:Armor())
	if mode then
		blogs_duelrequested(plyRequest,ply,hp,armor)
		plyRequest:SetHealth(hp)
		ply:SetHealth(hp)
		plyRequest:SetArmor(armor)
		ply:SetArmor(armor)
	else
		blogs_duelrequested(plyRequest,ply,0,0)
	end
	plyRequest:SetNWEntity("TKGOsaka_DuelEnemy", ply)
	ply:SetNWEntity("TKGOsaka_DuelEnemy", plyRequest)
	net.Start("TKGOsaka_OnDuel")
		net.WriteEntity(plyRequest)
	net.Send(ply)
	net.Start("TKGOsaka_OnDuel")
		net.WriteEntity(ply)
	net.Send(plyRequest)
	
end)

net.Receive("TKGOsaka_DuelEnd", function(len, ply)
	print("Yup !")
	local playerToSend = net.ReadEntity()
	print("HP1:"..ply:GetNWInt("TKGOsaka_DuelHP"))
	print("ARMOR1:"..ply:GetNWInt("TKGOsaka_DuelArmor"))
	print("HP2:"..playerToSend:GetNWInt("TKGOsaka_DuelHP"))
	print("ARMOR2:"..playerToSend:GetNWInt("TKGOsaka_DuelArmor"))

	if alreadyTimer == false then
		getDefaults(ply, playerToSend)
	end
	
	alreadyTimer = true
	net.Start("TKGOsaka_DuelEnd")
	net.Send(playerToSend)
end)

hook.Add("EntityTakeDamage", "TKGOsaka_DuelDamage", function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()
	local attackerNW = attacker:GetNWEntity("TKGOsaka_DuelEnemy")
	local targetNW = target:GetNWEntity("TKGOsaka_DuelEnemy")
	if !(IsValid(attackerNW)) and !(IsValid(targetNW)) then return end
	if attacker:GetNWEntity("TKGOsaka_DuelEnemy") == target && target:GetNWEntity("TKGOsaka_DuelEnemy") == attacker then 
		if target:Health() - dmginfo:GetDamage() <= 0 then
			dmginfo:SetDamage(0)
			attacker:SetNWEntity("TKGOsaka_DuelEnemy", nil)
			target:SetNWEntity("TKGOsaka_DuelEnemy", nil)
			net.Start("TKGOsaka_DuelEnd")
			net.Send(attacker)
			net.Start("TKGOsaka_DuelEnd")
			net.Send(target)
			getDefaults(target, attacker)
			return true
		end
	else
		return true
	end
	
end)

function getDefaults(ply, playerToSend)
	ply:SetHealth(ply:GetNWInt("TKGOsaka_DuelHP"))
	playerToSend:SetHealth(playerToSend:GetNWInt("TKGOsaka_DuelHP"))
	ply:SetArmor(ply:GetNWInt("TKGOsaka_DuelArmor"))
	playerToSend:SetArmor(playerToSend:GetNWInt("TKGOsaka_DuelArmor"))

	ply:SetNWEntity("TKGOsaka_DuelEnemy", nil)
	playerToSend:SetNWEntity("TKGOsaka_DuelEnemy", nil)
	ply:SetNWEntity("TKGOsaka_DuelHP", nil)
	playerToSend:SetNWEntity("TKGOsaka_DuelHP", nil)
	ply:SetNWEntity("TKGOsaka_DuelArmor", nil)
	playerToSend:SetNWEntity("TKGOsaka_DuelArmor", nil)
end