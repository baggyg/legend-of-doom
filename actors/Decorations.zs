class ZeldaBillboard : Actor abstract
{
	Default
    {
		Height 64;
		Radius 32;
		+SOLID
	}
}

class ZeldaTree : ZeldaBillboard
{
	Default
	{
        //$Title Tree Brown
		Height 128;
	}
	States
	{
		Spawn:
			TREB A -1;
			Stop;
	}
}

class ZeldaTree2 : ZeldaBillboard
{
	Default
	{
        //$Title Tree Green
		Height 128;
	}
	States
	{
		Spawn:
			TREG A -1;
			Stop;
	}
}

class ZeldaFire : ZeldaBillboard
{
	Default
	{
		//$Title Fire
        +RANDOMIZE
		-SOLID
        +NOGRAVITY
        +FLOAT
	}
	States
	{
		Spawn:
			FIRE AB 8 BRIGHT;
			Loop;
	}
}

class ZeldaBushGreen : ZeldaBillboard
{
	Default
	{
        //$Title Bush Green
		Radius 8;
	}
	States
	{
		Spawn:
			BSHG A -1;
			Stop;
	}
}

class ZeldaBushBrown : ZeldaBillboard
{
	Default
	{
        //$Title Bush Brown
		Radius 8;
	}
	States
	{
		Spawn:
			BSHB A -1;
			Stop;
	}
}

class ZeldaOldMan : ZeldaBillboard
{
	Default
	{
        //$Title NPC Old Man
	}
	States
	{
		Spawn:
			GRPA A -1;
			Stop;
	}
}

class ZeldaOldLady : ZeldaBillboard
{
	Default
	{
        //$Title NPC Old Lady
	}
	States
	{
		Spawn:
			GRMA A -1;
			Stop;
	}
}

class ZeldaMerchant : ZeldaBillboard
{
	Default
	{
        //$Title NPC Merchant
	}
	States
	{
		Spawn:
			MRCH A -1 BRIGHT;
			Stop;
	}
}

class ZeldaMoblinNpc : ZeldaBillboard
{
	Default
	{
        //$Title NPC Moblin
	}
	States
	{
		Spawn:
			MBLN A -1;
			Stop;
	}
}
