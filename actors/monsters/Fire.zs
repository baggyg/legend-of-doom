class ZeldaKillableFire : Actor
{
    Default
    {
        //$Title Fire Killable
        Health 1;
        Speed 0;
        Radius 40;
        Height 64;
        SeeSound "";
		ActiveSound "";
		AttackSound "";
		DeathSound "zelda/e_die";
        Monster;
        +RANDOMIZE
        +FLOORCLIP
        +NOBLOOD
        +NOBLOODDECALS
        +NOICEDEATH
    }

    States
	{
		Spawn:
			FIRE AB 8 BRIGHT;
			Loop;
	}
}
