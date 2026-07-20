// Game I\O

var filehandle;

// Define local paths

path "MDL";
path "SFX";
path "GFX";
path "WDL";
path "WMB";

// Define paths to CD-ROM drive

ifdef a; path "a:\\Data\\MDL"; path "a:\\Data\\SFX"; path "a:\\Data\\GFX"; path "a:\\Data\\WDL"; path "a:\\Data\\WMB"; endif;
ifdef b; path "b:\\Data\\MDL"; path "b:\\Data\\SFX"; path "b:\\Data\\GFX"; path "b:\\Data\\WDL"; path "b:\\Data\\WMB"; endif;
ifdef c; path "c:\\Data\\MDL"; path "c:\\Data\\SFX"; path "c:\\Data\\GFX"; path "c:\\Data\\WDL"; path "c:\\Data\\WMB"; endif;
ifdef d; path "d:\\Data\\MDL"; path "d:\\Data\\SFX"; path "d:\\Data\\GFX"; path "d:\\Data\\WDL"; path "d:\\Data\\WMB"; endif;
ifdef e; path "e:\\Data\\MDL"; path "e:\\Data\\SFX"; path "e:\\Data\\GFX"; path "e:\\Data\\WDL"; path "e:\\Data\\WMB"; endif;
ifdef f; path "f:\\Data\\MDL"; path "f:\\Data\\SFX"; path "f:\\Data\\GFX"; path "f:\\Data\\WDL"; path "f:\\Data\\WMB"; endif;
ifdef g; path "g:\\Data\\MDL"; path "g:\\Data\\SFX"; path "g:\\Data\\GFX"; path "g:\\Data\\WDL"; path "g:\\Data\\WMB"; endif;
ifdef h; path "h:\\Data\\MDL"; path "h:\\Data\\SFX"; path "h:\\Data\\GFX"; path "h:\\Data\\WDL"; path "h:\\Data\\WMB"; endif;
ifdef i; path "i:\\Data\\MDL"; path "i:\\Data\\SFX"; path "i:\\Data\\GFX"; path "i:\\Data\\WDL"; path "i:\\Data\\WMB"; endif;
ifdef j; path "j:\\Data\\MDL"; path "j:\\Data\\SFX"; path "j:\\Data\\GFX"; path "j:\\Data\\WDL"; path "j:\\Data\\WMB"; endif;
ifdef k; path "k:\\Data\\MDL"; path "k:\\Data\\SFX"; path "k:\\Data\\GFX"; path "k:\\Data\\WDL"; path "k:\\Data\\WMB"; endif;
ifdef l; path "l:\\Data\\MDL"; path "l:\\Data\\SFX"; path "l:\\Data\\GFX"; path "l:\\Data\\WDL"; path "l:\\Data\\WMB"; endif;
ifdef m; path "m:\\Data\\MDL"; path "m:\\Data\\SFX"; path "m:\\Data\\GFX"; path "m:\\Data\\WDL"; path "m:\\Data\\WMB"; endif;
ifdef n; path "n:\\Data\\MDL"; path "n:\\Data\\SFX"; path "n:\\Data\\GFX"; path "n:\\Data\\WDL"; path "n:\\Data\\WMB"; endif;
ifdef o; path "o:\\Data\\MDL"; path "o:\\Data\\SFX"; path "o:\\Data\\GFX"; path "o:\\Data\\WDL"; path "o:\\Data\\WMB"; endif;
ifdef p; path "p:\\Data\\MDL"; path "p:\\Data\\SFX"; path "p:\\Data\\GFX"; path "p:\\Data\\WDL"; path "p:\\Data\\WMB"; endif;
ifdef q; path "q:\\Data\\MDL"; path "q:\\Data\\SFX"; path "q:\\Data\\GFX"; path "q:\\Data\\WDL"; path "q:\\Data\\WMB"; endif;
ifdef r; path "r:\\Data\\MDL"; path "r:\\Data\\SFX"; path "r:\\Data\\GFX"; path "r:\\Data\\WDL"; path "r:\\Data\\WMB"; endif;
ifdef s; path "s:\\Data\\MDL"; path "s:\\Data\\SFX"; path "s:\\Data\\GFX"; path "s:\\Data\\WDL"; path "s:\\Data\\WMB"; endif;
ifdef t; path "t:\\Data\\MDL"; path "t:\\Data\\SFX"; path "t:\\Data\\GFX"; path "t:\\Data\\WDL"; path "t:\\Data\\WMB"; endif;
ifdef u; path "u:\\Data\\MDL"; path "u:\\Data\\SFX"; path "u:\\Data\\GFX"; path "u:\\Data\\WDL"; path "u:\\Data\\WMB"; endif;
ifdef v; path "v:\\Data\\MDL"; path "v:\\Data\\SFX"; path "v:\\Data\\GFX"; path "v:\\Data\\WDL"; path "v:\\Data\\WMB"; endif;
ifdef w; path "w:\\Data\\MDL"; path "w:\\Data\\SFX"; path "w:\\Data\\GFX"; path "w:\\Data\\WDL"; path "w:\\Data\\WMB"; endif;
ifdef x; path "x:\\Data\\MDL"; path "x:\\Data\\SFX"; path "x:\\Data\\GFX"; path "x:\\Data\\WDL"; path "x:\\Data\\WMB"; endif;
ifdef y; path "y:\\Data\\MDL"; path "y:\\Data\\SFX"; path "y:\\Data\\GFX"; path "y:\\Data\\WDL"; path "y:\\Data\\WMB"; endif;
ifdef z; path "z:\\Data\\MDL"; path "z:\\Data\\SFX"; path "z:\\Data\\GFX"; path "z:\\Data\\WDL"; path "z:\\Data\\WMB"; endif;

ifdef l1;  bmap bLoading = <Loading01.pcx>; endif;
ifdef l2;  bmap bLoading = <Loading02.pcx>; endif;
ifdef l3;  bmap bLoading = <Loading03.pcx>; endif;
ifdef l4;  bmap bLoading = <Loading04.pcx>; endif;
ifdef l5;  bmap bLoading = <Loading05.pcx>; endif;
ifdef l6;  bmap bLoading = <Loading06.pcx>; endif;
ifdef l7;  bmap bLoading = <Loading07.pcx>; endif;
ifdef l8;  bmap bLoading = <Loading08.pcx>; endif;
ifdef l9;  bmap bLoading = <Loading09.pcx>; endif;
ifdef l10; bmap bLoading = <Loading10.pcx>; endif;
ifdef l11; bmap bLoading = <Loading11.pcx>; endif;
ifdef l12; bmap bLoading = <Loading12.pcx>; endif;
ifdef l13; bmap bLoading = <Loading13.pcx>; endif;
ifdef l14; bmap bLoading = <Loading14.pcx>; endif;
ifdef l15; bmap bLoading = <Loading15.pcx>; endif;
ifdef l16; bmap bLoading = <Loading16.pcx>; endif;
ifdef l17; bmap bLoading = <Loading17.pcx>; endif;
ifdef l18; bmap bLoading = <Loading18.pcx>; endif;
ifdef l19; bmap bLoading = <Loading19.pcx>; endif;
ifdef l20; bmap bLoading = <Loading20.pcx>; endif;
ifdef l21; bmap bLoading = <Loading21.pcx>; endif;
ifdef l22; bmap bLoading = <Loading22.pcx>; endif;

include <movement.wdl>;
include <messages.wdl>;
include <particle.wdl>;
include <doors.wdl>;
include <actors.wdl>;
include <weapons.wdl>;
include <war.wdl>;
include <lflare.wdl>;
include <DIalog.wdl>;
include <Voice.wdl>;
include <Afgan.wdl>;
include <Weather.wdl>;
include <Help.wdl>;

// constants
var _ASYLUM 	= 1;
var _MANSION 	= 2;
var _OLYMPIC 	= 4;
var _TOWN 	= 8;
var _VOLCANO 	= 16;
var _VILLAGE 	= 32;

var varLevelID;
var varPhotoID = 0;
var HasID = 0;
var varNewMap = 0;

//////////////////////////////////////////////////////////////////////////////
// Hi-res 2D fit system.
// The whole UI was authored for a 640x480 (4:3) logical screen. The engine now
// renders at a higher resolution (screen_size), so these globals + helpers map
// every 2D element from that logical space onto the real screen: uniform scale
// that preserves the 4:3 art aspect, plus centering offsets. On an exact 4:3
// screen gfx_ox/gfx_oy are 0; on wider screens (16:9/21:9, later) the UI is
// centered with pillar/letter-box offsets.
//////////////////////////////////////////////////////////////////////////////
var gfx_scale = 1;
var gfx_ox = 0;
var gfx_oy = 0;

function gfx_init()
{
	var sx; var sy;
	sx = screen_size.x / 640;
	sy = screen_size.y / 480;
	gfx_scale = sx;
	if (sy < sx) { gfx_scale = sy; }
	gfx_ox = (screen_size.x - 640 * gfx_scale) / 2;
	gfx_oy = (screen_size.y - 480 * gfx_scale) / 2;
}

// Fit one panel: scale its bitmap and map its authored (logical) position into
// physical screen space. Set _fitp to the panel, then call fit(). Call once,
// after gfx_init(), before the panel is shown.
panel* _fitp;
function fit()
{
	_fitp.scale_x = gfx_scale;
	_fitp.scale_y = gfx_scale;
	_fitp.pos_x = gfx_ox + _fitp.pos_x * gfx_scale;
	_fitp.pos_y = gfx_oy + _fitp.pos_y * gfx_scale;
}

bmap bmenuhelp = <menuhelp.pcx>;
bmap bclouds = <clds.pcx>;
bmap bsky = <sky.bmp>;
bmap bhorizon = <horizon.pcx>;
bmap PozCursor = <cursor1.pcx>;
bmap bRIP = <RIP.pcx>;
bmap bRIPb1 = <RIPb1.pcx>;
bmap bRIPb2 = <RIPb2.pcx>;
bmap bRIPb3 = <RIPb3.pcx>;
bmap bRIPb4 = <RIPb4.pcx>;
bmap bNoMap = <NoMap.pcx>;
bmap bNoSave = <NoSave.pcx>;
bmap bSave = <Save.pcx>;

bmap bPause = <Pause.pcx>;

bmap bar1 = <ar1.pcx>;
bmap bar2 = <ar2.pcx>;
bmap bar3 = <ar3.pcx>;
bmap bar4 = <ar4.pcx>;

bmap bmapBack1 = <Horizon1.pcx>;	// Town
bmap bmapBack2 = <Horizon2.pcx>;	// Forest
bmap bmapBack3 = <Horizon3.pcx>;	// Hills
bmap bmapBack4 = <Horizon4.pcx>;	// Desert
bmap bmapBack5 = <Horizon5.pcx>;	// Dark plains
bmap bmapBack6 = <Horizon6.pcx>;	// Snowy peaks

bmap bCon_Load = <con_save.pcx>;
bmap bCon_Save = <con_load.pcx>;
bmap bCon_Quit = <con_quit.pcx>;
bmap bCon_Map = <con_map.pcx>;

string strDOD1 = "20/2/1973";
string strDOD2 = "00/00/0000";
string DODTemp = "    ";
string sEXEc;
string DateToWrite;

var Flag_First_Village = 0;
var Flag_First_Asylum  = 0;
var Flag_First_Mansion = 0;
var Flag_First_Volcano = 0;
var Flag_First_Olympic = 0;

var TalkedOnce = 0;

var GameScore = 0;
var vPointer = 0;

var vNoMap = 0;
var vNoSave = 0;

var Piece[5] = 0,0,0,0,0;	// 0: Start with, 1: Village, 2: Volcano, 3: Olympic, 4: Asylum
var Village[5] = 0,0,0,0,0; 	// 0: Fatass, 1: Chick, 2: Yoyo, 3: Capoeria, 4: Rula
var Volcano[5] = 0,0,0,0,0; 	// 0: Quest, 1: Airplanes, 2: Temple, 3:Shrine, 4: Mine
var Olympic[4] = 0,0,0,0;	// 0: Quest, 1: Race, 2: Shooter, 3: Golf
var Mansion[3] = 0,0,0;		// 0: Quest, 1: Poker, 2: Final shooter
var Asylum[3] = 0,0,0;		// 0: Entry, 1: Quest, 2: Cell game

var PrevArc = 0;
var PrevDist = 0;

var GameAction = 0;
var GameNum = 1;

string strTemp;
string Nada = "";
string ReturnTo = "                               ";
string StageToSave = "                            ";
string StageToLoad = "                            ";
string Nada = "";
string GameNumS = " ";

var Turn = 0;
var Dir = 0;
var Select = 2;
var SaveOrLoad = 0;

string txtGameName = "            ";

var ScreenshotsLoaded;

BMAP full1 = (<SShot1.pcx>,0,0,640,480);
BMAP full2 = (<SShot2.pcx>,0,0,640,480);
BMAP full3 = (<SShot3.pcx>,0,0,640,480);
BMAP full4 = (<SShot4.pcx>,0,0,640,480);
BMAP full5 = (<SShot5.pcx>,0,0,640,480);
BMAP full6 = (<SShot6.pcx>,0,0,640,480);
BMAP full7 = (<SShot7.pcx>,0,0,640,480);
BMAP full8 = (<SShot8.pcx>,0,0,640,480);
BMAP full9 = (<SShot9.pcx>,0,0,640,480);

BMAP slot1 = (<SShot1.pcx>,0,0,128,96);
BMAP slot2 = (<SShot1.pcx>,0,0,128,96);
BMAP slot3 = (<SShot1.pcx>,0,0,128,96);
BMAP slot4 = (<SShot1.pcx>,0,0,128,96);
BMAP slot5 = (<SShot1.pcx>,0,0,128,96);
BMAP slot6 = (<SShot1.pcx>,0,0,128,96);
BMAP slot7 = (<SShot1.pcx>,0,0,128,96);
BMAP slot8 = (<SShot1.pcx>,0,0,128,96);
BMAP slot9 = (<SShot1.pcx>,0,0,128,96);

panel pConsole
{
	bmap = bCon_Save;
	layer = 10;
	pos_x = 220;
	pos_y = 380;
	flags = d3d,refresh,overlay;

	BUTTON -10,0,bar2,bar1,bar2,TurnRight,NULL,NULL;
	BUTTON 170,0,bar4,bar3,bar4,TurnLeft,NULL,NULL;
}

panel pPause
{
	bmap = bPause;
	layer = 100;
	pos_x = 220;
	pos_y = 200;
	flags = d3d,refresh,overlay;
}

panel pLoading
{
	bmap = bLoading;
	layer = 20;
	flags = d3d,refresh,visible;
}

panel pNoMap
{
	bmap = bNoMap;
	layer = 30;
	pos_x = 100;
	pos_y = 222;
	flags = refresh,d3d;
}

panel pNoSave
{
	bmap = bNoSave;
	layer = 30;
	pos_x = 180;
	pos_y = 222;
	flags = refresh,d3d;
}

panel pmenuhelp
{
	bmap = bmenuhelp;
	layer = 10;
	flags = refresh,d3d,overlay;
}

entity entSaveLoadMenu
{
	type = <SaveLoad.mdl>;
	layer = 10;
	view = camera;
	x = 700;
	y = -4;
	z = -13;
	ambient = 100;
}

entity entVaseMenu1 { type = <BVase1.mdl>; layer = 10; view = camera; x = 500; y = 200; z = -70; ambient = 100; }
entity entVaseMenu2 { type = <BVase2.mdl>; layer = 10; view = camera; x = 500; y = 200; z = -70; ambient = 100; }
entity entVaseMenu3 { type = <BVase3.mdl>; layer = 10; view = camera; x = 500; y = 200; z = -70; ambient = 100; }
entity entVaseMenu4 { type = <BVase4.mdl>; layer = 10; view = camera; x = 500; y = 200; z = -70; ambient = 100; }
entity entVaseMenu5 { type = <BVase5.mdl>; layer = 10; view = camera; x = 500; y = 200; z = -70; ambient = 100; }

entity entMillMenu
{
	type = <Mill.mdl>;
	layer = 10;
	view = camera;
	x = 500;
	y = -300;
	z = -70;
	pan = 110;
	ambient = 100;
}

entity entPiposhMenu
{
	type = <PipMenu.mdl>;
	layer = 10;
	view = camera;
	x = 450;
	y = -180;
	z = -80;
	pan = 200;
	ambient = 100;
}

panel pRIP
{
	layer = 20;
	bmap = bRIP;

	BUTTON 020,380,bRIPb1,bRIPb3,bRIPb1,fRIP1,NULL,NULL;
	BUTTON 140,380,bRIPb2,bRIPb4,bRIPb2,fRIP2,NULL,NULL;

	flags = refresh,d3d,overlay;
}

function fRIP1 { HideRIP(); main(); }		// return to level
function fRIP2 	 	// return to map
{ 
	if (vNoMap == 1)
	{
		pNoMap.visible = on;
		pNoMap.alpha = 100;

		waitt (60);

		pNoMap.transparent = on;
	
		while(pNoMap.alpha > 3) { pNoMap.alpha = pNoMap.alpha - 3 * time; wait(1); }

		pNoMap.alpha = 0;
		pNoMap.visible = off;
	}
	else
	{
		ReturnToMap(); 
	}
}

BMAP bRIPSlot = (<SShot1.pcx>,0,0,320,240);
panel pRIPSlot
{
	pos_x = 18;
	pos_y = 107;
	layer = 21;
	bmap = bRIPSlot;
	flags = refresh,d3d;
}

text ptRIP1
{
	pos_x = 460;
	pos_y = 150;
	font = standard_font;
	string = strDOD1;
	layer = 21;
}

text ptRIP2
{
	pos_x = 455;
	pos_y = 170;
	font = standard_font;
	string = strDOD2;
	layer = 21;
}

panel ShowFull
{
	layer = 20;
	bmap = full1;
	flags = refresh,d3d;
}

PANEL SavePanel
{
	bmap = bSave;
	BUTTON 090,070,slot1,slot1,slot1,xslot1,NULL,NULL;
	BUTTON 248,070,slot2,slot2,slot2,xslot2,NULL,NULL;
	BUTTON 406,070,slot3,slot3,slot3,xslot3,NULL,NULL;

	BUTTON 090,196,slot4,slot4,slot4,xslot4,NULL,NULL;
	BUTTON 248,196,slot5,slot5,slot5,xslot5,NULL,NULL;
	BUTTON 406,196,slot6,slot6,slot6,xslot6,NULL,NULL;

	BUTTON 090,322,slot7,slot7,slot7,xslot7,NULL,NULL;
	BUTTON 248,322,slot8,slot8,slot8,xslot8,NULL,NULL;
	BUTTON 406,322,slot9,slot9,slot9,xslot9,NULL,NULL;

	flags = d3d,refresh;
}

text txtSaveGame1 { pos_x = 120; pos_y = 180; string = "            "; layer = 22; font = english_font; }
text txtSaveGame2 { pos_x = 278; pos_y = 180; string = "            "; layer = 22; font = english_font; }
text txtSaveGame3 { pos_x = 436; pos_y = 180; string = "            "; layer = 22; font = english_font; }

text txtSaveGame4 { pos_x = 120; pos_y = 300; string = "            "; layer = 22; font = english_font; }
text txtSaveGame5 { pos_x = 278; pos_y = 300; string = "            "; layer = 22; font = english_font; }
text txtSaveGame6 { pos_x = 436; pos_y = 300; string = "            "; layer = 22; font = english_font; }

text txtSaveGame7 { pos_x = 120; pos_y = 423; string = "            "; layer = 22; font = english_font; }
text txtSaveGame8 { pos_x = 278; pos_y = 423; string = "            "; layer = 22; font = english_font; }
text txtSaveGame9 { pos_x = 436; pos_y = 423; string = "            "; layer = 22; font = english_font; }

function ShowSaveText 
{ 
	txtSaveGame1.visible = on; 
	txtSaveGame2.visible = on; 
	txtSaveGame3.visible = on; 
	txtSaveGame4.visible = on; 
	txtSaveGame5.visible = on; 
	txtSaveGame6.visible = on; 
	txtSaveGame7.visible = on; 
	txtSaveGame8.visible = on; 
	txtSaveGame9.visible = on; 

	filehandle = file_open_read ("Desc.1");
		file_str_read (filehandle,ReturnTo);
		str_cpy(txtSaveGame1.string,ReturnTo);
	file_close (filehandle);

	filehandle = file_open_read ("Desc.2");
		file_str_read (filehandle,ReturnTo);
		str_cpy(txtSaveGame2.string,ReturnTo);
	file_close (filehandle);

	filehandle = file_open_read ("Desc.3");
		file_str_read (filehandle,ReturnTo);
		str_cpy(txtSaveGame3.string,ReturnTo);
	file_close (filehandle);

	filehandle = file_open_read ("Desc.4");
		file_str_read (filehandle,ReturnTo);
		str_cpy(txtSaveGame4.string,ReturnTo);
	file_close (filehandle);

	filehandle = file_open_read ("Desc.5");
		file_str_read (filehandle,ReturnTo);
		str_cpy(txtSaveGame5.string,ReturnTo);
	file_close (filehandle);

	filehandle = file_open_read ("Desc.6");
		file_str_read (filehandle,ReturnTo);
		str_cpy(txtSaveGame6.string,ReturnTo);
	file_close (filehandle);

	filehandle = file_open_read ("Desc.7");
		file_str_read (filehandle,ReturnTo);
		str_cpy(txtSaveGame7.string,ReturnTo);
	file_close (filehandle);

	filehandle = file_open_read ("Desc.8");
		file_str_read (filehandle,ReturnTo);
		str_cpy(txtSaveGame8.string,ReturnTo);
	file_close (filehandle);

	filehandle = file_open_read ("Desc.9");
		file_str_read (filehandle,ReturnTo);
		str_cpy(txtSaveGame9.string,ReturnTo);
	file_close (filehandle);
}


function HideSaveText { txtSaveGame1.visible = off; txtSaveGame2.visible = off; txtSaveGame3.visible = off; txtSaveGame4.visible = off; txtSaveGame5.visible = off; txtSaveGame6.visible = off; txtSaveGame7.visible = off; txtSaveGame8.visible = off; txtSaveGame9.visible = off; }

function xslot1 { if (SaveOrLoad == 1) { MenuSaveGame (1); } else { MenuLoadGame(1); } }
function xslot2 { if (SaveOrLoad == 1) { MenuSaveGame (2); } else { MenuLoadGame(2); } }
function xslot3 { if (SaveOrLoad == 1) { MenuSaveGame (3); } else { MenuLoadGame(3); } }
function xslot4 { if (SaveOrLoad == 1) { MenuSaveGame (4); } else { MenuLoadGame(4); } }
function xslot5 { if (SaveOrLoad == 1) { MenuSaveGame (5); } else { MenuLoadGame(5); } }
function xslot6 { if (SaveOrLoad == 1) { MenuSaveGame (6); } else { MenuLoadGame(6); } }
function xslot7 { if (SaveOrLoad == 1) { MenuSaveGame (7); } else { MenuLoadGame(7); } }
function xslot8 { if (SaveOrLoad == 1) { MenuSaveGame (8); } else { MenuLoadGame(8); } }
function xslot9 { if (SaveOrLoad == 1) { MenuSaveGame (9); } else { MenuLoadGame(9); } }

function StartSaveLoad
{
	my = entPiposhMenu;

	while(1)
	{
		if (entSaveLoadMenu.visible == on)
		{
			MenuBlink();

			entVaseMenu1.pan = entVaseMenu1.pan + 2 * time;
			entVaseMenu1.tilt = entVaseMenu1.tilt + 2 * time;
			entVaseMenu1.roll = entVaseMenu1.roll - 2 * time;

			entVaseMenu2.pan = entVaseMenu2.pan + 2 * time;
			entVaseMenu2.tilt = entVaseMenu2.tilt + 2 * time;
			entVaseMenu2.roll = entVaseMenu2.roll - 2 * time;

			entVaseMenu3.pan = entVaseMenu3.pan + 2 * time;
			entVaseMenu3.tilt = entVaseMenu3.tilt + 2 * time;
			entVaseMenu3.roll = entVaseMenu3.roll - 2 * time;

			entVaseMenu4.pan = entVaseMenu4.pan + 2 * time;
			entVaseMenu4.tilt = entVaseMenu4.tilt + 2 * time;
			entVaseMenu4.roll = entVaseMenu4.roll - 2 * time;

			entVaseMenu5.pan = entVaseMenu5.pan + 2 * time;
			entVaseMenu5.tilt = entVaseMenu5.tilt + 2 * time;
			entVaseMenu5.roll = entVaseMenu5.roll - 2 * time;

			if (Turn > 0)
			{
				entSaveLoadMenu.pan = entSaveLoadMenu.pan + Dir * 15;
				entMillMenu.roll = entMillMenu.roll - 15;
				Turn = Turn - 15;
				ent_cycle ("Run",my.skill1);
			}
			else
			{
				ent_cycle ("Stand",my.skill1);
			}

			my.skill1 = my.skill1 + 10;
		}

		wait(1);
	}
}

function MenuLoadGame (x)
{
	GameNum = x;
	str_for_num (GameNumS,GameNum);

	str_cpy (StageToLoad,"Stage.");
	str_cat (StageToLoad,GameNumS);


	filehandle = file_open_read (StageToLoad);
		file_str_read (filehandle,ReturnTo);	// Determine the level that the game was saved in
	file_close (filehandle);

	if (str_cmpi(ReturnTo,"Empty") == 0)
	{
		GameAction = 1;

		WriteFlags();		

		filehandle = file_open_write ("Game.num");
			file_asc_write (filehandle,GameNum);
		file_close (filehandle);

		run (ReturnTo);	// Execute the level and exit
	}
	else
	{
		HideSaveText();
		SavePanel.visible = off;
		Mouse_Mode = 0;
	}
		
}

function MenuSaveGame (x)
{
	GameNum = x;
	str_for_num (GameNumS,GameNum);

	if (x == 1) { str_cpy(txtGameName,txtSaveGame1.string); txtSaveGame1.visible = off; msg.pos_x = 120; msg.pos_y = 180; }
	if (x == 2) { str_cpy(txtGameName,txtSaveGame2.string); txtSaveGame2.visible = off; msg.pos_x = 278; msg.pos_y = 180; }
	if (x == 3) { str_cpy(txtGameName,txtSaveGame3.string); txtSaveGame3.visible = off; msg.pos_x = 436; msg.pos_y = 180; }
	if (x == 4) { str_cpy(txtGameName,txtSaveGame4.string); txtSaveGame4.visible = off; msg.pos_x = 120; msg.pos_y = 300; }
	if (x == 5) { str_cpy(txtGameName,txtSaveGame5.string); txtSaveGame5.visible = off; msg.pos_x = 278; msg.pos_y = 300; }
	if (x == 6) { str_cpy(txtGameName,txtSaveGame6.string); txtSaveGame6.visible = off; msg.pos_x = 436; msg.pos_y = 300; }
	if (x == 7) { str_cpy(txtGameName,txtSaveGame7.string); txtSaveGame7.visible = off; msg.pos_x = 120; msg.pos_y = 423; }
	if (x == 8) { str_cpy(txtGameName,txtSaveGame8.string); txtSaveGame8.visible = off; msg.pos_x = 278; msg.pos_y = 423; }
	if (x == 9) { str_cpy(txtGameName,txtSaveGame9.string); txtSaveGame9.visible = off; msg.pos_x = 436; msg.pos_y = 423; }

	msg.font = english_font;
	msg.string = txtGameName;
	msg.visible = on;
	inkey (txtGameName);
	msg.visible = off;
	msg.font = standard_font;

	msg.pos_x = 0; msg.pos_y = 0;

	// Write game description
	str_cpy (StageToSave,"Desc.");
	str_cat (StageToSave,GameNumS);

	filehandle = file_open_write (StageToSave);
		file_str_write (filehandle,txtGameName);
	file_close (filehandle);

	HideSaveText();
	SavePanel.visible = off;
	Mouse_Mode = 0;

	wait(3);

	GameAction = 0;

	WriteFlags();
	Save ("Save",GameNum);
	WriteGameData (GameNum);

	// Write stage data
	str_cpy (StageToSave,"Stage.");
	str_cat (StageToSave,GameNumS);

	filehandle = file_open_write (StageToSave);
		file_str_write (filehandle,app_name);
	file_close (filehandle);

	filehandle = file_open_read ("Last.dat");
		file_str_read (filehandle,ReturnTo);	// Determine the last level the player has been in
	file_close (filehandle);

	screenshot ("SShot",GameNum);

	// Update the screenshot on the save\load panel

	if (GameNum == 1) { freeze_map slot1,5,0; }
	if (GameNum == 2) { freeze_map slot2,5,0; }
	if (GameNum == 3) { freeze_map slot3,5,0; }
	if (GameNum == 4) { freeze_map slot4,5,0; }
	if (GameNum == 5) { freeze_map slot5,5,0; }
	if (GameNum == 6) { freeze_map slot6,5,0; }
	if (GameNum == 7) { freeze_map slot7,5,0; }
	if (GameNum == 8) { freeze_map slot8,5,0; }
	if (GameNum == 9) { freeze_map slot9,5,0; }
}

function WriteGameData (x)
{
	if ((x == 0) || (x == null))
	{ 
		str_cpy(StageToSave,"Game.tmp"); 
	}
	else
	{
		GameNum = x;
		str_for_num (GameNumS,GameNum);

		str_cpy (StageToSave,"Game.");
		str_cat (StageToSave,GameNumS);
	}

	filehandle = file_open_write (StageToSave);

		var n;

		n = 0; while (n <= 4) { file_asc_write (filehandle,Piece[n]); n = n + 1; }
		n = 0; while (n <= 4) { file_asc_write (filehandle,Village[n]); n = n + 1; }
		n = 0; while (n <= 4) { file_asc_write (filehandle,Volcano[n]); n = n + 1; }
		n = 0; while (n <= 3) { file_asc_write (filehandle,Olympic[n]); n = n + 1; }
		n = 0; while (n <= 2) { file_asc_write (filehandle,Mansion[n]); n = n + 1; }
		n = 0; while (n <= 2) { file_asc_write (filehandle,Asylum[n]); n = n + 1; }

		file_asc_write (filehandle,flag_first_Village);
		file_asc_write (filehandle,flag_first_Volcano);
		file_asc_write (filehandle,flag_first_Olympic);
		file_asc_write (filehandle,flag_first_Mansion);
		file_asc_write (filehandle,flag_first_Asylum);

		file_asc_write (filehandle,varPhotoID);
		file_asc_write (filehandle,HasID);
		file_asc_write (filehandle,varNewMap);
		file_asc_write (filehandle,TalkedOnce);

		n = 0; while (n <= 31) { file_asc_write (filehandle,AFG[n]); n = n + 1; }

	file_close (filehandle);
}

function RefreshState (x)
{
	if ((x == 0) || (x == null))
	{ 
		str_cpy (StageToSave,"Game.tmp"); 
	}
	else
	{
		GameNum = x;
		str_for_num (GameNumS,GameNum);

		str_cpy (StageToSave,"Game.");
		str_cat (StageToSave,GameNumS);
	}

	filehandle = file_open_read (StageToSave);

		var n;

		n = 0; while (n <= 4) { Piece[n] =   file_asc_read (filehandle); n = n + 1; }
		n = 0; while (n <= 4) { Village[n] = file_asc_read (filehandle); n = n + 1; }
		n = 0; while (n <= 4) { Volcano[n] = file_asc_read (filehandle); n = n + 1; }
		n = 0; while (n <= 3) { Olympic[n] = file_asc_read (filehandle); n = n + 1; }
		n = 0; while (n <= 2) { Mansion[n] = file_asc_read (filehandle); n = n + 1; }
		n = 0; while (n <= 2) { Asylum[n] =  file_asc_read (filehandle); n = n + 1; }

		flag_first_Village = file_asc_read (filehandle);
		flag_first_Volcano = file_asc_read (filehandle);
		flag_first_Olympic = file_asc_read (filehandle);
		flag_first_Mansion = file_asc_read (filehandle);
		flag_first_Asylum =  file_asc_read (filehandle);

		varPhotoID = file_asc_read (filehandle);
		HasID = file_asc_read (filehandle);
		varNewMap = file_asc_read (filehandle);
		TalkedOnce = file_asc_read (filehandle);

		n = 0; while (n <= 31) { AFG[n] = file_asc_read (filehandle); n = n + 1; }

	file_close (filehandle);

	ScreenshotsLoaded = 0;	// Fix: must refresh screenshots, otherwise it will use the ones at the time of save
}

action RunIt
{
	if (entSaveLoadMenu.visible == off) { return; }

	if (Select == 1) 	// Load
	{ 
		if (ScreenshotsLoaded == 0)
		{
			CreateScreenshots();
			while (ScreenShotsLoaded == 0) { wait(1); }
		}

		entSaveLoadMenu.visible = off;
		pConsole.visible = off;
		pmenuhelp.visible = off;

		entVaseMenu1.visible = off;
		entVaseMenu2.visible = off;
		entVaseMenu3.visible = off;
		entVaseMenu4.visible = off;
		entVaseMenu5.visible = off;

		entMillMenu.visible = off;
		entPiposhMenu.visible = off;

		SaveOrLoad = 2;
		SavePanel.visible = on;
		ShowSaveText();
	}
		
	if (Select == 2) 	// Map
	{ 
		if (vNoMap == 0)
		{
			ReturnToMap();
		}
		else
		{
			pNoMap.visible = on;
			pNoMap.alpha = 100;

			waitt (60);

			pNoMap.transparent = on;
	
			while(pNoMap.alpha > 3) { pNoMap.alpha = pNoMap.alpha - 3 * time; wait(1); }

			pNoMap.alpha = 0;
			pNoMap.visible = off;
		}
	}

	if (Select == 3)	// Save
	{
		if (vNoSave == 1) 
		{ 
			HideConsole();

			pNoSave.visible = on;
			pNoSave.alpha = 100;

			waitt (60);

			pNoSave.transparent = on;
	
			while(pNoSave.alpha > 3) { pNoSave.alpha = pNoSave.alpha - 3 * time; wait(1); }

			pNoSave.alpha = 0;
			pNoSave.visible = off;

			return; 
		}

		if (ScreenshotsLoaded == 0)
		{
			CreateScreenshots();
			while (ScreenShotsLoaded == 0) { wait(1); }
		}

		HideConsole();

		SaveOrLoad = 1;
		SavePanel.visible = on;
		ShowSaveText();
	}

	if (Select == 4) { DoExit(); }	// Quit
}

function HideConsole
{
	entSaveLoadMenu.visible = off;
	pConsole.visible = off;
	pmenuhelp.visible = off;

	entVaseMenu1.visible = off;
	entVaseMenu2.visible = off;
	entVaseMenu3.visible = off;
	entVaseMenu4.visible = off;
	entVaseMenu5.visible = off;

	entMillMenu.visible = off;
	entPiposhMenu.visible = off;
}

function CreateScreenshots
{
	camera.visible = off;
	pmenuhelp.visible = off;
	mouse_mode = 0;

	wait(1);

	showfull.visible = on;

	ShowFull.bmap = full1;
	wait(1);
	freeze_map slot1,5,0;
	
	ShowFull.bmap = full2;
	wait(1);
	freeze_map slot2,5,0;

	ShowFull.bmap = full3;
	wait(1);
	freeze_map slot3,5,0;

	ShowFull.bmap = full4;
	wait(1);
	freeze_map slot4,5,0;

	ShowFull.bmap = full5;
	wait(1);
	freeze_map slot5,5,0;

	ShowFull.bmap = full6;
	wait(1);
	freeze_map slot6,5,0;

	ShowFull.bmap = full7;
	wait(1);
	freeze_map slot7,5,0;

	ShowFull.bmap = full8;
	wait(1);
	freeze_map slot8,5,0;

	ShowFull.bmap = full9;
	wait(1);
	freeze_map slot9,5,0;

	ShowFull.visible = off;

	camera.visible = on;

	wait(1);

	bmap_purge (full1);
	bmap_purge (full2);
	bmap_purge (full3);
	bmap_purge (full4);
	bmap_purge (full5);
	bmap_purge (full6);
	bmap_purge (full7);
	bmap_purge (full8);
	bmap_purge (full9);

	ScreenshotsLoaded = 1;
}

function WriteFlags
{
	filehandle = file_open_write ("Flags.dat");

		file_asc_write (filehandle,GameNum);	// Game number (1-5) 0 if the game has never been saved before
		file_asc_write (filehandle,GameAction);	// Action to perform (0 = none, 1 = load game from game num slot)

	file_close (filehandle);
}

function TurnRight
{
	if (Turn == 0) { Turn = 90; Dir = 1; Select = Select + 1; if (select > 4) { Select = 1; } }

	UpdateConsole();
}

function TurnLeft
{
	if (Turn == 0) { Turn = 90; Dir = -1; Select = Select - 1; if (select < 1) { Select = 4; } }

	UpdateConsole();
}

function UpdateConsole
{
	if (Select == 1) { pConsole.bmap = bCon_Save; }
	if (Select == 2) { pConsole.bmap = bCon_Map; }
	if (Select == 3) { pConsole.bmap = bCon_Load; }
	if (Select == 4) { pConsole.bmap = bCon_Quit; }
}

function ReadGameData
{
	filehandle = file_open_read ("game.num");
		GameNum = file_asc_read (filehandle);
	file_close (filehandle);

	GameAction = 0;
	WriteFlags();

	pLoading.visible = on;

	wait(3);

	sPlay ("Wait.wav");
	while (GetPosition(Voice) < 1000000) { wait(1); }

	wait(3);

	Load ("Save",GameNum);
	RefreshState (GameNum);

	WriteGameData(0);

	pLoading.visible = off;
}

function Initialize
{
	Randomize();

	pLoading.visible = off;

	entvasemenu1.scale_x = entvasemenu1.scale_x / 2;
	entvasemenu1.scale_y = entvasemenu1.scale_y / 2;
	entvasemenu1.scale_z = entvasemenu1.scale_z / 2;

	entvasemenu2.scale_x = entvasemenu2.scale_x / 2;
	entvasemenu2.scale_y = entvasemenu2.scale_y / 2;
	entvasemenu2.scale_z = entvasemenu2.scale_z / 2;

	entvasemenu3.scale_x = entvasemenu3.scale_x / 2;
	entvasemenu3.scale_y = entvasemenu3.scale_y / 2;
	entvasemenu3.scale_z = entvasemenu3.scale_z / 2;

	entvasemenu4.scale_x = entvasemenu4.scale_x / 2;
	entvasemenu4.scale_y = entvasemenu4.scale_y / 2;
	entvasemenu4.scale_z = entvasemenu4.scale_z / 2;

	entvasemenu5.scale_x = entvasemenu5.scale_x / 2;
	entvasemenu5.scale_y = entvasemenu5.scale_y / 2;
	entvasemenu5.scale_z = entvasemenu5.scale_z / 2;

	mouse_map = PozCursor;
	sky_map = bsky;
	cloud_map = bclouds;
	scene_map = bHorizon;
	sky_scale = 1;
	cloud_speed.x = 10;
	cloud_speed.y = 10;
	sky_speed.x = 3;
	sky_speed.y = 3;

	sky_scale = 0.5;
	sky_curve = 1;

	scene_nofilter = on;

	scene_field = 60;  		// repeat map 6 times
	scene_angle.tilt = -10; 	// lower edge of scene_map 10 units below horizon

	sky_clip = scene_angle.tilt;	// clip the sky at bottom of scene_map

	ScreenshotsLoaded = 0;

	anim_walk_dist = 3;
	anim_run_dist = 3;

	filehandle = file_open_read ("Flags.dat");
		GameNum = file_asc_read (filehandle);	// Game number (1-5) 0 if the game has never been saved before
		GameAction = file_asc_read (filehandle);// Action to perform (0 = none, 1 = save game into game num slot, 2 = load game from game num slot)
	file_close (filehandle);

	if (GameAction == 1) { ReadGameData(); } else { RefreshState(0); }

	StartSaveLoad();
}

function BuildVase
{
	if (Piece[0] == 1) { entVaseMenu1.visible = on; }
	if (Piece[1] == 1) { entVaseMenu2.visible = on; }
	if (Piece[2] == 1) { entVaseMenu3.visible = on; }
	if (Piece[3] == 1) { entVaseMenu4.visible = on; }
	if (Piece[4] == 1) { entVaseMenu5.visible = on; }
}

function GoToOptions
{	
	if (SavePanel.visible == on) { SavePanel.visible = off; HideSaveText(); return; }

	if (entSaveLoadMenu.visible == off)
	{
		UpdateConsole();
		PrevArc = camera.arc;
		camera.arc = 60;
		entSaveLoadMenu.visible = on;
		pConsole.visible = on;

		BuildVase();

		entMillMenu.visible = on;
		entPiposhMenu.visible = on;
		pmenuhelp.visible = on;
	}
	else
	{
		camera.arc = PrevArc;
		HideConsole();
	}

//	screenshot ("Shot", 0);
//	wait(1);

//	Save ("State",0);
//	VoiceStop();

//	filehandle = file_open_write ("Last.dat");
		file_str_write (filehandle,app_name);
//	file_close (filehandle);
}

function ReturnToMap
{
	if (varLevelID != 0)
	{
		filehandle = file_open_write ("Depart.dat");
			file_asc_write (filehandle,varLevelID);
		file_close (filehandle);
	}

	Run ("Map.exe"); 
}

function MenuBlink()
{
	if (my.skill22 > 0) { my.skill22 = my.skill22 - 1 * time; }
	if (my.skill22 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 2; my.skill22 = 5; }
	}
}

function Run (filename)
{
	// Notify the runner which file to run
	filehandle = file_open_write ("Run.txt");
		file_str_write (filehandle,filename);
	file_close (filehandle);

	WriteDate();

	exit;
}

function DoExit
{
	// Flag loader to exit
	filehandle = file_open_write ("Prefs\\Flag.txt");
		file_str_write (filehandle,"0");
	file_close (filehandle);

	// Notify the runner which file to run
	filehandle = file_open_write ("Run.txt");
		file_str_write (filehandle,"start.exe");
	file_close (filehandle);

	exit;
}

// Desc: switches the mouse on
function mouse_on()
{
//	MOUSE_MAP = arrow;
	while(MOUSE_MODE > 0)
	{
		MOUSE_POS.X = POINTER.X;
		MOUSE_POS.Y = POINTER.Y;
		wait(1); 		      // now move it over the screen
	}
}

// Desc: switches the mouse off
function mouse_off()
{
	MOUSE_MODE = 0;
}


function mouse_toggle()
{
	MOUSE_MODE += 2;
	if(MOUSE_MODE > 2)
	{	// was it already on?
		MOUSE_MODE = 0;		// mouse off
	}
	else
	{
		mouse_on();
	}
}

function SetDOD
{
	str_for_num (DODTemp,sys_day);
	str_cpy (strDOD2,DODTemp);
	str_cat (strDOD2,"/");
	str_for_num (DODTemp,sys_month);
	str_cat (strDOD2,DODTemp);
	str_cat (strDOD2,"/");
	str_for_num (DODTemp,sys_year);
	str_cat (strDOD2,DODTemp);
}

function ShowRIP
{
	sPlay ("RIP.wav");

	freeze_map bRIPSlot,2,0;

	SetDOD();
	pRIP.visible = on;
	pRipSlot.visible = on;
	ptRIP1.visible = on;
	ptRIP2.visible = on;
}

function HideRIP
{
	pRIP.visible = off;
	pRipSlot.visible = off;
	ptRIP1.visible = off;
	ptRIP2.visible = off;
}

function WriteDate
{
	str_for_num (DODtemp,sys_doy);
	str_cpy (DateToWrite,DODtemp);
	str_for_num (DODtemp,sys_hours);
	str_cat (DateToWrite,DODtemp);
	str_for_num (DODtemp,sys_minutes);
	str_cat (DateToWrite,DODtemp);
	str_for_num (DODtemp,sys_seconds);
	str_cat (DateToWrite,DODtemp);

	// Mark the date in which the execution has been requested
	filehandle = file_open_write ("Prefs\\Date.txt");
		file_str_write (filehandle,DateToWrite);
	file_close (filehandle);
}

function GoToLocation (ID)
{
	if (ID == _ASYLUM)
	{
		if (Asylum[0] == 0) 
		{ 
			if (Flag_First_Asylum == 0) { Run ("Intro3.exe"); return; } else { Run ("AsyAct1.exe"); return; }
		}

		if (Asylum[1] == 0) { Run ("AsyAct2.exe"); return; }
		if (Asylum[2] == 0) { Run ("AsyAct3.exe"); return; }
	}

	if (ID == _MANSION)
	{
		if (Mansion[0] == 0) { Run ("Mansion.exe"); return; }
		if (Mansion[1] == 0) { Run ("Cardgame.exe"); return; }
		if (Mansion[2] == 0) { Run ("Final.exe"); return; }
	}

	if (ID == _TOWN) { Run ("Town.exe"); return; }


	if (ID == _OLYMPIC)
	{
		if (Olympic[0] == 0)
		{
			if (Flag_First_Olympic == 0) { Run ("Intro16.exe"); return; } else { Run ("Olympic.exe"); return; }
		}

		if (Olympic[1] == 0) { Run ("Race.exe"); return; }
		if (Olympic[2] == 0) { Run ("Shooter.exe"); return; }
		if (Olympic[3] == 0) { Run ("Golf.exe"); return; }
	}

	if (ID == _VOLCANO)
	{
		if (Volcano[0] == 0) 
		{ 
			if (Flag_First_Volcano == 0) { Run ("Intro4.exe"); return; } else { Run ("Dutyfree.exe"); return; }
		}

		if (Volcano[1] == 0) { Run ("Mount.exe"); return; }
		if (Volcano[2] == 0) { Run ("Temple.exe"); return; }
		if (Volcano[3] == 0) { Run ("InShrine.exe"); return; }
		if (Volcano[4] == 0) { Run ("Mine.exe"); return; }
	}

	if (ID == _VILLAGE) 
	{ 
		if (Village[0] == 0)
		{
			if (Flag_First_Village == 0) { Run ("Intro2.exe"); return; } else { Run ("VS.exe"); return; }
		}
		else { Run ("VS.exe"); return; }
	}
}

function Help
{
	if (pHelp.visible == off) { SetHelp(); freeze_mode = 1; } else { CloseHelp(); }
}

on_esc = GoToOptions();
on_enter = RunIt;
on_h = Help();

function quicksave 
{ 
	filehandle = file_open_write ("Quick.lev");
		file_str_write (filehandle,app_name);
	file_close (filehandle);
	
	save ("quick",0); 
	msg.string = "TEM EG VA DJCEL FONV ,ETMUN ETJEM ETJMU"; 
	show_message(); 
}

function quickload 
{ 
	filehandle = file_open_read ("Quick.lev");
		file_str_read (filehandle,StrTemp);
	file_close (filehandle);

	if (str_cmpi (strTemp,app_name) == 0) { msg.string = "CFLFMKH EGE WOMB ETJEM ETJMU ETMUN AL"; show_message(); }
	else
	{
		load ("quick",0); 
	}
}

function quickinn { if (TalkedOnce == 1) { Run ("Inn.exe"); } }
function togglepause { if (freeze_mode > 0) { freeze_mode = 0; pPause.visible = off; } else { freeze_mode = 2; pPause.visible = on; } }

// Disable predefined function key actions

on_f1  = null;
on_f2  = null;
on_f3  = null;
on_f4  = null;
on_f5  = quicksave();
on_f6  = null;
on_f7  = quickload();
on_f8  = null;
on_f9  = null;
on_f10 = quickinn();
on_mouse_right = mouse_toggle();
on_1 = null;
on_2 = null;
on_3 = null;
on_4 = null;
on_5 = null;
on_6 = null;
on_7 = null;
on_8 = null;
on_9 = null;
on_p = togglepause();
