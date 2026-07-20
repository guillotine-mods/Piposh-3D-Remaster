include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Genia;
var GeniaZ;
var PipZ;
var Talking = 0;
var Scene = 1;
var MoviePhase = 0;
var CamShow = 0;
var Start = 0;
var TurNow = 0;
var Ride = 0;
var SPD = 30;
var Warts;
var B[3] = 0,0,0;
var CamShow = 1;
var NotAgain = 0;
var ShowPiposh = 0;
var OldCamPos[3];
var OldCamPan[3];

var PeeStr = 4;
var PrevZ;

var Quick1 = 0;
var Quick2 = 0;

var Dirt[3] = 0,0,0;
var Type;
var TalkingNow = 1;
var SND = 0;
var CamMark = 1;
var CamDelay = 0;

var PosM = 1;
var Scene2 = 0;
var DontCome = 1;

bmap bPee = <Pee.bmp>;
bmap bSkuf = <Skuf.pcx>;

sound Behema = <PIP067.WAV>;

sound Honk1 = <SFX007.wav>;
sound Honk2 = <SFX008.wav>;
sound Honk3 = <SFX009.wav>;

synonym TheVespa { type entity; }

synonym PIP { type entity; }

synonym WartCamX { type entity; }

bmap Wart = <Wart.pcx>;
bmap Wart1 = <Wart1.pcx>;
bmap Wart2 = <Wart2.pcx>;
bmap Wart3 = <Wart3.pcx>;
bmap Wart4 = <Wart4.pcx>;
bmap Wart5 = <Wart5.pcx>;
bmap Wart6 = <Wart6.pcx>;
bmap Wart7 = <Wart7.pcx>;

synonym player2 { type entity; }

panel pWart
{
	bmap = Wart1;
	pos_x = 130;
	pos_y = 100;
	flags = refresh,d3d;
	layer = 2;
}

panel pSkuf
{
	bmap = bSkuf;
	flags = refresh,d3d;
	layer = 2;
}

sound VespaEngine = <SFX101.wav>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	fog_color = 1;

	vNoMap = 1;

	max_entities = 2000;

	load_level(<Smash.WMB>);

	VoiceInit();
	Initialize();

	scene_map = bmapBack1;
}

action Dome
{
	my.skin = 1;
	while(1) { my.pan = my.pan + 3 * time; wait(1); }
}

action BigBad
{
	while(1)
	{
		if (Quick1 == 1)
		{
			my.invisible = off;
			my.x = my.x - 2 * time;
			talk();
		}
		else
		{
			my.invisible = on;
		}
		wait(1);
	}
}

action PipRide
{
	while(1)
	{
		if (Ride == 1)
		{
			my.invisible = off;
			my.x = my.x + SPD * time;
			my.y = my.y + SPD * time;
		}

		wait(1);
	}
}

action Bads
{
	my.skill1 = my.x;
	my.x = my.x - 200;

	while(1)
	{
		if (Ride == 2) { if (my.skill8 == 4) { my.pan = my.pan + 180; Ride = 1; } }
		if ((MoviePhase == 3) && (PosM == 1) && (pSkuf.visible == off) && (DontCome == 0))
		{ 
			my.invisible = off; my.shadow = on;
			if (my.x < my.skill1) { my.x = my.x + 5 * time; ent_cycle ("Walk",my.skill2); my.skill2 = my.skill2 + 10 * time; if (Talking == my.skill8) { Talk2(); } else { Blink2(); } }
			else { if (Talking == my.skill8) { Talk(); } else { Blink(); } }
		} else { my.invisible = on; my.shadow = off; }

		wait(1);
	}
}

action Turnx
{
	while(1)
	{
		if (MoviePhase == 2)
		{
			if (GetPosition(Voice) < 1000000)
			{
				if (GetPosition(Voice) > 130000) { Start = 1; }
				if (Start == 1) { if (my.skill2 == 0) { TurNow = 1; my.skill2 = 1; } }
				if (TurNow == 1) { my.pan = my.pan + 5 * time; }
				wait(1);
			}
			else { MoviePhase = 1; }
		}

		wait(1);
	}
}

action BitTurn
{
	my.skill1 = 1;
	my.skin = int(random(8)) + 1;

	while(1)
	{
		if (Start == 1)
		{
			if (my.skill1 == 1) { ent_cycle ("Turn",my.skill2); my.skill2 = my.skill2 + 10 * time; }
			if (my.skill1 == 2) { ent_frame ("Hat",my.skill2); my.skill2 = my.skill2 + 6 * time; if (my.skill2 >= 100) { my.skill1 = 1; TurNow = 1; } }
			if (my.skill1 == 1) { if (int(random(50)) == 25) { my.skill1 = 2; my.skill2 = 0; TurNow = 0; } }
		}

		wait(1);
	}
}

action Dance
{
	my.skill10 = my.z;
	ent_frame ("Cling",0);
	my.skill30 = int(random(5)) + 1;
	if ((my.flag2 == off) && (my.flag3 == off)) { my.pan = random(360); }
	if (my.skill5 != 0 ) { my.skin = my.skill5; }

	while(1)
	{
		if ((my.flag2 == off) && (my.flag3 == off)) { if (int(random(80)) == 40) { my.pan = random(360); } }

		if (my.flag5 == on)
		{
			vec_set(temp,camera.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);
		}

		if (my.flag2 == on) { if (int(random(30)) == 15) { ent_frame ("Cling",int(random(3)) * 50); } }
		if (my.flag3 == on) { ent_frame ("Die",0); }

		if ((Start == 0) && (my.flag1 == on)) { ent_frame ("Sit",0); }
		if (Start == 1)
		{
			if (my.flag5 == on) { Talk(); }

			if (my.flag1 == on) 
			{ 
				if (my.skill30 == 1) { ent_cycle ("Cheer",my.skill20); }
				if (my.skill30 == 2) { ent_cycle ("Dance",my.skill20); }
				if (my.skill30 == 3) { ent_cycle ("Jackson",my.skill20); }
				if (my.skill30 == 4) { ent_cycle ("Headspin",my.skill20); }
				if (my.skill30 == 5) { ent_cycle ("Cool",my.skill20); }

				if (int(random(100)) == 50) { my.skill30 = int(random(5)) + 1; }
			}

			my.skill20 = my.skill20 + 20 * time;
		}

		wait(1);
	}
}

action IntroCam
{
	while(1)
	{
		if (MoviePhase == 2)
		{
			if (CamShow == my.skill1)
			{
				camera.x = my.x;
				camera.y = my.y;
				camera.z = my.z;
				camera.pan = my.pan;
				camera.roll = my.roll;
				camera.tilt = my.tilt;
			}

			my.skill2 = my.skill2 - 1 * time;
			if (my.skill2 < 0) { CamShow = int(random(2)) + 1; my.skill2 = random(200) + 150; }
		}

		wait(1);
	}
}

action Cam
{
	while(1)
	{
	   if ((PosM == 1) || (ShowPiposh == 1))
	   {

		if (PIP == null) { wait(1); }

		if ((MoviePhase != 2) && (Warts == 0))
		{
			if (CamShow == my.skill1)
			{
				camera.x = my.x;
				camera.y = my.y;
				camera.z = my.z;
				camera.tilt = my.tilt;
				camera.roll = my.roll;
				camera.pan = my.pan;
			}
		}

           }

		wait(1);
	}
}

action PieceFall
{
	GeniaZ = my.z;
	my.shadow = off;

	while(MoviePhase == 0)
	{
		if ((player.skill2 > 0) && (player.skill3 <= 5))
		{
			my.shadow = on;
			my.z = my.z - 50 * time;
			GeniaZ = my.z;
			my.pan = my.pan + random(2) - 1;
			my.roll = my.roll + random(2) - 1;
			my.tilt = my.tilt + random(2) - 1;
		}
		wait(1);
	}
}

action Grandma
{
	while(1)
	{
		if (Talking == 2) { Talk(); } else { Blink(); }
		if (Ride == 1)
		{
			my.x = my.x + SPD * time;
			my.y = my.y + SPD * time;
		}

		wait(1);
	}
}

function particlefade()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = 300;
		MY_SPEED.X = RANDOM(2)-1;
		MY_SPEED.Y = RANDOM(2)-1;
		MY_SPEED.Z = RANDOM(2)-1;
		MY_COLOR.RED = 128;
		MY_COLOR.GREEN = 128;
		MY_COLOR.BLUE = 128;
	}
	else
	{
		if(MY_AGE > 10) { MY_ACTION = NULL; }
	}
}

action Vespa
{
	while(1)
	{
		if (Ride == 1)
		{
			if (my.skill40 == 0) { play_sound (vespaengine,100); my.skill40 = 1; }

			my.x = my.x + SPD * time;
			my.y = my.y + SPD * time;

			temp = 3 * TIME;
			if(temp > 6) { temp = 6; }
			emit(temp,MY.POS,particlefade);
		}

		wait(1);
	}
}

action PiposhFall
{
	player = my;
	while(MoviePhase == 0)
	{
		if ((player.skill2 > 0) && (player.skill3 <= 5))
		{
			my.z = my.z - 50 * time;
			ent_cycle ("Fall",my.skill1);
			my.skill1 = my.skill1 + 15 * time;
			if (player.skill2 == 20) { player.skill3 = player.skill3 + 3 * time; my.skill1 = 0; }
		}
		if ((player.skill2 > 0) && (player.skill3 >= 5))
		{
			if (my.skill4 != 1) { my.z = my.z + 45; my.skill4 = 1; }
			ent_frame ("Climb",my.skill1);
			my.skill1 = my.skill1 + 3 * time;
			if (my.skill1 > 100) { my.skill2 = -10; }
		}
		if (my.skill2 == -10)
		{
			if (my.skill4 != 2) { my.invisible = on; my.shadow = off; MoviePhase = 1; SetVoice(); my.skill2 = -20; }
		}

	wait(1);
	}
}

action PipTalk
{
	PIP = my;
	exclusive_global;

	while(1)
	{
	    if (PosM == 1)
	    {

		if (Talking == 5) { if (my.skill17 == 0) { my.pan = my.pan - 90; my.skill17 = 1; } }
		if (Talking == 1) { Talk(); } else { Blink(); }

		if ((MoviePhase == 1) || (MoviePhase == 3))
		{
			player = my;
			if ((Talking != 0) && (Scene != 3)) { if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; SetVoice(); } }
			my.invisible = off;
			my.shadow = on;
		}

		if (Ride > 0)
		{
			my.invisible = on;
			my.shadow = off;
		}

		while ((DialogIndex == 7) && (MoviePhase != 3))
		{
			if (DialogChoice == 0) { Blink(); }

			if (DialogChoice == 1) 
			{
				sPlay ("PIP057.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk();  wait(1); }
				sPlay ("BRA002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP058.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk();  wait(1); }
				sPlay ("BRA003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DoDialog(7);
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP059.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk();  wait(1); }
				sPlay ("BRA004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP060.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk();  wait(1); }
				DoDialog(7);
			}

			if (DialogChoice == 3) 
			{
				if (NotAgain == 0)
				{
					NotAgain = 1;
					sPlay ("PIP061.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk();  wait(1); }
					sPlay ("BRA005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
					sPlay ("PIP062.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk();  wait(1); }
					sPlay ("SNG004.WAV");
					MoviePhase = 2;	while (MoviePhase == 2) { wait(1); }
					MoviePhase = 1; sPlay ("BRA006.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
					MoviePhase = 3;
					DialogIndex = 0;
					DialogChoice = 0;
				}
			}

			wait(1);
		}

		while (DialogIndex == 8)
		{
			if (DialogChoice == 0) { Blink(); }

			if (DialogChoice == 1) 
			{
				sPlay ("PIP064.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DialogIndex = 0; Scene = 9; SetVoice(); 
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP065.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DialogIndex = 0; Scene = 9; SetVoice(); 
			}

			if (DialogChoice == 3) 
			{
				Warts = 100;
				pWart.bmap = Wart1;
				pWart.visible = on;

				on_space = null;

				while (Warts > 0)
				{
					OldCamPos.x = camera.x;
					OldCamPos.y = camera.y;
					OldCamPos.z = camera.z;
					OldCamPan.pan = camera.pan;
					OldCamPan.tilt = camera.tilt;
					OldCamPan.roll = camera.roll;

					camera.x = wartcamx.x;
					camera.y = wartcamx.y;
					camera.z = wartcamx.z;
					camera.pan = wartcamx.pan;
					camera.tilt = wartcamx.tilt;
					camera.roll = wartcamx.roll;

					while (my.skill30 == my.skill31) { my.skill30 = int(random(14)) + 1; }
					my.skill31 = my.skill30;

					if (my.skill30 == 1)  { sPlay ("WRT001.WAV"); }
					if (my.skill30 == 2)  { sPlay ("WRT002.WAV"); }
					if (my.skill30 == 3)  { sPlay ("WRT003.WAV"); }
					if (my.skill30 == 4)  { sPlay ("WRT004.WAV"); }
					if (my.skill30 == 5)  { sPlay ("WRT005.WAV"); }
					if (my.skill30 == 6)  { sPlay ("WRT006.WAV"); }
					if (my.skill30 == 7)  { sPlay ("WRT007.WAV"); }
					if (my.skill30 == 8)  { sPlay ("WRT008.WAV"); }
					if (my.skill30 == 9)  { sPlay ("WRT009.WAV"); }
					if (my.skill30 == 10) { sPlay ("WRT010.WAV"); }
					if (my.skill30 == 11) { sPlay ("WRT011.WAV"); }
					if (my.skill30 == 12) { sPlay ("WRT012.WAV"); }
					if (my.skill30 == 13) { sPlay ("WRT013.WAV"); }
					if (my.skill30 == 14) { sPlay ("WRT014.WAV"); }

					my.skill37 = 1;
					while (my.skill37 < 10)
					{
						create (<Wart.pcx>,camera.x,Warty);
						my.skill37 = my.skill37 + 1;
					}

					while (GetPosition(Voice) < 1000000) { wait(1); }

					Warts = Warts - 1;

					if (Warts < 87) { pWart.bmap = Wart3; }
					if (Warts < 67) { pWart.bmap = Wart2; }
					if (Warts < 50) { pWart.bmap = Wart4; }
					if (Warts < 40) { pWart.bmap = Wart5; }
					if (Warts < 30) { pWart.bmap = Wart6; }
					if (Warts < 10) { pWart.bmap = Wart7; }
				}

				camera.x = OldCamPos.x;
				camera.y = OldCamPos.y;
				camera.z = OldCamPos.z;
				camera.pan = OldCamPan.pan;
				camera.tilt = OldCamPan.tilt;
				camera.roll = OldCamPan.roll;

				on_space = FF;

				pWart.visible = off;
				DoDialog (8);
			}

			wait(1);
		}

            }

		wait(1);
	}
}		

action Warty
{
	my.facing = on;
	my.near = on;
	my.ambient = 100;
	my.lightgreen = random(255);
	my.lightred = random(255);
	my.lightblue = random(255);
	my.lightrange = 100;
	my.skill1 = random(1);
	my.scale_x = my.skill1;
	my.scale_y = my.skill1;
	my.scale_z = my.skill1;

	my.x = random(wartcamx.x - 700) + 200;
	my.y = random(wartcamx.y + 200);
	my.z = random(wartcamx.z - 700) + 200;


	While (Warts > 0)
	{
		my.x = my.x + int(random(3)) - 1;
		my.z = my.z + int(random(3)) - 1;
		wait(1);
	}

	remove (my);
}

action WalkGeniaWalk
{
	Genia = my.y;
	PipZ = my.z;
	
	while(MoviePhase == 0)
	{
		if (PosM == 1)
		{
		if (Talking == 3) { Talk(); } else { Blink(); }
		if (my.y > player.y)
		{
			my.y = my.y - 10 * time;
			ent_cycle ("Walk",my.skill1);
			my.skill1 = my.skill1 + 15 * time;
		}
		else
		{
			if (player.z >= my.z - 100)
			{
				if ((GeniaZ - 200) < my.z)
				{
					if (player.skill39 == 0) { sPlay ("SFX090.WAV"); player.skill39 = 1; }
					player.skill2 = 10;
					ent_cycle ("Talk",my.skill1);
					my.skill1 = my.skill1 + 15 * time;
				}
				else
				{
					if (my.skill39 == 0) { sPlay ("SFX122.WAV"); while (GetPosition(Voice) < 1000000) { Talk(); Wait(1);} my.skill39 = 1; }
					player.skill2 = 10;
					ent_cycle ("Stand",my.skill1);
					my.skill1 = my.skill1 + 15 * time;
				}
			}
			else
			{
				if (player.skill40 == 0) { sPlay ("SFX104.WAV"); player.skill40 = 1; }
				player.skill2 = 20;
				_gib(30);
				killgenia();
			}
		}
		}
		
		wait(1);
	}
}

function killgenia { remove(my); }

action Hole
{
	while(1)
	{
		if (player.skill2 == 20)
		{
			my.invisible = on;
		}
	wait(1);
	}
}

action WartCam { WartCamX = my; }

function SetVoice
{
	if (PosM == 1)
	{
		if (Scene == 1) { sPlay ("BRA001.WAV"); Talking = 2; }
		if (Scene == 2) { DoDialog (7); }

		if (Scene == 3) 
		{ 
			pSkuf.visible = on;
			waitt(32);
			pSkuf.visible = off;
			Scene2 = 1; 
			PosM = 2; 
		}

		if (Scene == 4) { CamShow = 1; sPlay ("KVC003.WAV"); Talking = 5; }
		if (Scene == 5) { sPlay ("MAR004.WAV"); Talking = 4; }
		if (Scene == 6) { sPlay ("KVC004.WAV"); Talking = 5; }
		if (Scene == 7) { sPlay ("PIP063.WAV"); Talking = 1; }
		if (Scene == 8) { DoDialog (8); }
		if (Scene == 9) { If (NotAgain == 1) { sPlay ("MAR004.WAV"); Talking = 4; NotAgain = 2; } }
		if (Scene ==10) { sPlay ("PIP066.WAV"); Talking = 1; }
		if (Scene ==11) { Ride = 1; sPlay ("KVC005.WAV"); Talking = 5; }
		if (Scene ==12) { Ride = 2; sPlay ("MAR006.WAV"); Talking = 4; }
		if (Scene ==13) { sPlay ("KVC006.WAV"); Talking = 5; }
		if (Scene ==14) { sPlay ("MAR007.WAV"); Talking = 4; }
		if (Scene ==15) { ReturnToMap(); }
	}

	if (PosM == 2)
	{
		if (Scene2 == 1 ) { sPlay ("NAN001.WAV"); }
		if (Scene2 == 2 ) { sPlay ("ROG002.WAV"); }
		if (Scene2 == 3 ) { sPlay ("NAN002.WAV"); }
		if (Scene2 == 4 ) { sPlay ("ROG003.WAV"); }
		if (Scene2 == 5 ) { sPlay ("MAR002.WAV"); PrevZ = Pip.z; Pip.z = Pip.z - 1000; ShowPiposh = 1; Quick1 = 1; CamShow = 1; }
		if (Scene2 == 6 ) { sPlay ("KVC001.WAV"); ShowPiposh = 0; Quick1 = 0; }
		if (Scene2 == 7 ) { sPlay ("NAN003.WAV"); ShowPiposh = 1; Quick2 = 1; CamShow = 1;}
		if (Scene2 == 8 ) { sPlay ("MAR003.WAV"); }
		if (Scene2 == 9 ) { sPlay ("KVC002.WAV"); Pip.Z = PrevZ; ShowPiposh = 0; Quick2 = 0; }
		if (Scene2 == 10) { sPlay ("NAN004.WAV"); }

		if (Scene2 == 11) { Scene = 4; DontCome = 0; PosM = 1; SetVoice(); }
	}
}

function stream()
{
	// just born?
	if(MY_AGE == 0)
	{
		MY_SPEED.X = -PeeStr + (random(2) - 1) / 10; //scatter_speed.X + RANDOM(scatter_spread) - (scatter_spread/2);
		MY_SPEED.Y = PeeStr + (random(2) - 1) / 10;  //scatter_speed.Y + RANDOM(scatter_spread) - (scatter_spread/2);
		MY_SPEED.Z = PeeStr + (random(2) - 1) / 10; //scatter_speed.Z + RANDOM(scatter_spread) - (scatter_spread/2);

		MY_SIZE = scatter_size;
		MY_MAP = bpee;
		MY_FLARE = ON;
		my_transparent = on;
		return;
	}
	// Add gravity
	MY_SPEED.Z -= scatter_gravity;
	// Maybe add random term to age
	//	MY_AGE += RANDOM(0.05);

	if(MY_AGE >= scatter_lifetime)
	{
		MY_ACTION = NULL;
	}
}

action PipPee
{
	while(1)
	{
		if (Quick2 == 1) 
		{ 
			my.invisible = off; 
			my.shadow = on; 
			if (PeeStr > 0) { PeeStr = PeeStr - 0.03 * time; }
			if (PeeStr < 2) { ent_frame ("Look",0); } else { ent_frame ("Stand",0); }
			temp.x = my.x;
			temp.y = my.y;
			temp.z = my.z - 20;
			emit 2,temp.x,stream;
		}
		else 
		{ 
			my.invisible = on; 
			my.shadow = off; 
		}
		
		wait(1);
	}
}

action PipSit
{
	while(1)
	{
		if (Quick1 == 1) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }
		wait(1);
	}
}

action Mendy
{
	while(1)
	{
		if (Quick1 == 1) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }
		ent_cycle ("Stand",my.skill1);
		my.skill1 = my.skill1 + 10 * time;
		wait(1);
	}
}

action Ami
{
	while(1)
	{
		if (Quick1 == 1) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }
		talk();
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

action Cam2
{
	while(1)
	{
		if (PosM == 2)
		{

		if (GetPosition(Voice) >= 1000000) { Scene2 = Scene2 + 1; SetVoice(); }

		else
		{
			CamDelay = CamDelay - 1 * time;

			if (CamDelay < 0) { if (int(random(100)) == 50) { if (CamMark == 1) { CamMark = 2; } else { CamMark = 1; } CamDelay = random(50) + 50; } }
			if ((CamMark == my.skill1) && (ShowPiposh == 0))
			{
				camera.x = my.x;
				camera.y = my.y;
				camera.z = my.z;
				camera.pan = my.pan;
				camera.tilt = my.tilt;
				camera.roll = my.roll;
			}
		}

		}

		wait(1);
	}
}

action Vespa2
{
	my.skill20 = my.y;
	TheVespa = my;
}

action Dummy
{
	while(1)
	{
		if (int(random(80)) == 40) { AddTraffic(); }
		wait(1);
	}
}

function AddTraffic
{
	Type = int(random(6)) + 1;
	if (Type == 1) { Create (<OilTank.mdl>,my.x,Traffic); }
	if (Type == 2) { Create (<FarmTruk.mdl>,my.x,Traffic); }
	if (Type == 3) { Create (<Mechbesh.mdl>,my.x,Traffic); }
	if (Type == 4) { Create (<WarCar.mdl>,my.x,Traffic); }
	if (Type == 5) { Create (<SportCar.mdl>,my.x,Traffic); }
	if (Type == 6) { Create (<Taxi.mdl>,my.x,Traffic); }
}
	
action Move
{
	my.pan = random(360);

	while (my.z < TheVespa.z - 30)
	{
		my.z = my.z + 10*time;
		wait(1);
	}

	while(1)
	{
		my.y = my.y - 50*time;
		wait(1);
		if (my.y < TheVespa.y - 5000) { Kill(); }
	}
}

action KillEntity
{
	Remove (you);
}

action Killer
{
	my.event = KillEntity;
	my.enable_entity = on;
}

function Kill { Remove(my); }

function particlefade()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = 600;
		MY_SPEED.X = RANDOM(2)-1;
		MY_SPEED.Y = RANDOM(2)-1;
		MY_SPEED.Z = RANDOM(2)-1;
		MY_COLOR.RED = 0;
		MY_COLOR.GREEN = 0;
		MY_COLOR.BLUE = 0;
	}
	else
	{
		//MY_COLOR.RED += (fade_targetcolor.RED - MY_COLOR.RED)*0.2;
		//MY_COLOR.GREEN += (fade_targetcolor.GREEN - MY_COLOR.GREEN)*0.2;
		//MY_COLOR.BLUE += (fade_targetcolor.BLUE - MY_COLOR.BLUE)*0.2;

		if(MY_AGE > 10) { MY_ACTION = NULL; }
	}
}

action Traffic
{
	my.scale_x = my.scale_x * 2;
	my.scale_y = my.scale_y * 2;
	my.scale_z = my.scale_z * 2;

	my.push = 200;
	my.skill30 = 1;
	my.ambient = 50;

	while(1)
	{
		if ((int(random(100)) == 50) && (PosM == 2))
		{ 
			my.skill40 = int(random(3)) + 1;
			if (my.skill40 == 1) { play_entsound (my,Honk1,500); }
			if (my.skill40 == 2) { play_entsound (my,Honk2,500); }
			if (my.skill40 == 3) { play_entsound (my,Honk3,500); }
		}

		my.y = my.y - 150 * time;
	
		my.skill1 = my.skill1 + 1 * time;
		if (my.skill1 > 300) { kill(); }

		wait(1);
	}
}

action Actor
{
	while (1)
	{
		if (Scene2 != 10)
		{
			if (TalkingNow == my.skill2) { Talk(); } else { Blink(); ent_cycle ("Stand",my.skill1); }
		}
		else
		{
			if (TalkingNow == my.skill2) { Talk2(); if (int(random(20)) == 10) { ent_frame ("Oh",random(100)); } } else { Blink(); ent_cycle ("Stand",my.skill1); }
		}

		my.skill1 = my.skill1 + 10 * time;

		wait(1);
	}
}

action RollFilm
{
	while(1)
	{
		if ((SCene2 == 1) || (Scene2 == 3) || (Scene2 == 7) || (Scene2 == 10)) { TalkingNow = 1; }
		if ((Scene2 == 2) || (Scene2 == 4)) { TalkingNow = 2; }
		if ((SCene2 == 5) || (SCene2 == 8)) { TalkingNow = 3; }
		if ((SCene2 == 6) || (Scene2 == 9)) { TalkingNow = 4; }
		wait(1);
	}
}