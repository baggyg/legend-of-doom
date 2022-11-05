class Dodongo : ZeldaMonster
{
	Default
	{
		Health 8;
        DamageFunction(8);
        ZeldaMonster.DropGroup "D";
		Obituary "%o was killed by Dodongo";
        Scale 3;
		Speed 8;
        SeeSound "zelda/boss1";
		ActiveSound "zelda/boss1";
		DeathSound "zelda/boss2";
		+BOSS
	}

	States
	{
        Spawn:
            DODO AB 10 A_Look;
            Loop;
        See:
            DODO AB 4 A_Chase;
            Loop;
        Melee:
            DODO AB 8;
            DODO AB 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            DODO AB 8;
            Goto See;
        Pain:
            DODO CCCC 20;
            Goto See;
	}

    override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
    {
        if (damagetype != "Bomb")
        {
            damage = 0;
            A_StartSound("zelda/shield", CHAN_AUTO);
        }
        else if (InStateSequence(CurState, ResolveState("Pain")))
        {
            damage = 0;
        }
        return Super.TakeSpecialDamage(inflictor, source, damage, damagetype);
    }
}
