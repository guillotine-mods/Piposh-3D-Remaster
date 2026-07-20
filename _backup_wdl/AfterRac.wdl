include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.

bmap clouds = <GolfCLD.pcx>;
//bmap sky = <GOlfSKY.pcx>;

var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Talking = 0;
var Scene = 0;

var CamShow = 1;

var A[3] = 0,0,0;
var B[3] = 0,0,0;

var SwitchIn = -1;

Var Played = 0;

////////////////////////////////////////////////////////////////////////////
// The following script controls the sky movement
bmap horizon_map = <horizon.pcx>;
// A backdrop texture's horizontal size must be a power of 2;
// the vertical size does not matter

function init_environment()
{
	scene_map = horizon_map;	// horizon backdrop overlay
	scene_nofilter = on;

	sky_speed.x = 1;
	sky_speed.y = 1.5;
	cloud_speed.x = 3;
	cloud_speed.y = 4.5;

	sky_scale = 0.5;
	sky_curve = 1;  			// 'steepness' of sky dome

	scene_field = 60;  		// repeat map 6 times
	scene_angle.tilt = -10; // lower edge of scene_map 10 units below horizon

	sky_clip = scene_angle.tilt;	// clip the sky at bottom of scene_map
}

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	sky_map = sky;
	cloud_map = clouds;
	sky_scale = 1;
	cloud_speed.x = 10;
	cloud_speed.y = 10;
	sky_speed.x = 3;
	sky_speed.y = 3;

	level_load("AfterRac.wmb");

	VoiceInit();
	Initialize();

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running
}

action RunInCircle
{
	my.skill10 = my.z - 10;
	my.skill20 = 0;
	actor_init();
	drop_shadow();
	my._movemode = 1;
	my.passable = on;

	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found
	my.skill39 = random(3) + 2;

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
		if (result < 25) { ent_nextpoint(my._TARGET_X); }

		// turn and walk towards target
		force = 6;
		actor_turnto(my_angle.PAN);
		force = 6;
		actor_move();

		//my.z = my.skill10;
		ent_cycle ("Run",my.skill40);

		my.skill40 = my.skill40 + 6 * time;

		wait(1);
	}
}

action Ad
{
	my.skin = int(random(7)) + 1;
}

action Cam
{
	my.skill2 = my.pan;

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

			if (Talking == 10) { my.pan = my.pan - 0.9 * time; } else { my.pan = my.skill2; }
		}

		if ((CamShow == 3) && (my.skill1 == 3))
		{
			my.x = my.x - 5 * time;
			my.y = my.y - 5 * time;

			vec_set(temp,b.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

			if (SwitchIn != -1)
			{
				SwitchIn = SwitchIn - 1 * time;
				if (SwitchIn < 0) { CamShow = 1; Scene = 0; }
			}

		}

		wait(1);
	}
}

action Bow
{
	while(1)
	{
		if (Scene == 1)
		{
			if (my.skill1 == 2) { my.invisible = off; }
			if (my.skill1 == 1) { my.invisible = on; }
		}
		else
		{
			if (my.skill1 == 2) { my.invisible = on; }
			if (my.skill1 == 1) { my.invisible = off; }
		}

		wait(1);
	}
}

action Flow
{
	sPlay ("OLY001.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("BRA022.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("PIP251.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
	CamShow = 4; Scene = 1;
	sPlay ("BRA023.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("SFX002.WAV"); Talking = 5; while (GetPosition(Voice) < 1000000) { wait(1); }
	Scene = 2; CamShow = 2;
	while (Scene == 2) { wait(1); }
	sPlay ("SFX003.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("OLY007.WAV"); Talking = 3; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("YCH009.WAV"); Talking = 4; while (GetPosition(Voice) < 1000000) { wait(1); }
	CamShow = 1;
	sPlay ("PIP252.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
	sPlay ("BRA024.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }
	CamShow = 3; Scene = 3;
	sPlay ("SFX002.WAV");
	while (Scene == 3) { wait(1); }
	sPlay ("PIP253.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
	Run ("Shooter.exe");
}

action Yach
{
	while(1)
	{
		if (Talking == 4) { Talk3(); } else { Blink(); }
		wait(1);
	}
}

action Piposh
{
	while(1)
	{
		if (Talking == 1) { Talk2(); } else { Blink(); }
		waIt(1);
	}
}

action Plunger
{
	my.skill1 = my.y;
	my.y = my.y + 500;

	while(1)
	{
		if (Scene == 2)
		{
			my.invisible = off; my.shadow = on;

			if (my.y > my.skill1) 
			{ 
				my.y = my.y - 50 * time; 
			}
			else { Scene = 0; }

		}

		wait(1);
	}
}

action Killer
{
	my.skill1 = my.z;

	while(1)
	{
		if (Scene == 3) 
		{ 
			b.x = my.x;
			b.y = my.y;
			b.z = my.z;

			my.invisible = off; my.shadow = on; 

			vec_set(temp,a.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

			my.tilt = 0; my.roll = 0;

			force = 30;
			actor_move();

			my.z = my.skill1;
		}

		wait(1);
	}
}

action Killer2
{
	while(1)
	{
		if (Talking == 5) 
		{ 
			my.invisible = off;
			my.y = my.y - 100 * time;
			my.z = my.z + 12 * time;
		} 
		else { my.invisible = on; }

		wait(1);
	}
}

action Blowme
{
	_gib (100);
	actor_explode();

	my = you;
	actor_explode();

	SwitchIN = 50;

	sPlay ("SFX004.WAV"); Talking = 0;
}

action Sonia
{
	a.x = my.x;
	a.y = my.y;
	a.z = my.z;

	my.enable_entity = on;
	my.enable_push = on;
	my.enable_impact = on;
	my.event = blowme;
}

action Gran
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

function Talk3()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { ent_frame ("Speech",int(random(5)) * 25); }
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