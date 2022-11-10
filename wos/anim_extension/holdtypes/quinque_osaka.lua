local DATA = {}
DATA.Name = "quinque_osaka"
DATA.HoldType = "quinque_osaka"
DATA.BaseHoldType = "melee"
DATA.Translations = {} 

DATA.Translations[ ACT_MP_SWIM ] = {
	{ Sequence = "swimming_all", Weight = 1 },
}

DATA.Translations[ ACT_MP_WALK ] = {
	{ Sequence = "wos_bs_shared_sidewalk_lower", Weight = 1 },
}

DATA.Translations[ ACT_MP_STAND_IDLE ] = {
	{ Sequence = "phalanx_b_idle", Weight = 1 },
}

DATA.Translations[ ACT_MP_SPRINT ] = {
	{ Sequence = "phalanx_r_run", Weight = 1 },
}

DATA.Translations[ ACT_HL2MP_RUN_SUITCASE ] = {
	{ Sequence = "wos_phalanx_r_run", Weight = 1 },
}

DATA.Translations[ ACT_MP_RUN ] = {
	{ Sequence = "wos_phalanx_r_run", Weight = 1 },
}

DATA.Translations[ ACT_RUN_AIM_RELAXED ] = {
	{ Sequence = "wos_phalanx_r_run", Weight = 1 },
}

DATA.Translations[ ACT_RUN_AIM_STIMULATED ] = {
	{ Sequence = "wos_phalanx_r_run", Weight = 1 },
}

DATA.Translations[ ACT_RUN_AIM_AGITATED ] = {
	{ Sequence = "wos_phalanx_r_run", Weight = 1 },
}

DATA.Translations[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] = {
	{ Sequence = "wos_ryoku_r_c4_t2", Weight = 1 },
	{ Sequence = "ryoku_r_c2_t1", Weight = 1 },

}

DATA.Translations[ ACT_MP_CROUCH_IDLE ] = {
	{ Sequence = "wos_judge_h_s3_charge", Weight = 1 },
}

DATA.Translations[ ACT_MP_CROUCHWALK ] = {
	{ Sequence = "c_crouchwalkidle_knife", Weight = 1 },
}

DATA.Translations[ ACT_LAND ] = {
	{ Sequence = "wos_bs_shared_jump_land", Weight = 1 },
}
 
DATA.Translations[ ACT_MP_JUMP ] = {
	{ Sequence = "wos_judge_a_idle", Weight = 1 },
}

DATA.Translations[ ACT_MP_RELOAD_STAND ] = {
	{ Sequence = "dash_forward", Weight = 1 },
}

DATA.Translations[ ACT_MP_RELOAD_STAND ] = {
	{ Sequence = "wos_bs_shared_dash", Weight = 1 },
}



wOS.AnimExtension:RegisterHoldtype( DATA )

