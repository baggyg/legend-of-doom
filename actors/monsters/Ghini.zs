class GhiniChild : ZeldaMonster
{
    Default
    {
        Health 9;
        DamageFunction(8);
        ZeldaMonster.DropGroup "C";
        OBITUARY "%o was scared by a ghini";
        Scale 3;
        Speed 4;
        RenderStyle "Add";
        +NOCLIP
    }

    States
    {
        Spawn:
            GOST A 10 A_Look;
            Loop;
        See:
            GOST A 3 A_Chase;
            Loop;
        Melee:
            GOST A 8;
            GOST A 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            GOST A 8;
            Goto See;
    }
}

class Ghini : GhiniChild
{
    Default
    {
        +VISIBILITYPULSE
    }

    States
    {
        Spawn:
            GOSS A 10 A_Look;
            Loop;
        See:
            GOSS A 3 A_Chase;
            Loop;
        Melee:
            GOSS A 8;
            GOSS A 6 A_CustomMeleeAttack(GetMissileDamage(0,1));
            GOSS A 8;
            Goto See;
    }

	override void Die(Actor source, Actor inflictor, int dmgflags)
    {
        A_KillChildren("ParentAbuse");
    	Super.Die(source, inflictor, dmgflags);
    }
}
