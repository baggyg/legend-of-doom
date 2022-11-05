class ZeldaRingBlue : StoreItem
{
    Default
    {
        //$Title Ring Blue
        StoreItem.Cost 250;
        Scale 0.5;
		Inventory.Pickupmessage "You got the blue tunic!";
    }

    States
    {
        Spawn:
            RING A -1 BRIGHT;
            Stop;
    }
}

class ZeldaRingRed : Inventory
{
    Default
    {
        //$Title Ring Red
        Scale 0.5;
		Inventory.Pickupmessage "You got the red tunic!";
    }

    States
    {
        Spawn:
            RING B -1;
            Stop;
    }

    override void AttachToOwner(Actor a)
    {
        Super.AttachToOwner(a);

        PrincessZelda zelda;
        let zeldaFinder = ThinkerIterator.Create("PrincessZelda");
        while (zelda = PrincessZelda(zeldaFinder.Next()))
        {
            zelda.CheckOutfit();
        }
    }
}
