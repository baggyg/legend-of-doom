class Wallmaster : ZeldaMonster
{
    Default
    {
        Health 2;
        Damage 0;
        ZeldaMonster.DropGroup "C";
        Speed 2;
        Radius 15;
        Height 56;
        Monster;
		+SPECIAL
        +FLOAT
        // +NOCLIP
    }

    States
    {
        Spawn:
            WMAS A 1 A_Look;
            WMAS A 1 A_Wander;
            Loop;
        See:
            WMAS A 1 A_Chase;
            Loop;
	}

    override void Touch (Actor toucher)
	{
        if (toucher is "PlayerPawn" == false || level.IsFrozen())
        {
            return;
        }
        toucher.ACS_NamedExecute("TeleportToStart", 0);
	}
}
