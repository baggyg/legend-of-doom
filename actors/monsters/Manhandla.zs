class Manhandla : ZeldaMonster
{
    mixin OrbitingChildren;

    Default
    {
        Health 1;
        Scale 3;
		SeeSound "zelda/boss3";
		ActiveSound "zelda/boss3";
        ZeldaMonster.DropGroup "X";

        Manhandla.ChildZ 10;
        Manhandla.OrbitSpeed 0;
        Manhandla.ChildCount 4;
        Manhandla.ChildClass "ManhandlaBulb";
        Manhandla.ChildDistance 48;
        Manhandla.ChildShield true;
        Manhandla.FixChildAngles true;
        Manhandla.SpeedIncreaseOnChildDeath 12;

        +FLOAT
		+NOCLIP
        +MISSILEEVENMORE
    }

    States
    {
        Spawn:
            MANH A 4 A_Look;
            Loop;
        See:
            MANH A 4 A_Chase;
            Loop;
        Missile:
            MANH A 6 A_Wander;
            MANH A 6 A_SpawnProjectile("ZeldaProjectile",20,0,0,0);
			Goto See;
    }
}

class ManhandlaBulb : ZeldaMonster
{
    Default
    {
        Health 3;
        DamageFunction(8);
        ZeldaMonster.DropGroup "X";
        Speed 0;
        Scale 3.5;
        +NOGRAVITY
        +ALLOWTHRUBITS
        ThruBits(2);
    }

    States
    {
        Spawn:
            MANB AABBCC 8 A_Look;
            Loop;
        See:
        Wound:
            MANB ABCBA 6;
            Loop;
        Melee:
            MANB C 0 A_FaceTarget;
            MANB C 1 A_CustomMeleeAttack(GetMissileDamage(0,1));
            MANB ABCBA 6;
            Goto See;
        Missile:
            MANB # 1 A_SpawnProjectile("ZeldaProjectile",20,0,0,0);
            Goto See;
    }
}
