--- Initialisation des resources serveur dans un seul fichier séparé.
-- @author Starnix
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module sv_resources

-- Importation des ressources nécessaires pour le serveur.
include( "gmodadminsuite/modules/logging/modules/osakatkglogs.lua" )
resource.AddFile("materials/tkg_osaka/eat_frame_bar_1.png")
resource.AddFile("materials/tkg_osaka/eat_frame_time.png")
resource.AddFile("materials/tkg_osaka/eat_frame_bar.png")
resource.AddFile("materials/tkg_osaka/bikaku_icon.png")
resource.AddFile("materials/tkg_osaka/koukaku_icon.png")
resource.AddFile("materials/tkg_osaka/rinkaku_icon.png")
resource.AddFile("materials/tkg_osaka/exit_menu_1.png")
resource.AddFile("materials/tkg_osaka/exit_menu_2.png")
resource.AddFile("materials/tkg_osaka/bouton_tkg_1.png")
resource.AddFile("materials/tkg_osaka/bouton_tkg_2.png")
resource.AddFile("materials/tkg_osaka/osaka_menu_goule_background_3.png")
resource.AddFile("materials/icon64/reveilosaka.png")
resource.AddFile("materials/tkg_osaka/duel_popup/duel_bar.png")
resource.AddFile("materials/tkg_osaka/duel_popup/accept.png")
resource.AddFile("materials/tkg_osaka/duel_popup/cancel.png")
resource.AddFile("materials/tkg_osaka/duel_popup/duel_barinfo.png")
resource.AddFile("materials/tkg_osaka/icon_duel.png")
resource.AddFile("materials/tkg_osaka/weapon_hud/quinque_icon.png")

resource.AddFile("materials/tkg_osaka/quinque_slot_hovered.png")
resource.AddFile("materials/tkg_osaka/quinque_slot.png")
resource.AddFile("materials/tkg_osaka/osaka_menu_quinque_background_1.png")

resource.AddFile("materials/tkg_osaka/tkg_menu/close_button_V2.png")
resource.AddFile("materials/tkg_osaka/tkg_menu/home_button_V2.png")
resource.AddFile("materials/tkg_osaka/tkg_menu/menu_base_V2.png")
resource.AddFile("materials/tkg_osaka/tkg_menu/menu_para.png")

resource.AddFile("sound/osaka_sound_tkg/osaka_exit.mp3")
resource.AddFile("sound/osaka_sound_tkg/osaka_select.mp3")
resource.AddFile("sound/osaka_sound_tkg/osaka_souris.mp3")


-- Polices d'écriture
resource.AddFile("ressource/osaka_fonts/font_tkg.ttf")
resource.AddFile("ressource/osaka_fonts/montserrat-bold.ttf")
resource.AddFile("ressource/osaka_fonts/montserrat-light.ttf")
resource.AddFile("ressource/osaka_fonts/montserrat-regular.ttf")
resource.AddFile("ressource/osaka_fonts/rajdhani.ttf")
resource.AddFile("ressource/osaka_fonts/rajdhani_bold.ttf")

-- Préparation des net utilisés.
util.AddNetworkString("TKGOsaka_Menu")
util.AddNetworkString("TKGOsaka_MenuCreate")
util.AddNetworkString("TKGOsaka_Reroll")
util.AddNetworkString("TKGOsaka_MenuChange")
util.AddNetworkString("TKGOsaka_BarDrawText")
util.AddNetworkString("TKGOsaka_DuelRequest")
util.AddNetworkString("TKGOsaka_DuelAccepted")
util.AddNetworkString("TKGOsaka_OnDuel")
util.AddNetworkString("TKGOsaka_DuelEnd")
util.AddNetworkString("TKGOsaka_CCGWeaponsOpen")
util.AddNetworkString("TKGOsaka_QuinqueDMGSet")