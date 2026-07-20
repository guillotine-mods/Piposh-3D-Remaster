include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var MoviePhase = 0;
var Talking = 0;
var Dial = 0;
var Scene = 0;
var Type = 0;
var Hold = 0;
var CamShow = 1;
var WithPhone = 0;
var Cam2Show = 0;

synonym syndocs { type entity; }

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	fog_color = 1;
	vNoSave = 1;

	load_level(<Intro3.WMB>);

	VoiceInit();
	Initialize();

	SKY_MAP = sky;
	scene_map = bmapBack6;

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running

	night = 1;
	storm();

	SetVoice();
}

action Cam2
{
	while (1)
	{
		if (Cam2Show == 1)
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

action Dome
{
	my.skin = 3;
	while(1) { my.pan = my.pan + 0.1; wait(1); }
}

action Cam
{
	while(1)
	{
		if (Cam2Show == 0)
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

			if (MoviePhase != 0)
			{
				my.skill2 = my.skill2 - 1 * time;
				if (my.skill2 < 0) { CamShow = int(random(3)) + 1; my.skill2 = random(200) + 150; }
			}
		}

		wait(1);
	}
}

action PiposhCell
{
	player = my;
	actor_init();
	drop_shadow();
	my.skill1 = 0;

	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }

	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
		if (Talking != 0) { if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; SetVoice(); } }

		while (Dialog.visible == on) { Blink(); wait(1); }

		if (Scene == 3)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP259.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("SHK039.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("EFI001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				Scene = 4; SetVoice();
			}

			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP260.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				Scene = 4; SetVoice();
			}

			if (DialogChoice == 3) 
			{ 
				sPlay ("PIP261.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("EFI002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("SHK040.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("PIP262.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("EFI003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				Scene = 4; SetVoice();
			}
		}

		if (Scene == 7)
		{
			if (DialogChoice == 1) 
			{ 
				WithPhone = 0; sPlay ("PIP263.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("EFI005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				DoDialog (33);
			}

			if (DialogChoice == 2) 
			{ 
				WithPhone = 1; sPlay ("PIP265.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("EFI005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				DoDialog (33);

			}

			if (DialogChoice == 3) 
			{ 
				Scene = 8; SetVoice();
			}
		}

		if (Scene == 14)
		{
			if (DialogChoice == 1) 
			{ 
				WithPhone = 0; sPlay ("PIP269.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("EFI008.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				DoDialog (34);
			}

			if (DialogChoice == 2) 
			{ 
				WithPhone = 0; sPlay ("PIP270.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("EFI008.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				DoDialog (34);

			}

			if (DialogChoice == 3) 
			{ 
				Scene = 15; SetVoice();
			}
		}

		if (Scene == 24)
		{
			if (DialogChoice == 1) 
			{ 
				WithPhone = 0; sPlay ("PIP276.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("EFI013.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { TalkBlink();  wait(1); }
				DoDialog (35);
			}

			if (DialogChoice == 2) 
			{ 
				Scene = 25; SetVoice();
			}

			if (DialogChoice == 3) 
			{ 
				WithPhone = 0; sPlay ("PIP277.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("EFI014.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { TalkBlink();  wait(1); }
				DoDialog (35);
			}
		}

		if (Scene == 32)
		{
			if (DialogChoice == 1) 
			{ 
				WithPhone = 0; sPlay ("PIP281.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("DOC007.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { TalkBlink();  wait(1); }
				sPlay ("EFI018.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { TalkBlink();  wait(1); }

				Flag_First_Asylum = 1;
				WriteGameData (0);
				Run ("AsyAct1.exe");
			}

			if (DialogChoice == 2) 
			{ 
				WithPhone = 0; sPlay ("PIP282.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("DOC007.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("EFI018.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }

				Flag_First_Asylum = 1;
				WriteGameData (0);
				Run ("AsyAct1.exe");
			}

			if (DialogChoice == 3) 
			{ 
				WithPhone = 0; sPlay ("PIP283.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { TalkBlink(); wait(1); }
				sPlay ("DOC007.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { TalkBlink();  wait(1); }
				sPlay ("EFI018.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { TalkBlink();  wait(1); }

				Flag_First_Asylum = 1;
				WriteGameData (0);
				Run ("AsyAct1.exe");
			}
		}

		TalkBlink(); 

		wait(1);
	}
}

function TalkBlink
{
		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		if (result < 25) { ent_nextpoint(my._TARGET_X); }

		if (Dial < 20) 
		{ 
			Blink();
			ent_frame ("Dial",Dial);
			Dial = Dial + 2 * time; 
		}
		else
		{
			if (syndocs.invisible == on)
			{
				if ((int(random(100)) == 50) && (Type <= 0)) { Type = 50; }

				if (Type <= 0)	// Walking and talking
				{
					force = 2;
					actor_turnto(my_angle.PAN);
					force = 3;
					actor_move(); 
					if (Talking == 1) { Talk2(); } else { Blink2(); }
					if (WithPhone == 0) { ent_cycle ("WWalk",my.skill40); } else { ent_cycle ("Walk",my.skill40); }
					my.skill40 = my.skill40 + 5 * time;
				}
				else			// Standing and talking
				{
					Type = Type - 1 * time;
					if (Talking == 1) { Talk(); } else { Blink(); }
				}
			}
			else
			{
				vec_set(temp,syndocs.x);
				vec_sub(temp,my.x);
				vec_to_angle(my.pan,temp);
				if (Talking == 1) { Talk(); } else { Blink(); }
			}
		}
}

action Tree { my.pan = random(360); }

action Docs
{
	syndocs = my;
	my.invisible = on;
	my.shadow = off;

	while(1)
	{
		if (Scene > 30) { my.invisible = off; my.shadow = on; }
		vec_set(temp,player.x);
		vec_sub(temp,my.x);
		vec_to_angle(my.pan,temp);
		if (Talking == 3) { Talk(); } else { Blink(); }
		wait(1);
	}
}

action Effy
{
	my.skill1 = my.x;
	my.skill22 = 22;

	while(1)
	{
		if (MoviePhase == 1)
		{
			if (my.x > (my.skill1 - 300)) 
			{ 
				my.x = my.x - 15 * time; 
				ent_cycle ("Walk",my.skill2); 
				my.skill2 = my.skill2 + 20 * time; 
			}
			else { MoviePhase = 2; }
		}

		if (MoviePhase == 2)
		{
			my.x = my.x - my.skill22 * time;
			my.skill22 = my.skill22 - 1 * time;;
			ent_cycle ("Voosh",0);
			if (my.skill22 < 0) { ent_frame ("Stand",0); MoviePhase = 3; }
		}

		if (MoviePhase == 3)
		{
			if (Hold == 0) { if (Talking == 2) { Talk(); } else { Blink(); } }
			vec_set(temp,player.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);
			my.tilt = 0;
			my.roll = 0;

			if (Hold == 1)
			{
				if (my.skill40 == 0) { ent_frame ("Hold",0); my.skill40 = 1; }
				if (Talking == 2) { Talk2(); if (int(random(30)) == 15) { ent_frame ("Hold",(int(random(4))) * 33.3); } } else { ent_frame ("Hold",0); Blink2(); }
				my.x = player.x;
				my.y = player.y;
				my.z = player.z + 90;
				my.pan = player.pan;
			}
		}

	wait(1);
	}
}

action Running
{
	actor_init();
	drop_shadow();

	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found

	ent_waypoint(my._TARGET_X,1);

	while (MoviePhase == 0)
	{
		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		if (result < 25) { ent_nextpoint(my._TARGET_X); my.skill3 = my.skill3 + 1; }
		if (my.skill3 > 15) { MoviePhase = 1; }

		if ((int(random(100)) == 50) && (my.skill1 == 0)) { my.skill1 = 100; }

		if (MoviePhase == 0)
		{
			force = 4;
			actor_turnto(my_angle.PAN);
			force = 4;
			actor_move();
		}

		wait(1);
	}
}

function SetVoice
{
	if (Scene ==  0) { sPlay ("Wait.wav"); Talking = 10; WithPhone = 1; }
	if (Scene ==  1) { sPlay ("PIP258.WAV"); Talking = 1; }
	if (Scene ==  2) { sPlay ("SHK038.WAV"); Talking = 4; }
	if (Scene ==  3) { DoDialog (32); }
	if (Scene ==  4) { sPlay ("SHK041.WAV"); Talking = 4; }
	if (Scene ==  5) { sPlay ("SHK042.WAV"); Talking = 4; }
	if (Scene ==  6) { sPlay ("EFI004.WAV"); Talking = 2; }
	if (Scene ==  7) { DoDialog (33); }
	if (Scene ==  8) { sPlay ("PIP266.WAV"); Talking = 1; WithPhone = 0; }
	if (Scene ==  9) { sPlay ("EFI006.WAV"); Talking = 2; }
	if (Scene == 10) { sPlay ("PIP267.WAV"); Talking = 1; }
	if (Scene == 11) { sPlay ("EFI007.WAV"); Talking = 2; }
	if (Scene == 12) { sPlay ("PIP268.WAV"); Talking = 1; }
	if (Scene == 13) { sPlay ("EFI008.WAV"); Talking = 2; }
	if (Scene == 14) { DoDialog (34); }
	if (Scene == 15) { sPlay ("PIP271.WAV"); Talking = 1; WithPhone = 0; }
	if (Scene == 16) { sPlay ("PIP272.WAV"); Talking = 1; }
	if (Scene == 17) { sPlay ("EFI009.WAV"); Talking = 2; }
	if (Scene == 18) { sPlay ("EFI010.WAV"); Talking = 2; }
	if (Scene == 19) { sPlay ("PIP273.WAV"); Talking = 1; }
	if (Scene == 20) { sPlay ("PIP274.WAV"); Talking = 1; WithPhone = 1; }
	if (Scene == 21) { sPlay ("EFI011.WAV"); Talking = 2; }
	if (Scene == 22) { sPlay ("PIP275.WAV"); Talking = 1; }
	if (Scene == 23) { sPlay ("EFI012.WAV"); Talking = 2; Hold = 1; }
	if (Scene == 24) { DoDialog (35); }
	if (Scene == 25) { sPlay ("PIP278.WAV"); Talking = 1; WithPhone = 0; }
	if (Scene == 26) { sPlay ("EFI015.WAV"); Talking = 2; }
	if (Scene == 27) { sPlay ("PIP279.WAV"); Talking = 1; }
	if (Scene == 28) { sPlay ("EFI016.WAV"); Talking = 2; }
	if (Scene == 29) { sPlay ("PIP280.WAV"); Talking = 1; }
	if (Scene == 30) { Cam2Show = 1; sPlay ("DOC006.WAV"); Talking = 3; }
	if (Scene == 31) { Cam2Show = 0; sPlay ("EFI017.WAV"); Talking = 2; }
	if (Scene == 32) { DoDialog (36); }
}

action Poz
{
	while (1) { talk(); wait(1); }
}

function DoDialog (num)
{
	DialogChoice = 0;
	DialogIndex = num; 
	ShowDialog();
	Talking = 0;
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) 
	{ 
		if (my == player) 
		{ 
			if (WithPhone == 0) 
			{ 
				ent_frame ("WTalk",int(random(5)) * 25); 
			} 
			else
			{ 
				ent_frame ("Talk",int(random(8)) * 14.2); 
			} 

		}
		else { ent_frame ("Talk",int(random(5)) * 25); } }
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

function lightning ()
{
	temp = RANDOM(20);
	IF (temp <=10 ) {lightning1 ();}
	ELSE {lightning2 ();}
}

function lightning1 ()
{
	create <blitz.pcx>,temp,lightning_ent;
	play_sound (thunder,50);
	SKY_MAP = sky_light;
	CAMERA.FOG -= 80;
	WAITT	1;
	SKY_MAP = sky_light2;
	CAMERA.FOG += 30;
	WAITT	2;
	CAMERA.FOG += 20;
	WAITT	1;
	SKY_MAP = sky_light;
	CAMERA.FOG -= 40;
	WAITT	3;
	SKY_MAP = sky_light2;
	CAMERA.FOG += 30;
	WAITT	1;
	SKY_MAP = sky;
	CAMERA.FOG += 40;
	WAITT	2;
	SKY_MAP = sky_light2;
	CAMERA.FOG -= 30;
	WAITT	1;
	SKY_MAP = sky;
	CAMERA.FOG += 30;
}

function lightning2 ()
{
	create <blitz.pcx>,temp,lightning_ent;
	play_sound (thunder,50);
	SKY_MAP = sky_light;
	CAMERA.FOG -= 80;
	WAITT	4;
	SKY_MAP = sky_light2;
	CAMERA.FOG += 50;
	WAITT	3;
	SKY_MAP = sky_light;
	CAMERA.FOG -= 40;
	WAITT	2;
	SKY_MAP = sky;
	CAMERA.FOG += 70;
}