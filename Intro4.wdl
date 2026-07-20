include <IO.wdl>;

sound Liftoff = <SFX052.WAV>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var CamView = 1;
var Phase = 0;

// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	vNoSave = 1;

	load_level(<Intro4.WMB>);

	VoiceInit();
	Initialize();

	scene_map = bmapBack6;
}

action DefinePiposh
{
	player = my;

	while (CamView == 1) { wait(1); }

	actor_init();
	drop_shadow();

// attach next path
	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found

// find first waypoint
	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
	// find direction
		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

// near target? Find next waypoint
// compare radius must exceed the turning cycle!

		if (result < 25) { ent_nextpoint(my._TARGET_X); my.skill3 = my.skill3 + 1; }

// turn and walk towards target
		force = 2;
		actor_turnto(my_angle.PAN);
		force = 11;
		actor_move();

// Wait one tick, then repeat
		wait(1);
	}
}

action Cam
{
	my.invisible = on;
	my.passable = on;

	sPlay("PIP143.WAV");

	while(1)
	{
		if (CamView == my.skill1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;

			if (CamView == 1)
			{
				if (my.skill10 == 0) { while (GetPosition(Voice) < 1000000) { wait(1); } }
				Phase = 1;
				if (my.skill11 < 90) { if (my.skill10 == 0) { my.skill10 = 1; play_entsound (my,liftoff,100); } my.pan = my.pan - 2 * time; } else { CamView = 2; }
				my.skill11 = my.skill11 + 2 * time;
				camera.pan = my.pan;
			}

			if (CamView == 2)
			{
				if (my.skill12 == 0) { sPlay("KRZ001.WAV"); my.skill12 = 1; }
				if ((my.skill12 == 1) && (GetPosition(Voice) >= 1000000)) { sPlay ("PIP144.WAV"); my.skill12 = 2; }
				vec_set(temp,player.x);
				vec_sub(temp,camera.x);
				vec_to_angle(camera.pan,temp);
			}

			if ((my.skill12 == 2) && (GetPosition(Voice) >= 1000000)) 
			{ 
				Flag_First_Volcano = 1;
				WriteGameData (0);
				Run ("Dutyfree.exe");
			}
		}
		wait(1);
	}
}

action Wind
{
	my.skill1 = my.pan;

	while(1)
	{
		my.pan = my.skill1;
		my.pan = my.pan + (random(3) - 1) * 10;
		wait(1);
	}
}

Action Sit
{
	while(1)
	{
		ent_frame ("Sit",0);
		wait(1);
	}
}

Action Clean
{
	while(1)
	{
		ent_cycle ("Clean",my.skill1);
		my.skill1 = my.skill1 + 5;
		wait(1);
	}
}

action Pip
{
	while(1)
	{
		if (Phase == 0)
		{
			my.skill11 = my.skill11 + 1 * time;
			if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; }
			if (int(random(30)) == 15) { ent_frame ("Talk",int(random(8)) * 14); }
		}
		else { ent_frame ("Stand",0); my.skin = 1; }

		wait(1);
	}
}

action Land
{
	while(1)
	{
		ent_cycle ("Fly",my.skill1);
		my.skill1 = my.skill1 + 5 * time;
		wait(1);
	}
}

action Fly
{
	while(1)
	{
		if (Phase == 1)
		{
			my.x = my.x + 80 * time;
			my.z = my.z + 20 * time;
		}
		wait(1);
	}
}