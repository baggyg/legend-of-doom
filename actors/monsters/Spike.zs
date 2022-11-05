class SpikeTrap : Actor
{
    Default
    {
        //$Title Spike Trap
        Projectile;
        DamageFunction(8);
        Scale 1.5;
        Radius 60;
        +RIPPER
        +FLOAT
        +BLOODLESSIMPACT
    }

    States
    {
        Spawn:
            SPIK A 1 BRIGHT;
            Loop;
    }

    int CurrentState;

    Array<int> Angle;
    Array<int> AngleDestX;
    Array<int> AngleDestY;

    int MoveDistX;
    int MoveDistY;

    Vector3 StartPos;
    Vector3 DestPos;

    int XSpeed;
    int YSpeed;

    enum SpikeState
    {
        IDLE,       // Sitting still
        ADVANCE,    // Moving towards center
        RETREAT     // Moving back to start position
    };

    override void PostBeginPlay()
    {
        XSpeed = 18;
        YSpeed = 12;
        StartPos = pos;
        CurrentState = IDLE;

        // Check 4 directions. Distance > 100 are the
        // directions where it has room to move.
        for (let checkAngle = 0; checkAngle <= 270; checkAngle += 90)
        {
            let moveDistance = GetMoveDistance(checkAngle);
            if (moveDistance > 100)
            {
                Angle.Push(checkAngle);

                switch(checkAngle)
                {
                    case 0:
                        AngleDestX.Push(pos.x + moveDistance);
                        AngleDestY.Push(pos.y);
                        break;
                    case 90:
                        AngleDestX.Push(pos.x);
                        AngleDestY.Push(pos.y + moveDistance);
                        break;
                    case 180:
                        AngleDestX.Push(pos.x - moveDistance);
                        AngleDestY.Push(pos.y);
                        break;
                    case 270:
                        AngleDestX.Push(pos.x);
                        AngleDestY.Push(pos.y - moveDistance);
                        break;
                }
            }
        }
    }

    override void Tick()
    {
        switch (CurrentState)
        {
            case IDLE:
                if (CheckSight(players[consoleplayer].mo) == false)
                {
                    return;
                }

                FLineTraceData RemoteRay;
                for (let i = 0; i < Angle.Size(); i++)
                {
                    LineTrace(Angle[i], 2048, pitch, offsetz: 32, data: RemoteRay);

                    if (RemoteRay.HitActor is "ZeldaPlayer" || RemoteRay.HitActor is "Sheeld")
                    {
                        CurrentState = ADVANCE;
                        DestPos = (AngleDestX[i], AngleDestY[i], pos.z);
                        MoveDistX = DestPos.x - pos.x;
                        MoveDistY = DestPos.y - pos.y;
                        A_ChangeVelocity(XSpeed*Signum(MoveDistX), YSpeed*Signum(MoveDistY), 0, CVF_REPLACE);
                        A_StartSound("zelda/spike");
                    }
                }
                break;

            case ADVANCE:
                if (Vector3Equal(pos, DestPos, 10))
                {
                    CurrentState = RETREAT;
                    A_ChangeVelocity(-XSpeed*Signum(MoveDistX)/2, -YSpeed*Signum(MoveDistY)/2, 0, CVF_REPLACE);
                }
                break;

            case RETREAT:
                if (Vector3Equal(pos, StartPos, 10))
                {
                    CurrentState = IDLE;
                    A_ChangeVelocity(0, 0, 0, CVF_REPLACE);
                    SetOrigin(StartPos, true);
                }
                break;
        }

        Super.Tick();
    }

    // The fractional portions of location vectors
    // are killing me. Probably not the best practice
    // way to do this or I'm missing something
    // (epsillon is too small for ~== to work).
    bool Vector3Equal(Vector3 pos1, Vector3 pos2, int thresh = 1)
    {
        let diff = pos1 - pos2;
        return abs(diff.x) < thresh && abs(diff.y) < thresh && abs(diff.z) < thresh;
    }

    double GetMoveDistance(int angle)
    {
        FLineTraceData RemoteRay;
        LineTrace(angle, 2048, pitch, offsetz: 32, data: RemoteRay);
        return RemoteRay.Distance > 100 ? (RemoteRay.Distance / 2) - 64 : 0;
    }

    int Signum(double x)
    {
        if (x > 0) return 1;
        if (x < 0) return -1;
        return 0;
    }
}
