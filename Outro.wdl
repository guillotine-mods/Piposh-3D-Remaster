include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var CamShow = 1;
var Talking = 0;
var Scene = 0;
var A[3] = 0,0,0;
var B[3] = 0,0,0;
var SND = 0;
var STR;
var KAZ;
var Phase = 0;

bmap bShkufit1 = <Shkufit1.pcx>;
bmap bShkufit2 = <Shkufit2.pcx>;

panel pShkufit
{
	bmap = bShkufit1;
	flags = d3d,refresh;
	layer = 10;
}

sound stir = <SFX054.wav>;
sound TomSmash = <SFX072.WAV>;
sound Kazablan = <SFX074.WAV>;
sound Ambient = <SFX075.WAV>;
sound Traffic = <SFX076.WAV>;

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;

	vNoMap = 1;

	level_load("Outro.wmb");

	VoiceInit();
	Initialize();

	Scene_map = bmapBack1;

	Scene = 0;
	SetVoice();
}

action TV
{
	SET MY.INVISIBLE,ON;

	SET MY.LIGHTRED,0;
	SET MY.LIGHTGREEN,0;
	SET MY.LIGHTBLUE,128;

		WHILE (Scene < 7) 
		{
			MY.LIGHTRANGE = RANDOM (200)+150;
			WAITT 4;
		}

		my.lightrange = 0;
} 

action Cam
{
	while(1)
	{
		if (CamShow == my.skill1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.roll = my.roll;
			camera.tilt = my.tilt;
			camera.pan = my.pan;

			if (Talking == 2)
			{
				my.y = my.y + 1 * time;
				my.x = my.x + 1 * time;
				my.z = my.z - 1 * time;
			}

			if (Talking == 3) { my.roll = 5; }

			if ((Scene == 20) && (my.flag1 == on)) { my.x = my.x + 1 * time; }
		}

		wait(1);
	}
}

action Yach
{
	while(1)
	{
		B.x = my.x;
		B.y = my.y;
		B.z = my.z;

		ent_frame ("Sit",0);
		if (Talking == 6) { Talk2(); } else { Blink2(); }

		wait(1);
	}
}

action CamX
{
	while(1)
	{
		if (CamShow == my.skill1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;

			if ((Talking == 6) || (Talking == 7)) { my.x = my.x - 1.5 * time; }

			vec_set(temp,B.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

			camera.roll = my.roll;
			camera.tilt = my.tilt;
			camera.pan = my.pan;
		}

		wait(1);
	}
}

action Soldier
{
	ent_frame ("Stand",0);
}

action Roga
{
	while(1)
	{
		ent_cycle ("Stir",my.skill1);
		my.skill1 = my.skill1 + 10 * time;
		if (Scene < 3) { if (snd_playing (STR) == 0) { play_entsound (my,stir,300); STR = result; } }
		wait(1);
	}
}

action Nanny
{
	while(1)
	{
		if (talking == 1) { talk(); } else { blink(); }
		my.skin = 8;
		if ((Talking == 5) && (my.flag1 == on)) { ent_cycle ("Tom",my.skill1); my.skill1 = my.skill1 + 5 * time; my.x = my.x - 8 * time; }
		wait(1);
	}
}

action Manager
{
	my.skill1 = my.z;
	my.z = my.z - 50;

	while(1)
	{
		if (Talking == 6) { Talk(); } else { Blink(); }
		if (Talking == 6) { if (my.z < my.skill1) { my.z = my.z + 10 * time; } }
		wait(1);
	}
}

action Flow
{
	while(1)
	{
		if ((GetPosition(Voice) >= 1000000) && (Scene != 29) && (Scene != 34) && (SCene != 17) && (SCene != 10)) { Scene = Scene + 1; SetVoice(); }
		wait(1);
	}
}

action Piposh
{
	ent_frame ("Die",0);

	while(1)
	{
		if (Talking == 3)
		{
			my.shadow = on;
			if (my.skill1 < 100) { ent_frame ("Die",my.skill1); my.skill1 = my.skill1 + 10 * time; } else { Scene = 11; SetVoice(); }
		}

		wait(1);
	}
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(20)) == 10) { if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } else { ent_frame ("Talk",int(random(5)) * 25); } }
}

function Talk2()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
}

function TalkK()
{
	if (int(random(20)) == 10) { ent_frame ("KTalk",int(random(3)) * 50); } }
}

function TalkN()
{
	if (int(random(20)) == 10) { ent_frame ("NTalk",int(random(3)) * 50); } }
}

function TalkNin()
{
	if (int(random(20)) == 10) { ent_frame ("Lie",int(random(4)) * 33.3); } }
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

function Blink2()
{
	if (my.skill22 > 0) { my.skill22 = my.skill22 - 1 * time; }
	if (my.skill22 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill22 = 5; }
	}
}

action Stain
{
	while(1)
	{
		if (Talking == 3) { my.invisible = off; }
		wait(1);
	}
}

action Drive
{
	while(1)
	{
		if (Talking == 4)
		{
			my.y = my.y + 100 * time;
		}

		wait(1);
	}
}

action DummyZ
{
	A.x = my.x;
	A.y = my.y;
	A.z = my.z;
}

action Tom
{
	while(1)
	{
		if (Talking == 5)
		{
			if (my.y >= A.y) { ent_frame ("Smash",0); my.z = my.z - 0.2 * time; if (my.skill40 == 0) { play_entsound (my,TomSmash,300); my.skill40 = 1; } } 
			else 
			{ 
				my.z = my.z - 5 * time; 
				if (my.x < A.x) { my.x = my.x + 1 * time; }
				if (my.x > A.x) { my.x = my.x - 1 * time; }
			
				if (my.y < A.y) { my.y = my.y + 20 * time; }
			}
		}

		wait(1);
	}
}

action Dome { my.skin = 1; while(1) { my.pan = my.pan + 0.2 * time; wait(1); } }

action Girls
{
	while(1)
	{
		ent_cycle ("Frame",my.skill1);
		my.skill1 = my.skill1 + 5 * time;
		if (Talking == 20) { Talk2(); }
		wait(1);
	}
}

action Ami
{
	while(1)
	{
		if (Talking == 9) { talk(); } else { blink(); }
		wait(1);
	}
}

action KN
{
	while(1)
	{
		if (Talking == 10) 
		{ 
			if (Phase == 10) { TalkK(); }
			if (Phase == 11) { ent_cycle ("EKTalk",my.skill1); }
		}

		if (Talking == 20) 
		{ 
			if (Phase == 10) { TalkN(); }
			if (Phase == 11) { ent_cycle ("ENTalk",my.skill1); }
		}

		if ((Talking != 10) && (Talking != 20)) { Blink(); }

		my.skill1 = my.skill1 + 10 * time;
		wait(1);
	}
}

action NinLie
{
	my.skill30 = 10;

	while(1)
	{
		if (Talking == 12) { TalkNin(); } else { ent_frame ("Lie",0); }
		if (Talking == 13) { ent_frame ("Flip",0); }
		wait(1);
	}
}

function SetVoice
{
	if (Scene == 0) { sPlay ("Wait.WAV"); Talking = 0; }
	if (Scene == 1) { CamShow = 1; sPlay ("ROY001.WAV"); Talking = 0; }
	if (Scene == 2) { sPlay ("SFX121.WAV"); Talking = 0; }
	if (Scene == 3) { CamShow = 2; sPlay ("ROY002.WAV"); Talking = 0; }
	if (Scene == 4) { sPlay ("SHK069.WAV"); Talking = 1; }
	if (Scene == 5) { CamShow = 3; sPlay ("ROY003.WAV"); Talking = 0; play_sound (Kazablan,100); KAZ = result; } 
	if (Scene == 6) { sPlay ("KVC035.WAV"); Talking = 1; }
	if (Scene == 7) { stop_sound (KAZ); CamShow = 4; sPlay ("ROY004.WAV"); Talking = 0; }
	if (Scene == 8) { sPlay ("MSC004.WAV"); Talking = 2; }
	if (Scene == 9) { CamShow = 5; sPlay ("ROY005.WAV"); Talking = 0; }
	if (Scene ==10) { sPlay ("SFX071.WAV"); while (GetPosition(Voice) < 1000000) { wait(1); } Talking = 3; }
	if (Scene ==11) { Scene_map = bmapBack2; CamShow = 6; sPlay ("ROY006.WAV"); Talking = 0; }
	if (Scene ==12) { sPlay ("EFI027.WAV"); Talking = 1; }
	if (Scene ==13) { Scene_map = bmapBack3; CamShow = 7; sPlay ("ROY007.WAV"); Talking = 0; }
	if (Scene ==14) { sPlay ("BRA008.WAV"); Talking = 4; }
	if (Scene ==15) { Scene_map = bmapBack1; CamShow = 8; sPlay ("ROY008.WAV"); Talking = 0; }
	if (Scene ==16) { sPlay ("JOK3101.WAV"); Talking = 1; }
	if (Scene ==17) { Talking = 0; waitt(16); Scene = 18; }
	if (Scene ==18) { sPlay ("JOK3102.WAV"); Talking = 1; }
	if (Scene ==19) { sPlay ("JOK3103.WAV"); Talking = 5; }
	if (Scene ==20) { CamShow = 9; sPlay ("ROY009.WAV"); Talking = 0; play_sound (Ambient,30); SND = result; }
	if (Scene ==21) { stop_sound (SND); CamShow = 10; sPlay ("ROY010.WAV"); Talking = 0; play_sound (Traffic,30); SND = result; }
	if (Scene ==22) { sPlay ("SFX120.WAV"); Talking = 20; }
	if (Scene ==23) { stop_sound (SND); CamShow = 11; sPlay ("ROY011.WAV"); Talking = 0; }
	if (Scene ==24) { sPlay ("GAY022.WAV"); Talking = 6; }
	if (Scene ==25) { CamShow = 12; sPlay ("ROY012.WAV"); Talking = 0; }
	if (Scene ==26) { sPlay ("YCH001.WAV"); Talking = 6; }
	if (Scene ==27) { sPlay ("GRD003.WAV"); Talking = 7; }
	if (Scene ==28) { sPlay ("YCH002.WAV"); Talking = 6; }
	if (Scene ==29) { pShkufit.visible = on; waitt(32); pShkufit.visible = off; Scene = 30; SetVoice(); }
	if (Scene ==30) { CamShow = 14; sPlay ("MSC009.WAV"); Talking = 12; }
	if (Scene ==31) { CamShow = 15; sPlay ("MSC010.WAV"); Talking = 0; }
	if (Scene ==32) { sPlay ("SFX125.WAV"); Talking = 13; }
	if (Scene ==33) { sPlay ("MSC011.WAV"); Talking = 0; }
	if (Scene ==34) { pShkufit.bmap = bShkufit2; pShkufit.visible = on; waitt(32); pShkufit.visible = off; CamShow = 99; waitt (32); Scene = 35; SetVoice(); } 
	if (Scene ==35) { CamShow = 16; sPlay ("AMI013.WAV"); Talking = 9; }
	if (Scene ==36) { CamShow = 13; Phase = 10; sPlay ("JOK7901.WAV"); Talking = 10; }
	if (Scene ==37) { sPlay ("JOK7902.WAV"); Talking = 20; }
	if (Scene ==38) { sPlay ("JOK7903.WAV"); Talking = 10; }
	if (Scene ==39) { sPlay ("laugh.WAV"); Talking = 0; }
	if (Scene ==40) { CamShow = 17; sPlay ("AMI014.WAV"); Talking = 9; }
	if (Scene ==41) { CamShow = 13; sPlay ("JOK8001.WAV"); Talking = 10; }
	if (Scene ==42) { sPlay ("JOK8002.WAV"); Talking = 20; }
	if (Scene ==43) { sPlay ("JOK8003.WAV"); Talking = 10; }
	if (Scene ==44) { sPlay ("laugh.WAV"); Talking = 0; }
	if (Scene ==45) { CamShow = 20; Phase = 11; sPlay ("JOK8101.WAV"); Talking = 10; }
	if (Scene ==46) { sPlay ("JOK8102.WAV"); Talking = 20; }
	if (Scene ==47) { sPlay ("JOK8103.WAV"); Talking = 10; }
	if (Scene ==48) { sPlay ("laugh.WAV"); Talking = 0; }

	if (Scene ==49) { DoExit(); }
}