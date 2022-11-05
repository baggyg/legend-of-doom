class Gleeok : ZeldaMonster
{
	Default
	{
		Health 12;
		DamageFunction(4);
        ZeldaMonster.DropGroup "D";
        Scale 3;
		SeeSound "zelda/boss1";
		ActiveSound "zelda/boss1";
		DeathSound "zelda/boss2";
		HitObituary "%o was killed by Gleeok";
        +MISSILEEVENMORE
	}

    States
    {
        Spawn:
            GLEE ABC 4 A_Look;
            Loop;
        See:
            #### AABBCC 4 A_Chase;
            Loop;
		Melee:
		Missile:
		    #### ABC 8 A_FaceTarget;
            #### A 8 A_SpawnProjectile("ZeldaProjectile",128,0,0,0);
            #### A 8 A_SpawnProjectile("ZeldaProjectile",128,0,0,0);
            #### A 8 A_SpawnProjectile("ZeldaProjectile",128,0,0,0);
			Goto See;
        Load:
			GLE2 A 0;
			GLE1 A 0;
			Stop;
    }

    int headCount;

    override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
    {
        let newHealth = Health - damage;
        if (newHealth <= 8 && headCount == 0)
        {
            Spawn("GleeokHead", (pos.x, pos.y, pos.z + 100));
            sprite = GetSpriteIndex("GLE2");
            headCount++;
        }
        if (newHealth <= 4 && headCount == 1)
        {
            Spawn("GleeokHead", (pos.x, pos.y, pos.z + 100));
            sprite = GetSpriteIndex("GLE1");
            headCount++;
        }
        return Super.TakeSpecialDamage(inflictor, source, damage, damagetype);
    }

	override void Die(Actor source, Actor inflictor, int dmgflags)
    {
        GleeokHead mo;
        let ti = ThinkerIterator.Create("GleeokHead");
        while (mo = GleeokHead(ti.Next()))
        {
            mo.Die(mo, mo, 666);
            mo.Destroy();
        }
    	Super.Die(source, inflictor, dmgflags);
    }
}

class GleeokHead : ZeldaMonster
{
    Default
    {
        Health 1000;
        DamageFunction(4);
        Speed 4;
		Radius 16;
		Height 4;
        +NOGRAVITY
        +DONTFALL
        +RETARGETAFTERSLAM
    }

    States
	{
        Spawn:
            GLEH A 10 A_Look;
            Loop;
        See:
            GLEH A 4 A_Wander;
            GLEH A 1 A_Chase;
            Loop;
        Missile:
            GLEH A 8 A_FaceTarget;
            GLEH A 6 A_SpawnProjectile("ZeldaProjectile", -1);
            GLEH A 8;
            Goto See;
	}
}
