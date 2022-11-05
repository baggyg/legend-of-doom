class TektiteBlue : Tektite
{
    Default
    {
        BloodColor "Blue";
        ZeldaMonster.DropGroup "C";
        Translation "248:248=196:196", "175:175=204:204";
    }
}

class Tektite : ZeldaMonster
{
    Default
    {
        Health 1;
        DamageFunction(4);
        ZeldaMonster.DropGroup "A";
        HitObituary "%o was nipped by a Tektite";
        Radius 20;
        Height 25;
        Speed 6;
        Scale 2;
        MeleeThreshold 64;
        MinMissileChance 50;
        -CANPASS
    }

    States
    {
        Spawn:
            TEKT AB 4 A_Look;
            Loop;
        See:
            TEKT AABBAABBAABB 10 A_Wander;
            TEKT A 0 A_SkullAttack;
            TEKT B 10 ThrustThingZ(0, 35, 0, 1);
            TEKT A 0 A_Stop;
            TEKT A 0 A_Look;
            Loop;
        Melee:
            TEKT B 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            Goto See;
    }
}
