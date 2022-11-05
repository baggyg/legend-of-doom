class LynelBlue : Lynel
{
	Default
	{
		Health 6;
        ZeldaMonster.DropGroup "B";
        Translation "248:248=195:195", "179:179=203:203";
	}
}

class Lynel : ZeldaMonster
{
	Default
	{
		Health 4;
        DamageFunction(16);
        ZeldaMonster.DropGroup "D";
        Obituary "%o was killed by Lynel";
        Scale 3.5;
		Speed 8;
        +MISSILEMORE
	}

	States
	{
        Spawn:
            LYNL AB 10 A_Look;
            Loop;
        See:
            LYNL AABB 4 A_Chase;
            Loop;
        Melee:
            LYNL AB 8 A_FaceTarget;
            LYNL A 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            Goto See;
        Missile:
            LYNL AB 8 A_FaceTarget;
            LYNL B 6 A_SpawnProjectile("SwordProjectileTwo",32,0,0,0);
            LYNL AB 8;
            Goto See;
	}
}
