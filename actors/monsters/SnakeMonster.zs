/**
*   Original class `EOW_Head` by Kizoky
*/
class SnakeMonster : ZeldaMonster abstract
{
	Array<actor> NumOfBodies;
	bool NotInitSpawn;

    property BodyClass : BodyClass;
    string BodyClass;

	// Start spawning bodies on spawn, if it's done via console
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		if (!NotInitSpawn)
		{
			int NumberOfBodiesToSpawn = 5;

			for (uint i = 0; i < NumberOfBodiesToSpawn; i++)
			{
				let NewBody = spawn(BodyClass, pos);
				if (NewBody)
				{
					// Access body's variables
					let VarBody = SnakeMonsterBody(NewBody);
                    VarBody.SpawnedBy = SpawnedBy;
					if (VarBody)
					{
						// The idea here is that each body shouldn't follow the head,
						// but rather the head's already existing body/bodies
						if (NumOfBodies.Size() == 0)
							VarBody.Follow = self;
						else
							VarBody.Follow = NumOfBodies[i-1];

						VarBody.Brain = self;

						NumOfBodies.Push(VarBody);
					}
				}
			}
            let controller = SpawnController(StaticEventHandler.Find("SpawnController"));
            controller.ReportSpawns(SpawnedBy.user_id, NumberOfBodiesToSpawn, false);
		}
	}

	override void Tick()
	{
		Super.Tick();
		A_Recoil(-0.15);
		if (target)
		{
			Angle = AngleTo(target);
		}
	}

	// Reset Bodies' targets, when ONLY the Head was destroyed
	void RetargetBodies(actor Whom, bool HeadDestroyed = true)
	{
		if (HeadDestroyed)
		{
			NumOfBodies[0].Destroy();

			Array<actor> temp;
			temp.Move(NumOfBodies);

			for (uint i = 0; i < temp.Size(); i++)
			{
				if (temp[i])
				{
					NumOfBodies.Push(temp[i]);
				}
			}

			temp.Clear();
		}

		for (uint i = 0; i < NumOfBodies.Size(); i++)
		{
			let Body = SnakeMonsterBody(NumOfBodies[i]);
			if (Body)
			{
				if (i-1 >= 0)
				{
					if (NumOfBodies[i-1])
					{
						Body.Follow = NumOfBodies[i-1];
					}
				}

				if (i == 0)
					Body.Follow = Whom;

				Body.Brain = Whom;
			}
		}
	}

	// A Body was destroyed, which one?
	void MedusaEffect(actor Whom)
	{
		// First we need to get the Body's number in the array,
		// 0 is next to the head, while higher numbers are spawned lastly
		int BodyNum = 0;
		for (uint i = 0; i < NumOfBodies.Size(); i++)
		{
			if (NumOfBodies[i] && Whom && Whom == NumOfBodies[i])
				BodyNum = i;
		}

		// Store the bodies into a temp array, starting after the destroyed body
		Array<actor> temp;
		for (uint i = BodyNum+1; i < NumOfBodies.Size(); i++)
		{
			if (NumOfBodies[i])
				temp.Push(NumOfBodies[i]);
		}

		let NewHead = spawn(Super.GetClassName(), NumOfBodies[BodyNum].pos);

		if (NewHead)
		{
			let VarHead = SnakeMonster(NewHead);
			if (VarHead)
			{
                VarHead.SpawnedBy = SpawnedBy;
				VarHead.NumOfBodies.Move(temp);
				VarHead.RetargetBodies(VarHead, false);
				VarHead.target = target;
				VarHead.angle = AngleTo(target);
				VarHead.NotInitSpawn = true;

				NumOfBodies[BodyNum].Destroy();

				// And now fix the array for our main head
				// starting with removing bodies from the array that are no longer ours
				Array<actor> NewArray;
				for (uint i = 0; i < NumOfBodies.Size(); i++)
				{
					if (NumOfBodies[i])
					{
						let VarBody = SnakeMonsterBody(NumOfBodies[i]);
						if (VarBody)
						{
							if (VarBody.Brain == self)
								NewArray.Push(VarBody);

						}
					}
				}

				NumOfBodies.Clear();
				NumOfBodies.Move(NewArray);

                let controller = SpawnController(StaticEventHandler.Find("SpawnController"));
                controller.ReportSpawns(SpawnedBy.user_id, 1, false);
			}

		}
	}

	void SpawnNewHead()
	{
		vector3 PosOfFirstBody = (0,0,0);
		if (NumOfBodies.Size() != 0)
		{
			PosOfFirstBody = NumOfBodies[0].pos;

			let NewHead = spawn(Super.GetClassName(), PosOfFirstBody);
			if (NewHead)
			{
				let VarHead = SnakeMonster(NewHead);
				if (VarHead)
				{
                    VarHead.SpawnedBy = SpawnedBy;

					VarHead.NotInitSpawn = true;
					VarHead.NumOfBodies.Move(NumOfBodies);

					VarHead.RetargetBodies(VarHead);

					VarHead.target = target;
					VarHead.angle = AngleTo(target);
					Destroy();
				}
			}
		}
	}

	Default
	{
		Radius 12;
		Height 10;
		Scale 3;
		Speed 1;
		-NOGRAVITY
		-NOINTERACTION
		-NOBLOCKMAP
		+SHOOTABLE
        -SPECIAL
	}

	States
	{
		Melee:
		Missile:
			Goto See;
		Death:
            TNT1 A 1 A_SpawnItemEx("ZeldaDead", 0, 0, 10);
			TNT1 A 0 SpawnNewHead();
			TNT1 A -1;
			Stop;
	}
}

/**
*   Original class by Kizoky
*   Eater of Worlds body
*   It's main purpose is to follow the head's movements, and deal damage
*/
class SnakeMonsterBody : ZeldaMonster
{
	actor Follow, Brain;

	override void Tick()
	{
		Super.Tick();

		if (Follow)
		{
			Angle = AngleTo(Follow);

			if (Distance2D(Follow) > 25)
				A_Recoil(-0.45);
			else
				vel.xy = (0,0);

		}
	}

	void BodyDestroyed()
	{
		if (Brain)
		{
			let Head = SnakeMonster(Brain);
			if (Head)
			{
				Head.MedusaEffect(self);
			}
		}
	}

	Default
	{
		Radius 12;
		Height 10;
		Scale 3;
		Speed 0;
        ZeldaMonster.DropGroup "X";
		-NOGRAVITY
		-NOINTERACTION
		-NOBLOCKMAP
		+SHOOTABLE
        -SPECIAL
	}

	States
	{
		Death:
            TNT1 A 1 A_SpawnItemEx("ZeldaDead", 0, 0, 10);
			TNT1 A 0 BodyDestroyed();
			TNT1 A -1;
			Stop;
	}
}
