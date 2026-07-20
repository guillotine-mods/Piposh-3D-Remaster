include <IO.wdl>;

synonym Piposh { type entity; }

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; 	 // 16 bit colour D3D mode
var Counter = 0;
var MovPos = 0;
var FCloud = 0;
var Talking = 0;
var Scene = 1;
var PipOrigX;
var PipOrigY;
var KidOrigX;
var KidOrigY;
var NatOrigY;
var I[3] = 0,0,0;
var Dancing = 0;
var CamShow = 0;
var MovTemp = 0;
var SND = 0;
var Eat = 0;
var Shulov = 0;
var MoviePlaying = 0;
var SoundPlaying = 0;

sound FogHorn = <SFX049.WAV>;
sound Ocean = <SFX051.WAV>;
sound Eating = <SFX118.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	vNoSave = 1;

	load_level(<Intro2.WMB>);

	VoiceInit();
	Initialize();

	scene_map = bmapBack2;

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running
}

action Boat 
{ 
	while(1) 
	{ 
		my.y = my.y - 0.5 * time; 
		if (int(random(200)) == 100) { play_entsound (my,foghorn,750); }
		wait(1); 
	} 
}

action Dome
{
	my.skin = 1;
	while(1) { my.pan = my.pan + 0.1 * time; wait(1); }
}

action Cam
{
	while(1)
	{
		if (MovPos == 0)
		{
			vec_set(temp,player.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

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

action Cam2
{
	while(1)
	{
		if ((MovPos > 0) && (Talking != 5))
		{
			if (Talking == 6) { CamShow = 1; }

			if (CamShow == my.skill1)
			{
				camera.x = my.x;
				camera.y = my.y;
				camera.z = my.z;
				camera.tilt = my.tilt;
				camera.roll = my.roll;
				camera.pan = my.pan;
			}

			if ((CamShow != 3) && (Talking != 6))
			{
				my.skill2 = my.skill2 - 1 * time;
				if (my.skill2 < 0) { CamShow = int(random(2)) + 1; my.skill2 = random(200) + 150; }
			}
		}
		wait(1);
	}
}

action CamBuga
{
	while(1)
	{
		if ((MovPos > 0) && (Talking == 5))
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.tilt = my.tilt;
			camera.roll = my.roll;
			camera.pan = my.pan;
		}

		wait(1);
	}
}

action Dome { my.skin = 1; while(1) { my.pan = my.pan + 0.2 * time; wait(1); } }

function SkipDrive { Counter = 76; }

action DrivePath
{
	player = my;
	actor_init();
	drop_shadow();

	sPlay ("SFX050.WAV");

	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }
	my._movemode = 3;

	ent_waypoint(my._TARGET_X,1);

	while (Counter < 75)
	{
		if (GetPosition (Voice) >= 1000000) { sPlay ("SFX050.WAV"); }
		on_space = SkipDrive;
		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		if (result < 25) { ent_nextpoint(my._TARGET_X); Counter = Counter + 1; }

		force = 3;
		actor_turnto(my_angle.PAN);
		force = 10;
		actor_move();

		wait(1);
	}

	on_space = FF;
	MovPos = 1;
	SetVoice();
}

ACTION Piposh2
{
	while (1)
	{
		if (MovPos > 0) { my.invisible = on; } else { my.invisible = off; }
		my.skill10 = my.skill10 + 30 * time;
		if (my.skill10 == 1000) { my.skill10 = 0; }

		my.x = player.x;
		my.y = player.y;
		my.z = player.z - 9 * time;
		my.pan = player.pan;
		my.tilt = player.tilt;
		my.roll = player.roll;
		wait (1);
	 }
}

ACTION Grandma
{
	while (1)
	{
		my.skill10 = my.skill10 + 30 * time;
		if (my.skill10 == 1000) { my.skill10 = 0; }

		my.x = player.x;
		my.y = player.y;
		my.z = player.z - 9 * time;
		my.pan = player.pan;
		my.tilt = player.tilt;
		my.roll = player.roll;
		wait (1);
	 }
}

action Dummy
{
	while(1)
	{
		if (snd_playing(SND) == 0) { play_entsound (my,Ocean,750); SND = result; }
		wait(1);
	}
}

action Piposh3
{
	Piposh = my;
	PipOrigY = my.y;
	PipOrigX = my.x;

	while(1)
	{
		if (MovPos > 0)
		{
		my.invisible = off;
		my.shadow = on;

		if ((Talking > 0) && (Scene > 1)) { if (GetPosition(Voice) >= 1000000) { my.skin = 1; Talking = 0; Scene = Scene + 1; SetVoice(); } }
		if ((Talking > 0) && (Scene == 1)) { if (GetPosition(Voice) >= 1000000) { Talking = 0; Blink(); } }

		if (DialogIndex == 11)
		{
			while (Dialog.visible == on) { Blink(); wait(1); }

			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP089.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("WIF001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("SHA001.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP090.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("WIF002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DialogIndex = 0;
				Talking = 0;
				MoviePlaying = 0;
			}
		
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP091.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("WIF003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DialogIndex = 0;
				Talking = 0;
				MoviePlaying = 0;
			}
	
			if (DialogChoice == 3) 
			{
				sPlay ("PIP092.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("WIF004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("SHA002.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP093.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				Shulov = 1;
				sPlay ("SHA003.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				shulov = 2;
				while (Shulov == 2) { wait(1); }
				MovPos = 2;
				sPlay ("PIP094.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DialogIndex = 0;
				Talking = 0;
				MoviePlaying = 0;
			}
		}

		if (DialogIndex == 12)
		{
			while (Dialog.visible == on) { Blink(); wait(1); }

			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP096.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DialogIndex = 0;
				Talking = 0;
				MoviePlaying = 0;
			}
		
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP097.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("KID003.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				if (MovPos == 1) { sPlay ("SHA004.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); } }
				if (MovPos == 2) { sPlay ("SHA005.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); } MovPos = 3; sPlay ("KID002.WAV"); }

				DialogIndex = 0;
				Talking = 0;
				MoviePlaying = 0;
			}
	
			if (DialogChoice == 3) 
			{
				sPlay ("PIP098.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				CamShow = 3;
				sPlay ("JOK0101.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0102.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK0103.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("laugh.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
				CamShow = 1;
				DialogIndex = 0;
				Talking = 0;
				MoviePlaying = 0;
			}
		}

		if (DialogIndex == 13)
		{
			while (Dialog.visible == on) { Blink(); wait(1); }

			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP099.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP100.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk2(); CamShow = 1; wait(1); }
				ent_frame ("Stand",0); sPlay ("PIP101.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); CamShow = 1; wait(1); }
				morph (<PipCell.mdl>,my);
				my.skill30 = 0;
				my.skill31 = - 6;
				while (my.skill30 < 100) { ent_frame ("Dial",my.skill30); my.skill30 = my.skill30 + 2 * time; my.skill31 = my.skill31 + 1 * time; if (my.skill31 > 8) { sPlay("TIK.WAV"); my.skill31 = 0; } CamShow = 1; wait(1); }
				ent_frame ("Stand",0);
				sPlay ("PIP102.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk3(); CamShow = 1; wait(1); }
				morph (<Piposh.mdl>,my);
				ent_frame ("Stand",0);
				sPlay ("PIP103.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DoDialog (13);
			}
		
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP104.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("MNO002.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP105.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DoDialog (13);
			}
	
			if (DialogChoice == 3) 
			{
				sPlay ("PIP106.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("MNO003.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP107.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				DoDialog (14);
			}
		}

		if (DialogIndex == 14)
		{
			morph (<PipSong.mdl>,my);

			while (Dialog.visible == on) { Blink(); wait(1); }

			if (DialogChoice == 1) 
			{ 
				I.x = 1;
				sPlay ("PIP108.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("MNO004.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP109.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				EndIt();
			}
		
			if (DialogChoice == 2) 
			{ 
				I.y = 1;
				sPlay ("PIP110.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("MNO005.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP111.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("MNO006.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP112.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("MNO007.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP113.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				EndIt();
			}
	
			if (DialogChoice == 3) 
			{
				I.z = 1;
				sPlay ("PIP114.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				Dancing = 1; sPlay ("SNG011.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { Talk(); ent_cycle ("Sing",my.skill30); my.skill30 = my.skill30 + 10 * time; wait(1); }
				Dancing = 0; sPlay ("PIP115.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				EndIt();
			}
		}

		if (MovPos != 3)
		{
			if (Talking == 1) { Talk(); } else { Blink(); }
		}
		else
		{
			ent_frame ("Fetch",66);

			while (MovTemp < 50)
			{
				if ((my.y < KidOrigY) && (my.x > KidOrigX))
				{
					my.y = my.y + 5 * time;
					if (my.y > (KidOrigY + PipOrigY) / 2) { my.z = my.z - 5 * time; } else { my.z = my.z + 5 * time; }
					if (my.x > KidOrigX) { my.x = my.x - 5 * time; }
 				}

				else
				{
					my.invisible = on;
					FCloud = 1;
					MovTemp = MovTemp + 1 * time;
				}
				
				wait(1);
			}

			ent_frame ("stand",0); 
			FCloud = 0; 
			MovPos = 5; 
			Scene = 2; 
			Talking = 5;
			SoundPlaying = 1;
			sPlay ("SFX142.WAV"); while (GetPosition (Voice) < 1000000) { wait(1); }
			SoundPlaying = 0;
			SetVoice(); 
			my.x = PipOrigX; 
			my.y = PipOrigY; 
			my.invisible = off; 
		}
	}

	wait(1);
	}
}

function EndIt
{
	if ((I.x == 1) && (I.y == 1) && (I.z == 1)) { morph (<Piposh.mdl>,my); DialogIndex = 0; Talking = 0; Scene = 4; SetVoice(); } else { DoDialog (14); }
}

action Mom
{
	while(1)
	{
		if (Talking == 2) { Talk(); } else { Blink(); }
		if (Dancing == 1) { Dance(); }
		wait(1);
	}
}

action Sholov 
{ 
	if (MoviePlaying == 1) { return; }

	if (MovPos < 2) { MoviePlaying = 1; DoDialog (11); }
}
action KidTalk 
{ 
	if (MoviePlaying == 1) { return; }

	MoviePlaying = 1;

	if (MovPos < 3) 
	{ 
		sPlay ("PIP095.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		sPlay ("KID001.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		DoDialog (12); 
	} 
}

action Dad
{
	my.enable_click = on;
	my.event = Sholov;

	while(1)
	{
		if (Talking == 3) { Talk(); } else { Blink(); }

		if ((MovPos >=2) && (MovPos < 4)) { if (snd_playing (EAT) == 0) { play_entsound (my,eating,400); EAT = result; } ent_cycle ("Eat",my.skill1); my.skill1 = my.skill1 + 15 * time; my.skill45 = my.skill45 + 1 * time; if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; } }

		if (Dancing == 1) { stop_sound (EAT); Dance(); }

		if (Shulov == 1) { ent_cycle ("Dance",my.skill30); my.skill30 = my.skill30 + 20 * time; }
		if (Shulov == 2)
		{
			my.skill39 = 1;
			my.skill30 = 0;

			while (my.Skill39 == 1) { ent_cycle ("Run",my.skill30); my.skill30 = my.skill30 + 15 * time; my.y = my.y - 20 * time; if (my.skill30 > 500) { my.skill30 = 0; my.skill39 = 2; my.pan = my.pan + 180; } wait(1); }
			while (my.Skill39 == 2) { ent_cycle ("Run",my.skill30); my.skill30 = my.skill30 + 15 * time; my.y = my.y + 20 * time; if (my.skill30 > 500) { my.skill30 = 0; my.skill39 = 3; my.pan = my.pan + 180; } wait(1); }
			if (my.skill39 == 3) { Shulov = 0; }
		}
		wait(1);
	}
}

function Dance { ent_cycle ("Dance",my.skill30); my.skill30 = my.skill30 + 10 * time; }

action Kid
{
	my.event = KidTalk;
	my.enable_click = on;

	KidOrigY = my.y;
	KidOrigX = my.x;

	while(1)
	{
		if (FCloud == 1) { my.invisible = on; } else { my.invisible = off; }
		if (MovPos < 3) 
		{ 
			if (my.skill2 <= 0) 
			{ 
				if (Talking == 4) { Talk(); }
				else
				{
					blink2();
					ent_frame ("Stand",my.skill1); 
					my.skill1 = my.skill1 + 15 * time; 
					if (my.skill1 > 100) 
					{ 
						my.skill1 = 0; 
						ent_frame ("stand",0); 
						my.skill2 = random(30); 
					} 
				}
			} 
			else { my.skill2 = my.skill2 - 1 * time; }
		} 
		else { ent_cycle ("Cry",my.skill1); my.skill1 = my.skill1 + 30 * time; }

		if (Dancing == 1) { Dance(); }

		wait(1);
	}
}

action Bang
{
	while(1)
	{
		if (FCloud == 1) { my.invisible = off; } else { my.invisible = on; }
		
		my.pan = my.pan + 60 * time;
		my.tilt = my.tilt + 60 * time;
		my.roll = my.roll + 60 * time;

		ent_cycle ("Frame",my.skill1);
		my.skill1 = my.skill1 + 6 * time;
		
	wait(1);
	}
}

action NativeY
{
	while(1)
	{
		if (MovPos > 4) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }
		blink();
		wait(1);
	}
}

action Native1
{
	while(1)
	{
		if (MovPos > 4) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }

		if (SoundPlaying == 1) { Blink(); }
		else
		{		
			if (Talking == 5) { Talk(); } else { Blink(); }
		}

		if (Dancing == 1) { Dance(); }

		wait(1);
	}
}

action Native2
{
	NatOrigY = my.y;

	my.y = my.y - 200;

	while(1)
	{
		if (MovPos > 5) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }

		if (MovPos == 6)
		{
			if (my.y < NatOrigY) { my.y = my.y + 3 * time; ent_cycle ("Walk",my.skill1); my.skill1 = my.skill1 + 15 * time; }
			else
			{
				if (Talking == 6) { Talk(); } else { Blink(); }
			}
		}

		if (Dancing == 1) { Dance(); }

		wait(1);
	}
}

function SetVoice
{
	if (Scene == 0) { sPlay ("Wait.wav"); }
	if (Scene == 1) { sPlay ("PIP088.WAV"); Talking = 1; }
	if (Scene == 2) { sPlay ("MNO001.WAV"); Talking = 5; }
	if (Scene == 3) { DoDialog (13); }
	if (Scene == 4) { MovPos = 6; sPlay ("MNO009.WAV"); Talking = 5; }
	if (Scene == 5) { sPlay ("KZK001.WAV"); Talking = 6; }
	if (Scene == 6) { sPlay ("MNO010.WAV"); Talking = 5; }
	if (Scene == 7) { sPlay ("KZK002.WAV"); Talking = 6; }
	if (Scene == 8) { Run ("VilInt.exe"); }
}

action KN
{
	while(1)
	{
		if (CamShow == 3) { my.invisible = off; } else { my.invisible = on; }
		if (Talking == 10) { ent_cycle ("KTalk",my.skill1); }
		if (Talking == 20) { ent_cycle ("NTalk",my.skill1); }
		if (Talking == 0) { ent_cycle ("Stand",my.skill1); }
		my.skill1 = my.skill1 + 10 * time;
		wait(1);
	}
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { if (my == Piposh) { ent_frame ("Talk",int(random(8)) * 14.2); } else { ent_frame ("Talk",int(random(6)) * 20); } }
}

function Talk2()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(10)) == 5) { ent_frame ("Dance",(int(random(22)) * 4.5)/2); }
}

function Talk3()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(10)) == 5) { ent_frame ("Dance",(int(random(22)) * 4.5)/2); }
	if (int(random(40)) == 20) { ent_frame ("Sit",int(random(5)) * 25); }
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