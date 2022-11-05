class Darknut : ZeldaMonster
{
    property SwordType : SwordType;
    string SwordType;

    Default
    {
        Health 4;
        DamageFunction(8);
        ZeldaMonster.DropGroup "B";
        Obituary "%o was pierced by the darknut's sword.";
        Darknut.SwordType "SwordProjectile";
        Scale 3.5;
        ReactionTime 8;
        Speed 8;
    }

    States
    {
        Spawn:
            DARK AB 10 A_Look;
            Loop;
        See:
            DARK AABBAABBAABB 8 A_Chase;
            DARK A 0 A_Stop;
            DARK A 0 A_Look;
        Melee:
            DARK AB 8 A_FaceTarget;
            DARK A 8 A_CustomMeleeAttack(GetMissileDamage(0,1));
            DARK AB 4;
            Goto See;
    }

	override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
    {
        if (AbsAngle(angle, AngleTo(inflictor)) <= 45)
        {
            damage = 0;
            A_StartSound("zelda/shield", CHAN_AUTO);
        }
		return Super.TakeSpecialDamage(inflictor, source, damage, damagetype);
    }
}

class DarknutBlue : Darknut
{
    Default
    {
        Health 8;
        DamageFunction(16);
        ZeldaMonster.DropGroup "D";
        Translation "248:248=195:195", "179:179=203:203";
        Darknut.SwordType "SwordProjectileTwo";
    }
}
