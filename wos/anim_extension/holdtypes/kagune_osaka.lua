local DATA = {}
DATA.Name = "kagune_osaka"
DATA.HoldType = "kagune_osaka"
DATA.BaseHoldType = "fist"
DATA.Translations = {} 

DATA.Translations[ ACT_MP_SWIM ] = {
	{ Sequence = "swimming_all", Weight = 1 },
}

DATA.Translations[ ACT_MP_WALK ] = {
	{ Sequence = "wos_bs_shared_run_lower", Weight = 1 },
}

DATA.Translations[ ACT_MP_STAND_IDLE ] = {
	{ Sequence = "b_idle", Weight = 1 },
}

DATA.Translations[ ACT_MP_SPRINT ] = {
	{ Sequence = "phalanx_r_run", Weight = 1 },
}

DATA.Translations[ ACT_MP_RUN ] = {
	{ Sequence = "run_fist", Weight = 1 },
}

DATA.Translations[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] = {
	{ Sequence = "wos_ryoku_r_c4_t2", Weight = 1 },
	{ Sequence = "ryoku_r_c3_t1", Weight = 1 },
	{ Sequence = "ryoku_r_c3_t2", Weight = 1 },
	{ Sequence = "ryoku_r_c2_t2", Weight = 1 },

}

DATA.Translations[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = {
	{ Sequence = "wos_ryoku_r_c6_t1", Weight = 1 },
}

DATA.Translations[ ACT_MP_CROUCH_IDLE ] = {
	{ Sequence = "pose_ducking_01", Weight = 1 },
}

DATA.Translations[ ACT_MP_CROUCHWALK ] = {
	{ Sequence = "c_crouchwalkidle_knife", Weight = 1 },
}



DATA.Translations[ ACT_MP_JUMP ] = {
	{ Sequence = "h_jump", Weight = 1 },
}

wOS.AnimExtension:RegisterHoldtype( DATA )

