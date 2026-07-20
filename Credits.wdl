include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var SPD = 2;
bmap bBack = <Credits.bmp>;
sound BGMusic1 = <SNG031.WAV>;
sound BGMusic2 = <SNG019.WAV>;
var BGM = 0;

panel Back
{
	bmap = bBack;
	pos_x = 320;
	pos_y = 0;
	layer = 1;
	flags = visible,d3d,refresh;
}

text Credits
{
	layer = 2;
	pos_x = 340;
	pos_y=  550;
	font = standard_font;
	flags = visible;
	strings = 255;
	string ="                                        EBJVK ",
		"                                       -------\n",	// Writing

		"                                    YMGFLC YNT",
		"                                   YMGFLC JPFT",
		"                                  [JBFTGL JPFT\n",

		"                                       ESJQTC ",
		"                                      --------\n",	// Artwork

		"YMGFLC YNT                    VJDMJM FD ESJQTC",
		"[JBFTGL JPFT                   JDMJM VLV BFRJP\n",

		"                                        VFNKV ",
		"                                       -------\n",	// Programming

		"                                  [JBFTGL JPFT\n",

		"                                        VFLFS ",	// Voices
		"                                       -------\n",

		"UFQJQ JGH                            JNNC YLJA\n",

		"SJNQFTS YIQS                          DLQ YLJA",
		"GFP OFU                                       ",
		"YKAG AILA                                     ",
		"JNN LU YLKLKE JSFRSJI TM                      \n",

		"SIOFBLB LDHJ                          BEL JNFJ",
		"YFLME LENM                                    ",
		"TMG ELTB                                      \n",

		"JNN LJTBJ'C                  YFTU (U\"MFV) TMFV",
		"PCFUME SJR ERJBS                              ",
		"PCFUME LKFNE                                  ",
		"XFBJLCJD                                      ",
		"VFPJON YKFO                                   \n",

		"ELPCFT                            TBE YJP WLJL",
		"EKTB                                          ",
		"SMPGFQ SAMGFQ VFHA                            ",
		"XJNQE DTUM VDJSQ                              ",
		"BFLFAU LU FVUA                                \n",

		"VJMO QFLQ SJN SJN'RFFS                FMO LBFJ",

		"XJLBJNS TQK YJJTS                             ",
		"LBJNSE EDNCFA DJLJ JRNB                       ",
		"SJOFO                                         ",
		"BRSE                                          \n",

		"FLFLE JQA                            YLFC TQFP\n",

		"SJU TM                               TILS TPLC",
		"XJPCFUME VJBB XJPCFUMEM JRH                   \n",

		"[JBFTGL JPFT             XJPCFUME VJBB XJAQFTE",
		"YMGFLC YNT                                    ",
		"TFGM JL                                       \n",

		"OFIME VLJJD YGH ETJM                  TSN VJLE\n",

		"EHQN FBA ZFTPM                      YMGFLC YNT",
		"UJLU ELRS                                     ",
		"ZFI JDJC                                      ",
		"YEK VNOFA ZJ'R                                ",
		"JTQ JIFJDB TKFM                               ",
		"BFLFAU                                        \n",

		"UJLU E'RHN                        [JBFTGL JPFT",
		"TFQJR AFEU BUFHU DOFME LENM                   ",
		"IOJITSE JCJG                                  ",
		"XJUJUSE VDJJQMJLFA YJJTS TBC .P BBFJ          ",
		"XFIAIE                                        ",
		"XFJOE YJJTS ZOFJ                              ",
		"CFLFKJOQE EUNM XHNM                           ",
		"FNJMFD                                        \n",

		"TFGM JL                           XJQOFN VFLFS",
		"JBU JTFA                                      ",
		"[JBFNJD LI                                    ",
		"PBC ZOA                                       ",
		"TSN VJLE                                      ",
		"TKFG AL JNAU EMK DFP FJE HIB                  \n",

		"                           XJJLBB OTH JDK ITO ",
		"                          --------------------\n",

		"YMGFLC YNT                               EBJVK",
		"[JBFTGL JPFT                              SHUM",
		"YMGFLC YNT                             VFNJJTS",
		"JBU JTFA                                 XFLJR",
		"TSN VJLEF JBU JTFA              LJPCM SRB VNKE\n",

		"                                        XJTJU ",	// Songs
		"                                       -------\n",

		"                                   XJIJ'RE TJU\n",	// The cheat song

		"[JBFTGL JPFTF YMGFLC YNT          PFRJB, XJLJM",
		"ENBL YTJU                                  YHL\n",

		"                            XJMJ'R EBFDL EDLBE\n",	// The ballade for Zimim

		"YMGFLC YNT                               XJLJM",
		"JSONJDBJL LACJ                             YHL",
		"YFTU (U\"MFV) TMFV                        PFRJB\n",

		"                        JNFIFNFM VDLFE XFJ TJU\n",	// Monotone birthday song

		"YMGFLC YNT                          XJLJM PBTA",
		"ENBL YTJU                                  YHL",
		"YMGFLC YNTF JNNC YLJA                    PFRJB\n",

		"                                     BFBGE TJU\n",	// The fly song

		"YMGFLC YNT                               XJLJM",
		"ENBL YTJU                                  YHL",
		"JNNC YLJA                                PFRJB\n",

		"                           JCJG LU TJUE YFJOJN\n",	// Ziggy's song

		"[JBFTGL JPFT                      PFRJB ,XJLJM",
		"ENBL YTJU                                  YHL\n",

		"                                   OTH JLP LQN\n",	// A shred fell on me

		"YLFC TQFP                    PFRJB, YHL ,XJLJM\n",

		"                              JGH WTDE VA LKAV\n",	// Eat the road Hezi

		"YLFC TQFP                    PFRJB, YHL ,XJLJM\n",

		"                                         LBJNS\n",	// Cannibal

		"[JBFTGL JPFT                             XJLJM",
		"DLQ LAJND                                  YHL",
		"[JBFTGL JPFTF YMGFLC YNT                 PFRJB\n",


		"                                        SJNIJB\n",	// Bitnic song

		"YMGFLC YNT                               XJLJM",
		"JSONJDBJL LACJ                             YHL",
		"JNNC YLJA                                PFRJB\n",

		"                          XJOTHE LU TFBJHE HFL\n",	// The shred song

		"YMGFLC YNT                               XJLJM",
		"ENBL YTJU                                  YHL",
		"JNNC YLJA                                PFRJB\n",

		"                                       JBR VJB\n",	// Bait Zabi

		"YMGFLC YNT                               XJLJM",
		"ENBL YTJU                                  YHL",
		"JNNC YLJA                                PFRJB\n",

		"                               TUS YJA ,TUS UJ\n",	// The mad and old song

		"[JBFTGL JPFTF YMGFLC YNT          PFRJB ,XJLJM",
		"ENBL YTJU                                  YHL\n",

		"                            SIOFBLB LDHJL ENJS\n",	// A requiem for Yachdal

		"[JBFTGL JPFTF YMGFLC YNT          PFRJB ,XJLJM",
		"ENBL YTJU                                  YHL\n",

		"                                     TGCB WFUM\n",	// Pull the carrot

		"[JBFTGL JPFTF YMGFLC YNT                 XJLJM",
		"ENBL YTJU                                  YHL",
		"[JBFTGL JPFT                             PFRJB",
		"YFQLH JOA                                     ",
		"[JBFNJD LI                                    \n",

		"                               CCFLCFGL VMFOTQ\n",	// Hotdog commercial

		"YMGFLC YNT                               XJLJM",
		"DLQ LAJND                                  YHL",
		"JNNC YLJA                                PFRJB\n",

		"                                        VFDFV ",	// Recording Studio
		"                                       -------\n",

		"additional audio programming by cameron aycock\n",

		"     TUAM THA AL VLENEB m-vision JNQLFAB ILSFE",
		"            JSONJDBJL \"FJUKP FAFBV LA AL\" LACJ\n",

		"                TFMLI LCF [JBFNJD LI :VFKJA VTSB\n",	// QA

		"                 [JBFTGL JPFTL VFDFEL ERFT YNT",	// Thank yous
		"     FVFA XJHJTKM LBA YNTL VFDFEL ERFT AL JPFT\n",

		"1789 GAM    www.piposh.co.il    M\"PB YJIFJLJC\n",

		"                               XJATFS XVAU YMGB",
		"XJ BLB XJARMN SHUME LU XJTRFJE ELAE XJIJDTSE VA",
		"ABE SHUME VA XJBVFKF VFJNVMJA XJ VFRLQMB XJSBAN\n",

		"                 2 EJNCL UDSFM                 ",
		" YFSTJE ZFHM XJTIMJINO 2 VP XTVB XJPLOB EONKNU \n";

}

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;

	vNoMap = 1;

	level_load("Credits.WMB");

	VoiceInit();
	Initialize();

	camera.size_x = 320;

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running
}

action Cam
{
	while(1)
	{
		if (snd_playing (BGM) == 0) 
		{ 
			if (my.skill40 == 1) { play_sound (BGMusic2,100); BGM = result; }
			if (my.skill40 == 0) { play_sound (BGMusic1,100); BGM = result; my.skill40 = 1; }
		}

		Credits.pos_y = credits.pos_y - 0.7 * time;

		if (player.skill10 == 0)
		{
			my.y = my.y - SPD * time;
		}

		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;
		camera.tilt = my.tilt;
		camera.roll = my.roll;
		camera.pan = my.pan;

		wait(1);
	}
}

action Dummy
{
	while(1)
	{
		if (player == null) { wait(1); }

		if (player.y < my.y) { player.skill10 = 1; }
		wait(1);
	}
}

action Piposh
{
	player = my;
	my.skill11 = my.pan;

	while(1)
	{
		if (my.skill10 == 0)
		{
			my.y = my.y - SPD * time;
		}
		else
		{
			my.pan = my.skill11 + 90;
			my.x = my.x + SPD * time;
		}

		ent_cycle ("Walk",my.skill1);
		my.skill1 = my.skill1 + (SPD * 5) * time;
		Blink();

		wait(1);
	}
}

action RunPath
{
	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	my._movemode = 1;

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
		force = 3;
		actor_turnto(my_angle.PAN);
		actor_move();

		wait(1);
	}
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

function GetOut { Run ("Menu.exe"); }
on_esc = GetOut();