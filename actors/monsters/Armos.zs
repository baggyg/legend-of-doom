class Armos : ZeldaMonster
{
    Default
    {
        Health 3;
		DamageFunction(8);
        ZeldaMonster.DropGroup "X";
        Obituary "%o was fried by armos.";
        Scale 3;
        Speed 8;
    }

    States
    {
        Spawn:
            ARMO AB 10 A_Look;
            Loop;
        See:
            ARMO AABB 4 A_Wander;
            Loop;
        Melee:
            ARMO AB 8;
            ARMO AB 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            ARMO AB 8;
            Goto See;
    }

    override void PostBeginPlay()
    {
        if (Random(1, 100) > 50)
        {
            Speed *= 4;
        }
        Super.PostBeginPlay();
    }
}
