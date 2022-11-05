/**
*    Placed on the map to define a trigger and spawn area
*    where monsters will be spawned. SpawnController actually
*    triggers the SpawnMonster method.
*/
class ZeldaSpawner : MapSpot
{
    Default
    {
		//$Title Spawner
	}

    // A unique identifer.
    string user_id;

    // Comma separated list of classes to spawn.
    // Example: ZombieMan,ShotgunGuy
    string user_spawnclass;
    Array<string> spawnClasses;

    // Comma spearted list of chances corresponding
    // to `user_spawnclass` class(es). Should be same
    // length as `usesr_spawnclass` list. Chances are
    // required to total to 1.0.
    // Example: 0.75,0.25
    string user_spawnchances;
    Array<string> spawnChances;

    // Z offset for spawned things. Useful if the spawner is at
    // a different elevation than the floor you want to spawn on.
    int user_spawn_z;

    // Triggers spawns when player is this far away or closer.
    int user_triggerdist_x;
    int user_triggerdist_y;

    // Spawner will spawn monsters in this radius.
    int user_spawndist;

    // How many monsters to spawn
    int user_howmany_min;
    int user_howmany_max;

    // Does not put the spawner into the
    // queue tracking recently triggered spawners.
    bool user_skip_queue;

    // Linedef ID/tag that will become a closed
    // Door when spawner activates. Door will
    // open when all child spawns have been killed.
    int user_closedoor;

    // Spawner will require that the sector has a matching `user_spawnType` value.
    // Default: Land
    string user_spawnType;

	override void PostBeginPlay()
    {
        Super.PostBeginPlay();

        // Set defaults and check difficulty/CVars
        if (!user_spawn_z)
            user_spawn_z = 0.0;

        if (skill == 0)
        {
            user_howmany_min -= 2;
            user_howmany_max -= 2;
        }
        else if (skill == 1)
        {
            user_howmany_min -= 1;
            user_howmany_max -= 1;
        }
        else if (skill == 3)
        {
            user_howmany_min += 1;
            user_howmany_max += 1;
        }
        else if (skill == 4)
        {
            user_howmany_min += 2;
            user_howmany_max += 2;
        }

        if (user_howmany_min <= 0)
            user_howmany_min = 1;

        if (user_howmany_max <= 0)
            user_howmany_max = 1;

        if (sv_nomonsters)
        {
            user_howmany_min = 0;
            user_howmany_max = 0;
        }

        if (!user_spawnType)
            user_spawnType = "Land";

        user_spawnchances.Split(spawnChances, ",");
        user_spawnclass.Split(spawnClasses, ",");

        // Validate some critical fields
        if (user_spawnchances == "")
            Console.PrintF("ERROR - ZeldaSpawner %s does not have spawn chances.", user_id);

        if (user_spawnclass == "")
            Console.PrintF("ERROR - ZeldaSpawner %s does not have spawn classes.", user_id);

        if (spawnClasses.Size() != spawnChances.Size())
            Console.PrintF("ERROR - ZeldaSpawner %s spawn classes and spawn chances lists must be the same size.", user_id);
    }

    // Spawn at random points within spawn distance
    virtual void SpawnMonsters()
    {
        // Console.PrintF("Spawning monster %s", user_spawnclass);

        bool spawnSuccess = false;
        int numClasses = spawnClasses.Size();
        int numSpawns = Random(user_howmany_min, user_howmany_max);

        for (let i = 0; i < numSpawns; i++)
        {
            let spawnDest = GetSpawnPosition();
            if (spawnDest == pos)
            {
                continue;
            }

            // Pick a class
            let spawnClass = "";
            let cFloor = 0;
            let cCiel = 0;
            let roll = Random(1, 100);

            for (let j = 0; j < numClasses; j++)
            {
                let chance = spawnChances[j].ToInt();
                cCiel += chance;
                if (roll >= cFloor && roll <= cCiel)
                {
                    spawnClass = spawnClasses[j];
                    break;
                }
                else
                {
                    cFloor += chance;
                }
            }

            // Spawn
            let spawned = ZeldaMonster(Spawn(spawnClass, spawnDest));
            if (spawned)
            {
                spawnSuccess = true;
                spawned.SpawnedBy = self;
                if (spawned.ShowSpawnFog)
                {
                    let fog = Spawn("ZeldaFog", spawnDest);
                    fog.A_StartSound("zelda/warp");
                }
            }
        }

        if (!spawnSuccess)
        {
            return;
        }

        let controller = SpawnController(StaticEventHandler.Find("SpawnController"));
        controller.ReportSpawns(user_id, numSpawns, user_skip_queue);

        // Lock doors
        if (user_closedoor)
        {
            // Console.PrintF("Closing Door %i", user_closedoor);
            CallACS("CloseDoor", user_closedoor);
        }
    }

    // Get a random position where a thing will be spawned.
    protected Vector3 GetSpawnPosition()
    {
        FCheckPosition fCheckPos;
        let spawnDest = GetPosition();

        let tries = 1;
        let maxTries = 100;

        while (!CheckMove(spawnDest.xy + (32, 0), PCM_NOACTORS) ||
               !CheckMove(spawnDest.xy + (0, 32), PCM_NOACTORS) ||
               !CheckMove(spawnDest.xy - (32, 0), PCM_NOACTORS) ||
               !CheckMove(spawnDest.xy - (0, 32), PCM_NOACTORS, fCheckPos) ||
               fCheckPos.CurSector.GetUDMFString("user_spawntype") != user_spawnType)
        {
            spawnDest = GetPosition();
            tries++;
            if (tries > maxTries) return pos;
        }

        return spawnDest;
    }

    // Get a random point relative to the spawners pos.
    // Point is within a circular radius defined by `user_spawndist`.
    private Vector3 GetPosition()
    {
        return (pos.x + Random(-user_spawndist, user_spawndist),
                pos.y + Random(-user_spawndist, user_spawndist),
                pos.z + user_spawn_z);
    }
}

/**
*   Manual spawners aren't tracked in a queue by SpawnController
*   so that they can be triggered over and over. Used for spawning
*   monsters when the player touches statues.
*/
class ZeldaManualSpawner : ZeldaSpawner
{
    Default
    {
		//$Title Spawner - Manual
	}
}

/**
* Ghost spawner is tracked in the spawn controller queue
* for the first ghost only.
*/
class ZeldaGhostSpawner : ZeldaSpawner
{
    Default
    {
		//$Title Spawner - Ghost
    }

    Ghini keyGhost;

    override void SpawnMonsters()
    {
        let spos = GetSpawnPosition();

        if (keyghost)
        {
            keyGhost.A_SpawnItemEx("GhiniChild", pos.x-spos.x, pos.y-spos.y, 0, flags: SXF_SETMASTER);
        }
        else
        {
            keyGhost = Ghini(Spawn("Ghini", spos));
            let controller = SpawnController(StaticEventHandler.Find("SpawnController"));
            controller.ReportSpawns(user_id, 1, user_skip_queue);
        }
    }
}

/**
*   Data structure for tracking ZeldaSpawners and spawned creatures
*   Not persistent between HUB maps.
*/
class SpawnData : Thinker
{
    // All spawners on a map
    Array<ZeldaSpawner> spawners;

    // Tracks spawners and thier number of children
    // Dictionary<s:spawnerId, i:spawnsAliveCount>
    Dictionary spawnCounts;

    // A FIFO queue that tracks which spawners were last activated
    // so that monsters are not constantly spawning.
    Array<string> spawnerQ;

	SpawnData Init()
    {
		ChangeStatNum(STAT_INFO); // STAT_STATIC if persisting between maps.
		return self;
	}

	static SpawnData Get()
    {
		let it = ThinkerIterator.Create("SpawnData",STAT_INFO); // STAT_STATIC if persisting between maps.
		let p = SpawnData(it.Next());
		if (p == null) p = new("SpawnData").Init();
		return p;
	}
}

/**
*    Controlls triggering ZeldaSpawners at a specified tick interval.
*    Tracks which spawners have most recently spawned in a spawnerQ
*    and prevents them from repeatedly spawning on top of a player
*    who stays in spawn distance. As the player triggers a new
*    spawn point, the oldest one in the spawnerQ drops out.
*
*    Removes monsters after the player has moved a certain distance away.
*    If monsters didn't leash in this way the overworld would have a lot
*    of randomly wondering monsters if the player just runs through.
*    Since spawners can't respawn if any of their previously spawned
*    monsters are still alive, the overworld could get into a bad state.
*/
class SpawnController : StaticEventHandler
{
    Actor player;
    SpawnData data;

    // Build in a delay so spawner distance
    // checks don't run on every tick.
    int spawnTickCount;
    int spawnCheckTicks;

    // Leash/monster cleanup
    int leashDistance;
	int leashTickCount;
	int leashCheckTicks;
    int spawnQueueMaxSize;

    int numSpawners;

    override void WorldLoaded(WorldEvent e)
    {
        player = players[consoleplayer].mo;
        data = SpawnData.Get();

        spawnCheckTicks = 20;
        spawnQueueMaxSize = 6;
        spawnTickCount = 0;
        numSpawners = data.spawners.Size();

        leashDistance = 4000;
        leashCheckTicks = 100;
        leashTickCount = 0;

        if (skill == 4)
        {
            spawnQueueMaxSize = 2;
        }

        if (!numSpawners)
        {
            let dupeChecker = Dictionary.Create();
            let ti = ThinkerIterator.Create("ZeldaSpawner");
            ZeldaSpawner mo;

            while (mo = ZeldaSpawner(ti.Next()))
            {
                // Manual spawners are not tracked in the spawnQ
                if (mo.GetClassName() == "ZeldaManualSpawner")
                {
                    continue;
                }

                if (dupeChecker.At(mo.user_id) != "")
                {
                    Console.PrintF("WARNING - duplicate Zelda spawner id (%s) at (%i, %i)", mo.user_id, mo.pos.xy);
                }
                else
                {
                    dupeChecker.Insert(mo.user_id, "exists");
                }

                data.spawners.Push(mo);
            }

            data.spawnCounts = Dictionary.Create();
            numSpawners = data.spawners.Size();
        }
    }

    override void WorldTick()
    {
        // Check spawners for trigger distance
        spawnTickCount++;

        if (spawnTickCount >= spawnCheckTicks)
        {
            spawnTickCount = 0;

            for (let i = 0; i < numSpawners; i++)
            {
                if (CanSpawn(data.spawners[i]))
                {
                    data.spawners[i].SpawnMonsters();
                }
            }
        }

        // Pull leash on far away monsters
        leashTickCount++;

        if (leashTickCount >= leashCheckTicks && level.levelnum == 1)
        {
            leashTickCount = 0;

            ZeldaMonster mo;
            let ti = ThinkerIterator.Create("ZeldaMonster");

            while (mo = ZeldaMonster(ti.Next()))
            {
                if (mo.bIsMonster)
                {
                    if (mo.CheckIfCloser(player, leashDistance) == false)
                    {
                        mo.Die(mo, mo, 666);
                        mo.Destroy();
                    }
                }
            }
        }
    }

    // Called by `ZeldaSpawner.SpawnMonsters`
    void ReportSpawns(string spawnerId, int numSpawns, bool skipQueue = false)
    {
        //Console.PrintF("Spawner %s spawned %i mobs", spawnerId, numSpawns);
        let currentCount = GetSpawnCount(spawnerId);
        data.spawnCounts.Remove(spawnerId);
        data.spawnCounts.Insert(spawnerId, string.Format("%i", currentCount + numSpawns));

        if (!skipQueue)
        {
            Enqueue(spawnerId);
        }
    }

    // Called by `SpawnedThing.Die`
    void ReportDeath(ZeldaSpawner spawner)
    {
        // Console.PrintF("Death reported to %s", spawner.user_id);

        if (!spawner) return;

        // Get and remove current spawn count
        let currentCount = GetSpawnCount(spawner.user_id);
        data.spawnCounts.Remove(spawner.user_id);

        if (currentCount > 1)
        {
            // Save updated spawn count
            data.spawnCounts.Insert(spawner.user_id, string.Format("%i", currentCount-1));
        }
        else
        {
            //Console.PrintF("Spawner was depleted %s", spawner.user_id);

            // Door should open after all spawned enemies are killed.
            if (spawner.user_closedoor)
            {
                CallACS("OpenDoor", spawner.user_closedoor, 0);
                spawner.A_StartSound("zelda/door", CHAN_AUTO);
            }

            // Reveal any invisible UniqueItems within trigger range.
            Inventory item;
            let itemIter = ThinkerIterator.Create("Inventory");
            while (item = Inventory(itemIter.Next()))
            {
                let isClose = PointFound(
                    item.pos.xy,
                    (spawner.pos.x - spawner.user_triggerdist_x, spawner.pos.y - spawner.user_triggerdist_y),
                    (spawner.pos.x + spawner.user_triggerdist_x, spawner.pos.y + spawner.user_triggerdist_y)
                );

                if (isClose && item.bInvisible && !item.owner)
                {
                    item.bInvisible = false;
                    item.A_StartSound("zelda/showitem", CHAN_AUTO);
                }
            }
        }
    }

    // Spawner can spawn if it:
    // 1. has no active spawns
    // 2. isn't in the spawnQ
    // 3. is in range of player
    private bool CanSpawn(ZeldaSpawner spawner)
    {
        if (data.spawnCounts.At(spawner.user_id) != "")
            return false;

        if (QContains(spawner.user_id))
            return false;

        return PointFound(
            player.pos.xy,
            (spawner.pos.x - spawner.user_triggerdist_x, spawner.pos.y - spawner.user_triggerdist_y),
            (spawner.pos.x + spawner.user_triggerdist_x, spawner.pos.y + spawner.user_triggerdist_y)
        );
    }

    // Returns true if point p is found on the 2d plane bound
    // by r1 (bottom-left) and r2 (top-right)
    private bool PointFound(Vector2 p, Vector2 r1, Vector2 r2)
    {
        return p.x > r1.x && p.x < r2.x &&
               p.y > r1.y && p.y < r2.y;
    }

    // Returns the number of spawns, spawned by `spawnerId` that are still alive
    private int GetSpawnCount(string spawnerId)
    {
        let countValueString = data.spawnCounts.At(spawnerId);
        return countValueString == "" ? 0 : countValueString.ToInt();
    }

    // Trigger a spawner via script, regardless of queue status
    static void TriggerSpawner(string id)
    {
        ZeldaSpawner mo;
        let ti = ThinkerIterator.Create("ZeldaSpawner");
        while (mo = ZeldaSpawner(ti.Next()))
        {
            if (mo.user_id == id)
            {
                mo.SpawnMonsters();
            }
        }
    }

    // Insert element at rear of spawnerQ
    void Enqueue (string value)
    {
        if (spawnQueueMaxSize == data.spawnerQ.Size())
        {
            Dequeue();
        }
        data.spawnerQ.push(value);
    }

    // Remove element from front of spawnerQ
    void Dequeue ()
    {
        data.spawnerQ.Delete(0, 1);
    }

    // Remove everything from the spawnerQ
    void ClearQueue()
    {
        while (data.spawnerQ.Size() > 0)
        {
            Dequeue();
        }
    }

    // Return true if the value is found in spawnerQ
    bool QContains(string value)
    {
        let qSize = data.spawnerQ.Size();
        for (let i = 0; i < qSize; i++)
        {
            if (data.spawnerQ[i] == value)
            {
                return true;
            }
        }
        return false;
    }

    // Display spawner contents
    void QPrint()
    {
        let qDisplay = "";
        let qSize = data.spawnerQ.Size();
        for (let i = 0; i < qSize; i++)
        {
            qDisplay = qDisplay..data.spawnerQ[i]..",";
        }
        Console.PrintF(qDisplay);
    }
}
