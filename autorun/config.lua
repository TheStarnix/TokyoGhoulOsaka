--- Configuration de l'addon
-- @author Starnix & Hokai
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module config.lua

--Grades qui ont la permission de gérer les Kagune, joueurs, RC, etc...
adminRanks = {
	["superadmin"] = true,
	["admin"] = true,
}

configKagune_Bikaku = {
	["cd_Bikaku_PRM"] = 0.5,
	["cd_Bikaku_SCR"] = 10,
	["cd_Bikaku_ULT"] = 1,
	["cd_Bikaku_deploy"] = 3, --Cooldown avant d'utiliser le Bikaku
	["dmg_Bikaku_PRM_min"] = 0.05, --Dégâts minimaux par RC pour la 1e compétence
	["dmg_Bikaku_SCR_min"] = 0.2, --Dégâts minimaux par RC pour la 2e compétence
	["dmg_Bikaku_PRM_max"] = 0.1, --Dégâts max par RC pour la 1e compétence
	["dmg_Bikaku_SCR_max"] = 0.3, --Dégâts max par RC pour la 2e compétence
	["bikaku_hitDistance"] = 150, --Distance de frappe
	["bikaku_passive"] = 50, --Valeur ajoutée s'il tombe sur le passif du bikaku
	["bikaku_maxchance"] = 2, --Sur combien le joueur peut avoir une chance d'augmenter sa vitesse en faisant des clic gauches?
	["bikaku_maxpassive"] = 700, --Valeur maximale pour la vitesse
	["bikaku_moovespeed"] = 50, --Vitesse ajoutée quand la goule sort son kagune
	["Bikaku_ult"] = 0.25, --Dégâts de l'ult par RC
	["Bikaku_holdtype"] = "kagune_osaka" --Animations
}
configKagune_Rinkaku = {
	["cd_Rinkaku_PRM"] = 0.5,
	["cd_Rinkaku_SCR"] = 10,
	["cd_Rinkaku_ULT"] = 1,
	["cd_Rinkaku_deploy"] = 3, --Cooldown avant d'utiliser le Rinkaku
	["dmg_Rinkaku_PRM_min"] = 0.1, --Dégâts minimaux par RC pour la 1e compétence
	["dmg_Rinkaku_SCR_min"] = 0.3, --Dégâts minimaux par RC pour la 2e compétence
	["dmg_Rinkaku_PRM_max"] = 0.3, --Dégâts max par RC pour la 1e compétence
	["dmg_Rinkaku_SCR_max"] = 0.5, --Dégâts max par RC pour la 2e compétence
	["Rinkaku_hitDistance"] = 150, --Distance de frappe
	["Rinkaku_maxchance"] = 2, --Sur combien le joueur peut avoir une chance de se heal en faisant des clic gauches?
	["Rinkaku_passive"] = 0.05, --Pourcentage du heal en fonction des PV max
	["Rinkaku_moovespeed"] = 10, --Vitesse ajoutée quand la goule sort son kagune
	["Rinkaku_ult"] = 0.25, --Regen de la vie sur l'ult. -> viegagnée= ply:Health()+regenult*ply:GetMaxHealth()
	["Rinkaku_holdtype"] = "kagune_osaka" --Animations
}
configKagune_Koukaku = {
	["cd_Koukaku_PRM"] = 0.8,
	["cd_Koukaku_SCR"] = 10,
	["cd_Koukaku_ULT"] = 5,
	["cd_Koukaku_deploy"] = 3, --Cooldown avant d'utiliser le Koukaku
	["dmg_Koukaku_PRM_min"] = 0.3, --Dégâts minimaux par RC pour la 1e compétence
	["dmg_Koukaku_PRM_max"] = 0.5, --Dégâts max par RC pour la 1e compétence
	["Koukaku_SCR_maxshield"] = 0.15, --Pourcentage de shield en fonction de ses PV restants.
	["Koukaku_hitDistance"] = 150, --Distance de frappe
	["Koukaku_maxchance"] = 90, --Sur combien le joueur peut avoir une chance d'encaisser les dégâts en en recevant ?
	["Koukaku_passive"] = 0.10, --Combien de % des dégâts doivent être bloqués s'il réussit à avoir le passif ?
	["Koukaku_moovespeed"] = -10, --Vitesse ajoutée quand la goule sort son kagune
	["Koukaku_ult"] = 2, --Nombre de secondes de stun sur l'ult
	["Koukaku_holdtype"] = "kagune_osaka" --Animations
}
configKagune_Ukaku = {
	["cd_Ukaku_PRM"] = 0.5,
	["cd_Ukaku_SCR"] = 0.2,
	["cd_Ukaku_ULT"] = 1,
	["cd_Ukaku_deploy"] = 3, --Cooldown avant d'utiliser le Rinkaku
	["dmg_Ukaku_PRM_min"] = 0.025, --Dégâts minimaux par RC pour la 1e compétence
	["dmg_Ukaku_PRM_max"] = 0.75, --Dégâts max par RC pour la 1e compétence
	["dmg_Ukaku_SCR_min"] = 0.1, --Dégâts min par RC pour la 2e compétence
	["dmg_Ukaku_SCR_max"] = 0.25, --Dégâts max par RC pour la 2e compétence
	["Ukaku_PRM_hitDistance"] = 150, --Distance de frappe 1e compétence
	["Ukaku_SCR_hitDistance"] = 2000, --Distance de frappe 2e compétence
	["Ukaku_maxchance"] = 2, --Sur combien le joueur peut avoir une chance de faire plus de dégâts sur sa prochaine shard? 
	["Ukaku_passive"] = 1.10, --Pourcentage de dégâts sur la prochaine shard en fonction de ses PV restants.
	["Ukaku_moovespeed"] = 25, --Vitesse ajoutée quand la goule sort son kagune
	["Ukaku_numbermaxshards"] = 10, --Combien de shards max avant de recharger?
	["Ukaku_timemaxshards"] = 3, --Combien de temps dure le temps de recharge?
	["Ukaku_holdtype"] = "kagune_osaka" --Animations
}
configQuinque_Doublelames = {
	["cd_PRM"] = 0.5,
	["cd_SCR"] = 5,
	["cd_ULT"] = 0.25,
	["cd_deploy"] = 3, --Cooldown avant d'utiliser le Rinkaku
	["dmg_PRM_min"] = 0.025, --Dégâts minimaux par RC pour la 1e compétence
	["dmg_PRM_max"] = 0.75, --Dégâts max par RC pour la 1e compétence
	["dmg_SCR_min"] = 0.1, --Dégâts min par RC pour la 2e compétence
	["dmg_SCR_max"] = 0.25, --Dégâts max par RC pour la 2e compétence
	["PRM_hitDistance"] = 150, --Distance de frappe 1e compétence
	["SCR_hitDistance"] = 2000, --Distance de frappe 2e compétence
	["maxchance"] = 2, --Sur combien le joueur peut avoir une chance d'attaquer à la double lame? 
	["passive"] = 1.10, --Pourcentage de dégâts en plus sur le passif.
	["moovespeed"] = 25, --Vitesse ajoutée quand la goule sort son kagune
	["holdtype"] = "quinque_osaka", --Animations
	["time_guard"] = 1, --Combien de temps dure la parade
	["dash"] = 500, --Distance de dash (ulti)
	["dash_dmg"] = 0.5 --Dégâts du dash PAR RC.
 }

ccgRCLimit = {
	["Directeur du CCG"] = 15000,
	["Directeur Adjoint"] = 15000,
	["Légende du CCG"] = 9000,
	["Insp Spécial"] = 9000,
	["Inspecteur 1er classe"] = 8000,
	["Inspecteur 2ème classe"] = 6500,
	["Inspecteur 3ème classe"] = 5000,
	["Apprenti Inspecteur CCG"] = 4000,
	["Scientifique en chef CCG"] = 6500,
	["SCI Inspecteur 3e"] = 5000,
	["SCI Inspecteur 2e"] = 6500,
	["SCI Inspecteur 1e"] = 8000,
	["Quinx I Apprentie Insp"] = 5000,
	["Quinx I Inspecteur 3e"] = 5000,
	["Quinx I Inspecteur 2e"] = 6500,
	["Quinx I Inspecteur 1e"] = 8000,
}

charge_walljump = 3 --Combien de charges maximum lorsque le joueur tente de sauter sur le mur.
corpstimeeat = 2

limitrc = 45000

//Temps en seconde nécessaire pour manger un cadavre d'un joueur.
cd_Corpseseat = 2

//RC ajoutés aux joueurs s'il manque un cadavre
rc_corpseeat = 10
//Par combien sont divisés les RC gagnés en fonction des RC du cadavres
rc_fromoriginplayer = 200