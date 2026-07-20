include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var MyTemp = 0;
var Path = 0;
var TheCam = 1;
var Scene = 0;
var Talking = 0;
var Counter = 0;
var CamShow = 1;

bmap redsky = <redsky.pcx>;
bmap redmount = <horizon7.pcx>;

sound Ambient = <SFX077.WAV>;
var SND;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	vNoSave = 1;

	load_level(<Intro5.WMB>);

	VoiceInit();
	Initialize();

	sky_map = redsky;
	scene_map = redmount;

	play_sound (Ambient,100);
	SND = result;
}

action Dome { while(1) { my.pan = my.pan + 0.2 * time; wait(1); } }

action Cam
{
	my.skill1 = my.x;
	my.skill2 = my.y;
	my.skill3 = my.z;

	while(TheCam == 1)
	{
		if (Path < 44)
		{
			my.z = player.z;
			my.z = my.z + (int(random(3)) - 1) * 3;

			my.y = player.y - 200;
			my.x = player.x;

			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;

			camera.pan = my.pan;
		}
		else { TheCam = 2; stop_sound (SND); play_sound (Ambient,30); }

		wait(1);
	}
}

action Cam2
{
	while(1)
	{
		if (TheCam == 2)
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
		}

		wait(1);
	}
}


function particlefade()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = random(1000) + 500;
		MY_SPEED.X = (RANDOM(3)-1) * 0.2;
		MY_SPEED.Y = (RANDOM(3)-1) * 0.2;
		MY_SPEED.Z = random(5)+1;

		MyTemp = int(random(129));

			MY_COLOR.RED = MyTemp;
			MY_COLOR.GREEN = MyTemp;
			MY_COLOR.BLUE = MyTemp;
	}
	else
	{

		if(MY_AGE > 1000) { MY_ACTION = NULL; }
	}
}

function Lavaflow()
{
	if(MY_AGE == 0)
	{	// just born?
		MY_SIZE = random(1000) + 500;
		MY_SPEED.X = (RANDOM(3)-1) * 0.2;
		MY_SPEED.Y = (RANDOM(3)-1) * 0.2;
		MY_SPEED.Z = random(50)+30;

			MY_COLOR.RED = random(255);
			MY_COLOR.GREEN = 0;
			MY_COLOR.BLUE = 0;
	}
	else
	{
		my_speed.z = my_speed.z - 5;
		if(MY_AGE > 100) { MY_ACTION = NULL; }
	}
}

action Smoke
{
	while(1)
	{
		if (int(random(20)) == 10)
		{
			MyTemp = int(random(30)) + 10;
			emit(MyTemp,MY.POS,particlefade); 	// smoke trail
		}
		wait(1);
	}
}

action Gayser
{
	my.invisible = on;

	while(1)
	{
		if (int(random(100)) == 50)
		{
			emit(50,MY.POS,Lavaflow); 	// smoke trail
		}
		wait(1);
	}
}

function SkipPath { Path = 45; }

action Running
{
	player = my;
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

	while (my._movemode > 0)
	{
	// find direction
		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

// near target? Find next waypoint
// compare radius must exceed the turning cycle!

		if (result < 25) { ent_nextpoint(my._TARGET_X); path = path + 1; }

// turn and walk towards target
				
		if (Path < 45)
		{
			on_space = SkipPath;
			my.skin = 5;
			force = 8;
			actor_turnto(my_angle.PAN);
			force = 6;
			actor_move();
		}
		else { on_space = FF; }

		ent_cycle ("Run",my.skill22);
		my.skill22 = my.skill22 + 10;

// Wait one tick, then repeat
		wait(1);
	}
}

action Burst
{
	my.ambient = 50;
	if (player == null) { wait(1); }

	while(1)
	{
		if ((abs(my.x - player.x) < 200) && (abs(my.y - player.y) < 200)) { create (<Piece.wmb>,my.x,Gayser); _gib(50); actor_explode(); }
		if (int(random(1000)) == 500) { create (<Piece.wmb>,my.x,Gayser); _gib(50); actor_explode(); }
		wait(1);
	}
}

function SetVoice
{
	if (Scene == 0)   { sPlay ("Wait.wav"); Talking = 10; }
	if (Scene == 1)   { sPlay ("PIP200.WAV"); Talking = 1; }
	if (Scene == 2)   { sPlay ("KVC022.WAV"); Talking = 2; }
	if (Scene == 3)   { sPlay ("PIP201.WAV"); Talking = 1; }
	if (Scene == 4.5) { sPlay ("KVC023.WAV"); Talking = 2; }
	if (Scene == 5.5) { sPlay ("MAR032.WAV"); Talking = 3; }
	if (Scene == 6.5) { sPlay ("KVC024.WAV"); Talking = 2; }
	if (Scene == 7.5) { sPlay ("MAR023.WAV"); Talking = 3; }
	if (Scene == 8.5) { sPlay ("KVC025.WAV"); Talking = 2; }
	if (Scene ==10.5) { sPlay ("KVC026.WAV"); Talking = 2; }
	if (Scene ==11.5) { ReturnToMap(); }
}

action BadLava1
{
	while(1)
	{
		if (Scene > 3) { my.invisible = off; my.shadow = on; }
		if (Talking == 2) { Talk(); } else { Blink(); }
		wait(1);
	}
}

action BadLava2
{
	while(1)
	{
		if (Scene > 3) { my.invisible = off; my.shadow = on; }
		if (Talking == 3) { Talk(); } else { Blink(); }
		wait(1);
	}
}


action Lava
{
	while(1)
	{
		SET MY.LIGHTRED,255;
		SET MY.LIGHTGREEN,0;
		SET MY.LIGHTBLUE,0;
		MY.LIGHTRANGE = 3000;
		wait(1);
	}
}

action Lava2 
{ 
	while(1) 
	{ 
		if (TheCam == 2)
		{
			my.y = my.y - 7 * time; 
			SET MY.LIGHTRED,255;
			SET MY.LIGHTGREEN,0;
			SET MY.LIGHTBLUE,0;
			MY.LIGHTRANGE = 3000;
		}

		wait(1); 
	} 
}

action Pip
{
	my.skill1 = my.y;
	my.y = my.y + 300;
	my.pan = my.pan + 180;
	my.skill2 = my.pan;

	while(1)
	{
		if (TheCam == 2)
		{
			if (my.y > my.skill1) { my.y = my.y - 10 * time; ent_cycle ("Run",my.skill22); my.skill22 = my.skill22 + 10 * time; Blink2(); }
			else
			{
				if (Scene == 0) { Scene = 1; SetVoice(); my.pan = my.pan + 180; }
				if (Scene > 3) { my.pan = my.skill2; my.y = my.y - 10 * time; ent_cycle ("Run",my.skill22); my.skill22 = my.skill22 + 10 * time; Blink2(); }
				if (Talking == 1) { Talk(); } else { Blink(); }
				if ((GetPosition(Voice) >= 1000000) && (Scene != 9.5) && (Scene != 4)) { Scene = Scene + 1; SetVoice(); }
			}
		}

		wait(1);
	}
}

action Bad1
{
	my.skill31 = 12;
	my.skill1 = my.pan;

	while(1)
	{
		if (TheCam == 2)
		{
			if (CamShow == 2) { my.invisible = on; my.shadow = off; }
			if (Talking == 2) { Talk(); } else { Blink(); }
			if (Scene > 3) { Counter = Counter + 1 * time; my.pan = my.skill1 + 180; }
			if (Scene > 3) { if (Counter > 30) { my.pan = my.skill1 - 90; } }
			if (Scene > 3) { if (Counter > 50) { if (my.skill40 == 0) { sPlay ("SFX053.WAV"); my.skill40 = 1; } Jump(); } }
		}

		wait(1);
	}
}

action BadX 
{ 
	my.skill31 = 12;
	my.skill1 = my.pan;

	while(1) 
	{ 
		if (TheCam == 2)
		{
			if (CamShow == 2) { my.invisible = on; my.shadow = off; }
			Blink(); 
			if (Scene > 3) { my.pan = my.skill1 + 180; }
			if (Scene > 3) { if (Counter > 30) { my.pan = my.skill1 + 90; } }
			if (Scene > 3) { if (Counter > 50) { Jump(); } }
			if (Scene > 3) { if (Counter > 70) { if (CamShow == 1) { CamShow = 2; Scene = 4.5; SetVoice(); } } }
		}

		wait(1); 
	} 
}

function Jump
{
	ent_cycle ("AH",my.skill30); 
	my.skill30 = my.skill30 + 20 * time; 
	my.z = my.z + my.skill31 * time;
	my.skill31 = my.skill31 - 1 * time;
	my. x = my.x + 5 * time;
}

action BadLava1
{
	while(1)
	{
		if (CamShow == 2) { my.invisible = off; my.shadow = on; }
		if (Talking == 2) { if (Scene != 10.5) { Talk(); } else { Talk2(); } } else { Blink(); }
		wait(1);
	}
}

action BadLava2
{
	while(1)
	{
		if (CamShow == 2) { my.invisible = off; my.shadow = on; }
		if (Talking == 3) { Talk(); } else { Blink(); }
		if (Scene == 9.5) { ent_frame ("Talk",100); }
		wait(1);
	}
}

action Twig
{
	while(1)
	{
		my.pan = my.pan + 10 * time; 
		my.roll = my.roll + 10 * time;
		my.tilt = my.tilt + 10 * time;

		if (Scene == 9.5)
		{
			my.invisible = off;
			my.shadow = on;
			my.skill1 = my.skill1 + 1 * time;
			if (my.skill1 > 7) { Scene = 10.5; SetVoice(); } else { my.x = my.x - 1 * time; my.y = my.y - 10 * time; }
		}

		if (Scene == 10.5) { my.z = my.z - 10 * time; }

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
	if (int(random(20)) == 10) { ent_frame ("Look",int(random(4)) * 33.3); }
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

action Creator
{
	while(1)
	{
		if ((int(random(100)) == 50) && (CamShow == 2))
		{
			my.skill1 = int(random(2)) + 1;
			if (my.skill1 == 1) { create (<Barrel.mdl>,my.x,Float); }
			if (my.skill1 == 2) { create (<Miner.mdl>,my.x,Float); }
		}

		wait(1);
	}
}

action Float
{
	my.pan = random(360);
	my.tilt = random(360);
	my.roll = random(360);
	my.skill2 = my.z;

	my.scale_x = my.scale_x / 4;
	my.scale_y = my.scale_y / 4;
	my.scale_z = my.scale_z / 4;

	while(1)
	{
		my.y = my.y - 7 * time;
		my.pan = my.pan + (int(random(3)) - 1) * time;
		my.tilt = my.tilt + (int(random(3)) - 1) * time;
		my.roll = my.roll + (int(random(3)) - 1) * time;
		my.z = my.z + (int(random(3)) - 1) * time;

		if (my.z > my.skill2 + 5) { my.z = my.skill2 + 5; }
		if (my.z < my.skill2 - 5) { my.z = my.skill2 - 5; }

		wait(1);
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