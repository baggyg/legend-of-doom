/**
*
*   Loot tables and drop rates from:
*   https://www.zeldadungeon.net/zelda-runners-examining-random-and-forced-drops-and-chatting-with-zant/
*
*   By killing 10 enemies without themselves being hit (this includes encounters which don’t damage Link),
*   the player can force the 11th enemy to drop an item. If this enemy is killed by a bomb explosion,
*   the item drop will be a bomb. If the enemy is killed by anything else, the drop will be 5 rupees.
*
*   Returns what, if any item a monster drops when it dies. Drops are determined based
*   on the monster's DropGroup and the value of KillCount.
*
*   In addition to this, the 16th kill will drop a Fairy, regardless of the method.
*
*/
class LootController : StaticEventHandler
{
    static const string LootA[] =
    {
        "ZeldaRupee", "ZeldaSmallHeart", "ZeldaRupee", "ZeldaFairyDrop","ZeldaRupee",
        "ZeldaSmallHeart", "ZeldaSmallHeart", "ZeldaRupee","ZeldaRupee","ZeldaSmallHeart"
    };

    static const string LootB[] =
    {
        "ZeldaBomb", "ZeldaRupee", "ZeldaClock", "ZeldaRupee", "ZeldaSmallHeart",
        "ZeldaBomb", "ZeldaRupee", "ZeldaBomb", "ZeldaSmallHeart", "ZeldaSmallHeart"
    };

    static const string LootC[] =
    {
        "ZeldaRupee", "ZeldaSmallHeart", "ZeldaRupee", "ZeldaRupee5", "ZeldaSmallHeart",
        "ZeldaClock", "ZeldaRupee", "ZeldaRupee", "ZeldaRupee", "ZeldaRupee5"
    };

    static const string LootD[] =
    {
        "ZeldaSmallHeart", "ZeldaFairyDrop", "ZeldaRupee", "ZeldaSmallHeart", "ZeldaFairyDrop",
        "ZeldaSmallHeart", "ZeldaSmallHeart", "ZeldaSmallHeart", "ZeldaRupee", "ZeldaSmallHeart"
    };

    // 31, 41, 59, 41% converted for A_DropItem chance
    static const int DropChances[] = { 79, 104, 151, 104 };

    Dictionary DropAmounts;

    int KillCount, FlawlessCount;

    override void WorldLoaded(WorldEvent e)
    {
        KillCount = 0;
        DropAmounts = Dictionary.Create();
		DropAmounts.Insert("ZeldaRupee", "1");
		DropAmounts.Insert("ZeldaRupee5", "5");
		DropAmounts.Insert("ZeldaSmallHeart", "8");
		DropAmounts.Insert("ZeldaBomb", "8");
		DropAmounts.Insert("ZeldaFairyDrop", "24");
		DropAmounts.Insert("ZeldaClock", "1");
    }

    string, int, int GetLoot(string dropGroup, Name damageType)
    {
        // Means we're getting loot for the 11th flawless kill
        if (FlawlessCount == 10)
        {
            let drop = damagetype == "Bomb" ? "ZeldaBomb" : "ZeldaRupee5";
            return drop, 256, DropAmounts.At(drop).ToInt();
        }
        else if (FlawlessCount == 15)
        {
            let drop = "ZeldaFairyDrop";
            return drop, 256, DropAmounts.At(drop).ToInt();
        }

        if (dropGroup == "D")
        {
            return LootD[KillCount], DropChances[3], DropAmounts.At(LootD[KillCount]).ToInt();
        }
        else if (dropGroup == "C")
        {
            return LootC[KillCount], DropChances[2], DropAmounts.At(LootC[KillCount]).ToInt();
        }
        else if (dropGroup == "B")
        {
            return LootB[KillCount], DropChances[1], DropAmounts.At(LootB[KillCount]).ToInt();
        }
        else if (dropGroup == "A")
        {
            return LootA[KillCount], DropChances[0], DropAmounts.At(LootA[KillCount]).ToInt();
        }

        // Ganon is the only monster without a loot group.
        return "ZeldaTriforcePower", 256, 1;
    }

    void ReportKill()
    {
        KillCount++;
        FlawlessCount++;
        if (KillCount == 10) KillCount = 0;
        if (FlawlessCount == 16) FlawlessCount = 1;
    }

    void ReportPlayerHit()
    {
        FlawlessCount = 0;
    }

    // Called by lodoverworld.VisitMoblin
    static void SetLoot(int from, int lootId)
    {
        static const string loots[] = { "MoblinRupee10", "MoblinRupee30", "MoblinRupee100" };
        let lootKey = string.Format("%i-%i", from, lootId);
        SpawnLoot(lootKey, loots[lootId], "MoblinLootSpot");
    }

    // Called by lodoverworld.PayOldMan
    static void SetPayment(int from)
    {
        let lootKey = string.Format("%i-20", from);
        SpawnLoot(lootKey, "ZeldaMoblinRupeeNeg20", "MoblinPaymentSpot");
    }

    /**
    *   Keeps track of what moblin loot has already been
    *   collected by the player so that it doesn't
    *   reset after they pick it up once and return.
    */
    private static void SpawnLoot(string lootKey, string lootClass, string spawnSpot)
    {
        let controller = UniqueItemController(StaticEventHandler.Find("UniqueItemController"));
        if (controller.IsPickedUp(lootKey))
        {
            return;
        }

        // Prevents duplicates without having to track.
        MoblinRupee rupee;
        let ri = ThinkerIterator.Create("MoblinRupee");
        while (rupee = MoblinRupee(ri.Next()))
        {
            if (!rupee.owner)
            {
                rupee.Destroy();
            }
        }

        let ti = ThinkerIterator.Create(spawnSpot);
        let spot = MoblinLootSpot(ti.Next());
        let spawned = spot.Spawn(lootClass, spot.pos);
        MoblinRupee(spawned).user_id = lootKey;
    }
}

/**
*   Marks the spot on the map where a moblin loot piece
*   will spawn. There should only be 1 on the map.
*/
class MoblinLootSpot : MapSpot
{
    Default
    {
        //$Title Moblin Loot Spot
    }
}

class MoblinPaymentSpot : MoblinLootSpot
{
    Default
    {
        //$Title Moblin Payment Spot
    }
}
