class OctorockBlue : Octorock
{
	Default
	{
		Health 2;
        ZeldaMonster.DropGroup "B";
		Translation "175:175=203:203", "248:248=195:195";
	}
}

class Octorock : ZeldaMonster
{
	Default
	{
		Health 1;
		DamageFunction(4);
        ZeldaMonster.DropGroup "A";
		Speed 10;
		Scale 3.5;
		Obituary "%o was killed by an octorock";
	}
	States
	{
        Spawn:
            OCTO AB 10 A_Look;
            Loop;
        See:
            OCTO AABB 4 A_Chase;
            Loop;
        Melee:
            OCTO AB 8 A_FaceTarget;
            OCTO A 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            Goto See;
        Missile:
            OCTO AB 8 A_FaceTarget;
            OCTO B 6 A_SpawnProjectile("Octoball",20,0,0,0);
            Goto See;
	}
}

class Octoball : Actor
{
	Default
	{
		DamageFunction(4);
		Radius 6;
		Height 8;
		Speed 16;
		Projectile;
		Scale 1.5;
		+RANDOMIZE
		+ZDOOMTRANS
		+NOTIMEFREEZE
        +BLOODLESSIMPACT
		DamageType "Weak";
	}
	States
	{
	Spawn:
		OCTR ABCD 4 BRIGHT;
		Loop;
	}
}
