class GohmaBlue : Gohma
{
    Default
    {
        Health 6;
        Translation "248:248=195:195", "180:180=203:203";
        +MISSILEEVENMORE
    }
}

class Gohma : ZeldaMonster
{
    Default
    {
        Health 2;
        ZeldaMonster.DropGroup "D";
        Obituary "%o was vaporized by Gohma";
        Scale 3;
        Speed 6;
        SeeSound "zelda/boss2";
        ActiveSound "zelda/boss2";
        +MISSILEMORE
        +BOSS
    }

    States
    {
        Spawn:
            GOMA AB 10 A_Look();
            Loop;
        See:
            GOMA C 20;
            GOMA CCDDEE 3 A_Chase();
            GOMA FGGHH 3 A_Chase();
            Goto See;
        Melee:
        Missile:
            GOMA AB 4 A_FaceTarget();
            GOMA A 2 A_SpawnProjectile("ZeldaProjectile",24,0,0);
            GOMA A 2 A_SpawnProjectile("ZeldaProjectile",24,0,15);
            GOMA AB 8;
            Goto See+1;
    }

    override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
    {
        if ((damagetype == "Arrow" || damagetype == "SilverArrow") && InStateSequence(CurState, ResolveState("Missile")))
        {
            A_StartSound("zelda/e_hit", CHAN_AUTO);
        }
        else
        {
            damage = 0;
            A_StartSound("zelda/shield", CHAN_AUTO);
        }
        return Super.TakeSpecialDamage(inflictor, source, damage, damagetype);
    }
}
