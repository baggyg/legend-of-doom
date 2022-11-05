class Stalfos : ZeldaMonster
{
	Default
	{
		Health 2;
		DamageFunction(4);
        ZeldaMonster.DropGroup "C";
        Scale 4;
		Obituary "%o was killed by Stalfos";
		Speed 10;
		+MISSILEMORE
	}

	States
	{
        Spawn:
            STAF AB 8 A_Look;
            Loop;
        See:
            STAF AABB 8 A_Chase;
            Loop;
        Melee:
            STAF AABB 8 A_FaceTarget;
            STAF A 4 A_CustomMeleeAttack(GetMissileDamage(0,1));
            STAF AABB 8;
            Goto See;
	}
}
