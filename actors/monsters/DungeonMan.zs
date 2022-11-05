class DungeonMan : Actor
{
    Default
    {
        //$Title Dungeon man
        Health 10000;
        Speed 0;
        Radius 40;
        Height 64;
        SeeSound "";
		ActiveSound "";
		AttackSound "";
		PainSound "zelda/e_die";
        PainChance 256;
        Monster;
        +FLOORCLIP
        +NOBLOOD
        +NOBLOODDECALS
        +NOICEDEATH
    }

    States
	{
		Spawn:
			GRPA A -1 BRIGHT;
			Stop;
        Pain:
			#### # 2 A_Pain;
			#### # 0 A_SetRenderStyle(0.85, STYLE_TranslucentStencil);
			#### # 1 SetShade("ffffff");
			#### # 2 SetShade("ff0000");
			#### # 1 SetShade("ffffff");
			#### # 0 A_SetRenderStyle(1, STYLE_Normal);
			Goto Spawn;
	}

	override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
    {
        let ti = ThinkerIterator.Create("FireballSpawner");
        FireballSpawner mo;
        while (mo = FireballSpawner(ti.Next()))
        {
            if (CheckSight(mo))
            {
                mo.user_paused = false;
            }
        }
    	return Super.TakeSpecialDamage(inflictor, source, damage, damagetype);
    }
}
