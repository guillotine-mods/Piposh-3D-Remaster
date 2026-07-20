include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Scene = -1;
var CamTemp = 1;
var CamDelay = 0;
var CamShow = 1;
var Talking = 0;
var AlarmNow = 0;
var DangerZ;

sound Engine = <SFX064.WAV>;
sound Alarm1 = <"SFX129.WAV">;
sound SFX017 = <SFX017.WAV>;

bmap bMeanwhile = <mod2.pcx>;

panel pMeanwhile
{
	bmap = bMeanwhile;
	layer = 20;
	flags = visible,d3d,refresh;
}


/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	vNoSave = 1;

	level_load("Intro11.wmb");

	VoiceInit();
	Initialize();

	scene_map = bmapBack6;

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running

	waitt(60);
	pMeanwhile.visible = off;
}

action Intro11
{
	while(1)
	{
		my.skin = int(random(10)) + 1;
		waitt (64);
	}
}

action IntroCam
{
	my.skill2 = random(200) + 150; 
	while(1)
	{
		if ((Scene >= 8) && (CamShow == my.skill1))
		{
			if ((GetPosition(Voice) >= 1000000) && (Scene != 11) && (Scene != 13) && (Scene != 16)) { Scene = Scene + 1; SetVoice(); }

			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.roll = my.roll;
			camera.tilt = my.tilt;
		}

		if (CamShow < 3)
		{
			my.skill2 = my.skill2 - 1 * time;
			if (my.skill2 < 0) { CamShow = int(random(2)) + 1; my.skill2 = random(200) + 150; }
		}

		if ((CamShow == 5) && (my.skill1 == 5)) { my.x = my.x - 3 * time; }


		wait(1);
	}
}

action Soldier
{
	while(1)
	{
		if (Scene == 16) 
		{ 
			vec_set(temp,player.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);
		
			my.invisible = off; my.shadow = on;

			if (abs(my.x - player.x) < 200) { force = 3; actor_move(); ent_cycle ("Walk",my.skill10); my.skill10 = my.skill10 + 10 * time; }
		}
		else { my.invisible = on; my.shadow = off; }

		wait(1);
	}
}

action Soldier2
{
	while(1)
	{
		if (Scene == 15) 
		{ 
			my.invisible = off; my.shadow = on;
			my.y = my.y + 20 * time;
			ent_cycle ("Walk",my.skill10); my.skill10 = my.skill10 + 10 * time;
		}
		else { my.invisible = on; my.shadow = off; }

		wait(1);
	}
}

action KN
{
	while(1)
	{
		if (Talking == 10) { ent_cycle ("KTalk",my.skill1); }
		if (Talking == 20) { ent_cycle ("NTalk",my.skill1); }
		if (Talking == 0) { ent_cycle ("Stand",my.skill1); }
		my.skill1 = my.skill1 + 10 * time;
		wait(1);
	}
}

action cam
{
	while (pMeanwhile.visible == on) { wait(1); }

	SetVoice();
	my.skill2 = 200;

	while(1)
	{
		if (Scene < 8)
		{
			if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; SetVoice(); }

			if ((CamShow == my.skill1) && (Scene != 7))
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

action Cam2
{
	while(1)
	{
		if (AlarmNow == 1) { if (snd_playing (my.skill40) == 0) { play_sound (Alarm1,50); my.skill40 = result; } }

		if (Scene == 7)
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
			if (my.skill2 < 0) { CamShow = int(random(3)) + 1; my.skill2 = random(200) + 150; }

		}

		wait(1);
	}
}

action Nanny
{
	while(1)
	{
		if (Scene < 7)
		{
			ent_cycle ("Annoyed",my.skill1);
			my.skill1 = my.skill1 + 20 * time;
		}
		else
		{
			if (int(random(40)) == 20) { ent_frame ("What",int(random(5)) * 25); }
		}

		if ((Scene == 1) || (Scene == 7)) { Talk(); } else { Sleeping(); }
		wait(1);
	}
}

action Abrasha
{
	while(1)
	{
		if ((Scene == 2) || (Scene == 4) || ( Scene == 6)) { Talk(); if (int(random(40)) == 20) { ent_frame ("Talk",int(random(5)) * 25); } }
		else { Blink(); ent_frame ("Talk",0); }
		wait(1);
	}
}

action Plane
{
	my.skin = 5;

	while(1)
	{
		if (Scene == 17)
		{
			if (snd_playing(my.skill40) == 0) { play_entsound (my,engine,1000); my.skill40 = result; }
			ent_cycle ("Fly",my.skill1);
			my.skill1 = my.skill1 + 5 * time;
		}

		wait(1);
	}
}

action B1
{
	while(1)
	{
		if (Scene > 11) { if (my.skill39 == 0 ) { play_sound (SFX017,100); my.skill39 = 1; } my.y = my.y + 50 * time; my.z = my.z + 30 * time; }
		//if (Scene == 8) { Talk2(); } else { ent_frame ("Stand",0); Blink(); }
		ent_frame ("phone",0);

		wait(1);
	}
}

action B2
{
	while(1)
	{
		if (player == null) { wait(1); }

		if (Scene > 13)
		{
			vec_set(temp,player.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);
		}

		if ((Scene == 9) || (Talking == 1)) { Talk2(); } else { ent_frame ("Stand",0); Blink(); }

		wait(1);
	}
}

action P1
{
	my._movemode = 1;
	//my.passable = on;

	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found

	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
		if (Scene == 10)
		{
			CamShow = 1;
			my.skill33 = my.skill33 + 1 * time;
			if (my.skill33 > 1.5) { my.skin = int(random(8))+1; my.skill33 = 0; }

			// find direction
			temp.x = MY._TARGET_X - MY.X;
			temp.y = MY._TARGET_Y - MY.Y;
			temp.z = 0;
			result = vec_to_angle(my_angle,temp);

			// near target? Find next waypoint
			// compare radius must exceed the turning cycle!
			if (result < 25) { ent_nextpoint(my._TARGET_X); my.skill32 = my.skill32 + 1; }

			if (my.skill32 < 8)
			{
				if (my.z < DangerZ) { my.z = my.z + 50; }
				// turn and walk towards target
				force = 6;
				actor_turnto(my_angle.PAN);
				force = 3;
				actor_move();
			}
			else { CamShow = 2; Talk2(); }
		}

		if (Scene == 11)
		{
			ent_frame ("FKick",my.skill34);
			my.skill34 = my.skill34 + 10 * time;
			if (my.skill34 > 100) { CamShow = 1; Scene = 12; SetVoice(); }
		}

		if (Scene > 11) { my.invisible = on; my.shadow = off; }

		wait(1);
	}
}

action JustDummy { DangerZ = my.z; }

action P3
{
	my.skill40 = my.pan;
	my.skill30 = my.z;

	while(1)
	{
		if (Scene > 11) { my.invisible = off; my.shadow = on; }

		while (Dialog.visible == on) { Blink(); wait(1); }

		while (DialogIndex == 19)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP151.WAV"); while (GetPosition(Voice) < 1000000) { Talk2(); wait(1); }
				Talking = 1; sPlay ("KVC021.WAV"); while (GetPosition(Voice) < 1000000) { ent_frame ("Stand",0); wait(1); }
				DialogIndex = 0; Talking = 0; Scene = 14; SetVoice();
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP152.WAV"); while (GetPosition(Voice) < 1000000) { Talk2(); wait(1); }
				CamShow = 4;
				sPlay ("JOK4201.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK4202.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("JOK4203.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("laugh.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
				CamShow = 1;
				DialogIndex = 0; Scene = 14; SetVoice();
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP153.WAV"); while (GetPosition(Voice) < 1000000) { Talk2(); wait(1); }
				sPlay ("PIP154.WAV"); while (GetPosition(Voice) < 1000000) { my.z = my.z - 1 * time; CamShow = 1; Talk2(); wait(1); }
				my.z = my.skill30;
				my.invisible = on; my.shadow = off; Talking = 100; sPlay ("PIP155.WAV"); while (GetPosition(Voice) < 1000000) { CamShow = 1; Talk2(); wait(1); }
				my.pan = my.skill40 + 150;
				my.invisible = off; my.shadow = on;
				sPlay ("PIP501.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { Talk2(); wait(1); }
				DialogIndex = 0; Scene = 14; SetVoice();
			}

			wait(1);
		}

		if (Scene == 14)
		{
			Talk();
			my.pan = my.skill40 + 150;
			ent_cycle ("Walk",my.skill39);
			my.skill39 = my.skill39 + 10 * time;
			my.x = my.x + 10 * time;
			my.y = my.y - 5 * time;
		}

		wait(1);
	}
}

action Pot
{
	while(1)
	{
		ent_cycle ("Frame",my.skill1);
		my.skill1 = my.skill1 + 10 * time;
		if (Talking == 100) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }
		wait(1);
	}
}

action P4
{
	while(1)
	{
		if (Scene == 17) { my.invisible = off; my.shadow = on; }
		Talk2();
		wait(1);
	}
}

action P6
{
	player = my;

	while(1)
	{
		if (Scene == 16) 
		{ 
			my.invisible = off; my.shadow = on;
			ent_cycle ("Run",my.skill1);
			my.skill1 = my.skill1 + 10 * time;
			my.x = my.x - 6 * time;
			my.skill40 = my.skill40 + 1 * time;
			if (my.skill40 > 200) { Scene = 17; SetVoice(); }
		}
		else { my.invisible = on; my.shadow = off; }
		
		wait(1);
	}
}

function Blink()
{
	if (my.skill12 > 0) { my.skill12 = my.skill12 - 1 * time; }
	if (my.skill12 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill12 = 5; }
	}

}

function Sleeping { my.skin = 7; }

function Talk()
{
	my.skill11 = my.skill11 + 1 * time;
	if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; }
}

function Talk2()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } else { ent_frame ("Talk",int(random(5)) * 25); } }
}

function DoDialog (num)
{
	DialogChoice = 0;
	DialogIndex = num; 
	ShowDialog();
	Talking = 0;
}

function SetVoice
{
	if (Scene == -1) { sPlay ("Wait.wav"); }
	if (Scene == 0) { sPlay ("ROG004.WAV"); }
	if (Scene == 1) { sPlay ("NAN005.WAV"); }
	if (Scene == 2) { sPlay ("FIN001.WAV"); }
	if (Scene == 3) { sPlay ("NAN037.WAV"); }
	if (Scene == 4) { sPlay ("FIN002.WAV"); }
	if (Scene == 5) { sPlay ("NAN038.WAV"); }
	if (Scene == 6) { sPlay ("FIN003.WAV"); }
	if (Scene == 7) { sPlay ("NAN006.WAV"); }
	if (Scene == 8) { sPlay ("MAR022.WAV"); CamShow = 1; }
	if (Scene == 9) { sPlay ("KVC020.WAV"); }
	if (Scene ==10) { sPlay ("PIP150.WAV"); }
	if (Scene ==12) { sPlay ("NAN007.WAV"); }
	if (Scene ==13) { DoDialog (19); }
	if (Scene ==14) { sPlay ("PIP156.WAV"); }
	if (Scene ==15) { sPlay ("ALR007.WAV"); CamShow = 6; }
	if (Scene ==16) { AlarmNow = 1; CamShow = 5; }
	if (Scene ==17) { sPlay ("PIP157.WAV"); CamShow = 3; }
	if (Scene ==18) { Run ("Intro15.exe"); }
}