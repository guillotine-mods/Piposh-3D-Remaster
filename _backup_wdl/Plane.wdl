include <IO.wdl>;

synonym Piposh { type entity; }

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var DialogCounter = 0;
var CartTemp = 0;
var Scene = -1;
var KRP = 0;
var ANM = 0;
var ARV = 0;
var Vase = 0;
var CamShow = 0;
var Phase = 0;
var Pip2 = 0;

var SND = 0;

synonym Krupnik { type entity; }
synonym Camera1 { type entity; }
synonym Camera2 { type entity; }
synonym Camera3 { type entity; }

sound CockPit = <SFX089.WAV>;
sound sHammer = <SFX090.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	on_space = null;

	warn_level = 0;
	tex_share = on;

	vNoMap = 1;

	load_level(<Plane.WMB>);

	VoiceInit();
	Initialize();

	scene_map = bmapBack1;

	SetVoice();
}

action Vase1 { while(1) { my.skin = 1; if (Vase == 1) { my.invisible = off; } else { my.invisible = on; } wait(1); } }
action Vase2 { while(1) { my.skin = 1; if (Vase == 2) { my.invisible = off; } else { my.invisible = on; } wait(1); } }

action Cam
{
	if (my.skill1 == 1) { Camera1 = my; }
	if (my.skill1 == 2) { Camera2 = my; }
	if (my.skill1 == 3) { Camera3 = my; }
}

action Dummy
{
	while(1)
	{
		if (snd_playing(SND) == 0) { play_entsound (my,cockpit,300); SND = result; }
		wait(1);
	}
}

action Cam2
{
	while(1)
	{
		if (CamShow == 1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.roll = my.roll;
			camera.tilt = my.tilt;
			camera.pan = my.pan;
		}

		wait(1);
	}
}

action Krup
{
	while(1)
	{
		if ((Phase == 1) || (Phase == 2)) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }
		Talk2();

		if (Phase == 1) { if (int(random(40)) == 20) { ent_frame ("Stand",int(random(3)) * 50); } }
		if (Phase == 2) 
		{ 
			ent_frame ("Stand",0);
			Talk2();
			if (int(random(40)) == 20) { my.skill10 = 1; }
			if (my.skill10 > 0)
			{
				my.skill10 = my.skill10 + 10 * time;
				ent_frame ("Hammer",my.skill10);
				if ((my.skill10 > 50) && (my.skill10 < 60)) { play_entsound (my,sHammer,300); }
				if (my.skill10 > 100) { my.skill10 = 0; }
			}
		}

			//ent_cycle ("Hammer",my.skill1); my.skill1 = my.skill1 + 15 * time; }
		
		wait(1);
	}
}

action PiposhWalk
{
	Piposh = my;

	my.skill1 = 1;
	my._movemode = 1;
	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found

	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
		while (Dialog.visible == on) { Blink(); wait(1); }

		while (DialogIndex == 3)
		{
			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP028.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("KRP002.WAV"); Talking = 2; KRP = int(random(3)) + 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP029.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("KRP003.WAV"); Talking = 2; KRP = int(random(3)) + 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DoDialog (3);
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP030.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("KRP004.WAV"); Talking = 2; KRP = int(random(3)) + 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DoDialog (3);
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP031.WAV"); Talking = 1; Vase = 1; while (GetPosition(Voice) < 1000000) { ent_frame ("Take",100); Talk2(); wait(1); }
				sPlay ("KRP005.WAV"); Talking = 2; Phase = 1; Vase = 0; CamShow = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("KRP006.WAV"); Talking = 2; Phase = 2; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			
				camera.x = camera1.x;
				camera.y = camera1.y;
				camera.z = camera1.z;
				camera.pan = camera1.pan;
				camera.tilt = camera1.tilt;
				camera.roll = camera1.roll;
				my.invisible = on; my.shadow = off;
				Phase = 3;

				sPlay ("PIP032.WAV"); Pip2 = 1; Talking = 1; Vase = 2; CamShow = 0; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("KRP007.WAV"); Talking = 2; KRP = int(random(3)) + 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP033.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				
				Run ("Plane2.exe");
			}

			wait(1);
		}

		if (Talking > 0) { if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; SetVoice(); } }

		if (Talking == 1) { Talk(); } else { Blink(); }

		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		force = 2;

		if (result < 25) { ent_nextpoint(my._TARGET_X); my.skill1 = my.skill1 + 1; }

		if (my.skill1 == 2) 
		{ 
			actor_turnto(my_angle.PAN);
			actor_move(); 
		}

		wait(1);
	}
}

function ChangeCamera
{
	if ((Camera1 == null) || (Camera2 == null) || (Camera3 == null)) { wait(1); }
	temp = int(random(4))+1;

	if (temp == 1)
	{
		camera.x = camera1.x;
		camera.y = camera1.y;
		camera.z = camera1.z;
		camera.pan = camera1.pan;
		camera.tilt = camera1.tilt;
		camera.roll = camera1.roll;
	}

	if (temp == 2)
	{
		camera.x = camera2.x;
		camera.y = camera2.y;
		camera.z = camera2.z;
		camera.pan = camera2.pan;
		camera.tilt = camera2.tilt;
		camera.roll = camera2.roll;
	}


	if (temp == 3)
	{
		camera.x = camera3.x;
		camera.y = camera3.y;
		camera.z = camera3.z;
		camera.pan = camera3.pan;
		camera.tilt = Camera3.tilt;
		camera.roll = camera3.roll;
	}
}

action Pip
{
	while(1)
	{
		if (Pip2 == 1) { my.invisible = off; } else { my.invisible = on; }
		if (Talking == 1) { Talk(); } else { ent_frame ("LookBack",0); Blink2(); }
		wait(1);
	}
}

action Dome { my.skin = 1; while(1) { my.pan = my.pan + 0.2 * time; wait(1); } }

action ThePlaneMovie
{
	while (Camera1 == null) { wait(1); }

	ent_frame ("Peek",0);

	camera.x = camera1.x;
	camera.y = camera1.y;
	camera.z = camera1.z;
	camera.pan = camera1.pan;
	camera.tilt = camera1.tilt;
	camera.roll = camera1.roll;

	Krupnik = my;

	while (1)
	{
		ANM = ANM + 5 * time;

		if (Scene == 0) 
		{ 
			if (Talking == 2) { Talk2(); if (int(random(40)) == 20) { ent_cycle ("Peek",int(random(3)) * 50); } } else { ent_frame ("Peek",0); Blink2(); }
		}

		if ((ARV < 100) && (Talking == 1))
		{
			ent_frame ("Arrive",ARV);
			ARV = ARV + 5 * time;
		}

		if ((Scene > 0) && (ARV >= 100))
		{
			on_space = FF;
			my.skill2 = my.skill2 - 1 * time;
			if ((my.skill2 < 0) && (CamShow == 0) && (Pip2 == 0)) { if (int(random(100)) == 50) { ChangeCamera(); my.skill2 = random(200) + 150; } }

			if (Talking == 2)
			{
				if (Phase != 3)
				{
					if (KRP == 1) { if (int(random(40)) == 20) { ent_frame ("Talk",int(random(7)) * 16); } }
					if (KRP == 2) { ent_cycle ("Circle",ANM); }
					if (KRP == 3) { ent_cycle ("Jump",ANM); }
				}
					
				Talk2();
			}
			else
			{
				Blink();
			}

			if (Phase == 3) { ent_frame ("Jump",0); }
		}

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

function SetVoice
{
	KRP = int(random(3)) + 1;
	ANM = 0;

	if (Scene == -1) { sPlay ("Wait.wav"); Talking = 10; }
	if (Scene == 0)  { sPlay ("KRP001.WAV"); Talking = 2; }
	if (Scene == 1)  { DoDialog (3); }
}