--- Gestion des cadavres
-- @author Hokai & Starnix
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module sv_eatcorpses

-- Hook utilisé afin de remplacer le ragdoll de mort par un corps stockant des informations comme les RC ou le kagune.
-- @author Hokai
hook.Add( "PlayerDeath", "OsakaTKG_RagdollDeath", function( victim, inflictor, attacker )
	if attacker != victim && !(attacker:IsWorld()) && attacker:IsPlayer() then 
		victim:GetRagdollEntity():Remove()
		local deathragdoll = ents.Create("prop_ragdoll")
		deathragdoll:SetModel(victim:GetModel())
		deathragdoll:SetPos(victim:GetPos())
		deathragdoll:SetNWInt("corpsoriginalplayer", victim:UniqueID() )
		deathragdoll:SetNWString("corpsplayerent", victim:SteamID())
		deathragdoll:SetAngles(victim:EyeAngles())
		deathragdoll:SetNWInt("RCNumber", victim:GetNWInt("RCNumber"))
		deathragdoll:SetNWInt("Kagune", (sql.QueryRow("SELECT Kagune from tkg_players WHERE SteamID64 = '".. victim:SteamID() .. "'"))["Kagune"])
		deathragdoll:SetNWString("corpsplayerkiller", attacker:SteamID()) 
		deathragdoll:Spawn()
	end
	
end)

--- Give de RC en mangeant le cadavre
-- @param ply Entity qui renvoit le joueur qui mange le cadavre.
function corpsmange( ply )
	local trace = ply:GetEyeTrace()
	if ply:KeyDown( IN_USE ) then
		if trace.HitPos:Distance(ply:GetShootPos()) <= 75 then
			if trace.Entity:GetClass() == "prop_ragdoll" then
				if ply.corpsentity != trace.Entity then
					ply.corpsentity = trace.Entity
					ply:SetNWInt("CorpsDelay", CurTime() + corpstimeeat )
				elseif ply:GetNWInt("CorpsDelay", 10 ) < CurTime() and ply.corpsentity == trace.Entity then
					ply:SetNWInt("CorpsDelay", 10 )
					ply.corpsentity = NULL
					if !isnumber(ccgRCLimit[team.GetName(ply:Team())]) then
						if trace.Entity:GetNWInt("corpsoriginalplayer", ply:UniqueID() ) == ply:UniqueID() then
							ply:PrintMessage(HUD_PRINTTALK, "Tu ne peux pas manger ton propre corps !")
						else
							local DataQuery = sql.QueryRow("SELECT * from tkg_players WHERE SteamID64 = '".. ply:SteamID() .. "'")
							ply:SetNWInt("RCNumber", ply:GetNWInt("RCNumber") + math.floor(trace.Entity:GetNWInt("RCNumber")/ rc_fromoriginplayer  ) + rc_corpseeat )
							sql.Query("UPDATE tkg_players SET RC ='".. ply:GetNWInt("RCNumber").."',Classification = '"..DataQuery["Classification"].."',Rerolls = '"..DataQuery["Rerolls"].."',Kagune = '"..DataQuery["Kagune"].."' WHERE SteamID64='"..ply:SteamID().."'")
							trace.Entity:Remove()
							--Fonction dans osakatkglogs.lua qui permet de logger ply1=> le nom du joueur qui mange le cadavre & ply2=> le nom du cadavre
							blogs_playereatragdoll(ply, trace.Entity:GetNWString("corpsplayerent"), trace.Entity:GetNWString("corpsplayerkiller"))
						end
					else
						if trace.Entity:GetNWInt("corpsoriginalplayer") == ply:UniqueID() then
							ply:PrintMessage(HUD_PRINTTALK, "Tu ne peux pas récupérer la poche RC de ton propre corps !")
						elseif IsValid(ccgRCLimit[team.GetName(trace.Entity:GetNWString("corpsplayerent"))]) and isnumber(ccgRCLimit[team.GetName(trace.Entity:GetNWString("corpsplayerent"):Team())]) then
							print(team.GetName(trace.Entity:GetNWString("corpsplayerent")) != nil)
							print(team.GetName(trace.Entity:GetNWString("corpsplayerent")) != "BOT")
							ply:PrintMessage(HUD_PRINTTALK, "Un CCG ne possède pas de poche RC !!")
						else
							local pocheRC = ents.Create("poche_rc")
							--pocheRC:SetModel(victim:GetModel())
							pocheRC:SetPos(trace.Entity:GetPos())
							pocheRC:SetNWInt("rcnumber", tonumber(trace.Entity:GetNWInt("RCNumber")))
							pocheRC:SetNWString("type", listeKagune[tostring(trace.Entity:GetNWInt("Kagune"))][1])
							pocheRC:SetNWBool("isOriginal", true)
							pocheRC:SetNWBool("bypasslimit", false)
							trace.Entity:Remove()
							pocheRC:Spawn()
						end
					end
				end
			end
		end
	end
	if ply:KeyReleased( IN_USE ) or  trace.HitPos:Distance(ply:GetShootPos()) > 75 or trace.Entity != ply.corpsentity then
		if ply.corpsentity != NULL then
			ply.corpsentity = NULL
			ply:SetNWInt("CorpsDelay", 10 )
		end
	end
end
hook.Add("SetupMove", "TKGOsaka_corpsmange",  corpsmange )