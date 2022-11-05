class Moldorm : SnakeMonster
{
    Default
    {
        Health 2;
        DamageFunction(4);
        PainSound "zelda/bosshit";
        SnakeMonster.BodyClass "MoldormBody";
        ZeldaMonster.DropGroup "D";
    }

    States
    {
        Spawn:
			MOLD A 1 A_Look;
			Loop;
		See:
			MOLD A 1 A_Chase;
			Loop;
        Melee:
            MOLD A 10 A_CustomMeleeAttack(GetMissileDamage(0,1));
            Goto See;
    }
}

class MoldormBody : SnakeMonsterBody
{
    Default
    {
        Health 2;
        DamageFunction(4);
        PainSound "zelda/bosshit";
        Scale 3;
        ZeldaMonster.DropGroup "X";
    }
    States
    {
        Spawn:
			MOLD A 1 A_Look;
			Loop;
		See:
			MOLD A 1 A_Chase;
			Loop;
    }
}

