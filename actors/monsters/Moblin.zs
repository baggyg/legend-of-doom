class MoblinBlue : Moblin
{
	Default
	{
		Health 3;
        ZeldaMonster.DropGroup "B";
	}

    States
	{
		Spawn:
			MOBB AB 10 A_Look;
			Loop;
		See:
			MOBB AABBAABB 3 A_Chase;
			Loop;
		Melee:
			MOBB AB 8 A_FaceTarget;
			MOBB A 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            Goto See;
		Missile:
			MOBB AB 8 A_FaceTarget;
			MOBB B 6 A_SpawnProjectile("MoblinSpear",32,0,0,0);
			Goto See;
	}
}

class Moblin : ZeldaMonster
{
	Default
	{
		Health 2;
		DamageFunction(4);
        ZeldaMonster.DropGroup "A";
		Speed 8;
		Scale 3.5;
		Obituary "%o was killed by a moblin";
	}

	States
	{
		Spawn:
			MOBL AB 10 A_Look;
			Loop;
		See:
			MOBL AABBAABB 3 A_Chase;
			Loop;
		Melee:
			MOBL AB 8 A_FaceTarget;
			MOBL A 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            Goto See;
		Missile:
			MOBL AB 8 A_FaceTarget;
			MOBL B 6 A_SpawnProjectile("MoblinSpear",32,0,0,0);
			Goto See;
	}
}

class MoblinSpear : Actor
{
	Default
	{
		DamageFunction(4);
		Radius 6;
		Height 8;
		Speed 16;
		FastSpeed 20;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		+NOTIMEFREEZE
        +BLOODLESSIMPACT
		DamageType "Weak";
	}
	States
	{
	Spawn:
		MARW A 4 BRIGHT;
		Loop;
	}
}
