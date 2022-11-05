class GoriyaBlue : Goriya
{
    Default
    {
        Health 5;
        DamageFunction(8);
        ZeldaMonster.DropGroup "D";
        Translation "248:248=195:195", "175:175=203:203";
    }
}

class Goriya : ZeldaMonster
{
    string BoomerangType;

    Default
    {
        Health 3;
        DamageFunction(8);
        ZeldaMonster.DropGroup "B";
        Obituary "%o was blasted by a goriya.";
        Scale 4;
        Speed 10;
        +MISSILEMORE
    }

    States
    {
        Spawn:
            GORI AB 8 A_Look;
            Loop;
        See:
            GORI AB 4 A_Chase;
            Loop;
        Melee:
            GORI AB 8 A_FaceTarget;
            GORI A 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            Goto See;
        Missile:
            GORI AB 8 A_FaceTarget;
            GORI B 6 A_SpawnProjectile(BoomerangType,32,0,0,0);
            Goto See;
    }

	override void PostBeginPlay()
    {
        BoomerangType = players[consoleplayer].mo.CountInv("BoomerangBlue") > 0
            ? "GoriyaRangBlue"
            : "GoriyaRang";
       	Super.PostBeginPlay();
    }
}

class GoriyaRang : BoomerangProj
{
    Default
    {
        DamageFunction(4);
        DamageType "Weak";
        ThruBits(2);
    }
}

class GoriyaRangBlue : BoomerangProjBlue
{
    Default
    {
        DamageFunction(4);
        DamageType "Weak";
        ThruBits(2);
    }
}
