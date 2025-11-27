init()
{
    level.modifyplayerdamage = ::modifyplayerdamage;
    level.rebirth_active = false;
    level thread on_player_connect();
    level thread match_start_timer();

    if(level.gametype == "dmz")
    {
        iprintlnbold("^3PLUNDER 1-HOUR MODE ACTIVATED");
        setdvar("scr_dmz_timelimit","60");
        setdvar("zetaforce","1");
    }
    else if(getdvar("scr_br_gametype") == "rebirth")
    {
        iprintlnbold("^2REBIRTH RESURGENCE ACTIVATED");
        setdvar("scr_br_respawn_delay","0");
        setdvar("scr_br_respawntime","0");
        setdvar("scr_br_min_wave_time","0");
        setdvar("scr_br_numlives","999");
        setdvar("zetaforce","1");
        level thread delay_gas_1hour();
        level.rebirth_active = true;
    }
    else
    {
        iprintlnbold("^2Wyatt's God Mod LOADED");
    }
}

delay_gas_1hour()
{
    while(!isdefined(level.br_level) || !isdefined(level.br_level.br_circledelaytimes))
        wait 0.05;
    level.br_level.br_circledelaytimes[0] = 3600;
    level.br_level.br_circleclosetimes[0] = 3600;
    if(isdefined(level.br_level.teamLives))
    {
        level.br_level.teamLives[0] = 999999;
        level.br_level.teamLives[1] = 999999;
    }
    iprintlnbold("^2Gas delayed 1 hour | Infinite lives");
}

match_start_timer()
{
    wait 120;
    iprintlnbold("^5Wyatt's GSC Script");
}

on_player_connect()
{
    for(;;)
    {
        level waittill("connected",player);
        player thread no_recoil();
        player thread infinite_stims();
        player thread stim_boost();
        player thread watch_spawned();
        player thread down_messages();
        player thread kill_message(); // only "good kill" now
    }
}

infinite_stims()
{
    self endon("disconnect");
    for(;;)
    {
        wait 0.5;
        if(!self hasweapon("eq_stim")) continue;
        if(self getammocount("eq_stim") < 2)
        {
            self setweaponammoclip("eq_stim",2);
            self setweaponammostock("eq_stim",0);
            self iprintlnbold("^3Wyatt has spawned 2 stims for u :)");
        }
    }
}

no_recoil()
{
    self endon("disconnect");
    self waittill("spawned_player");
    self player_recoilscaleon(0);
}

kill_message()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("player_killed",victim);
        if(isdefined(victim) && victim != self)
            self iprintlnbold("^2good kill");
    }
}

watch_spawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("spawned_player");
        if(level.rebirth_active || level.gametype == "dmz")
            self givemaxammo("all");
    }
}

down_messages()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("player_downed",victim);
        if(isdefined(victim) && victim != self)
        {
            for(i=0;i<6;i++)
            {
                self iprintlnbold("^"+randomintrange(1,8)+"50XP");
                wait 0.15;
            }
        }
    }
}

stim_boost()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("force_regeneration");
        self iprintlnbold("^2Wyatt's stim boost applied");
        self setmovespeedscale(1.35);

        self iprintlnbold("^2Stim Boost: ^113s"); wait 1;
        self iprintlnbold("^2Stim Boost: ^112s"); wait 1;
        self iprintlnbold("^2Stim Boost: ^111s"); wait 1;
        self iprintlnbold("^2Stim Boost: ^110s"); wait 1;
        self iprintlnbold("^2Stim Boost: ^19s");  wait 1;
        self iprintlnbold("^2Stim Boost: ^18s");  wait 1;
        self iprintlnbold("^2Stim Boost: ^17s");  wait 1;
        self iprintlnbold("^3Stim Boost: ^36s");  wait 1;
        self iprintlnbold("^3Stim Boost: ^35s");  wait 1;
        self iprintlnbold("^3Stim Boost: ^34s");  wait 1;
        self iprintlnbold("^3Stim Boost: ^33s");  wait 1;
        self iprintlnbold("^3Stim Boost: ^32s");  wait 1;
        self iprintlnbold("^3Stim Boost: ^31s");  wait 1;

        self setmovespeedscale(1.2);
        self iprintlnbold("^3Stim fading... 1.2x speed");
    }
}

modifyplayerdamage(eInflictor,eAttacker,iDamage,iDFlags,sMeansOfDeath,sWeapon,vPoint,vDir,sHitLoc,psOffsetTime)
{
    weap = scripts\mp\utility\weapon::getweaponrootname(sWeapon);
    iDamage = scripts\mp\damage::gamemodemodifyplayerdamage(eInflictor,eAttacker,iDamage,iDFlags,sMeansOfDeath,sWeapon,vPoint,vDir,sHitLoc,psOffsetTime);

    if(weap=="iw8_sn_kilo98"||weap=="iw8_sn_t9quickscope"||weap=="iw8_sn_t9standard"||weap=="iw8_sn_t9accurate"||weap=="iw8_sn_golf28"||weap=="iw8_sn_alpha50"||weap=="iw8_sn_t9cannon"||weap=="s4_mr_kalpha98"||weap=="iw8_sn_hdromeo")
    {
        if(isdefined(eAttacker)&&isplayer(eAttacker)) eAttacker iprintlnbold("^1downed and killed in 1 shot");
        return 999;
    }

    if(weap=="s4_sm_mpapa40") return 25;
    if(weap=="s4_ar_hyankee44") return 19;
    if(weap=="iw8_ar_mike4") return 29;
    if(weap=="iw8_sn_t9precisionsemi") return 40;
    if(weap=="iw8_sm_mpapa5") return 35;
    if(weap=="s4_sm_stango5") return 22;
    if(weap=="iw8_sm_t9fastfire") return 7;
    if(weap=="iw8_sn_golf28") return 999;
    if(weap=="iw8_sm_secho") return 26;
    if(weap=="iw8_sm_uzulu") return 17;
    if(weap=="iw8_sm_t9capacity") return 27;
    if(weap=="iw8_sm_t9cqb") return 13;
    if(weap=="iw8_pi_t9semiauto") return 42;
    if(weap=="iw8_ar_t9fastfire") return 31;
    if(weap=="iw8_sm_t9accurate") return 24;

    return int(iDamage);
}
