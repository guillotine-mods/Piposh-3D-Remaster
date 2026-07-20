include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var MoviePlaying = 0;
var Talking = 0;
var A[3] = 0,0,0;
var ThePan = 0;
var CamShow = 1;
var Close = 0;
var Door1 = 0;
var Door2 = 0;
var Vase = 0;
var Start = 0;
var Scene = 0;
var Go = 0;

sound Ambient = <SFX108.WAV>;
sound Bang = <SFX116.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;

	load_level(<Travel.WMB>);

	VoiceInit();
	Initialize();

	scene_map = bmapBack1;
}

action Woman
{
	while(1)
	{
		if (my.skill1 < 0) { my.skin = int(random(3)) + 1; my.skill1 = random(20) + 10; }
		my.skill1 = my.skill1 - 1 * time;
		wait(1);
	}
}

action Need
{
	my.roll = 0;

	while(1)
	{
		if (snd_playing (my.skill40) == 0) { play_sound (ambient,15); my.skill40 = result; }

		if (Vase == 1) { my.roll = my.roll - 1 * time; }
		else
		{
			if (CamShow == 2) { if (my.roll < 180) { my.roll = my.roll + 1 * time; } else { Go = 1; } }
		}

		wait(1);
	}
}

action Elv
{
	my.lightblue = 128;
	my.lightgreen = 0;
	my.lightred = 0;
	my.lightrange = 300;
	my.ambient = 100;

	my.skill1 = my.z;
	my.z = my.z - 1800;

	while (CamShow != 2) { wait(1); }

	while(1)
	{
		if (Go == 0) { if (my.z < my.skill1) { my.z = my.z + 10 * time; } }
		if (Vase == 1) { my.z = my.z - 10 * time; }

		wait(1);
	}
}

action Mar
{
	while(1)
	{
		if (Talking == my.skill1) { Talk(); } else { Blink(); }
		if (Start == 1) { my.invisible = on; my.shadow = off; }
		wait(1);
	}
}

action Vase1
{
	while(1)
	{
		if (VAse == 1) { my.shadow = off; my.invisible = on; }
		wait(1);
	}
}

action Vase2
{
	while(1)
	{
		if (Vase == 1) { my.shadow = on; my.invisible = off; }
		wait(1);
	}
}

action Eli
{
	my.skill35 = my.z;
	my.z = my.z - 1800;

	while (CamShow != 2) { wait(1); }

	while(1)
	{
		while (Go == 0) { if (my.z < my.skill35) { my.z = my.z + 10 * time; } wait(1); }
		if (Vase == 1) { my.z = my.z - 10 * time; }
		wait(1);
	}
}

action PipElv
{
	player = my;

	if (my.flag1 == on)
	{
		my.skill35 = my.z;
		my.z = my.z - 1800;
	}

	while (CamShow != 2) { wait(1); }

	while(1)
	{
		if (CamShow == 2)
		{
			if (Scene != my.skill1) { my.invisible = on; my.shadow = off; } else { my.invisible = off; my.shadow = on; player = my; }

			if ((Scene == 2) && (my.skill1 == 2))
			{
				if (my.skill11 == 0) { sPlay ("PIP082.WAV"); my.skill11 = 1; }
				if (my.skill10 < 50)
				{
					my.x = my.x - 15 * time;
					my.y = my.y + 4 * time;

					ent_cycle ("Walk",my.skill2);
					my.skill2 = my.skill2 + 10 * time;

					my.skill10 = my.skill10 + 1 * time;
					Talk2();
				}
				else
				{
					my.pan = 0;
					if (GetPosition(Voice) >= 1000000) { Close = 1; ent_frame ("Stand",0); my.skin = 1; } else { Talk(); }
					if (Close == 1)
					{
						while ((Door1 == 1) || (Door2 == 1)) { wait(1); }
						Vase = 1;
						sPlay ("KVC013.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { my.z = my.z - 10 * time; wait(1); }

						Run ("Town.exe");
					}
				}
			}

			if ((Scene == 1) && (my.skill1 == 1))
			{
				while (Go == 0) { if ((my.z < my.skill35) && (my.flag1 == on)) { my.z = my.z + 10 * time; } wait(1); }

				if (my.skill40 == 0) { sPlay ("SFX117.WAV"); my.skill40 = 1; }

				if (my.skill10 < 50)
				{
					my.x = my.x + 15 * time;
					my.y = my.y - 4 * time;

					ent_cycle ("Walk",my.skill2);
					my.skill2 = my.skill2 + 10 * time;

					my.skill10 = my.skill10 + 1 * time;
					Blink2();
				}
				else { Scene = 0; Start = 1; CamShow = 1; }
			}

				
		}

		wait(1);
	}
}

action Dude
{
	while(1)
	{
		if (Talking == 3) { Talk(); } else { Blink(); }
		wait(1);
	}
}

action AutoDoor
{
	my.skill2 = my.y;

	while(1)
	{
		if (abs(my.x - player.x) < 100) { my.y = my.y - my.skill1 * time; } else { my.y = my.y + my.skill1 * time; }
		if (Close == 1) { my.y = my.y + (my.skill1 * 2) * time; }
		if (my.y < my.skill2 - 100) { my.y = my.skill2 - 100; Door1 = 1; }
		if (my.y > my.skill2) { my.y = my.skill2; Door1 = 0; }
		wait(1);
	}
}

action AutoDoor2
{
	my.skill2 = my.y;

	while(1)
	{
		if (abs(my.x - player.x) < 100) { my.y = my.y - my.skill1 * time; } else { my.y = my.y + my.skill1 * time; }
		if (Close == 1) { my.y = my.y + (my.skill1 * 2) * time; }
		if (my.y > my.skill2 + 100) { my.y = my.skill2 + 100; Door2 = 1; }
		if (my.y < my.skill2) { my.y = my.skill2; Door2 = 0; }
		wait(1);
	}
}

action Cam
{
	while(1)
	{
		if (CamShow == my.skill1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;
		}
		wait(1);
	}
}

action Superman
{
	my.skill1 = my.y;
	my.y = my.y - 500;

	while (Start == 0) { wait(1); }

	while(1)
	{
		if (my.skill3 == 1)
		{
			if (my.skill40 == 0) { play_sound (Bang,50); my.skill40 = 1; }

			if (my.y < my.skill1) 
			{ 
				my.y = my.y + 20 * time; 
				ent_cycle ("Frame",my.y); 
			} 
			else 
			{
				ent_frame ("Hit",0); 
				my.skill2 = my.skill2 + 1 * time;
				if (my.skill2 > 10)
				{
					my.z = my.z - 5 * time; 
				}
			}
		}
		else { if (int(random(1000)) == 500) { my.skill3 = 1; } }

		wait(1);
	}
}

action PiposhDummy { A.x = my.x; A.y = my.y; A.z = my.z; ThePan = my.pan; }

action Piposh
{
	my.skill1 = 1;

	sPlay ("KVC012.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("MAR012.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { wait(1); }
	Scene = 1;
	CamShow = 2;

	while (Start == 0) { wait(1); }

	while(1)
	{
		if (Talking == 1) { Talk(); } else { if (my.skill1 == 2) { Blink(); } }

		if (my.skill1 == 1)
		{
			vec_set(temp,A.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

			my.tilt = 0; my.roll = 0;

			if (my.x < a.x) { my.x = my.x + 7 * time; } else { my.skill3 = 1; }
			if (my.y > a.y) { my.y = my.y - 5 * time; } else { my.skill4 = 1; }

			if ((my.skill3 == 1) && (my.skill4 == 1)) { my.skill1 = 2; }

			ent_cycle ("Walk",my.skill2);
			my.skill2 = my.skill2 + 10 * time;
		}

		if (my.skill1 == 2)
		{
			my.pan = ThePan;

			DoDialog (10);

			while (Dialog.visible == on) { Blink(); wait(1); }

			while (DialogIndex == 10)
			{
				if (DialogChoice == 1) 
				{ 
					sPlay ("PIP075.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					sPlay ("AGN001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
					sPlay ("PIP076.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					sPlay ("AGN002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
					DoDialog (10);
				}
	
				if (DialogChoice == 2) 
				{ 
					sPlay ("PIP077.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					sPlay ("AGN003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
					sPlay ("PIP078.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					DoDialog (10);
				}

				if (DialogChoice == 3) 
				{
					sPlay ("PIP079.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					sPlay ("AGN004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
					sPlay ("PIP080.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					sPlay ("AGN005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
					sPlay ("PIP081.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
					Scene = 2;
					CamShow = 2;
					DialogIndex = 0; Talking = 0; my.skill1 = 3;
				}

				wait(1);
			}

		}

		wait(1);
	}
}

action Nothing { while(1) { Blink(); wait(1); } }

action Dome
{
	while(1)
	{
		my.pan = my.pan + 2 * time;
		wait(1);
	}
}

action Agent
{
	while(1)
	{
		if (Talking == 2) { Talk(); } else { Blink(); }
		wait(1);
	}
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } else { ent_frame ("Talk",int(random(5)) * 25); } }
}

function Talk2()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
}

function Blink()
{
	ent_frame ("Stand",0);
	if (my.skill22 > 0) { my.skill22 = my.skill22 - 1 * time; }
	if (my.skill22 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill22 = 5; }
	}
}

function Blink2()
{
	if (my.skill22 > 0) { my.skill22 = my.skill22 - 1 * time; }
	if (my.skill22 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill22 = 5; }
	}
}

function DoDialog (num)
{
	DialogChoice = 0;
	DialogIndex = num; 
	ShowDialog();
	Talking = 0;
}