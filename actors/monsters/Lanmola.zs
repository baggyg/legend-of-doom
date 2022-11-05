class LanmolaBlue : Lanmola
{
    Default
    {
        Speed 8;
        Health 8;
        Translation "248:248=195:195", "175:175=203:203";
        SnakeMonster.BodyClass "LanmolaBodyBlue";
    }
}

class LanmolaBodyBlue : LanmolaBody
{
    Default
    {
        Health 8;
        Translation "248:248=195:195", "175:175=203:203";
    }
}

class Lanmola : SnakeMonster
{
    Default
    {
        Health 5;
        DamageFunction(8);
        ZeldaMonster.DropGroup "X";
        SnakeMonster.BodyClass "LanmolaBody";
        Scale 3;
        Speed 5;
    }
    States
    {
        Spawn:
			LANM A 1 A_Look;
			Loop;
		See:
			LANM A 1 A_Chase;
			Loop;
        Melee:
            #### A 10 A_CustomMeleeAttack(GetMissileDamage(0,1));
            Goto See;
    }
}

class LanmolaBody : SnakeMonsterBody
{
    Default
    {
        Health 5;
        Scale 3;
        ZeldaMonster.DropGroup "X";
    }
    States
    {
        Spawn:
			LANB A 1 A_Look;
			Loop;
		See:
			LANB A 1 A_Chase;
			Loop;
    }
}
