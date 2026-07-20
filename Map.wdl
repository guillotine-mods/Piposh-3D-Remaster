include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; 	// 16 bit colour D3D mode
var Say;
var SND = 0;
var LastLev = 0;
var SkipMovie = 0;

bmap NotA = <icn_nota.pcx>;
bmap done = <icn_done.pcx>;
bmap none = <icn_none.pcx>;

bmap asy1 = <icn_asy1.pcx>;
bmap asy2 = <icn_asy2.pcx>;
bmap asy3 = <icn_asy3.pcx>;

bmap man1 = <icn_man1.pcx>;
bmap man2 = <icn_man2.pcx>;
bmap man3 = <icn_man3.pcx>;

bmap oly1 = <icn_oly1.pcx>;
bmap oly2 = <icn_oly2.pcx>;
bmap oly3 = <icn_oly3.pcx>;
bmap oly4 = <icn_oly4.pcx>;

bmap town = <icn_town.pcx>;

bmap vol1 = <icn_vol1.pcx>;
bmap vol2 = <icn_vol2.pcx>;
bmap vol3 = <icn_vol3.pcx>;
bmap vol4 = <icn_vol4.pcx>;
bmap vol5 = <icn_vol5.pcx>;

bmap vil1 = <icn_vil1.pcx>;
bmap vil2 = <icn_vil2.pcx>;
bmap vil3 = <icn_vil3.pcx>;
bmap vil4 = <icn_vil4.pcx>;
bmap vil5 = <icn_vil5.pcx>;

bmap mappnl = <mappnl.pcx>;

bmap bLaw = <Law.pcx>;

bmap Map = <Map.pcx>;

bmap ba1 = <city.pcx>;
bmap ba2 = <cityh.pcx>;

bmap bb1 = <stad.pcx>;
bmap bb2 = <stadh.pcx>;

bmap bc1 = <crazy.pcx>;
bmap bc2 = <crazyh.pcx>;

bmap bd1 = <vil.pcx>;
bmap bd2 = <vilh.pcx>;

bmap be1 = <mount.pcx>;
bmap be2 = <mounth.pcx>;

bmap bf1 = <manor.pcx>;
bmap bf2 = <manorh.pcx>;

bmap bLastLev = <LastLev.pcx>;

panel pLastLev
{
	bmap = bLastLev;
	layer = 10;
	pos_x = 162;
	pos_y = 222;
	flags = refresh,d3d;
}

panel pLaw
{
	bmap = bLaw;
	layer = 2;
	pos_x = 100;
	pos_y = 0;
	flags = d3d,refresh,overlay;
}

panel pMap
{
	layer = -4;
	bmap = Map;
	pos_x = 0;
	pos_y = 0;
	flags = d3d,refresh,overlay;

	button = 10, 158, ba2, ba1, ba2, Goto1, null, Show1;
	button = 189, 197, bb2, bb1, bb2, Goto2, null, Show2;
	button = 379, 161, bc2, bc1, bc2, Goto3, null, Show3;
	button = 458, 188, bd2, bd1, bd2, Goto4, null, Show4;
	button = 486, 149, be2, be1, be2, Goto5, null, Show5;
	button = 533, 211, bf2, bf1, bf2, Goto6, null, Show6;
}

function CheckLastLev
{
	if ((Asylum[2] == 1) && (Olympic[3] == 1) && (Village[4] == 1) && (Volcano[4] == 1)) { LastLev = 1; }
}

function ShowLaw
{
	pLaw.visible = on;
	pLaw.alpha = 100;

	waitt (120);

	pLaw.transparent = on;
	
	while(pLaw.alpha > 3) { pLaw.alpha = pLaw.alpha - 3 * time; wait(1); }

	pLaw.alpha = 0;
	pLaw.visible = off;
}

function ShowLastLev
{
	pLastLev.visible = on;
	pLastLev.alpha = 100;

	waitt (60);

	pLastLev.transparent = on;
	
	while(pLastLev.alpha > 3) { pLastLev.alpha = pLastLev.alpha - 3 * time; wait(1); }

	pLastLev.alpha = 0;
	pLastLev.visible = off;
}

function Goto1 { LocationGo (_Town); }
function Goto2 { if (Olympic[3] != 1) { if (HasID == 1) { LocationGo (_Olympic); } else { ShowLaw(); } } }
function Goto3 { if ( Asylum[2] != 1) { if (HasID == 1) { LocationGo (_Asylum);  } else { ShowLaw(); } } }
function Goto4 { if (Village[4] != 1) { if (HasID == 1) { LocationGo (_Village); } else { ShowLaw(); } } }
function Goto5 { if (Volcano[4] != 1) { if (HasID == 1) { LocationGo (_Volcano); } else { ShowLaw(); } } }
function Goto6 { CheckLastLev(); if (LastLev == 1) { LocationGo (_Mansion); } else { ShowLastLev(); } }

function Show1 { SetLocations (_Town);    }
function Show2 { SetLocations (_Olympic); }
function Show3 { SetLocations (_Asylum);  }
function Show4 { SetLocations (_Village); }
function Show5 { SetLocations (_Volcano); }
function Show6 { SetLocations (_Mansion); }

entity entPhotoID
{
	type = <approve.mdl>;
	layer = 10;
	view = camera;
	x = 150;
	y = -50;
	z = -50;
	pan = 180;
	ambient = 100;
}

panel pnl { bmap = mappnl; pos_x = 231; pos_y = 430; layer = -3; flags = d3d,refresh,overlay; }

panel X1 { bmap = vol1; pos_x = 250; pos_y = 439; layer = -2; flags = d3d,refresh; }
panel X2 { bmap = vol2; pos_x = 282; pos_y = 439; layer = -2; flags = d3d,refresh; }
panel X3 { bmap = vol3; pos_x = 314; pos_y = 439; layer = -2; flags = d3d,refresh; }
panel X4 { bmap = vol4; pos_x = 346; pos_y = 439; layer = -2; flags = d3d,refresh; }
panel X5 { bmap = vol5; pos_x = 378; pos_y = 439; layer = -2; flags = d3d,refresh; }

panel D1 { bmap = none; pos_x = 250; pos_y = 439; layer = -1; flags = d3d,refresh,overlay; }
panel D2 { bmap = none; pos_x = 282; pos_y = 439; layer = -1; flags = d3d,refresh,overlay; }
panel D3 { bmap = none; pos_x = 314; pos_y = 439; layer = -1; flags = d3d,refresh,overlay; }
panel D4 { bmap = none; pos_x = 346; pos_y = 439; layer = -1; flags = d3d,refresh,overlay; }
panel D5 { bmap = none; pos_x = 378; pos_y = 439; layer = -1; flags = d3d,refresh,overlay; }

sound MapOpen = <SFX056.WAV>;
sound Ambient = <SFX057.WAV>;

function LocationGo (ID)
{
	if (HasID != 1) { Run ("Town.exe"); }	// Player has no ID, he is taken straight to the town
	else
	{
		filehandle = file_open_write ("Arrive.dat");
			file_asc_write (filehandle,ID);
		file_close (filehandle);

		Run ("Desert.exe"); 
	}
}

function SetLocations (ID)
{
	x1.visible = on;x2.visible = on;x3.visible = on;x4.visible = on;x5.visible = on;
	d1.visible = on;d2.visible = on;d3.visible = on;d4.visible = on;d5.visible = on;

	if (ID == _ASYLUM)
	{
		x1.bmap = asy1;
		x2.bmap = asy2;
		x3.bmap = asy3;
		x4.visible = off;
		x5.visible = off;

		if (Asylum[2] == 1) { d1.bmap = done; d2.bmap = done; d3.bmap = done; }
		if (Asylum[2] == 0) { d1.bmap = done; d2.bmap = done; d3.bmap = none; }
		if (Asylum[1] == 0) { d1.bmap = done; d2.bmap = none; d3.bmap = nota; }
		if (Asylum[0] == 0) { d1.bmap = none; d2.bmap = nota; d3.bmap = nota; }

		d4.visible = off;
		d5.visible = off;
	}

	if (ID == _MANSION)
	{
		x1.bmap = man1;
		x2.bmap = man2;
		x3.bmap = man3;
		x4.visible = off;
		x5.visible = off;

		if (Mansion[2] == 1) { d1.bmap = done; d2.bmap = done; d3.bmap = done; }
		if (Mansion[2] == 0) { d1.bmap = done; d2.bmap = done; d3.bmap = none; }
		if (Mansion[1] == 0) { d1.bmap = done; d2.bmap = none; d3.bmap = nota; }
		if (Mansion[0] == 0) { d1.bmap = none; d2.bmap = nota; d3.bmap = nota; }

		d4.visible = off;
		d5.visible = off;
	}

	if (ID == _OLYMPIC)
	{
		x1.bmap = oly1;
		x2.bmap = oly2;
		x3.bmap = oly3;
		x4.bmap = oly4;
		x5.visible = off;

		if (Olympic[3] == 1) { d1.bmap = done; d2.bmap = done; d3.bmap = done; d4.bmap = done; }
		if (Olympic[3] == 0) { d1.bmap = done; d2.bmap = done; d3.bmap = done; d4.bmap = none; }
		if (Olympic[2] == 0) { d1.bmap = done; d2.bmap = done; d3.bmap = none; d4.bmap = nota; }
		if (Olympic[1] == 0) { d1.bmap = done; d2.bmap = none; d3.bmap = nota; d4.bmap = nota; }
		if (Olympic[0] == 0) { d1.bmap = none; d2.bmap = nota; d3.bmap = nota; d4.bmap = nota; }

		d5.visible = off;
	}

	if (ID == _TOWN)
	{
		x1.bmap = town;
		x2.visible = off;
		x3.visible = off;
		x4.visible = off;
		x5.visible = off;

		d1.bmap = none;
		d2.visible = off;
		d3.visible = off;
		d4.visible = off;
		d5.visible = off;
	}

	if (ID == _VOLCANO)
	{
		x1.bmap = vol1;
		x2.bmap = vol2;
		x3.bmap = vol3;
		x4.bmap = vol4;
		x5.bmap = vol5;

		if (Volcano[4] == 1) { d1.bmap = done; d2.bmap = done; d3.bmap = done; d4.bmap = done; d5.bmap = done; }
		if (Volcano[4] == 0) { d1.bmap = done; d2.bmap = done; d3.bmap = done; d4.bmap = done; d5.bmap = none; }
		if (Volcano[3] == 0) { d1.bmap = done; d2.bmap = done; d3.bmap = done; d4.bmap = none; d5.bmap = nota; }
		if (Volcano[2] == 0) { d1.bmap = done; d2.bmap = done; d3.bmap = none; d4.bmap = nota; d5.bmap = nota; }
		if (Volcano[1] == 0) { d1.bmap = done; d2.bmap = none; d3.bmap = nota; d4.bmap = nota; d5.bmap = nota; }
		if (Volcano[0] == 0) { d1.bmap = none; d2.bmap = nota; d3.bmap = nota; d4.bmap = nota; d5.bmap = nota; }
	}

	if (ID == _VILLAGE)
	{
		x1.bmap = vil1;
		x2.bmap = vil2;
		x3.bmap = vil3;
		x4.bmap = vil4;
		x5.bmap = vil5;

		if (Village[4] == 1) { d1.bmap = done; d2.bmap = done; d3.bmap = done; d4.bmap = done; d5.bmap = done; }
		if (Village[4] == 0) { d1.bmap = done; d2.bmap = done; d3.bmap = done; d4.bmap = done; d5.bmap = none; }
		if (Village[3] == 0) { d1.bmap = done; d2.bmap = done; d3.bmap = done; d4.bmap = none; d5.bmap = nota; }
		if (Village[2] == 0) { d1.bmap = done; d2.bmap = done; d3.bmap = none; d4.bmap = nota; d5.bmap = nota; }
		if (Village[1] == 0) { d1.bmap = done; d2.bmap = none; d3.bmap = nota; d4.bmap = nota; d5.bmap = nota; }
		if (Village[0] == 0) { d1.bmap = none; d2.bmap = nota; d3.bmap = nota; d4.bmap = nota; d5.bmap = nota; }
	}
}
/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	warn_level = 0;
	tex_share = on;

	vNoMap = 1;
	Say = int(random(7));

	load_level(<Map.WMB>);

	VoiceInit();
	Initialize();

	if (HasID == 1) { entPhotoID.skin = varPhotoID; }
}

action Dummy
{
	while(1)
	{
		if (pMap.visible == on)
		{
			BuildVase();

			if (HasID == 1) { entPhotoID.visible = on; } else { entPhotoID.visible = off; }

			entPhotoID.pan = entPhotoID.pan + 2 * time;
			entPhotoID.tilt = entPhotoID.tilt - 2 * time;
			entPhotoID.roll = entPhotoID.roll - 2 * time;

			if (entSaveLoadMenu.visible == off)
			{
				entVaseMenu1.pan = entVaseMenu1.pan - 2 * time;
				entVaseMenu1.tilt = entVaseMenu1.tilt + 2 * time;
				entVaseMenu1.roll = entVaseMenu1.roll + 2 * time;

				entVaseMenu2.pan = entVaseMenu2.pan - 2 * time;
				entVaseMenu2.tilt = entVaseMenu2.tilt + 2 * time;
				entVaseMenu2.roll = entVaseMenu2.roll + 2 * time;

				entVaseMenu3.pan = entVaseMenu3.pan - 2 * time;
				entVaseMenu3.tilt = entVaseMenu3.tilt + 2 * time;
				entVaseMenu3.roll = entVaseMenu3.roll + 2 * time;

				entVaseMenu4.pan = entVaseMenu4.pan - 2 * time;
				entVaseMenu4.tilt = entVaseMenu4.tilt + 2 * time;
				entVaseMenu4.roll = entVaseMenu4.roll + 2 * time;

				entVaseMenu5.pan = entVaseMenu5.pan - 2 * time;
				entVaseMenu5.tilt = entVaseMenu5.tilt + 2 * time;
				entVaseMenu5.roll = entVaseMenu5.roll + 2 * time;
			}
		}

		wait(1);
	}
}

action Piposh
{
	waitt(16);

	while(1)
	{
		if (snd_playing(SND) == 0) { play_sound (Ambient,10); SND = result; }

		my.skill1 = my.skill1 + 5 * time;
		if ((my.skill1 > 40) && (my.skill39 == 0)) { my.skill39 = 1; play_sound (MapOpen,100); }
		ent_frame ("stand",my.skill1);

		Say = int(random(7));

		if ((my.skill1 >= 100) && (my.skill40 == 0))
		{
			if (varNewMap == 1)
			{
				if (Say == 0) { sPlay ("MAP001.WAV"); }
				if (Say == 1) { sPlay ("MAP002.WAV"); }
				if (Say == 2) { sPlay ("MAP003.WAV"); }
				if (Say == 3) { sPlay ("MAP004.WAV"); }
				if (Say == 4) { sPlay ("MAP005.WAV"); }
				if (Say == 5) { sPlay ("MAP006.WAV"); }
				if (Say == 6) { sPlay ("MAP007.WAV"); }
			}

			else
			{
				sPlay ("PIP074.WAV");
				varNewMap = 1;
				WriteGameData(0);
			}

			pmap.visible = on;
			pnl.visible = on;
			wait(1);

			if (my.skill35 == 0) { play_moviefile ("MOV\\Map.avi"); my.skill35 = 1; }
			while ((SkipMovie != 1) && (movie_frame != 0)) { wait(1); }

			my.skill40 = 1;

			stop_movie;

		}

		wait (1);
	}
}

function EndLogo
{
	SkipMovie = 1;
}

on_space = EndLogo();