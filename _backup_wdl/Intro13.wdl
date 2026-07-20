include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Scene = 0;
var GoZ = -30;
var Shake = 0;
var Phase = 0;
var CamShow = 1;

var cameratemp[3] = 0,0,0;
var n = 1;
var closest = 0;

var cameraX[9] = 910,910,1363,2289,2692,3683,3072,2200,1370;
var cameraY[9] = 1368,341,-569,32,826,1347,2096,2094,2092;

var MyPos [3] = 0,0,0;
var CamPos [3] = 0,0,0;
var TrollyPan = 0;

sound HitCat = <SFX085.WAV>;
sound PhoneSND = <SFX086.WAV>;

synonym PIP { type entity; }

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	vNoSave = 1;

	level_load("Intro13.wmb");

	VoiceInit();
	Initialize();

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running
}

action Cam
{
	my.skill10 = my.z;

	while(Phase == 0)
	{
		my.z = my.skill10;
		if (Shake > 0) { if (my.skill40 == 0) { play_sound (HitCat,30); play_sound (PhoneSND,30); my.skill40 = 1; } Shake = Shake - 1 * time; my.z = my.z + ((int(random(3)) - 1) * 20) * time; }
		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;
		camera.pan = my.pan;
		camera.roll = my.roll;
		camera.tilt = my.tilt;
		wait(1);
	}
}

action CamDrive
{
	while (Phase == 0) { wait(1); }

	my._movemode = 1;
	my.passable = on;
	my.skill40 = my.z;

	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found

	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
		if (my.flag4 == on) { player = my; }

		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		// near target? Find next waypoint
		// compare radius must exceed the turning cycle!
		if (result < 25) { ent_nextpoint(my._TARGET_X); }

		// turn and walk towards target
		force = 3;
		actor_turnto(my_angle.PAN);
		force = 3;
		actor_move();

		my.z = my.skill40;

		if (my.flag2 == on)
		{
			mypos.x = my.x;
			mypos.y = my.y;
			mypos.z = my.pan;
		}

		if (my.flag8 == on)
		{
			campos.x = my.x;
			campos.y = my.y;
			campos.z = my.pan;
		}

		if (my.flag3 == on) { my.x = mypos.x; my.y = mypos.y; my.pan = mypos.z; }
		if (my.flag7 == on) { my.x = campos.x; my.y = campos.y; my.pan = campos.z; }

		if ((Scene == 5) && (my.flag7 == on)) { Talk(); }
		if ((Scene == 6) && (my.flag5 == on)) { Talk(); }


		if ((my.flag1 == on) && (CamShow == 1))
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

ACTION CameraEngine
//***********************************************************************************************
//* Calculates the closest camera to the player and sets it as the active camera, uses 3 arrays *
//* of vector coordinates: cameraX, cameraY, cameraZ                           - Roy Lazarovich *
//***********************************************************************************************
{
	while (1)
	{
		my.skill30 = my.skill30 - 1 * time;
		if (my.skill30 < 0) { CamShow = int(random(2)) + 1; my.skill30 = random(70) + 30; }

		if (Scene == 5)
		{
			if (GetPosition(Voice) >= 1000000)
			{
				Scene = 6;
				sPlay ("PIP450.WAV");
			}
		}

		if (Scene == 6)
		{
			if (GetPosition(Voice) >= 1000000) { Run ("AsyAct2.exe"); }
		}

		if (CamShow == 2)
		{
			move_view_3rd();
			while (player == NULL) { wait(1); }	
			vec_set(temp,player.x);
			vec_sub(temp,camera.x);
			vec_to_angle(camera.pan,temp);
		
			n = 0;		
			temp = 100000;

			while (n < cameraX.length) 
			{
				cameratemp.x = cameraX[n];
				cameratemp.y = cameraY[n];
			
				if (vec_dist(cameratemp.x,player.x) < temp)
				{
					temp = vec_dist (cameratemp,player.x);
					closest = n;
				}

				n = n + 1;
			}

			cameratemp.x = cameraX[closest];
			cameratemp.y = cameraY[closest];
			cameratemp.z = -20;

			vec_set(camera.x, cameratemp);
		}
	wait(1);
	}

}

action Piposh
{
	PIP = my;

	sPlay ("PIP449.WAV");

	while(1)
	{
		Talk();

		if (Scene == 0)
		{
			ent_cycle ("Choke",0);
			my.skill2 = my.skill2 + 20 * time;
			if (my.skill2 > 50)  { GoZ = -GoZ; my.skill2 = 0;   }
			if (GetPosition(Voice) >= 100000) { Scene = Scene + 1; }
		}

		if (Scene == 1)
		{
			ent_frame ("Throw",0);
			if (GetPosition(Voice) >= 150000) { Scene = Scene + 1; Shake = 7; }
		}

		if (Scene == 2)
		{
			if (int(random(40)) == 20) { ent_frame ("Damn",int(random(6)) * 20); }
			if ((GetPosition(Voice) >= 550000) && (GetPosition(Voice) <= 600000)) { my.skin = 4; }
			if ((GetPosition(Voice) >= 700000) && (GetPosition(Voice) <= 750000)) { my.skin = 4; }
			if (GetPosition(Voice) >= 950000) { my.skin = 4; }
			if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; my.skill2 = 0; }
		}

		if (Scene == 3)
		{
			sPlay ("POZ011.WAV");
			Scene = 4;
		}

		if (Scene == 4) 
		{ 
			my.skin = 4;
			ent_frame ("Fall",my.skill2);
			my.skill2 = my.skill2 + 10 * time;
			if (GetPosition(Voice) >= 1000000) { sPlay ("DOC001.WAV"); Scene = 5; Phase = 1; CamShow = 1; } 
		}

		wait(1);
	}
}

action Pozmak
{
	my.skill11 = 15;

	while (PIP == null) { wait(1); }
	my.z = PIP.z;

	while(1)
	{
		if (Scene == 1)
		{
			my.x = my.x + 10 * time;
			my.z = my.z + 10 * time;
		}

		wait(1);
	}
}

action Phone
{
	while(1)
	{
		if (Scene == 2)
		{
			my.x = my.x - 15 * time;
			my.roll = my.roll - 20 * time;
		}

		wait(1);
	}
}

function Talk()
{
	my.skill11 = my.skill11 + 1 * time;
	if (my.skill11 > 1) { my.skin = int(random(8))+1; my.skill11 = 0; }
}

function Blink()
{
	if (my.skill22 > 0) { my.skill22 = my.skill22 - 1 * time; }
	if (my.skill22 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill22 = 5; }
	}
}	