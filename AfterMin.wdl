include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Pieces = 0;
var Broken = 0;

sound Break = <SFX001.wav>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;

	level_load("AfterMin.wmb");

	VoiceInit();
	Initialize();

	if (Piece[0] == 1) { Pieces = Pieces + 1; }
	if (Piece[1] == 1) { Pieces = Pieces + 1; }
	if (Piece[2] == 1) { Pieces = Pieces + 1; }
	if (Piece[3] == 1) { Pieces = Pieces + 1; }
	if (Piece[4] == 1) { Pieces = Pieces + 1; }

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running
}

action Piposh
{
	player = my;

	my.skill1 = my.y;
	my.skill2 = my.pan;
	my.y = my.y + 500;

	while (1)
	{
		if (my.y > my.skill1) { my.y = my.y - 15 * time; Blink(); }
		else
		{
			if (my.pan < (my.skill2 + 50)) { my.pan = my.pan + 4 * time; my.y = my.y - 4 * time; my.x = my.x + 3 * time; Blink(); }
			else
			{
				sPlay ("PIP193.WAV"); while (GetPosition (Voice) < 1000000) { Talk(); wait(1); }

				if (Pieces == 1) { sPlay ("VOC001.WAV"); while (GetPosition (Voice) < 1000000) { Blink(); wait(1); } }
				if (Pieces == 2) { sPlay ("VOC002.WAV"); while (GetPosition (Voice) < 1000000) { Blink(); wait(1); } }
				if (Pieces == 3) { sPlay ("VOC003.WAV"); while (GetPosition (Voice) < 1000000) { Blink(); wait(1); } }
				if (Pieces == 4) { sPlay ("VOC004.WAV"); while (GetPosition (Voice) < 1000000) { Blink(); wait(1); } }
				if (Pieces == 5) { sPlay ("VOC005.WAV"); while (GetPosition (Voice) < 1000000) { Blink(); wait(1); } }
				if (Pieces == 6) { sPlay ("VOC006.WAV"); while (GetPosition (Voice) < 1000000) { Blink(); wait(1); } }

				sPlay ("PIP194.WAV"); while (GetPosition (Voice) < 1000000) { Talk(); wait(1); }

				Run ("Intro7.exe");
			}
		}

		wait(1);
	}
}

action Miner
{
	my.skill1 = my.y;
	my.skill2 = my.pan;
	my.y = my.y + 500;
	my.skill3 = 5;

	while (1)
	{
		if (my.y > my.skill1) { my.y = my.y - 15 * time; }
		else
		{
			if (my.pan < (my.skill2 + 50)) { my.pan = my.pan + 4 * time; my.y = my.y - 4 * time; my.x = my.x + 3 * time; }
		}

		wait(1);
	}
}

action Wall
{
	while (player == null) { wait(1); }

	while(1)
	{
		if (player.y < (my.y + 100))
		{
			if (Broken == 0) { Broken = 1; play_sound Break,100; }
			ent_frame ("Break",my.skill1);
			my.skill1 = my.skill1 + 5 * time;
		}
		else { ent_frame ("Full",0); }
		
		wait(1);
	}
}

action Cam
{
	while(1)
	{
		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;
		camera.pan = my.pan;
		camera.tilt = my.tilt;
		camera.roll = my.roll;
		wait(1);
	}
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } else { ent_frame ("Talk",int(random(5)) * 25); } }
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