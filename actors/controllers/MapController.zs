/**
*   Keeps track of door unlocks and revealed secrets so they
*   don't re-appear when the player exits and re-enters a dungeon.
*/
class MapController : StaticEventHandler
{
    // Called from loddungeon.UnlockAndOpenDoor
    static void RegisterUnlock(int doorId)
    {
        let data =  MapData.Get();
        let mapNumber = string.Format("%i", level.levelnum);
        let doorList = data.openDoors.At(mapNumber);

        if (doorList != "") doorList = doorList..",";
        data.openDoors.Insert(mapNumber, doorList..string.Format("%i", doorId));
    }

    // Called from loddungeon.BombAndOpenDoor
    // Adds a line id to the map's revealed secret list
    static void RegisterSecret(int lineId)
    {
        let data =  MapData.Get();
        let mapNumber = string.Format("%i", level.levelnum);
        let secretList = data.revealedSecrets.At(mapNumber);

        if (secretList != "") secretList = secretList..",";
        data.revealedSecrets.Insert(mapNumber, secretList..string.Format("%i", lineId));
    }

    // Called by SecretRevealer
    static bool IsSecretRegistered(int lineId)
    {
        let data =  MapData.Get();
        let mapNumber = string.Format("%i", level.levelnum);
        let secretList = data.revealedSecrets.At(mapNumber);

        Array<string> secretIds;
        secretList.Split(secretIds, ",");
        return secretIds.Find(string.Format("%i", lineId)) != secretIds.Size();
    }

    // Called by loddungeon.GrumbleGrumble
    static void RegisterMoblinFed()
    {
        let data =  MapData.Get();
        data.moblinFed = true;
    }

    // Called by loddungeon.OnEnter
    // Checks saved data for lists of revealed secrets,
    // unlocked doors, or a fed moblin.
    static void UnlockDoors()
    {
        let data =  MapData.Get();
        let mapNumber = string.Format("%i", level.levelnum);

        // Key doors
        Array<string> doors;
        let mapDoors = data.openDoors.At(mapNumber);
        mapDoors.Split(doors, ",");
        for (let i = 0; i < doors.Size(); i++)
        {
            CallACS("OpenDoor", doors[i].ToInt(), 0, 0);
        }

        // Moblin
        if (level.levelnum == 8 && data.moblinFed)
        {
            CallACS("OpenDoor", 29, 0, 1);
        }
    }

    // Called by Candle
    // Turns on the lights in the player's current sector
    static void LightRoom()
    {
        let player = players[consoleplayer].mo;
        let tagiter = level.CreateSectorTagIterator(get_sector_tag(player.CurSector));

        int idx;
        while (idx = tagiter.Next())
        {
            if (idx == -1) break;
            level.sectors[idx].SetLightLevel(192);
        }
    }

    // Apeirogon
    // https://forum.zdoom.org/viewtopic.php?f=122&t=69955
    static int get_sector_tag(sector s)
    {
        int sector_tag = -15;
        for (int i = 1; i < 100/*or what maximum tags index are?*/; i++)
        {
            SectorTagIterator sec_tags = level.CreateSectorTagIterator(i);

            int sector_id = -15;
            while (sector_id = sec_tags.next())
            {
                if (sector_id < 0)
                    break;
                if (sector_id == s.index())
                {
                    sector_tag = i;
                    break;
                }
            }
            if (sector_tag >= 0)
                break;
        }
        return sector_tag;
    }
}

/**
*   Data structure for tracking opened dungeon doors
*   Is persistent across all HUB maps.
*/
class MapData : Thinker
{
    // Doors opened by a key
    Dictionary openDoors;

    // Doors bombed
    Dictionary revealedSecrets;

    // Level 7 moblin
    bool moblinFed;

	MapData Init()
    {
		ChangeStatNum(STAT_STATIC);
        openDoors = Dictionary.Create();
        revealedSecrets = Dictionary.Create();
        moblinFed = false;
		return self;
	}

	static MapData Get()
    {
		let it = ThinkerIterator.Create("MapData", STAT_STATIC);
		let p = MapData(it.Next());
		if (p == null) p = new("MapData").Init();
		return p;
	}
}
