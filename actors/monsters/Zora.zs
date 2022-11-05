class Zora : ZeldaMonster
{
	Default
	{
		Health 2;
		Speed 0;
		Scale 3;
        ZeldaMonster.DropGroup "D";
        +MISSILEMORE
        +MISSILEEVENMORE
	}

	States
    {
        Spawn:
            ZORA A 4 A_Look;
            Loop;
        See:
            TNT1 A 0 { bShootable = false; bSolid = false; }
            ZORA BBCC 10 A_Chase;
            Loop;
        Melee:
        Missile:
            TNT1 A 0 { bShootable = true; bSolid = true; }
            ZORA A 15 A_FaceTarget;
            ZORA A 6 A_SpawnProjectile("ZeldaProjectile",20,0,0,0);
            ZORA A 15;
            Goto See;
	}
}
