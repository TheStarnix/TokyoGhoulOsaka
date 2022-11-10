--- Fichier qui permet de stocker toutes les tables dans un endroit.
-- @author Starnix
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module sv_data

-- Table contenant la liste des Swep Kagunes. Utile pour check de façon optimisée si le joueur possède un Kagune.
pathKagune = {
	["kagune_bikaku1"] = true,
	["kagune_rinkaku1"] = true,
	["kagune_koukaku1"] = true,
	["kagune_ukaku1"] = true,
}

--- Liste de tous les Kagune.
listeKagune = {
	["1"] = {name="Bikaku", model="models/player/bikaku/bikaku.mdl", rerollable=true, swep_name="kagune_bikaku1"},
	["2"] = {name="Rinkaku", model="models/player/rinkaku/rinkaku.mdl", rerollable=true, swep_name="kagune_rinkaku1"},
	["3"] = {name="Koukaku", model="models/player/kagune_koukakou/koukakou.mdl", rerollable=true, swep_name="kagune_koukaku1"},
	["4"] = {name="Ukaku", model="models/player/ukaku.mdl", rerollable=true, swep_name="kagune_ukaku1"},
}

--- Liste des quinques.
listeQuinques = {
	["1"] = {name="Doublelames", model="models/starnix/vm_quinques/quinquedoublelame_1.mdl", rerollable=true, swep_name="quinque_doublelame"},
	["2"] = {name="Mêlée", model="models/player/ukaku.mdl", rerollable=true, swep_name="none"},
	["3"] = {name="Distante", model="models/player/ukaku.mdl", rerollable=true, swep_name="none"},
	["4"] = {name="Lourde", model="models/player/ukaku.mdl", rerollable=true, swep_name="none"},
}