include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Scene = 0;
var n = 0;
var Flag[6] = 0,0,0,0,0,0;
var STR;

var tNanny[8]   = 2,4,10,12,16,18,20,25;
var tRogale[5]  = 8,17,19,24,26;
var tButcher[4] = 1,9,14,21;
var tDomino[5]  = 11,13,15,23,26;
var tSusik[5]   = 5,6,7,22,26;

sound Stirring = <SFX054.WAV>;
sound Exploding = <SFX055.WAV>;

bmap bMeanwhile = <mod1.pcx>;

panel pMeanwhile
{
	bmap = bMeanwhile;
	layer = 20;
	flags = visible,d3d,refresh;
}

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	vNoSave = 1;

	load_level(<Intro6.WMB>);

	VoiceInit();
	Initialize();

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running

	waitt(60);
	pMeanwhile.visible = off;

}

action Nanny
{
	while (pMeanwhile.visible == on) { wait(1); }

	while(1)
	{
		n = 0; Flag[0] = 0;
		while (n < tNanny.length) { if (tNanny[n] == Scene) { Flag[0] = 1; } n = n + 1; }
		if (Flag[0] == 1) { Talk(); Flag[5] = 0; if (int(random(40)) == 20) { ent_frame ("Sit",int(random(8)) * 14.2); } } 
		else { ent_cycle ("Sit",0); Blink(); }
		wait(1);	
	}
}

action Rogale1
{
	while (pMeanwhile.visible == on) { wait(1); }

	while(1)
	{
		if (Scene > 6) { my.invisible = on; }
		if (Scene == 3) { Talk(); Flag[5] = 0; if (int(random(40)) == 20) { ent_frame ("Talk",int(random(4)) * 33.3); } } 
		else { ent_cycle ("Talk",0); Blink(); }
		wait(1);
	}
}

action Rogale2
{
	while (pMeanwhile.visible == on) { wait(1); }

	my.invisible = on;

	while(1)
	{
		if ((Scene > 6) && (Scene < 24)) { my.invisible = off; }
		if (Scene > 23) { my.invisible = on; }

		n = 0; Flag[1] = 0;
		while (n < tRogale.length) { if (tRogale[n] == Scene) { Flag[1] = 1; } n = n + 1; }
		if (Flag[1] == 1) 
		{ 
			if (int(random(40)) == 20) { ent_frame ("STalk",int(random(7)) * 16.6); } 
			Talk();
			Flag[5] = 0;
		}
		else 
		{ 
			if ((my.invisible == off) && (snd_playing (STR) == 0)) { play_entsound (my,stirring,1000); STR = result; } 
			Blink(); 
			ent_cycle ("Stir",my.skill1);
			my.skill1 = my.skill1 + 3;
		}

		wait(1);
	}
}

action Butcher
{
	while (pMeanwhile.visible == on) { wait(1); }

	while(1)
	{
		if (Scene == 26) { my.invisible = on; }
		n = 0; Flag[2] = 0; 
		while (n < tButcher.length) { if (tButcher[n] == Scene) { Flag[2] = 1; } n = n + 1; }
		if (Flag[2] == 1) { Talk(); Flag[5] = 1; if (int(random(40)) == 20) { ent_frame ("Talk",int(random(7)) * 16.6); } } 
		else { ent_cycle ("Sit",0); Blink(); }
		wait(1);
	}
}

action Domino
{
	while (pMeanwhile.visible == on) { wait(1); }

	while(1)
	{
		if (Scene == 26) { my.invisible = on; }
		n = 0; Flag[3] = 0; 
		while (n < tDomino.length) { if (tDomino[n] == Scene) { Flag[3] = 1; } n = n + 1; }
		if (Flag[3] == 1) { Talk(); Flag[5] = 1; if (int(random(40)) == 20) { ent_frame ("Talk",int(random(7)) * 16.6); } } 
		else { ent_cycle ("Sit",0); Blink(); }
		wait(1);
	}
}

action Susik
{
	while (pMeanwhile.visible == on) { wait(1); }

	while(1)
	{
		if (Scene == 26) { my.invisible = on; }
		n = 0; Flag[4] = 0; 
		while (n < tSusik.length) { if (tSusik[n] == Scene) { Flag[4] = 1; } n = n + 1; }
		if (Flag[4] == 1) { Talk(); Flag[5] = 1; if (int(random(40)) == 20) { ent_frame ("Talk",int(random(7)) * 16.6); } } 
		else { ent_cycle ("Sit",0); Blink(); }
		wait(1);
	}
}

action Cam
{
	while (pMeanwhile.visible == on) { wait(1); }

	my.skill1 = 0;
	Flag[5] = 1;
	Scene = 1;
	SetVoice();

	while(1)
	{
		if (Scene < 26)
		{
			my.skill1 = my.skill1 + 1;
			if (GetPosition(Voice) >= 1000000) { my.skill1 = 0; Scene = Scene + 1; SetVoice(); }

			if (Flag[5] == 0) { my.pan = 90; }
			if (Flag[5] == 1) { my.pan = -90; }

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

action Cam2
{
	while (pMeanwhile.visible == on) { wait(1); }
	my.skill1 = 0;

	while(1)
	{
		if (Scene == 26)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;

			my.z = my.z + 2 * time;
			my.skill1 = my.skill1 + 1 * time;
			if (my.skill1 > 80) { ReturnToMap(); }
		}

		wait(1);
	}
}

function Talk()
{
	my.skill11 = my.skill11 + 1 * time;
	if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; }
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


action RogCof
{
	my.invisible = on;

	while(1)
	{
		if (Scene > 23) { my.invisible = off; if (my.skill40 == 0) { play_sound (Exploding,100); my.skill40 = 1; } }
		while (n < tRogale.length) { if (tRogale[n] == Scene) { Flag[1] = 1; } n = n + 1; }
		if (Flag[1] == 1) { Talk(); } else { Blink(); }
		wait(1);
	}
}

action BlowUp
{
	while(Scene <= 23) { wait(1); }
	_gib(100);
	actor_explode();
}

action Coffee
{
	my.invisible = on;
	
	while(1)
	{
		if (Scene > 23) { my.invisible = off; }
		wait(1);
	}
}

function SetVoice
{
	if (Scene == 0)  { sPlay ("Wait.wav"); }
	if (Scene == 1 ) { sPlay ("KZV001.WAV"); }
	if (Scene == 2 ) { sPlay ("NAN016.WAV"); }
	if (Scene == 3 ) { sPlay ("ROG010.WAV"); }
	if (Scene == 4 ) { sPlay ("NAN017.WAV"); }
	if (Scene == 5 ) { sPlay ("SUS001.WAV"); }
	if (Scene == 6 ) { sPlay ("Wait.WAV"); }
	if (Scene == 7 ) { sPlay ("SUS002.WAV"); }
	if (Scene == 8 ) { sPlay ("ROG011.WAV"); }
	if (Scene == 9 ) { sPlay ("KZV002.WAV"); }
	if (Scene == 10) { sPlay ("NAN018.WAV"); }
	if (Scene == 11) { sPlay ("DOM001.WAV"); }
	if (Scene == 12) { sPlay ("NAN019.WAV"); }
	if (Scene == 13) { sPlay ("DOM002.WAV"); }
	if (Scene == 14) { sPlay ("KZV004.WAV"); }
	if (Scene == 15) { sPlay ("DOM003.WAV"); }
	if (Scene == 16) { sPlay ("NAN020.WAV"); }
	if (Scene == 17) { sPlay ("ROG012.WAV"); }
	if (Scene == 18) { sPlay ("NAN021.WAV"); }
	if (Scene == 19) { sPlay ("ROG014.WAV"); }
	if (Scene == 20) { sPlay ("NAN022.WAV"); }
	if (Scene == 21) { sPlay ("KZV005.WAV"); }
	if (Scene == 22) { sPlay ("SUS003.WAV"); }
	if (Scene == 23) { sPlay ("DOM004.WAV"); }
	if (Scene == 24) { sPlay ("ROG015.WAV"); }
	if (Scene == 25) { sPlay ("NAN023.WAV"); }
	if (Scene == 26) { sPlay ("KZV006.WAV"); }
}

action Fall
{
	my.invisible = on;

	while(1)
	{
		if (Scene == 26) { my.invisible = off; }
		wait(1);
	}
}