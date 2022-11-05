class Gel : ZeldaMonster
{
    Default
    {
        Health 1;
        DamageFunction(4);
        ZeldaMonster.DropGroup "X";
        PainThreshold 1;
        Obituary "%o was killed by a Gel";
        Radius 16;
        Speed 5;
        Scale 2;
    }

    States
    {
        Spawn:
            GEL1 AB 10 A_Look;
            Loop;
        See:
            GEL1 AABB 4 A_Chase;
            Loop;
        Melee:
            GEL1 AB 8;
            GEL1 AB 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            GEL1 AB 8;
            Goto See;
    }
}

class GelBlack : Gel
{
    States
    {
        Spawn:
            GEL2 AB 10 A_Look;
            Loop;
        See:
            GEL2 AABB 4 A_Chase;
            Loop;
        Melee:
            GEL2 AB 8;
            GEL2 AB 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            GEL2 AB 8;
            Goto See;
    }
}
