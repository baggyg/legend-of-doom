class LeeverBlue : Leever
{
    Default
    {
		Health 4;
		DamageFunction(8);
        ZeldaMonster.DropGroup "A";
		Translation "175:175=204:204", "248:248=195:195";
    }
}

class Leever : ZeldaMonster
{
    Default
    {
		Health 2;
		DamageFunction(4);
        ZeldaMonster.DropGroup "C";
		Obituary "%o was killed by a leever";
		Speed 8;
		Scale 3;
    }

    States
	{
        Spawn:
            LEEV E 1 A_Look;
            Loop;
        See:
            TNT1 A 0 { bShootable = false; bSolid = false; }
            LEEV EEDD 10 A_Chase;
            Loop;
        Melee:
        Missile:
            TNT1 A 0 { bShootable = true; bSolid = true; }
            LEEV AB 10 A_FaceTarget;
            LEEV AB 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            LEEV AB 10;
            Goto See;
	}
}
