AddCSLuaFile()

game.AddParticles( "particles/tkg_bloodimpact.pcf" )
CreateClientConVar( "tkg_particles", "1", true, false, "1: afficher les particules onhit de l'addon. 0: cacher les particules.", 0,1)
CreateClientConVar( "tkg_duels", "1", true, true, "1: autoriser les duels. 0: interdire les duels.", 0,1)
PrecacheParticleSystem( "tkg_bloodimpact" )
OsakaTKG = OsakaTKG or {}

list.Set(
		"DesktopWindows", 
		"TKGOsaka_MenuContext",
		{
			title = "TKG Menu",
			icon = "icon64/reveilosaka.png",
			width = 960,
			height = 700,
			onewindow = true,
			init = function(icon, window)
				window:Remove()
				RunConsoleCommand("TKGOsaka_Menu")
			end
		}
)

--- Liste des quinques.
listeQuinques = {
	["1"] = {"Doublelames", "models/starnix/quinques/quinquedoublelame1.mdl"},
	["2"] = {"Mêlée", "models/player/ukaku.mdl"},
	["3"] = {"Distante", "models/player/ukaku.mdl"},
	["4"] = {"Lourde", "models/player/ukaku.mdl"},
}

--- Liste des rerolls Quinques.
rerollsQuinques = {
	["1"] = {"Doublelames", "models/starnix/quinques/quinquedoublelame1.mdl"},
	["2"] = {"Mêlée", "models/player/ukaku.mdl"},
	["3"] = {"Distante", "models/player/ukaku.mdl"},
	["4"] = {"Lourde", "models/player/ukaku.mdl"},
}

if CLIENT then
	OsakaTKG.CarriedQuinques = {}
end
