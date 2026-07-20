include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var Scene = 0;
var Phase = 0;
var CamShow = 5;
var Limit1 = 0;
var Limit2 = 0;

bmap bLoading2 = <Loading23.pcx>;

panel pLoading2
{
	bmap = bLoading2;
	layer = 21;
	flags = d3d,refresh,visible;
}

string KTV1 = "JJSFA YK YK ,EA             XJUJUS ST XJTC FNLU ENFKUB                                 XJSLPVM UMUB JNUE LP DHA     !LFMVA WVFA JVJAT   TKFG AL JNA TFMH      ?YFUMU EVA      TVOA JMU XFAVQ EM         PBU FJUKP EPUE       XH JD YK  ?EM      IIIIILLLLAAAAAFFFC";
string KTV2 = "VOLE JL ETAUN JK WLME EQ JNA     VOTFE VFNBE VA JLU VJTFLBE     YMGM FTTFQVE TBK JLU XJTBH     YCB XEM JRH LJBUB XJTFBS XEM JRH      TIMM EAFT AL JNAF TIIS TBK JL FUP";
string KTV3 = "?VFTJQ VCFP JL VATS EVA             ! ! ! ! ! VHA ELMN             EDFV WVFA VJAT YFKN JVFA VJAT EVA VJJE EG ,JIFM                                XJPCFUME XJTC EMU EMU EMU           XJTC FNHNA EQ !EQ !AL              BFU LJHVV";
string KTV4 = "                            XJPCFUME XJTC EMU EMU EMU     XCF UQFH LFKAL UQFH FNL UJ       JMO JMO JMO JMO JMO JMO JMO JMO JMO JMO JMO                        !!!!XJTBDM FNHNA EMK                     LFCNFTIU XCF                              FVJA XCF                        (XCTVL VFTUQA YJAU VFLFS JNJM LK DFP)                                                                                 EDJH JL UJ";
string KTV5 = "                 EDJH JTEF       ?ENPJ VBL VFRFN EMK           ?ENPJ VB     !!! ??? EUDH EDJH FG                 !YFQLI JL UJ EJNU    XJUBJ VFTJQ EG ,AL";
string KTV6 = "XJVUJLQ VFABR DJCEL ST JL YV          JLGFNU           LKFA AFEU EM EVUA JNA ,TMG          JLGFNU JLGFNU               WL EATN AFB WL EATN AFB WL EATN AFB";
string KTV7 = "                                       VFNFKU JVUB XJTC FNHNA TUS YJA TUS UJ      VFILFU EJQAM VFNFKU JVU     VFLENM YA'CJMGFQGFQ VA         VFTSL LFKJ LKE YAK                    VFTSL LFKJ LKE                                                           VFTSL LFKJ LKE                            YBUJB WLU TCFAL VVL AB JNA EKH JIFM";

bmap Vilon1 = <Vilon1.pcx>;
bmap Vilon2 = <Vilon2.pcx>;
bmap Stage = <Stage.pcx>;

define Anim,skill22;

synonym PathDummy { type entity; }
synonym Apperation { type entity; }

text Ktuvit
{
	layer = 2;
	pos_x = 0;
	pos_y=  465;
	font = standard_font;
	string = KTV1;
	flags = visible;
}

panel pStage
{
	layer = 1;
	bmap = Stage;
	pos_y = 450;
	flags = refresh,d3d,visible;
}

panel pVil1
{
	layer = 2;
	pos_x = -20;
	bmap = Vilon1;
	flags = refresh,d3d,overlay,visible;
}

panel pVil2
{
	layer = 2;
	pos_x = 320;
	bmap = Vilon2;
	flags = refresh,d3d,overlay,visible;
}

entity MadDude
{
	type = <Fatguy.mdl>;
	layer = 3;
	view = camera;
	x = 60;
	y = 5;
	z = -10;
	pan = 180;
	roll = -20;
}

entity OldDude
{
	type = <Oldguy6.mdl>;
	layer = 3;
	view = camera;
	x = 160;
	y = 5;
	z = -30;
	pan = 180;
	roll = -20;
}

entity KRP
{
	type = <Krupnik.mdl>;
	layer = 3;
	view = camera;
	x = 150;
	y = -95;
	z = -100;
	pan = -120;
	tilt = 20;
	flags = visible;
}


/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;
	vNoSave = 1;

	load_level(<Intro8.WMB>);

	VoiceInit();
	Initialize();

	SetKtuvit();
	Scene = 0;
	SetVoice();

	pLoading2.visible = off;
}

function SetKtuvit
{
	if (scene == 1) { Ktuvit.string = KTV1; }
	if (scene == 2) { Ktuvit.string = KTV2; }
	if (scene == 3) { Ktuvit.string = KTV3; }
	if (scene == 4) { Ktuvit.string = KTV4; }
	if (scene == 5) { Ktuvit.string = KTV5; }
	if (scene == 6) { Ktuvit.string = KTV6; }
	if (scene == 7) { Ktuvit.string = KTV7; }

	ktuvit.pos_x = 320;
}

action ThereAndBackAgain
{
	my.skill2 = my.pan;
	my.skill4 = int(random(2));

	if (my.flag1 == on) { Limit1 = my.y; }
	if (my.flag2 == on) { Limit2 = my.y; }

	while(1)
	{
		if (int(random(100)) == 50) { if (my.skill4 == 0) { my.skill4 = 1; } else { my.skill4 = 0; } }
		my.y = my.y + (my.skill1 * 10) * time;
		if (my.skill4 == 0) { ent_cycle ("Hit",my.skill3); } else { ent_cycle ("Walk",my.skill3); }
		my.skill3 = my.skill3 + 10 * time;

		if (my.y > Limit1) { my.pan = my.pan + 180; my.skill1 = my.skill1 * -1; }
		if (my.y < Limit2) { my.pan = my.pan + 180; my.skill1 = my.skill1 * -1; }

		wait(1);
	}
}

action Dancing
{
	while (my.skill2 == 0) { my.skill2 = int(random(3)) - 1; }
	
	while(1)
	{
		ent_cycle ("Fall",my.skill1);
		my.skill1 = my.skill1 + 10 * time;
		my.pan = my.pan + (15 * my.skill2) * time;
		wait(1);
	}
}

action OldDance
{
	my.skill1 = 0;

	while(1)
	{
		if (Scene == 2)
		{
			talk2();
			ent_cycle ("Dance",my.skill1);
			my.skill1 = my.skill1 + 1 * time;
		}
		wait(1);
	}
}

action MadDance
{
	my.skill1 = 0;

	while(1)
	{
		if (Scene == 4)
		{
			talk2();
			ent_cycle ("Dance",my.skill1);
			my.skill1 = my.skill1 + 1 * time;
		}
		wait(1);
	}
}

action Krupnik
{
	player = my;

	while(1)
	{
		Talk();
		wait(1);
	}
}

action Cam
{
	while(1)
	{
		if (GetPosition(Voice) >= 1000000) { Scene = Scene + 1; SetVoice(); }

		if (CamShow == my.skill1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;

			if (my.skill1 == 4)
			{
				vec_set(temp,player.x);
				vec_sub(temp,camera.x);
				vec_to_angle(camera.pan,temp);
				my.z = my.z + 2 * time;
				my.x = my.x + 1 * time;

				if (GetPosition(Voice) > 920000) 
				{ 
					MadDude.visible = on; 
					MadDude.skill45 = MadDude.skill45 + 1 * time;
					if (MadDude.skill45 > 1.5) { MadDude.skin = int(random(7))+1; MadDude.skill45 = 0; }
				}
			}

			if (my.skill1 == 7)
			{
				my.x = PathDummy.x;
				my.y = PathDummy.y;

				vec_set(temp,Apperation.x);
				vec_sub(temp,my.x);
				vec_to_angle(my.pan,temp);
			}


			if (my.skill1 == 1)
			{
				if (GetPosition(Voice) > 920000) 
				{ 
					OldDude.visible = on; 
					OldDude.skill45 = OldDude.skill45 + 1 * time;
					if (OldDude.skill45 > 1.5) { OldDude.skin = int(random(7))+1; OldDude.skill45 = 0; }
				}

				if (GetPosition(Voice) > 980000) { ReturnToMap(); }
			}
		}

		wait(1);
	}
}

action Gist
{
	Apperation = my;

	while(1)
	{
		Ktuvit.pos_x = ktuvit.pos_x - 6 * time;

		if (Scene < 2)
		{
			KRP.skill45 = KRP.skill45 + 1 * time;
			if (KRP.skill45 > 1.5) { KRP.skin = int(random(7))+1; KRP.skill45 = 0; }
			if (Scene == 1) { KRP.skill1 = KRP.skill1 + 1 * time; }
			if (KRP.skill1 > 25) 
			{ 
				if (KRP.skill40 == 0) { KRP.skill40 = 1; morph (<KRPrope.mdl>,KRP); KRP.roll = 0; KRP.tilt = 0; KRP.Z = KRP.Z + 100; }
				if (KRP.skill41 == 0) { KRP.Z = KRP.Z - 5 * time; KRP.Y = KRP.Y - 2 * time; }
			}
		}

		if (Scene >= 2) { KRP.visible = off; }

		if ((KRP.skill40 == 1) && (Scene != 7))
		{
			if (pVil1.pos_x > -300) { pVil1.pos_x = pVil1.pos_x - 5 * time; } else { KRP.skill41 = 1; }
			if (pVil2.pos_x <  600) { pVil2.pos_x = pVil2.pos_x + 5 * time; }
		}

		if ((Scene == 7) && (GetPosition(Voice) > 800000))
		{
			if (pVil1.pos_x < -20) { pVil1.pos_x = pVil1.pos_x + 5 * time; }
			if (pVil2.pos_x > 320) { pVil2.pos_x = pVil2.pos_x - 5 * time; }
		} 

		my.pan = my.pan + 3 * time;
		wait(1);
	}
}

function MoveToCenter()
{
	my.y = my.y + my.skill1 * time;
	if (my.skill1 > 0)
	{
		if (my.y > my.skill2 + 370) { Phase = 1; }
	}
	if (my.skill1 < 0)
	{
		if (my.y < my.skill2 - 400) { Phase = 2; }
	}
	if (my.skill1 > 0) { ent_cycle ("Run",my.anim); } else { ent_cycle("Walk",my.anim); }
	my.anim = my.anim + 10 * time;
}

function SnapFingers()
{
	ent_cycle ("Snap",my.anim);
	my.anim = my.anim + 10 * time;
	if (Phase == 2) { my.skill40 = my.skill40 + 1 * time; if (my.skill40 > 30) { Phase = 3; } }
}

function Slide()
{
	ent_cycle ("Slide",my.anim);
	my.anim = my.anim + 10 * time;
	my.y = my.y + my.skill1 * time;
}

action Oldguys
{
	my.skill1 = 5;
	my.skill2 = my.y;

	while(1)
	{
		if (Scene == 7)
		{
			if (Phase == 0) { MoveToCenter(); }
			if ((Phase == 1) || (Phase == 2)) { SnapFingers(); }
			if (Phase == 3) { Slide(); }
		}
		
		wait(1);
	}
}

action Madmen
{
	my.skill1 = -5;
	my.skill2 = my.y;

	
	while(1)
	{
		if (Scene == 7)
		{
			if (Phase == 1) { MoveToCenter(); }
			if (Phase == 2) { SnapFingers(); }
			if (Phase == 3) { Slide(); }
		}

		wait(1);
	}
}

action PatternDance
{
	my.skill10 = my.z - 10;
	my.skill20 = 0;
	actor_init();
	drop_shadow();
	my._movemode = 1;
	my.passable = on;

// attach next path
	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 10000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found

// find first waypoint
	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
		if (Scene == 3)
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
			force = 3;
			actor_turnto(my_angle.PAN);
			force = 6;
			actor_move();

			if (my.skill1 == 1) { ent_cycle ("Walk",my.skill21); my.skill21 = my.skill21 + 10 * time; }
			if (my.skill1 == 2) { my.z = my.skill10; ent_cycle ("Run",my.skill21); my.skill21 = my.skill21 + 10 * time; }
		}

		// Wait one tick, then repeat
		wait(1);
	}
}

action DummyPath
{
	PathDummy = my;
	my._movemode = 1;
	my.passable = on;

	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 10000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }	// no path found

	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		if (result < 25) { ent_nextpoint(my._TARGET_X); }

		force = 3;
		actor_turnto(my_angle.PAN);
		force = 6;
		actor_move();

		wait(1);
	}
}

action Show
{
	while(1)
	{
		if (Scene == 5)
		{
			if (GetPosition(Voice) < 350000)
			{
				if (my.skill1 == 1) { Talk(); } else { Blink(); }
			}

			if ((GetPosition(Voice) > 350000) && (GetPosition(Voice) < 600000))
			{
				if (my.skill1 == 3) { Talk(); } else { Blink(); }
			}

			if ((GetPosition(Voice) > 600000) && (GetPosition(Voice) < 900000))
			{
				if (my.skill1 == 2) { Talk(); } else { Blink(); }
			}

			if (GetPosition(Voice) > 900000) { my.skin = 2; }

		}

		wait(1);
	}
}

function SetVoice()
{
	if (Scene == 0) { sPlay ("Wait.wav"); CamShow = 5; }
	if (Scene == 1) { sPlay ("scene1.wav"); CamShow = 5; }
	if (Scene == 2) { sPlay ("scene2.wav"); CamShow = 2; }
	if (Scene == 3) { sPlay ("scene3.wav"); CamShow = 4; pVil1.visible = off; pVil2.visible = off; pStage.visible = off; }
	if (Scene == 4) { sPlay ("scene4.wav"); CamShow = 3; MadDude.visible = off; pVil1.visible = on; pVil2.visible = on; pStage.visible = on; }
	if (Scene == 5) { sPlay ("scene5.wav"); CamShow = 6; }
	if (Scene == 6) { sPlay ("scene6.wav"); CamShow = 7; }
	if (Scene == 7) { sPlay ("scene7.wav"); CamShow = 1; }

	SetKtuvit();
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { ent_frame ("Talk",int(random(5)) * 25); }
}

function Talk2()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
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