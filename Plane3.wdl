include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Stage = 1;
var Count = 0;
var Yoyo;
var Talking;
var Dude = 3;
var Scene = 0;
var SPD = 1.5;
var Building;
var CamShow = 0;

var SND = 0;

synonym TheVase { type entity; }
synonym Birdy { type entity; }

sound Jet = <SFX091.WAV>;
sound WindS = <SFX092.WAV>;
sound VaseB = <SFX093.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;

	vNoMap = 1;

	load_level(<Plane3.WMB>);

	VoiceInit();
	Initialize();

	SetVoice();

	fog_color = 1;
	camera.fog = 10;
}

action RandomBuilding
{
	my.skill20 = my.y;

	Building = int(random(10)) + 1;
	if (Building == 1) { morph (<House1.mdl>,my); }
	if (Building == 2) { morph (<House2.mdl>,my); }
	if (Building == 3) { morph (<House3.mdl>,my); }
	if (Building == 4) { morph (<House4.mdl>,my); }
	if (Building == 5) { morph (<House5.mdl>,my); }
	if (Building == 6) { morph (<House6.mdl>,my); }
	if (Building == 7) { morph (<House7.mdl>,my); }
	if (Building == 8) { morph (<House8.mdl>,my); }
	if (Building == 9) { morph (<House9.mdl>,my); }
	if (Building == 10) { morph (<House10.mdl>,my); }

	Building = int(random(4)) + 1;
	if (Building == 1) { my.pan = 0; } 
	if (Building == 2) { my.pan = 90; }
	if (Building == 3) { my.pan = 180; }
	if (Building == 4) { my.pan = 270; }

	while(1) 
	{ 
		if ((Stage == 1) && (Dialog.visible == off)) { my.y = my.y - SPD * time; } 
		if ((Stage > 1) && (Dialog.visible == off)) { my.y = my.skill20; my.z = my.z + SPD * time; } 
		wait(1);
	}
}

action KKK
{
	my.invisible = on;

	while(1)
	{
		if (Scene == 5) { my.invisible = off; }
		if (Scene == 5) { ent_frame ("Throw",0); Talk(); } else { ent_frame ("Stand",0); Blink(); }
		wait(1);
	}
}

action Dome
{
	my.skin = 1;

	while(1) 
	{ 
		my.pan = my.pan + 0.1 * time; 

		if (Scene > -1) { if ((GetPosition(Voice) >= 1000000) && (Scene != 6)) { Scene = Scene + 1; SetVoice(); } }

		if (DialogIndex == 5)
		{
			while (Dialog.visible == on) { Blink(); wait(1); }

			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP049.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				DialogIndex = 0; Talking = 0; Scene = 5; SetVoice();
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP050.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				DialogIndex = 0; Talking = 0; Scene = 5; SetVoice();
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP051.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				DialogIndex = 0; Talking = 0; Scene = 5; SetVoice();
			}
		}

		if (DialogIndex == 6)
		{
			while (Dialog.visible == on) { Blink(); wait(1); }

			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP053.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				DialogIndex = 0; Dude = 2; Talking = 0;
			}
	
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP054.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("SHK023.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }
				DialogIndex = 0; Dude = 2; Talking = 0;
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP055.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { wait(1); }
				sPlay ("SHK024.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { wait(1); }
				DialogIndex = 0; Dude = 2; Talking = 0;
			}
		}

		wait(1); 
	}
}

action Cam
{
	while(1)
	{
		if (Stage == my.skill1)
		{
			if (CamShow == my.skill2)
			{
				camera.x = my.x;
				camera.y = my.y;
				camera.z = my.z;
				camera.tilt = my.tilt;
				camera.roll = my.roll;
				camera.pan = my.pan;
			}

			my.skill3 = my.skill3 - 1 * time;
		}
		wait(1);
	}
}

action PIPI
{
	my.invisible = on;

	while (Stage == 1)
	{
		if (Talking == 1) { Talk(); } else { Blink(); }
		if (CamShow == 1) { my.invisible = off; }
		if (Scene == 5) { if (int(random(40)) == 20) { ent_frame ("Lookup",int(random(3)) * 50); } } else { ent_cycle ("Stand",my.skill1); my.skill1 = my.skill1 + 10 * time; }
		if (Scene == 6) { ent_frame ("LookDown",0); }
		wait(1);
	}
}

action PIPI2
{
	while (Stage == 1)
	{
		if (Talking == 1) { Talk(); } else { Blink(); }
		if (CamShow == 1) { my.invisible = on; }
		wait(1);
	}
}

action Clouds
{
	my.skill1 = my.y;
	my.skill2 = random(1000) + 500;

	while(1)
	{
		my.y = my.y - 30 * time;
		if (my.y < (my.skill1 - my.skill2)) { my.y = my.skill1; my.skill2 = random(1000) + 500; }
		ent_cycle ("Walk",my.skill3);
		my.skill3 = my.skill3 + 30 * time;
		if (my.skill3 > 1000) { my.skill3 = 0; }
		wait(1);
	}
}

action Clouds2
{
	my.skill1 = my.z;
	my.skill2 = random(1000) + 500;

	while(1)
	{
		my.z = my.z + 30 * time;
		if (my.z > (my.skill1 + my.skill2)) { my.z = my.skill1; my.skill2 = random(1000) + 500; my.scale_x = random(1); my.scale_y = my.scale_x; my.scale_z = my.scale_x; }
		wait(1);
	}
}

action PipFall
{
	player = my;
	my.skill10 = my.z;
	my.skill30 = my.skill1;

	while(1)
	{
		if (snd_playing (SND) == 0)
		{
			if (Scene < 7) { play_sound (Jet,20); }
			else { play_sound (WindS,100); }

			SND = result;
		}

		if (Stage > 1)
		{
			if (Dude == my.skill30) 
			{ 
				player = my; my.invisible = off; 

				if (Dude == 1) { if (Talking == 1) { Talk(); } else { Blink(); } }
				if (Dude == 3) { if (Talking == 1) { Talk(); } else { Blink(); } }
				if (Dude == 2) { if (Talking == 1) { Talk(); } else { my.skin = 5; } }
			}
			else { my.invisible = on; }

			if (player.skill5 == 0) { ent_cycle ("Fall",my.skill1); my.skill1 = my.skill1 + 15 * time; }
			else 
			{ 
				if (TheVase == null) { morph (<PipWrite.mdl>,my); Stage = 4; }
				if (Stage == 4) { ent_cycle ("Write",my.skill1); my.skill1 = my.skill1 + 15 * time; my.z = my.z - 0.5 * time; }
				if (Stage < 4) { ent_frame ("Fetch",my.skill1); my.skill1 = my.skill1 + 3 * time; }
			}

			if ((my.skill5 == 1) && (TheVase != null))
			{
				if (my.skill30 == 2)
				{
					vec_set(temp,TheVase.x); 
					vec_sub(temp,my.x);
					vec_to_angle(my.pan,temp);
					Force = 0.8;
					actor_move();
					my.z = my.skill10;
				}
			}
	
			if (my.skill30 !=2) { my.pan = my.pan + (int(random(3)) - 1) * 2; } else { if (TheVase == null) { my.pan = my.pan + (int(random(3)) - 1) * 2; } }
		}
		
		wait(1);
	}
}

action Land
{
	my.skill20 = my.y;

	while (1)
	{
		if ((Stage == 1) && (Dialog.visible == off)) { my.y = my.y - SPD * time; } 
		if ((Stage > 1) && (Dialog.visible == off)) { my.y = my.skill20; my.z = my.z + SPD * time; } 
		wait(1);
	}
}

action XVase
{
	while(Scene != 7)
	{
		if (Scene == 5) { my.invisible = off; }
		if (Scene == 6) 
		{ 
			my.z = my.z - 30 * time; 
			my.skill1 = my.skill1 + 1 * time;
			if (my.skill1 > 10) { Scene = 7; SetVoice(); }
		}
		wait(1);
	}

	remove (my);
}

action Pisa
{
	my.skill20 = my.y;

	while (1)
	{
		if ((Stage == 1) && (Dialog.visible == off)) { my.y = my.y - SPD * time; } 
		if ((Stage > 1) && (Dialog.visible == off)) { my.y = my.skill20; my.z = my.z + SPD * time; } 
		wait(1);
	}
}

action Vase
{
	TheVase = my;

	while(TheVase != null)
	{
		my.pan = my.pan + 2 * time;
		my.tilt = my.tilt + 2 * time;
		my.roll = my.roll + 2 * time;

		if ((Stage == 2) && (Dude == 2))
		{
			if (my.z < (player.z + 50)) { my.z = my.z + 1 * time; }
			if ((my.z > player.z) && (player.skill5 == 0)) { player.skill1 = 0; player.skill5 = 1; }
		}
		wait(1);
	}
}

action BadBird2
{
	while(1)
	{
		if (TheVase == null)
		{
			my.invisible = off;
			my.x = my.x - 9 * time;
			my.y = my.y + 9 * time;
			my.roll = my.roll + 10 * time;
			ent_cycle ("Walk",my.skill1);
			my.skill1 = my.skill1 + 15 * time;
		}

		wait(1);
	}
}

action BadBird
{
	Birdy = my;
	my.skill2 = my.z;

	while(1)
	{
		ent_cycle ("Walk",my.skill1);
		my.skill1 = my.skill1 + 15 * time;

		if (TheVase == null) { wait(1); }

		if (player.skill5 == 1)
		{
			Stage = 3;

			force = 6;
			actor_move();

			if (TheVase != null) 
			{ 
				vec_set(temp,TheVase.x); 
				vec_sub(temp,camera.x);
				vec_to_angle(camera.pan,temp);

				my.z = TheVase.z;
				Yoyo = Yoyo + 1 * time;
				if (Yoyo > 40) 
				{ 
					play_sound (VaseB,100);
					my = TheVase;
					_gib (20);
					actor_explode();
					my = Birdy;
					sPlay ("PIP056.WAV");
					Talking = 1;
					while (GetPosition(Voice) < 1000000) { force = 6; actor_move(); wait(1); }

					Piece[0] = 1;
					writegamedata(0);

					Run ("Smash.exe");
				}

			}

		}
		wait(1);
	}
}

function SetVoice
{
	if (Scene == 0) { sPlay ("Wait.WAV"); Talking = 0; }
	if (Scene == 1) { sPlay ("PIP046.WAV"); Talking = 1; } 
	if (Scene == 2) { CamShow = 1; sPlay ("PIP047.WAV"); Talking = 1; }
	if (Scene == 3) { sPlay ("PIP048.WAV"); Talking = 1; }
	if (Scene == 4) { DoDialog (5); }
	if (Scene == 5) { sPlay ("KRP015.WAV"); Talking = 2; }
	if (Scene == 7) { stop_sound (SND); Stage = 2; CamShow = 1; sPlay ("PIP052.WAV"); Talking = 1; }
	if (Scene == 8) { Dude = 1; sPlay ("SHK022.WAV"); Talking = 2; }
	if (Scene == 9) { DoDialog (6); }
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
}

function Blink()
{
	if (my.skill42 > 0) { my.skill42 = my.skill42 - 1 * time; }
	if (my.skill42 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill42 = 5; }
	}
}

function DoDialog (num)
{
	DialogChoice = 0;
	DialogIndex = num; 
	ShowDialog();
	Talking = 0;
}