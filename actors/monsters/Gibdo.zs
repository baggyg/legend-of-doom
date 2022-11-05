class Gibdo : ZeldaMonster
{
    Default
    {
        Health 8;
        DamageFunction(16);
        ZeldaMonster.DropGroup "B";
        HitObituary "%o was killed by Gibdo";
        Scale 3.5;
        Speed 5;
    }

    States
    {
        Spawn:
            MUMY AB 10 A_Look;
            Loop;
        See:
            MUMY AABB 4 A_Chase;
            Loop;
        Melee:
            MUMY AB 8;
            MUMY AB 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            MUMY AB 8;
            Goto See;
    }
}
