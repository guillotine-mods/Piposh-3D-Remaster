include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	vNoSave = 1;

	level_load("Intro15.WMB");

	VoiceInit();
	Initialize();

	scene_map = bmapBack6;

	sPlay ("Wait.wav");
	while (GetPosition (Voice) < 1000000) { wait(1); }

	sPlay ("SFX048.WAV");
}

action Fly
{
	player = my;
	my.skill1 = 10;
	my.skin = 5;

	while(1)
	{
		my.x = my.x + my.skill1 * time;
		my.z = my.z + my.skill2 * time; 
		my.skill1 = my.skill1 + 1 * time;
		if (my.skill1 > 70) { my.skill2 = my.skill2 + 1 * time; }
		if (my.skill1 > 170) { Run ("Mount.exe"); }
		ent_cycle ("Fly",my.skill5);
		my.skill5 = my.skill5 + (my.skill1 / 8) * time;

		wait(1);
	}
}

action Cam
{
	while(1)
	{
		if (player == null) { wait(1); }
		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;
		vec_set(temp,player.x);
		vec_sub(temp,camera.x);
		vec_to_angle(camera.pan,temp);
		wait(1);
	}
}
