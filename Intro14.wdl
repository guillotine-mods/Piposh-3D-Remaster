include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Scene = 0;
var Talking;

sound Alarm1 = <"ALR001.WAV">;
sound Mad1 = <"MAD001.WAV">;
sound Mad2 = <"MAD002.WAV">;
sound Mad3 = <"MAD003.WAV">;
sound Mad4 = <"MAD004.WAV">;
sound Mad5 = <"MAD005.WAV">;
sound Mad6 = <"MAD006.WAV">;

sound Snatch = <SFX087.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	vNoSave = 1;

	level_load("Intro14.WMB");

	VoiceInit();
	Initialize();

	SetVoice();
}

action Cam
{
	while(1)
	{
		if ((GetPosition(Voice) >= 1000000) && (Scene != 10)) { Scene = Scene + 1; SetVoice(); }
		if ((Scene != 2) && (Scene != 10) && (Scene != 11))
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

action Piposh
{
	player = my;

	while(1)
	{
		if (Scene < 6)
		{
			if (my.skill1 == 1) { my.invisible = on; my.shadow = off; }
			if (my.skill1 == 2) { my.invisible = off; my.shadow = on; }
		}
		else
		{
			if (my.skill1 == 1) { my.invisible = off; my.shadow = on; }
			if (my.skill1 == 2) { my.invisible = on; my.shadow = off; }
		}
			
		if (Talking == 1) { Talk(); }
		else
		{
			if (Talking == 3) 
			{ 
				if (GetPosition (Voice) < 300000) { Talk(); } else { Talk3(); }
			}
			else { Blink(); }
		}

		if (Scene > 11) { my.invisible = on; my.shadow = off; }

		if (Scene < 2)
		{
			ent_frame ("TakeVase",0);
		}
		if ((Scene > 2) && (Scene < 5)) { ent_frame ("LookLeft",0); }

		wait(1);
	}
}

action Docs
{
	while(1)
	{
		if (Talking == 2) { Talk(); } else { Blink(); }

		if (Scene > 2) { my.invisible = off; my.shadow = on; }
		if (Scene > 11) { my.invisible = on; my.shadow = off; }

		wait(1);
	}
}


action Doctors
{
	while(1)
	{
		if (Talking == 2) { Talk(); } else { Blink(); }

		if (Scene == 2)
		{
			my.y = my.y + 5 * time;
			ent_cycle ("Walk",my.skill10);
			my.skill10 = my.skill10 + 10 * time;
		}

		wait(1);
	}
}

action PieceX
{
	while(1) { if (Scene >= 11) { my.invisible = on; } wait(1); }
}

action Piposh2
{
	my.skill1 = my.z;
	my.z = my.z - 50;

	while(1)
	{
		if (Scene == 10)
		{
			Blink();
			ent_frame ("Grab",0);
			if (my.z < my.skill1) {	my.z = my.z + 3 * time; } else { Scene = 11; SetVoice(); play_Sound (Alarm1,50); }
		}

		if (Scene == 11)
		{
			Talk();
			ent_frame ("Grab",100);
		}

		wait(1);
	}
}

action PieceX2
{
	while (1) { if (Scene > 10) { if (my.skill40 == 0) { play_sound (Snatch,100); my.skill40 = 1; } my.invisible = on; } wait(1); }
}

action Cam2
{
	while(1)
	{
		if (Scene == 2)
		{
			my.y = my.y + 5 * time;
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

action Cam3
{
	while(1)
	{
		if ((Scene == 10) || (Scene == 11))
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


function SetVoice()
{
	if (Scene == 0)  { sPlay ("Wait.wav"); Talking = 0; }
	if (Scene == 1)  { sPlay ("PIP485.WAV"); Talking = 1; }
	if (Scene == 2)  { sPlay ("DOC004.WAV"); Talking = 2; }
	if (Scene == 3)  { sPlay ("DOC002.WAV"); Talking = 2; }
	if (Scene == 4)  { sPlay ("PIP486.WAV"); Talking = 1; }
	if (Scene == 5)  { sPlay ("DOC005.WAV"); Talking = 2; }
	if (Scene == 6)  { sPlay ("PIP487.WAV"); Talking = 1; }
	if (Scene == 7)  { sPlay ("DOC003.WAV"); Talking = 2; }
	if (Scene == 8)  { sPlay ("PIP488.WAV"); Talking = 3; }
	if (Scene == 9)  { sPlay ("PIP489.WAV"); Talking = 1; }
	if (Scene == 11) { sPlay ("PIP490.WAV"); Talking = 1; }
	if (Scene == 12) { sPlay ("PIP491.WAV"); Talking = 1; MayHam(); }
	if (Scene == 13) { Run ("AsyAct3.exe"); }
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } else { ent_frame ("Talk",int(random(5)) * 25); } }
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

ACTION dyna_light {
	SET MY.INVISIBLE,ON;
	SET MY.LIGHTRED,128;
	SET MY.LIGHTGREEN,0;
	SET MY.LIGHTBLUE,0;
		WHILE (1) {
			
			MY.LIGHTRANGE = RANDOM (1000)+100;
			if (Scene < 11) { my.lightrange = 0; }
		WAITT 4;
	}
}

action RunInCircle
{
	actor_init();
	drop_shadow();
	my.skill1 = 0;
	my.passable = on;
	my.invisible = on;
	my.shadow = off;

	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found

	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
		if (Scene > 11) { my.invisible = off; my.shadow = on; }
		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		if (result < 25) { ent_nextpoint(my._TARGET_X); }
	
		force = 6;
		actor_turnto(my_angle.PAN);
		force = 6;
		actor_move();

		ent_cycle ("Walk",my.skill37);
		my.skill37 = my.skill37 + 20 * time;

		wait(1);
	}
}

action Mad
{
	while (1)
	{
		if (Scene >= 11) { my.invisible = on; my.shadow = off; } else { my.invisible = off; my.shadow = on; }
		wait(1);
	}
}

function MayHam
{
	play_sound (MAD1,30);
	play_sound (MAD2,30);
	play_sound (MAD3,30);
	play_sound (MAD4,30);
	play_sound (MAD5,30);
	play_sound (MAD6,30);
}

action PiposhCell
{
	actor_init();
	drop_shadow();
	my.skill1 = 0;

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

		if (Scene > 11) { my.invisible = off; my.shadow = on; } else { my.invisible = on; my.shadow = off; }

		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

// near target? Find next waypoint
// compare radius must exceed the turning cycle!

		if (result < 25) { ent_nextpoint(my._TARGET_X); }

		if ((int(random(100)) == 50) && (my.skill1 == 0)) { my.skill1 = 100; }

// turn and walk towards target
			
			if (my.skill1 == 0)
			{
				force = 6;
				actor_turnto(my_angle.PAN);
				force = 3;
				actor_move();
			}
			else
			{
				my.skill1 = my.skill1 - 1;
				if (int(random(30)) == 15) { ent_frame ("Talk",int(random(8)) * 14); }
			}

				my.skill15 = my.skill15 + 1;
				if (my.skill15 > 3) { my.skin = int(random(8))+1; my.skill15 = 0; }


// Wait one tick, then repeat
		wait(1);
	}
}