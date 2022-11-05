class PolsVoice : ZeldaMonster
{
    Default
    {
        Health 9;
        DamageFunction(16);
        DamageFactor "Arrow", 5;
        ZeldaMonster.DropGroup "C";
        Scale 3;
        -CANPASS
    }

    States
    {
        Spawn:
            POLS AB 4 A_Look;
            Loop;
        See:
            POLS AABBAABBAABB 10 A_Wander;
            POLS A 0 A_SkullAttack;
            POLS B 10 ThrustThingZ(0, 45, 0, 1);
            POLS A 0 A_Stop;
            POLS A 0 A_Look;
            Loop;
        Melee:
            POLS B 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            Goto See;
    }
}
