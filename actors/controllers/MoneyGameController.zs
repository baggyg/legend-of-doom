class MoneyGameController : StaticEventHandler
{
    /**
    * Rules of the game
    * https://www.zeldadungeon.net/wiki/Money_Making_Game
    */
    static void ResetGame()
    {
        EndGame(false);

        // Hard coding the line defs above map spots since
        // this isn't really something that will be abstracted.
        MoneySpot spot;
        Actor mapSpots[3];
        Array<int> mapSpotOrder;

        // Get the 3 money spots. Had this in WorldLoaded,
        // but would get memory/access errors later in ResetGame.
        let ti = ThinkerIterator.Create("MoneySpot");
        let i = 2;
        while (spot = MoneySpot(ti.Next()))
        {
            mapSpotOrder.Push(i);
            mapSpots[i--] = spot;
        }

        // Outcomes are applied in the same order to
        // a shuffled list of map spots.
        Shuffle(mapSpotOrder);

        // Spawn the game rupees
        Actor spawned;
        string spotClass;
        static const int priceLines[] = { 50, 51, 52 };

        for (i = 0; i < 3; i++)
        {
            // One spot is always -10
            // One spot has 50/50 chance to be -10 or -40
            // One spot has 50/50 chance to be +20 or +50
            spotClass = "ZeldaGameRupeeNeg10";
            if (i == 1) spotClass = Random(1, 100) > 50 ? "ZeldaGameRupeeNeg10" : "ZeldaGameRupeeNeg40";
            else if (i == 2) spotClass = Random(1, 100) > 50 ? "ZeldaGameRupee20" : "ZeldaGameRupee50";

            spot = MoneySpot(mapSpots[mapSpotOrder[i]]);
            spawned = spot.Spawn(spotClass, spot.pos);
            ZeldaGameRupee(spawned).LineId = priceLines[mapSpotOrder[i]];
        }

        spawned.ACS_NamedExecuteAlways("ResetPrices", 0);
    }

    /**
    *   Called when a ZeldaGameRupee is picked up
    */
    static void EndGame(bool showPrice = true)
    {
        ZeldaGameRupee rupee;
        let ti = ThinkerIterator.Create("ZeldaGameRupee");
        while (rupee = ZeldaGameRupee(ti.Next()))
        {
            if (showPrice)
            {
                rupee.ACS_NamedExecuteAlways("ShowPrice", 0, rupee.LineId, rupee.PriceTexture);
            }
            if (!rupee.owner)
            {
                rupee.Destroy();
            }
        }
    }

    // Durstenfeld shuffle adapted from:
    // https://stackoverflow.com/a/2450976/120783
    static void Shuffle(out Array<int> arr)
    {
        int temp, i, j;
        for (i = arr.Size() - 1; i > 0; i--)
        {
            j = Random(0, i);
            temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
    }
}

/**
*   Marks the spot where a game rupee will spawn
*/
class MoneySpot : MapSpot
{
    Default
    {
        //$Title Money Game Spot
    }
}
