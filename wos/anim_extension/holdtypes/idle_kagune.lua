--=====================================================================
/*		My Custom Holdtype
			Created by Theo Hargreeves( STEAM_0:0:160055395 )*/
local DATA = {}
DATA.Name = "idle kagune"
DATA.HoldType = "wos-kagune-melee"
DATA.BaseHoldType = "fist"
DATA.Translations = {} 

DATA.Translations[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] = {
	{ Sequence = "zombie_attack_01", Weight = 1 },
	{ Sequence = "zombie_attack_02", Weight = 1 },
}

DATA.Translations[ ACT_MP_STAND_IDLE ] = {
	{ Sequence = "judge_idle_lower", Weight = 1 },
}

wOS.AnimExtension:RegisterHoldtype( DATA )
--=====================================================================
