include <IO.wdl>;

var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var SkipMovie = 0;
var Start = 0;
var NoMovie = 0;

bmap bSom = <Somewher.bmp>;
bmap bOvr = <Someover.bmp>;

panel pSom
{
	layer = 2;
	bmap = bSom;
	pos_x = 0;
	pos_y = 460;
	flags = refresh,d3d;
}

panel pOvr
{
	layer = 3;
	bmap = bOvr;
	pos_x = 223;
	pos_y = 460;
	flags = refresh,d3d;
}

bmap splashmap = <A5.pcx>;
panel splashscreen {
	bmap = splashmap;
	flags = refresh,d3d;
}

function EndLogo
{
	SkipMovie = 1;
}

var LockZ = 0;
var Scene = 0;
var Delay = 20;

sound CRWD = <SFX097.WAV>;

bmap Shkufit = <Shkufit.pcx>;

panel pShkufit
{
	bmap = Shkufit;
	layer = 5;
	flags = refresh,d3d;
}

synonym Yachdel { type entity; }

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	camera.visible = off;
	splashscreen.visible = on;

	wait(3);

	filehandle = file_open_read ("Movie.dat");
		NoMovie = file_var_read (filehandle);
	file_close (filehandle);

	if (NoMovie == 0) { load_level(<Start.WMB>); }

	VoiceInit();
	Initialize();
	pLoading.visible = off;

	waitt(32);

  	splashscreen.visible = off;
	bmap_purge(splashmap);

	wait(3);

	play_moviefile ("MOV\\Logo.avi");

	while ((movie_frame != 0) && (SkipMovie == 0)) { wait(1); }

	stop_movie;

	SkipMovie = 0;

	play_moviefile ("MOV\\Title.avi");

	while ((movie_frame != 0) && (SkipMovie == 0)) { wait(1); }

	stop_movie;

	camera.visible = on;

	if (NoMovie == 1) { Run ("Menu.exe"); }	// Skip movie

	NoMovie = 1;

	filehandle = file_open_write ("Movie.dat");
		file_var_write (filehandle,NoMovie);
	file_close (filehandle);

	Start = 1;
}

action DefineYachdel
{
	Yachdel = my;

	while (Start == 0) { wait(1); }

	pOvr.visible = on;
	pSom.visible = on;

	while(1)
	{
		if (POvr.pos_x > -200) 
		{ 
			POvr.pos_x = POvr.pos_x - 8 * time; 
		}
		else
		{
			my.skill34 = my.skill34 + 1 * time;
			my.skill35 = my.skill35 + 1 * time;

			if (my.skill34 > 60) 
			{ 
				pOvr.pos_y = pOvr.pos_y + 1 * time;
				pSom.pos_y = pSom.pos_y + 1 * time;
			}

			if (my.skill35 > 5) 
			{ 
				if (POvr.visible == on) { pOvr.visible = off; } else { pOvr.visible = on; }
				my.skill35 = 0; 
			}
		}

		if (snd_playing(my.skill40) == 0) { if (Scene < 3) { play_sound (CRWD,30); my.skill40 = result; } }
		if (Scene == 3)
		{
			stop_sound (my.skill40);
			pShkufit.visible = on;
			Delay = Delay - 1 * time;
			if (Delay < 0) { Scene = 4; SetVoice(); }
		}
		else { pShkufit.visible = off; }

		if ((Scene == 0) || (Scene == 2) || (Scene == 4))
		{
			if (int(random(40)) == 20) { ent_frame ("Speech",int(random(23)) * 4.54); }
			Talk();
		}
		else { ent_frame ("Speech",0); Blink(); }

		wait(1);
	}
}

action LookAtMe
{

while (Start == 0) { wait(1); }

if (Yachdel == null) { wait(1); }

	SetVoice();
	LockZ = my.z;

	my._movemode = 1;
	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found

// find first waypoint
	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{

	if (Scene == 6) { Run ("Menu.exe"); }
	if ((GetPosition(Voice) >= 1000000) && (Scene != 3)) { Scene = Scene + 1; SetVoice(); }

	// find direction
		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		if (result < 25) { ent_nextpoint(my._TARGET_X); }

		if ((Scene == 0) || (Scene == 2))
		{
			if (my.flag1 == off)
			{
				force = 10; 
				actor_turnto(my_angle.PAN);
				force = 3; 
				actor_move(); 
				camera.x = my.x;
				camera.y = my.y;
				vec_set(temp,Yachdel.x);
				vec_sub(temp,camera.x);
				vec_to_angle(camera.pan,temp);
			}
		}
		else
		{
			if ((my.flag1 == on) && (Scene != 4))
			{
				force = 1; 
				actor_turnto(my_angle.PAN);
				actor_move(); 
				camera.x = my.x;
				camera.y = my.y;
				camera.pan = 270;
			}

		}

		my.z = LockZ;

// Wait one tick, then repeat
		wait(1);
	}
}

action Crowd
{
	while (Start == 0) { wait(1); }

	my.skill1 = random(100);
	my.skill2 = random(5)+5;

	while(1)
	{
		if ((Scene == 1) || (Scene ==5)) { Talk(); } else { my.skin = 1; }
		if ((Scene > 2) && (my.flag1 == OFF)) { my.invisible = on; my.shadow = off; }
		ent_cycle ("Frame",my.skill1);
		my.skill1 = my.skill1 + my.skill2 * time;
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
	if (my.skill12 > 0) { my.skill12 = my.skill12 - 1 * time; }
	if (my.skill12 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill12 = 5; }
	}

}

function SetVoice
{
	if (Scene == 0) { sPlay ("YCH003.WAV"); }
	if (Scene == 1) { sPlay ("CRD001.WAV"); }
	if (Scene == 2) { sPlay ("YCH004.WAV"); }
	if (Scene == 4) { sPlay ("YCH005.WAV"); }
	if (Scene == 5) { sPlay ("CRD002.WAV"); }
}

action Grandma
{
	while (Start == 0) { wait(1); }

	my.skill10 = my.z;

	while(1)
	{
		my.z = my.z + 1 * time;
		if (my.z > (my.skill10 + 2)) { my.z = my.skill10; }
		wait(1);
	}
}

action FarCam
{
	while (Start == 0) { wait(1); }

	while(1)
	{
		if (Scene == 4)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.tilt = my.tilt;
			camera.pan = my.pan;
			camera.roll = my.roll;
		}

		wait(1);
	}
}

function EndSCene { Run ("Menu.exe"); }

on_space = EndLogo();
on_mouse_left = EndLogo();
on_mouse_right = EndLogo();
on_enter = EndLogo();
on_esc = EndScene();