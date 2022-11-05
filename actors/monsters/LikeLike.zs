class LikeLike : ZeldaMonster
{
    Default
    {
        Health 9;
        DamageFunction(8);
        ZeldaMonster.DropGroup "X";
        Speed 2;
        Scale 4;
    }

    States
    {
        Spawn:
            LIKE AABBCC 4 A_Look;
            LIKE AABBCC 4 A_Wander;
            Loop;
        See:
            LIKE ABBC 4 A_Chase;
            LIKE CBBA 4 A_Chase;
            Loop;
        Melee:
            TNT1 A 0
            {
                if (Random(0, 100) < 25)
                {
                    target.TakeInventory("ZeldaShield", 1);
                }
                target.DamageMobj (self, self, GetMissileDamage(0,1), "Melee");
            }
            LIKE AAABBCC 4 A_FaceTarget;
            LIKE AAABBCC 4 A_FaceTarget;
            Goto See;
	}
}
