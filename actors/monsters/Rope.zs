class Rope : ZeldaMonster
{
    Default
    {
        Health 1;
        DamageFunction(4);
        ZeldaMonster.DropGroup "C";
        Scale 2.5;
        Speed 12;
        Obituary "%o tasted the venom of Rope";
        +QuickToRetaliate
        +RETARGETAFTERSLAM
        +MISSILEMORE
        +ALWAYSFAST
    }

	States
	{
        Spawn:
            ROPE AB 8 A_Look;
            Loop;
        See:
            ROPE AABBAABBAABB 10 A_Wander;
            ROPE A 0 A_SkullAttack;
            ROPE A 0 A_Look;
            Loop;
	}
}
