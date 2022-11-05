class Wizzrobe : ZeldaMonster
{
    property ProjectileClass: ProjectileClass;
    string ProjectileClass;

    Default
    {
        Health 4;
        DamageFunction(16);
        ZeldaMonster.DropGroup "B";
        Wizzrobe.ProjectileClass "WizzrobeProjectile";
        Scale 3;
    }

    States
    {
        Spawn:
            WIZZ AB 10 A_Look;
            Loop;
        See:
            TNT1 A 0
            {
                A_SetTranslucent(0.5, 0);
                bInvulnerable = true;
            }
            WIZZ AABB 4 A_Chase;
            Loop;
        Melee:
        Missile:
            TNT1 A 0
            {
                A_SetTranslucent(1.5, 0);
                bInvulnerable = false;
            }
            WIZZ AB 8 A_FaceTarget;
            WIZZ B 6 A_SpawnProjectile(ProjectileClass,20,0,0,0);
            WIZZ AB 12 A_FaceTarget;
            Goto See;
    }
}

class WizzrobeBlue : Wizzrobe
{
    Default
    {
        Health 8;
        DamageFunction(32);
        ZeldaMonster.DropGroup "A";
        Wizzrobe.ProjectileClass "WizzrobeProjectileStrong";
        Translation "248:248=196:196", "175:175=205:205";
        +MISSILEMORE
    }
}

class WizzrobeProjectileStrong : WandProjectile
{
    Default
    {
        DamageFunction(32);
    }
}

class WizzrobeProjectile : WandProjectile
{
    Default
    {
        +BLOODLESSIMPACT
        DamageFunction(16);
    }

    States
    {
        Death:
            TNT1 A 0;
            Stop;
    }
}
