class Aquamentus : ZeldaMonster
{
	Default
	{
		Health 6;
		DamageFunction(4);
        Scale 3;
		SeeSound "zelda/boss1";
		ActiveSound "zelda/boss1";
		DeathSound "zelda/boss2";
		HitObituary "%o was killed by Aquamentus";
        ZeldaMonster.DropGroup "D";
        +MISSILEEVENMORE
	}

	States
	{

        Spawn:
            AQUA AB 4 A_Look;
            Loop;
        See:
            AQUA AABB 3 A_Chase;
            Loop;
		Melee:
		Missile:
		    AQUA AB 8 A_FaceTarget;
			AQUA A 8 A_BruisAttack2;
			Goto See;
	}

	void A_BruisAttack2()
	{
		if (!target) return;

		if (CheckMeleeRange())
		{
			int damage = GetMissileDamage(0,1);
			int newdam = target.DamageMobj(self, self, damage, "Melee");
			target.TraceBleed(newdam > 0 ? newdam : damage, self);
		}
		else
		{
			let mo = SpawnMissile(target, "ZeldaProjectile");
			if (mo != null)
			{
				SpawnMissileAngle("ZeldaProjectile", mo.Angle - 45. / 8, mo.Vel.Z);
				SpawnMissileAngle("ZeldaProjectile", mo.Angle + 45. / 8, mo.Vel.Z);
			}
			A_StartSound("zelda/boss1", CHAN_AUTO, CHANF_OVERLAP);
		}
	}
}
