class Digdogger : ZeldaMonster
{
    Default
    {
		Health 1000;
		DamageFunction(8);
        Speed 3;
        Scale 3;
        MeleeRange 128;
		SeeSound "zelda/boss1";
		ActiveSound "zelda/boss1";
		DeathSound "zelda/boss2";
		HitObituary "%o was killed by Digdogger";
        ZeldaMonster.DropGroup "X";
        +FLOAT
        +NOGRAVITY
    }

    States
    {
		Spawn:
			DIGD AB 10 A_Look;
			Loop;
		See:
			DIGD AABBAABB 8 A_Chase;
			Loop;
		Melee:
			DIGD AB 8 A_FaceTarget;
			DIGD A 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
			DIGD A 4;
            Goto See;
    }

    // Called by Whistle
    void MakeSmall(Actor inflictor)
    {
        let spawned = Spawn("DigdoggerSmall", pos);
        DigdoggerSmall(spawned).SpawnedBy = SpawnedBy;

        let controller = SpawnController(StaticEventHandler.Find("SpawnController"));
        controller.ReportSpawns(SpawnedBy.user_id, 1, false);

        Super.Die(inflictor, inflictor, 666);
    }

    // Big Dig can't die
    override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
    {
        damage = 0;
        A_StartSound("zelda/shield", CHAN_AUTO);
        return Super.TakeSpecialDamage(inflictor, source, damage, damagetype);
    }
}

class DigdoggerSmall : ZeldaMonster
{
    Default
    {
		Health 6;
		DamageFunction(8);
        ZeldaMonster.DropGroup "X";
        Speed 3;
        Scale 3;
		SeeSound "zelda/boss1";
		ActiveSound "zelda/boss1";
		DeathSound "zelda/boss2";
		HitObituary "%o was killed by Digdogger";
        +FLOAT
        +NOGRAVITY
    }

    States
    {
		Spawn:
			DIGB AB 10 A_Look;
			Loop;
		See:
			DIGB AABBAABB 4 A_Chase;
			Loop;
		Melee:
			DIGB AB 8 A_FaceTarget;
			DIGB A 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            Goto See;
    }
}
