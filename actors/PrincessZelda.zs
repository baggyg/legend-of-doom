class PrincessZelda : ZeldaBillboard
{
	Default
	{
        //$Title NPC Princess
        Scale 3;
        +SPECIAL
	}

	States
	{
		Spawn:
            ZELG A -1;
            Stop;
        Happy:
            #### BC 8;
            Loop;
        Load:
            ZELB A 0;
            ZELR A 0;
            Stop;
	}

    override void PostBeginPlay()
    {
        CheckOutfit();
    }

    void CheckOutfit()
    {
        let player = players[consoleplayer].mo;

        if (player.CountInv("ZeldaRingRed") > 0)
        {
            sprite = GetSpriteIndex("ZELR");
        }
        else if (player.CountInv("ZeldaRingBlue") > 0)
        {
            sprite = GetSpriteIndex("ZELB");
        }
    }

    override void Touch (Actor toucher)
	{
        let player = players[consoleplayer].mo;
        if (player.CountInv("ZeldaTriforcePower") > 0)
        {
            SetStateLabel("Happy");
            toucher.ACS_NamedExecuteAlways("EndGame", 0);
        }
	}
}
