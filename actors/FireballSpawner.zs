class FireballSpawner : Actor
{
    Default
    {
        //$Title Fireball Spawner
    }

    int countdown;

    bool user_paused;

	override void PostBeginPlay()
    {
        if (!user_paused) user_paused = false;
        countdown = Random(70, 100);
    }

    override void Tick()
    {
        if (user_paused) return;

        countdown--;

        if (countdown == 0)
        {
            countdown = Random(70, 100);

            let player = players[consoleplayer].mo;
            if (Distance2D(player) < 800)
            {
                SpawnMissile(player, "ZeldaProjectile");
            }
        }
    }
}
