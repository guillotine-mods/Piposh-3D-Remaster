////////////////////////////////////////////////////////////////////////
// Module        : auftrag.wdl
// Version       : 1.0
// Last Change   : 8/21/00
// Desc: Main game WDL script
//
// Notes:
//
// To Do:
//
////////////////////////////////////////////////////////////////////////
// THE JOB "MISIION 2"
// Autor: Czeslaw Gorski
////////////////////////////////////////////////////////////////////////
//DEFINE german;
IFDEF german;
	PATH "german";
IFELSE;
	PATH "english";
ENDIF;
PATH	"..\\template";// Path to templates subdirectory

////////////////////////////////////////////////////////////////////////
// REDEFINEs to Template values!
DEFINE MSG_DEFS;
	FONT standard_font,<ackfont.pcx>,6,9;

	DEFINE MSG_X,10;		// from left
	DEFINE MSG_Y,10;		// from above
	DEFINE BLINK_TICKS,6;	// msg blinking period
	DEFINE MSG_TICKS,64;	// msg appearing time
	DEFINE msg_font,standard_font;
	SOUND msg_sound,<msg.wav>;

	DEFINE PANEL_POSX,4;	// health panel from left
	DEFINE PANEL_POSY,-20;	// from below
	FONT digit_font,<digfont.pcx>,12,16;	// ammo/health font
// END MSG_DEFS


//////////////////////////// template INCLUDE
INCLUDE <movement.wdl>;
INCLUDE <messages.wdl>;
INCLUDE <menu.wdl>;
INCLUDE <particle.wdl>;
INCLUDE <doors.wdl>;
INCLUDE <actors.wdl>;
INCLUDE <weapons.wdl>;
INCLUDE <war.wdl>;
/////////////////////////////////

MAIN main;


// 'indicator' values
DEFINE _HANDLE,1;		// player SCAN via space key
DEFINE _EXPLODE,2;	// SCAN by an explosion
DEFINE _GUNFIRE,3;	// SHOOT fired by a gun
DEFINE _WATCH,4;		// looking for an enemy
DEFINE _LIFTER,5;		// looking for an enemy
DEFINE _KANONE,6;		// looking for an enemy


var indicator = 0;

////////////////////////////////////////////////////////////////////////
// Entity synonyms
SYNONYM rakieta { TYPE ENTITY; }
SYNONYM robik_1 { TYPE ENTITY; }
SYNONYM robik_2 { TYPE ENTITY; }
SYNONYM robik_3 { TYPE ENTITY; }
SYNONYM robik_4 { TYPE ENTITY; }
SYNONYM robik_5 { TYPE ENTITY; }
SYNONYM robikus {TYPE ENTITY;}
SYNONYM kron {TYPE ENTITY;}
SYNONYM grun {TYPE ENTITY;}

SYNONYM winda_fl {TYPE ENTITY;}
SYNONYM winda_b2 {TYPE ENTITY;}
SYNONYM winda_ko {TYPE ENTITY;}
SYNONYM winda_kr { TYPE ENTITY; }
SYNONYM winda_r1 {TYPE ENTITY;}
SYNONYM winda_r2 {TYPE ENTITY;}
SYNONYM winda_r3 {TYPE ENTITY;}
SYNONYM bruecke_en {TYPE ENTITY;}
SYNONYM radar_en {TYPE ENTITY;}
SYNONYM radar2_en {TYPE ENTITY;}

////////////////////////////////////////////////////////////////////////
// SOUND
SOUND close_wav,<CLOS-MET.WAV>;
SOUND war1_wav,<war1.WAV>;
SOUND war2_wav,<war2.WAV>;
// SOUND war3_wav,<war3.WAV>;
// SOUND war4_wav,<war4.WAV>;
SOUND explo1_wav,<Explo1.wav>;
// SOUND explo2_wav,<Explo2.wav>;
SOUND explo3_wav,<Explo3.wav>;
SOUND szum1_wav,<SZUM4.WAV>;
SOUND sataus_wav,<sataus.WAV>;
SOUND sat_wav,<sat.WAV>;
SOUND metal_wav,<metal.WAV>;
SOUND glass_wav,<Glass.WAV>;
SOUND ekran_wav,<Ekran.WAV>;
SOUND kurz_wav,<Kurz.WAV>;
SOUND pstryk0_wav,<pstryk0.WAV>;
SOUND pstryk1_wav,<pstryk1.WAV>;
SOUND pstryk3_wav,<pstryk3.WAV>;
SOUND pstryk4_wav,<pstryk4.WAV>;
SOUND ventil_wav,<ventil.WAV>;
SOUND stuk1_wav,<stuk1.WAV>;
SOUND schwehr_wav,<schwehr.WAV>;
SOUND szur_wav,<szur.WAV>;
SOUND dostal_wav,<dostal.WAV>;
SOUND a_wav,<a.WAV>;
SOUND item_wav,<item.WAV>;
SOUND besser_wav,<besser.WAV>;
SOUND apple_wav,<apple.WAV>;
SOUND hambu_wav,<hambu.WAV>;
SOUND leben_wav,<leben.WAV>;
SOUND radar_wav,<radaran.WAV>;
SOUND radan_wav,<radan.WAV>;
SOUND radaus_wav,<radaus.WAV>;
SOUND rad_wav,<rad.WAV>;
SOUND geld_wav,<geld.WAV>;
SOUND trink_wav,<trink.WAV>;
SOUND selbst_wav,<selbs82.wav>;
SOUND buzzer_wav,<buzzer.wav>;
SOUND aufladen_wav,<aufladen.wav>;
SOUND kanon_an_wav,<kanon_an.wav>;
SOUND dostal2_wav,<dostal2.wav>;
SOUND dostal3_wav,<dostal3.wav>;
// SOUND en2_wav,<en2.wav>;
// SOUND schot1a_wav,<schot1a.wav>;
// SOUND schot1b_wav,<schot1b.wav>;
SOUND rocket_wav,<rocket.wav>;
SOUND	krlift_wav,<krliftan.wav>;
SOUND	radtop_wav,<radtop.wav>;
SOUND	furz_wav,<furz.wav>;
SOUND	fire0_wav,<fire-0.wav>;
SOUND	fire2_wav,<fire-2.wav>;
SOUND	logo_wav,<logo.wav>;
SOUND	gwizd_wav,<gwizd.wav>;

SOUND laser_wham,<laser.wav>;


////////////// VARS
//--var verlezung = 0;		// ferlezung des Players

var alles_ok_sk = 0; 	// DESTRUCTION - 0 /1 /2 /3
//--var thud_sound_sk = 1;  //ob thud  -Sound abgespielt werden soll
								// play thud sound?
var my_leben = 100;    	// 100 MEIN LEBEN (player's health)

var rotor_sat = 0;      // on/off Satelitenrotation - soll 0
								// satellite controls (on/off)

var angle_sat = 0; 		// Satelitenwinkel - soll 0, richtige Position 257
								// satellite rotation - start 0, correct position 257

var angle_rad = 0;     	// Radarwinkel - soll 0, richtige Position 129
								// radar rotation - start 0, correct position 129

var radar_an_ska = 0;	//ob der RADAR an ist 0/1 (radar on/off)

var gener_sk = 0; 		// Generator - soll 0 dann 1 (generator switch puzzle)
var lift_block_sk = 0; 	// Liftblokade - soll 0 dann 1

//Generator switches (for generator switch puzzle)
var gener1_sk = 0;  		// Generatorschalter - soll 0 / 1
var gener2_sk = 0;  		// Generatorschalter - soll 0 / 0
var gener3_sk = 0;  		// Generatorschalter - soll 0 / 1
var gener4_sk = 0;		// Generatorschalter - soll 0 / 1


// 5 switch puzzle (0-red/1-green)
var 5x_1_sk = 0;  		// EndRaum 5 Schalter 1 - soll 0 / 1
var 5x_2_sk = 0;  		// EndRaum 5 Schalter 2 - soll 0 / 0
var 5x_3_sk = 0;  		// EndRaum 5 Schalter 3 - soll 0 / 0
var 5x_4_sk = 0;  		// EndRaum 5 Schalter 4 - soll 0 / 1
var 5x_5_sk = 0;  		// EndRaum 5 Schalter 5 - soll 0 / 1
var 5x_schalt_sk = 0;  	// EndRaum 5 Schalter - soll 0 / 1 /2 wenn mit Password

// laser wall (0-off/1-on)
var laser_sk = 1; 		// Laserwand - soll 1 /0 /2

// Fuse-blown values (0-on/1-blown)
// 1 - bedroom
// 2 - speiseraum(?)
// 3 - corridor
// 4 - reactor
// 5 - down reactor(?)
var kasten_1_sk = 0;	 	// ElectroKasten Schlafzimmer  - soll 0/1
var kasten_2_sk = 0;		// ElectroKasten Speiseraum - soll 0/1
var kasten_3_sk = 0; 	// ElectroKasten Korridor - soll 0/1
var kasten_4_sk = 0;		// ElectroKasten Reaktor -schrÑge- 0/1
var kasten_5_sk = 0;		// ElectroKasten Reaktor unten - 0/1

// Gate switches (0-off/1-on)
var torschalt_1_sk = 0; //  Hausmeiser - 0 /1
var torschalt_2_sk = 0;	//  Krankenstation - 0 /1
var torschalt_3_sk = 0; //  Satelitenraum - 0 /1
var torschalt_4_sk = 0; //  Steuerraum - klein- 0 /1
var torschalt_5_sk = 0;	//  Schlafzimmer- 0 /1

// Elevators (0-off/1-on)
// 1 - hospital
// 2 -
// lager -
var lift_krank1_sk = 0;	// Lift zur Krankenstation Platte- 0/1
var lift_krank2_sk = 0; // Lift zur Krankenstation Schalter- 0/1
var lift_lager_sk  = 0; // Lift im Lager B - blockade- 0/1

// platform in stock room B blocked
var platt_lager_sk = 0;	// Plattformt im Lager B - blockade- 0/1

// gate in stock room A
var tor_lB_sk = 0; 		// Tor 2 im Lager A - blockade- 0/1

// gates (0-off/1-on)
var tor_sb_sk = 0;		// Tor SCECTOR B - blockade- 0/1
var tor_st_sk = 0;		// Tor STEUERRAUM - blockade- 0/1
var tor_la_sk = 0;		// Tor LABOR A R2 - blockade- 0/1
var tor_sr_sk = 0; 		// Tor satelitenraum - blockade- 0/1

// player has hardware key
var h_key_sk = 0; 		//  Hardwarekey - 0/1

var schacht_sk = 0;		// SChacht - 0

var fass_sk = 0; 			// fass - 0 (the 'exploding barrel' that blows a hole in the wall)

var schacht_sk = 0; 		// SChacht - 0
var bruecke_sk = 0; 		// Bruecke - 0 /1

SKILL wavehandle1 {TYPE LOCAL;}
SKILL wavehandle2 {TYPE LOCAL;}
SKILL wavehandle3 {TYPE LOCAL;}
//var gruene_pos_sk = 0;
var terminal_sk = 0;
var countdown_sk = 90; // soll 90

var geld_sk = 0;
var terminal_y;
var terminal_x;
var temp2;



////////////////////////////////////////////////////////////////////////
// songs
MUSIC song1,<song1.mid>;
MUSIC song2,<song2.mid>;
MUSIC song3,<song3.mid>;
MUSIC song4,<song4.mid>;


// Particle vars
var pix_farbe = 0;    // color
var pix_size = 0;

var ekran_pix[3] =  255, 255, 0;
var kasten_pix[3] = 227, 221, 255;

var spaw_on;

////////////////////////////////////////////////////////////////////////
// Mission2 INCLUDES
IFNDEF german;
INCLUDE <m2str_e.wdl>;
IFELSE;
INCLUDE <m2str_d.wdl>;
ENDIF;
INCLUDE <lift.wdl>;
INCLUDE <podest.wdl>;
INCLUDE <arbeiter.wdl>;
INCLUDE <rauch.wdl>;
INCLUDE <m2war.wdl>;
INCLUDE <kanone.wdl>;
INCLUDE <m2parti.wdl>;
//INCLUDE <m2menu.wdl>;
INCLUDE <m2move.wdl>;
INCLUDE <m2messag.wdl>;
INCLUDE <intro.wdl>;
INCLUDE <m2weap.wdl>;
INCLUDE <m2item.wdl>;


////////////////////////////////////////////////////////////////////////
// PANELS

// Desc: exit (quit game) panel
//       includes credits
BMAP	end_map,<end1.pcx>;
PANEL 	end_pan
{
	BMAP end_map;
	LAYER 20;
	POS_X   0;
	POS_Y   0;
	FLAGS REFRESH;
}

// Desc: panels used to control the rotation of the satellite and radar
BMAP	scala_map,<scala.pcx>; 		// satellite
BMAP	scala2_map,<scala2.pcx>;   // radar
PANEL 	scala_pan
{
	BMAP scala_map;
	LAYER 1;
	POS_X   0;
	POS_Y   0;
	FLAGS REFRESH;
	DIGITS	46,32,3,digi_font,1,angle_sat;
}
PANEL 	radar_pan
{
	BMAP scala2_map;
	LAYER 1;
	POS_X   0;
	POS_Y   0;
	FLAGS REFRESH;
	DIGITS	46,32,3,digi_font,1,angle_rad;
}


// Pin-up boards (that appear when the user clicks on them)
BMAP	pin1_map,<pin1-big.pcx>;
BMAP	pin2_map,<pin2-big.pcx>;
PANEL 	pinwand_pan
{
	BMAP pin1_map;
	LAYER 2;
	POS_X   0;
	POS_Y   0;
	FLAGS REFRESH;
}

// Computer monitors
BMAP	ekran0_map,<screen-b.pcx>;    // black bitmap
BMAP	ekran1_map,<ekran-1.pcx>;     // computer screen (for monitor)
BMAP	ekran1a_map,<ekran-2b.pcx>;   // scan-line f/x
BMAP	ekran3_map,<ekran-3.pcx>;  	// computer monitor
BMAP	ekran4_map,<ekran-4.pcx>;     // log monitor

// Desc: black bitmap
PANEL 	ekran0_pan
{
	BMAP ekran0_map;
	LAYER 4;
	POS_X   0;
	POS_Y   0;
	FLAGS REFRESH;
}

// Desc: gray computer screen
PANEL 	ekran1_pan
{
	BMAP ekran1_map;
	LAYER 5;
	POS_X   0;
	POS_Y   0;
	FLAGS REFRESH;
}

// Desc: scan-line f/x overlay
PANEL 	ekran1a_pan
{
	BMAP ekran1a_map;
	LAYER 7;
	POS_X   65;
	POS_Y   80;
	FLAGS REFRESH,TRANSPARENT;
}

// Desc: computer monitor interface overlay
PANEL 	ekran3_pan
{
	BMAP ekran3_map;
	LAYER 8;
	POS_X   0;
	POS_Y   0;
	FLAGS REFRESH,OVERLAY;
}

// Desc: log monitor interface overlay
PANEL 	ekran4_pan
{
	BMAP ekran4_map;
	LAYER 5;
	POS_X   0;
	POS_Y   0;
	FLAGS REFRESH;
}





///////////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the skill
// VIDEO_MODE. It is now possible to switch the resolution during
// gameplay using the SWITCH_VIDEO instruction:
DEFINE V640x480,6;
DEFINE V800x600,7;
DEFINE V1024x768,8;	// You'll need either D3D, or a P2-666 for this
DEFINE V1280x960,9;
DEFINE V1600x1200,10;

var VIDEO_MODE = 6;   	// 640 by 480
var VIDEO_DEPTH = 16;	// 16-bit color



// Desc: function used to apply damage to player
//
// Mod: 10/4/00 DCP
//			Increase damage from 1-3 to 2-6
function player_take_damage()
{
	IF(indicator == _GUNFIRE)
	{
		my_leben -= INT(RANDOM(4) + 2);	// take 2 to 6 points of damage
	}

}

// Desc: player action
ACTION player_prog
{
	MY.FAT = OFF;
	MY.NARROW = ON;
	MY.AMBIENT = 0;
	MY.SKIN = 1;
	MY._WALKFRAMES = DEFAULT_WALK;
	MY._RUNFRAMES = DEFAULT_RUN;
	MY.__JUMP = ON;
//	MY.__DUCK = ON;

	player_walk();
	MY.ENABLE_SHOOT = ON;
	MY.EVENT = player_take_damage;
}

var	tumblespeed[3] = 5,0,0;
var	angles[3];

////////////////////////////////////////////////////////////////////////////
// The following skills control the sky movement
BMAP sky1_map,<Sky01.pcx>;
BMAP stern_map,<Stern01.pcx>;

// Desc: init the sky values
function init_sky()
{
	SKY_SPEED.X = 0;
	SKY_SPEED.Y = 0;
	CLOUD_SPEED.X = 1;
	CLOUD_SPEED.Y = 1.5;
	SKY_SCALE = 1;
	SKY_CURVE = 1;
	SCENE_MAP = NULL;
	SKY_MAP = stern_map;
	CLOUD_MAP = sky1_map;
}

/////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////
// The following definitions are for the WDFC window composer
// (available only on the professional version)
// to define the start and exit window of the application.

WINDOW WINSTART
{
	TITLE			"Mission2";
	SIZE			480,320;
	MODE			IMAGE;	//STANDARD;
	BG_COLOR		RGB(240,240,240);
	FRAME			FTYP1,0,0,480,320;
//	BUTTON		BUTTON_START,SYS_DEFAULT,"Start",400,288,72,24;
	BUTTON		BUTTON_QUIT,SYS_DEFAULT,"Abort",400,288,72,24;
	TEXT_STDOUT	"Arial",RGB(0,0,0),10,10,460,280;
}

/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
// HANDLE -ACTION

// Desc: Overrides Action in movement.wdl
//			used to handle (pick up, move, etc) items
function handle()
{
	IF ((player != NULL) && (person_3rd != 0))
	{
		MY_POS.X = player.X;
		MY_POS.Y = player.Y;
		MY_POS.Z = player.Z;
	}
	ELSE
	{
		MY_POS.X = CAMERA.X;
		MY_POS.Y = CAMERA.Y;
		MY_POS.Z = CAMERA.Z;
	}
	MY_ANGLE.PAN = CAMERA.PAN;
	MY_ANGLE.TILT = CAMERA.TILT;
	temp.PAN = 130;  //org.120
	temp.TILT = 200; //org. 180
	temp.Z = 180;
	indicator = _HANDLE;
	SCAN	MY_POS,MY_ANGLE,temp;
}

///////////////////////////////////////
//MACHT PC-Monitore kaputt

// Desc: exploding monitor event
ACTION monitor_kaput
{
	IF (EVENT_TYPE == EVENT_SCAN)
	{
		IF (indicator != _EXPLODE) {END;}

		scatter_size = 200;
 		scatter_init();
		particle_pos.X = MY.X;
		particle_pos.Y = MY.Y;
		particle_pos.Z = MY.Z  + 20;
 		scatter_map = bruch_map;
 		EMIT 10,particle_pos,particle_sphere;
		WAIT 1;

		IF (MY.FLAG1 == ON)
		{
			CREATE <expl1+16.pcx>,MY.POS,explo_flame;
			PLAY_ENTSOUND	ME,glass_wav,200;
		}
		REMOVE ME;
		END;
	}

	MY.ENABLE_SHOOT = OFF;	// no longer shootable
	MY.FLAG1 = ON;
	MY.SKIN = 2;	// change to blown monitor skin
	WAIT 1;

	// explode
	PLAY_ENTSOUND	ME,glass_wav,200;
	CREATE <expl1+16.pcx>,MY.POS,explo_flame;
}

// Desc: exploding monitor action
ACTION init_monitor
{
	MY.EVENT = monitor_kaput;
	MY.ENABLE_SHOOT = ON;
	MY.ENABLE_SCAN = ON;
	MY.PUSH = 10;
}

////////////////////////////////////////////////////////////////////////
//Sicherungskasten an der Wand  der kaputt werden soll
// Fuse box code

// Desc: fuse box handles SHOOT (gunfire) and SCAN (explode) events
function kasten_kaput()
{
	// take a extra point for explosions
	// take no damage from other scans
	IF (EVENT_TYPE == EVENT_SCAN)
	{
		IF (indicator == _EXPLODE) {MY.SKILL1 += 1;} // extra point...
		ELSE {END;}
	}

	MY.SKILL1 += 1;	// take another point of damage
	IF (MY.SKILL1 < 2) {END;}	// do nothing until damage >= 3

	// Damage >= 3
	MY.EVENT = NULL;	// no longer react
	MY.ENABLE_SHOOT = OFF;
	MY.ENABLE_SCAN = OFF;
	WAITT 16;

	// glow and spark with sound
	MY.LIGHTRANGE = 120;
	MY.LIGHTRED = 160;
	MY.LIGHTGREEN = 150;
	MY.LIGHTBLUE = 255;
	PLAY_ENTSOUND	ME,kurz_wav,100;
	pix_size = 50;
	pix_farbe = kasten_pix;
	particle_pos.X = MY.X;
	particle_pos.Y = MY.Y;
	particle_pos.Z = MY.Z  + 20;
	EMIT 250,particle_pos,particle_ekran;
	WAITT 4;

	// second sparks
	EMIT 250,particle_pos,particle_ekran;
	MY.LIGHTRANGE = 0;
	WAITT 24;

	// third spark
	PLAY_ENTSOUND	ME,kurz_wav,100;
	pix_farbe = kasten_pix;
	MY.LIGHTRANGE = 120;
	MY.LIGHTRED = 160;
	MY.LIGHTGREEN = 150;
	MY.LIGHTBLUE = 255;
 	EMIT 250,particle_pos,particle_ekran;
  	WAITT 4;

	// forth spark
	EMIT 250,particle_pos,particle_ekran;
	WAITT 12;

	// change to burnt out fuse box
	MORPH 	<kap_b1b.wmb>,ME;
	WAIT 1;

	// explode...
	MY.LIGHTRANGE = 0;
	CREATE <expl1+16.pcx>,MY.POS,explo_flame;
	PLAY_SOUND explo1_wav,50;

	// use SKILL2 to set fuse-blown value
	IF (MY.SKILL2 == 1) {kasten_1_sk = 1;}
	IF (MY.SKILL2 == 2) {kasten_2_sk = 1;}
	IF (MY.SKILL2 == 3) {kasten_3_sk = 1;}
	IF (MY.SKILL2 == 4) {kasten_4_sk = 1;}
	IF (MY.SKILL2 == 5) {kasten_5_sk = 1;}
}


// Desc: init fuse box
ACTION init_kasten
{
	MY.EVENT = kasten_kaput; // fuse box event
	MY.ENABLE_SHOOT = ON;
	MY.ENABLE_SCAN = ON;
	MY.PUSH = 10;
}

///////////////////////////////////////
//Kanal - Eingang
// Air-vent code

// Desc: air-vent event (exploding when shot or explode scanned)
function kanal_kaput()
{
	// only use scan events if they are explosions
	IF (EVENT_TYPE == EVENT_SCAN){IF (indicator != _EXPLODE) {END;}}

	MY.EVENT = NULL;
	PLAY_SOUND   metal_wav,45;     // air vent break sound
	MORPH 	<canalk.wmb>,ME;      // broken air vent model

	// allow the player to pass
	MY.PASSABLE = ON;

	// animate air-vent chunks
	particle_pos.X = MY.X;
	particle_pos.Y = MY.Y;
	particle_pos.Z = MY.Z  + 40;
 	EMIT 20,particle_pos,particle_bruch;
}

// Desc: init air-vent
ACTION init_kanal
{
	MY.EVENT = kanal_kaput;
	MY.ENABLE_SHOOT = ON;
	MY.ENABLE_SCAN = ON;
   MY.PUSH = 10;
}

////////////////////////////////////////
// EKRAN - ACTION - Macht getrofene Bildschirme kaputt.
// Display monitor code

// Desc: display monitor event (exploding when shot or explode scanned)
function ekran_kaput()
{
	IF (EVENT_TYPE == EVENT_SCAN){IF (indicator != _EXPLODE) {END;}}

	MY.EVENT = NULL;
 	PLAY_ENTSOUND	ME,glass_wav,200;	// break sound
	MORPH 	<ekran0.wmb>,ME;

	// paricle explosion
	particle_pos.X = MY.X;
	particle_pos.Y = MY.Y;
	particle_pos.Z = MY.Z  + 40;
	pix_farbe = ekran_pix;
	pix_size = 60;
 	EMIT 120,particle_pos,particle_ekran;
	PLAY_ENTSOUND	ME,ekran_wav,200;
}

// Desc: init the display monitor
ACTION init_ekran
{
	MY.EVENT = ekran_kaput;
	MY.ENABLE_SHOOT = ON;
	MY.ENABLE_SCAN = ON;
   MY.PUSH = 10;
}

////////////////////////////////////////
/// Kapute Lampe
// flickering lamp action

var lampe_sk;

// Desc: create flickering lamp (on and off for random periods)
ACTION start_lampe
{
	WHILE (1)
	{
		// light on
		MY.LIGHTRED = 150;
		MY.LIGHTBLUE = 150;
		MY.LIGHTGREEN = 150;
		MY.AMBIENT = 100;
		MY.LIGHTRANGE = 150;
		lampe_sk = RANDOM(8);
		WAITT lampe_sk;

		// light off
		MY.AMBIENT = 0;
		MY.LIGHTRANGE = 0;
		lampe_sk = RANDOM(16);
		WAITT lampe_sk;

		WAIT 1;
	}
}

////////////////////////////////////////////////////////////////////////
// Wand explosion

// Desc: exploding wall event (on scan)
function wall_kaput()
{
	// only activates if the exploding barrel has exploded
	IF (fass_sk != 1) {END;}

	MY.EVENT = NULL;	// done reacting

	// explode into a hole in the wall
	PLAY_SOUND   metal_wav, 80;
	MORPH 	<Wall1b.wmb>,ME;
}

// Desc: init exploding wall Action
//			explodes into a hole when the 'exploding barrel' has been activated
ACTION init_wall
{
	MY.EVENT = wall_kaput;
	MY.ENABLE_SCAN = ON;
	MY.AMBIENT = 40;
   MY.PUSH = 10;
}


////////////////////////////////////////////////////////////////////////
//// FASS: The exploding barrels
// Note: if FLAG1 is set, just explode
//			if FLAG1 is not set, explode add make a hole in the wall (init_wall)


// Desc: exploding barrel function
function fass_explo()
{
	// don't explode on a scan event unless 'indicator == _EXPLODE'
	IF (EVENT_TYPE == EVENT_SCAN) {IF (indicator != _EXPLODE){END;}}

	// check for damage to the player...
	SHOOT MY.POS,player.POS;
	IF ((RESULT > 0) && (YOU == player))
	{
		// if the player is within 160 units...
		IF (RESULT < 160)
		{
			// take (160pts of damage - range)/5
			my_leben -=((160 - RESULT)/5);
		}
	}

	loescher_explo();		// explosion effect

	// if flag1 is set, stop here
	IF (MY.FLAG1 == ON) {END;}

	// this barrel blows a hole in the exploding wall (init_wall)
	WAITT 6;
	temp.PAN = 360;
	temp.TILT = 180;
	temp.Z = 64;
	fass_sk = 1;	// must always be set before scanning
	SCAN	MY.POS,MY_ANGLE,temp;
}

// Desc: init exploding barrel
ACTION init_fass
{
	MY.EVENT = fass_explo;
	MY.ENABLE_SHOOT = ON;
	MY.ENABLE_SCAN = ON;
	MY.PUSH = 10;
}


////////////////////////////////////////////////////////////////////////
// FEUERLOESCHER - ACTION - Explode


// Desc: event that calls explosion effect and does damage to the player
//		  on '_EXPLODE' scan or all other linked events.
function loescher_explo()
{
	IF (EVENT_TYPE == EVENT_SCAN){IF (indicator != _EXPLODE) {END;}}
	MY.EVENT = NULL;

	// morph into the explosion animated pic
	MORPH <expl1+16.pcx>,ME;

	loescher_explo1();  // call explosion effect

	// check for damage to the player...
	SHOOT MY.POS,player.POS;
	IF ((RESULT > 0) && (YOU == player))
	{
		// if the player is within 96 units...
		IF (RESULT < 96) {my_leben -=15;}	// take 15 points of damage
	}
	WAITT 8;


	CREATE <expl1+16.pcx>,MY.POS,explo_flame;
}

// Desc: explosion sound and light effects
function loescher_explo1()
{
	MY.FACING = ON;	// face the camera
	MY.NEAR   = ON;
	MY.FLARE  = ON;
	MY.FRAME  = 1;
	WAIT	1;

	PLAY_ENTSOUND ME,explo1_wav,500;
	MY.SCALE_X = 1.8;
	MY.SCALE_Y = 1.8;
	MY.AMBIENT = 100;
	MY.LIGHTRANGE += 60;
	WHILE (MY.FRAME < 16)
	{
		WAIT 1;

		MY.Z += 1.6 * TIME;
		MY.LIGHTRANGE += 15;
		MY.LIGHTRED += 20 * TIME;	// fade to yellow - mit orange
		MY.LIGHTGREEN += 10 * TIME; // fade to yellow - mit orange
		MY.FRAME += 1.2*TIME;
	}
	REMOVE ME;
}


// Zusazliche Explosionswolke
// Desc: explosion flame cloud animation effect
//			with light and frame animation (no sound)
function explo_flame()
{
	MY.FRAME  = 1;
	MY.FACING = ON;	// face the camera
	MY.NEAR   = ON;
	MY.FLARE  = ON;
	MY.FRAME  = 1;
	WAIT	1;

	MY.RADIANCE = 100;
	MY.SCALE_X = 1.8;
	MY.SCALE_Y = 1.8;
	MY.AMBIENT = 100;
	MY.LIGHTRANGE += 60;
	WHILE (MY.FRAME < 16)
	{
		WAIT 1;

		MY.Z += 1.8 * TIME;
		MY.LIGHTRANGE += 10;
		MY.LIGHTRED += 20 * TIME;	// fade to yellow - mit orange
		MY.LIGHTGREEN += 10 * TIME; // fade to yellow - mit orange
		MY.FRAME += 0.8*TIME;
	}
	WAIT 1;

	REMOVE ME;
}


////////////////////////////////////////////////////////////////////////
// FEUERLOESCHER - ACTION - Explode
// Desc: init the fire extinguisher (which explodes when shot)
ACTION init_loescher
{
	MY.EVENT = loescher_explo;
	MY.ENABLE_SHOOT = ON;
	MY.ENABLE_SCAN = ON;
   MY.PUSH = 10;
}


////////////////////////////////////////////////////////////////////////
// Sateliteneinstellung -  soll 57 Grad sein

// Desc: turn off rotor_sat value (set to 0)
ACTION wenn_q {rotor_sat = 0;}

// Desc: the planet rotation event
function planet_rotate()
{
	// only react to player input
	IF (indicator != _HANDLE) {END;}

	MY.ENABLE_SCAN = OFF;
	player._MOVEMODE = _MODE_STILL;  // freeze the player

	// play sound effects
	PLAY_SOUND   pstryk1_wav, 60;
	PLAY_LOOP   szum1_wav, 60;
	wavehandle1 = RESULT;

	// start up machine...
	rotor_sat = 1;				// machine on
	MY.RADIANCE = 100;      // lighting effect
	MY.LIGHTRANGE = 200;
	MY.AMBIENT = 100;
	MY.LIGHTRED = 60;
	MY.LIGHTBLUE = 100;
	scala_pan.VISIBLE = ON; // show user interface panel
	ON_Q = wenn_q;          // used to turn off machine

	WHILE (rotor_sat == 1)  // while machine is on...
	{
		MY.PAN += 3*TIME;
		WAIT	1;
	}

	// shut down machine...
	STOP_SOUND  wavehandle1;
	PLAY_SOUND   sataus_wav, 60;
	ON_Q = null;
	MY.RADIANCE = 0;
	MY.AMBIENT = 0;
	MY.LIGHTRANGE = 0;
	scala_pan.VISIBLE = OFF;	// turn off user interface panel
	MY.ENABLE_SCAN = ON;
	player._MOVEMODE = _MODE_WALKING;
}

// Desc: satellite dish event
function satelit_rotate()
{
	// react to user input only
	IF (indicator != _HANDLE) {END;}

	// only use when satellite display is on
	IF	(rotor_sat == 0) {END;}

	// rotate the satellite display while it is active...
	WHILE (rotor_sat == 1)
	{
		IF (KEY_N == ON)
		{
			PLAY_SOUND   sat_wav, 30;
			MY.PAN += 1;
			angle_sat += 1;
  			IF (angle_sat > 360) {angle_sat = 1;}
		}
		IF (KEY_B == ON)
		{
			PLAY_SOUND   sat_wav, 30;
			MY.PAN -= 1;
			angle_sat -=1;
			IF (angle_sat < 1) {angle_sat = 360;}
		}
		WAIT 4;
	}
	STOP_SOUND  wavehandle2;
}

// Desc: init satellite display
ACTION init_planet
{
	MY.EVENT = planet_rotate;
	MY.ENABLE_SCAN = ON;
	MY.PUSH = 4;
}

// Desc: init satellite display
ACTION init_satelit
{
	MY.EVENT = satelit_rotate;
	MY.ENABLE_SCAN = ON;
	MY.PUSH = 5;
}


// particle_pos.X = MY.X;
// particle_pos.Y = MY.Y;
// particle_pos.Z = MY.Z;
//  EMIT 50,particle_pos,particle_trace;
///GRUN
ACTION init_grun
{
	grun = MY;
}
/////////////////////////////////////////////////
///////// INITIATION f¸r ein - BILD (SPRITR - PCX)

// Desc: circuit board switch event
function platine_sch()
{
	// only accept user input after the lift krank1 value is set
	// (steel plate must be burnt away)
	IF ((indicator != _HANDLE) || (lift_krank1_sk == 0)) {END;}

	MY.EVENT = NULL;	// no more events

	MY.FRAME = 2;		// switch to frame 2

	PLAY_SOUND pstryk1_wav,50;
	WAIT 36;

	PLAY_SOUND   krlift_wav, 30;
	lift_krank2_sk = 1;   // set krank2 value (activate elevator)
}

// Desc: distroy poster (swap with half distroyed copy)
function bild_kaput()
{
	IF (EVENT_TYPE == EVENT_SCAN){IF (indicator != _EXPLODE) {END;}}

	MY.EVENT = NULL;	// no more events
	MORPH 	<-laska1b.pcx>,ME;
	WAIT 1;

	SET MY.PASSABLE,ON;  // can pass (user/gunfire/etc)
}

// Desc: self-destruct countdown event
function destruction()
{
	// user must be close to active (within 120 units)
	IF ((indicator != _HANDLE) || (RESULT > 120)) {END;}

	// destruction mode must be set to 2 to activate
	IF (alles_ok_sk != 2) {END;}

	// destruct armed sound
	PLAY_SOUND selbst_wav,70;
	WAITT 120;

	countdown_sk = 90;	// set countdown timer

	// create robot #5
	robikus = robik_5;
	robikus_rob();
	counter_panel.VISIBLE = ON;   // display countdown panel

	alles_ok_sk = 3;   // set destruction mode to 3
	// do the countdown...
	WHILE (1)
	{
		// buzz every 10 seconds
		IF (MY.SKILL2 == 0) {PLAY_SOUND buzzer_wav,40;}
		MY.SKILL2 += 1;
		IF (MY.SKILL2 > 10) {MY.SKILL2 = 0;}

		countdown_sk -= 1;
		IF (countdown_sk == 5) {all_explode();} 	// start the explosion process
		IF (countdown_sk < -5) {BREAK;}     	   // done counting down
 		WAITT 16;                                 // wait 1 second (16t)
	}
}


/*
// Desc: test the self-destruct countdown
function test_destruction()
{
	// destruct armed sound
	PLAY_SOUND selbst_wav,70;
	WAITT 120;

	countdown_sk = 10;

	counter_panel.VISIBLE = ON;   // display countdown panel

	alles_ok_sk = 3;   // set destruction mode to 3
	// do the countdown...
	WHILE (1)
	{
		//--IF (MY.SKILL2 == 0) {PLAY_SOUND buzzer_wav,40;}
		//--MY.SKILL2 += 1;
		countdown_sk -= 1;
		//--IF (MY.SKILL2 > 10) {MY.SKILL2 = 0;}
		IF (countdown_sk == 5) {all_explode();} 	// start the explosion process
		IF (countdown_sk < -5) {BREAK;}     	   // done counting down
 		WAITT 16;                                 // wait 1 second (16t)
	}
}
*/
//ON_T	test_destruction;


// Desc: okno moves down when activated
function okno_runter()
{
	// user must be close to active (within 120 units)
	IF ((indicator != _HANDLE) || (RESULT > 120)) {END;}

  	// destruction mode must be set to 1 to activate
	IF (alles_ok_sk != 1) {END;}

	MY.EVENT = NULL;	// no further action

	PLAY_SOUND tor4_wav,70;

	WHILE (MY.SKILL8 <76)
	{
		MY.Z -=1;
		MY.SKILL8 +=1;
		WAITT 1;
	}
	alles_ok_sk = 2;	// set destruct mode to 2
}

// Desc: init a okno action
ACTION init_okno
{
	MY.EVENT = okno_runter;
	MY.ENABLE_SCAN = ON;
   MY.PUSH = 10;
}


var stahl_fx = 0;
var stahl_xxx = 0;

// Desc: steel plate (covering elevator panel) event
//			must be burnt away with blow torch
//
// Mod:	10/3/00 DCP
//			Reduced 'burn' time and made it TIME dependent
function stall_kaput()
{
	// only react the blow-torch (weapon#3) scans
	IF ((indicator == _HANDLE) && (weapon_number != 3)&&(stahl_fx == 1))
	{END;}

	stahl_fx = 1;	// burning away...

	// while we are burning away at the plate...
	WHILE ((spaw_on == 1) && (RESULT != 0))
	{
 		//MY.SKILL15 = TIME;		// increase the wait time by current TIME

		// increase glow (up to 100%)
		IF (MY.AMBIENT < 100){MY.AMBIENT +=0.2;IF (MY.AMBIENT > 100){MY.AMBIENT = 100;}}
		IF (MY.LIGHTRANGE < 128) {MY.LIGHTRANGE += 0.2;IF (MY.LIGHTRANGE > 128) {MY.LIGHTRANGE = 128;}}
		IF (MY.LIGHTRED < 255)  {MY.LIGHTRED += 0.2;IF (MY.LIGHTRED > 255)  {MY.LIGHTRED = 255;}}

		// increase amount of burn
		MY.SKILL2 += max(1.0,TIME);

		// check burn ammount
	   IF (MY.SKILL2 > 600) {MY.FRAME = 6; GOTO end_stal;}	// burn thru..

	   IF (MY.SKILL2 > 300)  {MY.FRAME = 4;}
		ELSE { IF (MY.SKILL2 > 20)   {MY.FRAME = 2;}  }
	   WAITT(1);//(MY.SKILL15 + 1);    // wait for at least 1 unit
	}
	stahl_fx = 0;	// no longer burning
	BRANCH rote_platte;  // go to cool down

	// player has burnt thru steel plate
end_stal:
	MY.EVENT = NULL;

	// fade glow
	WHILE (MY.LIGHTRANGE > 1)
	{
		IF (MY.AMBIENT > 0)    {MY.AMBIENT -=0.1;}
		IF (MY.LIGHTRANGE > 0) {MY.LIGHTRANGE -= 0.1;}
		WAITT 1;
	}

	MY.FRAME = 7;
	MY.PASSABLE = ON;
	lift_krank1_sk = 1;		// can activate elevator
	EXCLUSIVE_GLOBAL;
}

// Desc: cool down steel plate
//			steel plate is not distroyed but it is damaged
function rote_platte()
{
	// fade (unless the player starts to burn again)
	WHILE	((MY.LIGHTRANGE > 0)&& (stahl_fx != 1))
	{
		stahl_xxx = 1;
		IF (MY.AMBIENT > 0)    {MY.AMBIENT -=0.1;}
		IF (MY.LIGHTRANGE > 0) {MY.LIGHTRANGE -= 0.1;}
		IF (MY.LIGHTRED > 0)  {MY.LIGHTRED -= 0.1;}
		stahl_xxx +=1;
		WAITT 1;
	}

	// switch to 'cool' frame
	IF (MY.FRAME == 2) {MY.FRAME = 3;}
	IF (MY.FRAME == 4) {MY.FRAME = 5;}
	stahl_xxx=0;
}


// Desc: init random item action
//  FLAG1 - Action for Poster        (poster action)
//  FLAG2 - Action f¸r Folie         (foil action)
//  FLAG3 - Action f¸r Blutflecken   (blood mark action)
//  FLAG4 - Action f¸r Gruen- (Lebenspfeil)  (life arrow)
//  FLAG5 - Action f¸r Glass 45 Grad
//  FLAG6 - Action f¸r Gitterboden
//  FLAG7 - Action f¸r Stahlplatte 	 (steel plate)
//  FLAG8 - Action f¸r Bilder mit SCALE_Y=0.5
//
//  SKILL4 - 1 - Schalter -Plattine    (switch circuit board)
//  SKILL4 - 2 - Action f¸r Bilder mit SCALE_Y=0.75
ACTION init_bild
{
	//circuit board switch (under steel plate)
	IF (MY.SKILL4 == 1)
	{
		MY.EVENT = platine_sch;
		MY.ENABLE_SCAN = ON;
		MY.FRAME = 1;
    	MY.PUSH = 10;
	}

	// self-destruct countdown button
	IF (MY.SKILL4 == 2)
	{
		MY.EVENT = destruction;
		MY.ENABLE_SCAN = ON;
		MY.SCALE_Y = 0.85;
    	MY.PUSH = 10;
	}

	// arm self-destruct countdown button
	IF (MY.SKILL4 == 3)
	{
		MY.EVENT = okno_runter;
		MY.ENABLE_SCAN = ON;
   	MY.PUSH = 10;
	}


	// Desc: poster (distroy when hit)
	IF (MY.FLAG1 == ON)
	{
		MY.EVENT = bild_kaput;
	 	MY.ENABLE_SHOOT = ON;
		MY.ENABLE_SCAN = ON;
    	MY.PUSH = 10;
	}

	// foil action
	IF (MY.FLAG2 == ON)
	{
		MY.TRANSPARENT = ON;
		MY.SCALE_X = 2;
	}

	// blood marks
	IF (MY.FLAG3 == ON)
	{
		MY.TRANSPARENT = ON;
		MY.PASSABLE = ON;
		MY.TILT = 90;
	}

	//
	IF (MY.FLAG4 == ON)
	{
		MY.TRANSPARENT = ON;
		MY.PASSABLE = ON;
		MY.SCALE_X = 0.5;
		MY.FLARE = ON;
		MY.AMBIENT = 100;
	}

	//
	IF (MY.FLAG5 == ON)
	{
		MY.TRANSPARENT = ON;
		MY.AMBIENT = 100;
		MY.TILT = 45;
		MY.SCALE_X = 6.5;
		MY.SCALE_Y = 1.6;
		MY.PASSABLE = ON;
	}

	IF (MY.FLAG6 == ON)
	{
		MY.TILT = 90;
		MY.SCALE_X = 6;
		MY.SCALE_Y = 1;
		MY.PASSABLE = ON;
	}

	// steel plate
	IF (MY.FLAG7 == ON)
	{
		MY.EVENT = stall_kaput;
	 	MY.ENABLE_SCAN = ON;
		MY.FRAME = 1;
    	MY.PUSH = 10;
	}

	IF (MY.FLAG8 == ON)
	{
		MY.SCALE_Y = 0.5;
	}

//	SET MY.PASSABLE,ON;
	MY.ORIENTED = ON;
//	SET MY.AMBIENT,50;
//	MY.SCALE_X = (YOUR.MAX_X - YOUR.MIN_X)/(MY.MAX_X - MY.MIN_X);
//	MY.SCALE_Y = MY.SCALE_X * 0.7;
//	MY.SCALE_Z = 1.0;
//	MY.TILT = 90;	// set it flat onto the floor
//	MY.PAN = 90;
}


// Shakes the player used in 'all_explode'
function m2_player_shake()
{
	IF (RANDOM(1) > 0.5)
	{
		PLAYER.ROLL += 8;
		PLAYER.TILT += 8;
		WAITT 2;
		PLAYER.TILT -= 5;
		WAITT 2;
		PLAYER.ROLL -= 8;
		PLAYER.TILT -= 3;
	}
	ELSE
	{
		PLAYER.ROLL -= 8;
		PLAYER.TILT += 8;
		WAITT 2;
		PLAYER.TILT -= 5;
		WAITT 2;
		PLAYER.ROLL += 8;
		PLAYER.TILT -= 3;
	}
}

// Desc: the entire level explodes!
//
// Mod Date: 8/7/00 DCP
//			Replace player_shake calls with m2_player_shake
function all_explode()
{
	PLAY_SOUND explo3_wav,70;
 	CALL m2_player_shake;
	WAITT 16;
	PLAY_SOUND explo3_wav,40;
	WAITT 8;
	PLAY_SOUND explo3_wav,60;
	CALL m2_player_shake;
	WAITT 12;
	PLAY_SOUND explo3_wav,30;
	WAITT 6;
	PLAY_SOUND explo3_wav,70;
	CALL m2_player_shake;
	WAITT 16;
	PLAY_SOUND explo3_wav,40;
	WAITT 8;
	PLAY_SOUND explo3_wav,60;
	CALL m2_player_shake;
	WAITT 12;
	PLAY_SOUND explo3_wav,30;
	WAITT 6;
	PLAY_SOUND explo3_wav,70;
	CALL m2_player_shake;
	IF (alles_ok_sk == 4) {END;}
	my_leben = -1;          // player dies
}

////////////////////////////////////////////////////////////////////////
// Puzzle functions (switchs and nobs)

// Desc: generator switch event
ACTION gen_schalter
{
	IF (indicator != _HANDLE) {END;}	// user scans only

	// freeze switch when generator skill is set
	IF ( gener_sk == 1) { MY.EVENT = NULL; END;}

	// must be close (within 70 units)
	IF (RESULT > 70) {END;}

	PLAY_SOUND pstryk4_wav,50;	// switch sound

	IF (MY.FLAG8 == ON)
	{
		// turn switch off
		MY.FLAG8 = 0;
		IF (MY.SKILL1 == 1) {SET gener1_sk,0; MY.FRAME = 1;}
		IF (MY.SKILL1 == 2) {SET gener2_sk,0; MY.FRAME = 1;}
		IF (MY.SKILL1 == 3) {SET gener3_sk,0; MY.FRAME = 1;}
		IF (MY.SKILL1 == 4) {SET gener4_sk,0; MY.FRAME = 1;}
	}
	ELSE
	{
		// turn switch on
		MY.FLAG8 = 1;
		IF (MY.SKILL1 == 1) {SET gener1_sk,1; MY.FRAME =2;}
		IF (MY.SKILL1 == 2) {SET gener2_sk,1; MY.FRAME =2;}
		IF (MY.SKILL1 == 3) {SET gener3_sk,1; MY.FRAME =2;}
		IF (MY.SKILL1 == 4) {SET gener4_sk,1; MY.FRAME =2;}
	}

	// see if the user has broken the code
	IF ( gener1_sk != 1) {END;}
	IF ( gener2_sk != 0) {END;}
	IF ( gener3_sk != 1) {END;}
	IF ( gener4_sk != 1) {END;}
	gener_sk = 1;           // flag puzzle as solved

	PLAY_SOUND stuk1_wav,70; // play solve sound

	// activate robot #1
	robikus = robik_1;
	robikus_rob();
}

// Desc: laser wall switch
ACTION laser_schalt
{
	// user activated within 36 units
	IF (indicator != _HANDLE) {END;}
	IF (RESULT > 36) {END;}

	// only activate once
	IF (MY.FLAG8 == ON) {END;}

	// flag activated
	MY.FLAG8 = 1;


	IF (laser_sk == 1)
	{
		// flip switch down and up..
		MY.FRAME =2;
		PLAY_SOUND pstryk0_wav,50;
		WAITT 8;
		MY.FRAME = 1;
		MY.FLAG8 = 0;	  // did not activate
	}
	ELSE
	{
		// flip switch and activate gate with a scan (laserWand)
		laser_sk = 2;
	 	MY.EVENT = NULL;
		MY.FRAME =3;
		PLAY_SOUND pstryk1_wav,50;
		scan_sector.PAN = 300;
		scan_sector.TILT = 120;
		scan_sector.Z = 160;
		SCAN MY.POS,MY.ANGLE,scan_sector;
	}
}

// Desc: door lock switches
//			activate once on user scan
function tuer_lock()
{
	// user scan within 36units
	IF (indicator == _EXPLODE) {END;}
	IF (RESULT > 36) {END;}

	IF (MY.SKILL2 == 1) {SET torschalt_1_sk,1;}	// gate 1
	IF (MY.SKILL2 == 2) {SET torschalt_2_sk,1;}  // hospital ward gate
	IF (MY.SKILL2 == 3) {SET torschalt_3_sk,1;}  // satellite room
	IF (MY.SKILL2 == 4) {SET torschalt_4_sk,1;}  // control room
	IF (MY.SKILL2 == 5) {SET torschalt_5_sk,1;}  // bed room

	// switch to frame #3
	MY.FRAME =3;
	PLAY_SOUND pstryk1_wav,50;
	MY.EVENT = NULL;
}

// Desc: activate the moving platform (crane)
function start_plattform()
{
	IF (indicator != _HANDLE) {END;}

	IF ((MY.FLAG8 == ON)||(platt_lager_sk > 0)) {END;}

	MY.FLAG8 = ON;

	IF (MY.FRAME == 2) {MY.FRAME = 1;}
	ELSE {IF (MY.FRAME == 1) {MY.FRAME = 2;} }

//sprung:
	PLAY_SOUND pstryk4_wav,50;
	MY.FLAG8 = OFF;
	MY = kron;
	move_kran();	// move the crane
}


// Desc: bridge function
function sch_bruecke()
{
	// not a player scan
	IF (indicator != _HANDLE) {IF (RESULT > 50) {END;}}

	IF (MY.SKILL1 == 2)
	{
		// Schalter unter dem Boden
		// switch underground
		MY.FRAME = 3;
		PLAY_SOUND pstryk1_wav,50;
		bruecke_sk = 1;
		MY.EVENT = NULL;
		END;
	}

	IF ( bruecke_sk == 0) {PLAY_SOUND schwehr_wav,50; END;}
	MY.EVENT = NULL;
	MY.FRAME = 3;
	PLAY_SOUND pstryk4_wav,50;

	// activate rotor bridge
	MY = bruecke_en;
	rotor_bruecke();
//			robikus = robik_4;
//			robikus_rob();
 }


// Desc: 5 red/green switches to turn on hardware key programmer
function 5x_schalter()
{
	// player scans only, within 40 units, and the puzzle hasn't already been solved
	IF (indicator != _HANDLE) {END;}
	IF ((5x_schalt_sk == 1)||(RESULT > 40)) {END;}

	PLAY_SOUND pstryk3_wav,50;		// switch sound


	IF (MY.FLAG8 == ON)
	{
		// switch off (red)
		MY.FLAG8 = 0;
		IF (MY.SKILL1 == 1) {SET 5x_1_sk,0;	MORPH <knopf.wmb>,ME; WAIT 1;}
		IF (MY.SKILL1 == 2) {SET 5x_2_sk,0; MORPH <knopf.wmb>,ME; WAIT 1;}
		IF (MY.SKILL1 == 3) {SET 5x_3_sk,0; MORPH <knopf.wmb>,ME; WAIT 1;}
		IF (MY.SKILL1 == 4) {SET 5x_4_sk,0; MORPH <knopf.wmb>,ME; WAIT 1;}
		IF (MY.SKILL1 == 5) {SET 5x_5_sk,0; MORPH <knopf.wmb>,ME; WAIT 1;}}
	ELSE
	{
		// switch on (green)
		MY.FLAG8 = 1;
		IF (MY.SKILL1 == 1) {SET 5x_1_sk,1;	MORPH <knopf1.wmb>,ME; WAIT 1;}
		IF (MY.SKILL1 == 2) {SET 5x_2_sk,1;	MORPH <knopf1.wmb>,ME; WAIT 1;}
		IF (MY.SKILL1 == 3) {SET 5x_3_sk,1;	MORPH <knopf1.wmb>,ME; WAIT 1;}
		IF (MY.SKILL1 == 4) {SET 5x_4_sk,1;	MORPH <knopf1.wmb>,ME; WAIT 1;}
		IF (MY.SKILL1 == 5) {SET 5x_5_sk,1;	MORPH <knopf1.wmb>,ME; WAIT 1;}
	}

	// check to see if the puzzle has been solved
	IF ( 5x_1_sk != 1) {END;}
	IF ( 5x_2_sk != 0) {END;}
	IF ( 5x_3_sk != 0) {END;}
	IF ( 5x_4_sk != 1) {END;}
	IF ( 5x_5_sk != 1) {END;}
	5x_schalt_sk = 1;        	// mark puzzle as solved
	PLAY_SOUND stuk1_wav,70;  	// play solved puzzle sound

	// activate robot #2
	robikus = robik_2;
	robikus_rob();
}


// SKILL 4 Werete:
//                1 - winda_fl
//                2 - winda_b2
//                3 - winda_ko
//                4 - winda_kr
//                5 - winda_r1
//                6 - winda_r2
//                7 - winda_r3

// Desc: lift switches
//			Skill4 determins where the lift goes
function sch_lift()
{
	// player scans only
	IF (indicator != _HANDLE)  {END;}

	PLAY_SOUND pstryk4_wav,50;
	WAITT 12;

	IF (MY.SKILL4 == 1) { MY = winda_fl; lift_act(); }
	IF (MY.SKILL4 == 2) { MY = winda_b2; lift_act(); }
	IF (MY.SKILL4 == 3) { MY = winda_ko; lift_act(); }
	IF (MY.SKILL4 == 4) { MY = winda_kr; lift_act(); }
	IF (MY.SKILL4 == 5) { MY = winda_r1; lift_act(); }
	IF (MY.SKILL4 == 6) { MY = winda_r2; lift_act(); }
	IF (MY.SKILL4 == 7) { MY = winda_r3; lift_act(); }
}

// Desc: init elevator
ACTION init_schlift
{
	MY.EVENT = sch_lift;
	MY.ENABLE_SCAN = ON;
   MY.PUSH = 10;
}



/// FLAG1 - Schalter - Generator SKILL1 - 1/2/3/4 Werte fuer jeden Schalter
//							  Generator switch values (1-4)
/// FLAG2 - Schalter - Laser
/// FLAG3 - Schalter - Tuerblockade
//  FLAG4 - Schalter - Platform
//  FLAG5 - Schalter - Bruecke SKILL1 -1= Hauptschalter 2=Sicherungsschalter
//  FLAG6 - SCHALTER ENDRaum 5x SKILL1 - 1/2/3/4/5 Werte fuer jeden Schalter
/// FLAG8 - an/aus
ACTION init_schalter
{
	MY.FRAME = 1;
	IF (MY.FLAG1 == ON) {MY.EVENT = gen_schalter;}	// generator switches
	IF (MY.FLAG2 == ON) {MY.EVENT = laser_schalt;} 	// laserwall switch
	IF (MY.FLAG3 == ON) {MY.EVENT = tuer_lock;}		// door lock switches
	IF (MY.FLAG4 == ON) {MY.EVENT = start_plattform;} // moving plateform (crane)
	IF (MY.FLAG5 == ON) {MY.EVENT = sch_bruecke;}	// Bridge
	IF (MY.FLAG6 == ON) {MY.EVENT = 5x_schalter;}	// 5 switch reprogrammer puzzle
	IF (MY.FLAG7 == ON) {MY.EVENT = sch_lift;}		// fÅr Tueren (elevator in Lager B2)
	MY.ENABLE_SCAN = ON;
   MY.PUSH = 10;
}




////////////////////////////////////////////////////////////////////////
// Laser Wall functions

// Desc: laser wall event
ACTION laser_wand
{
	// switch scanned the laser wall (turn it off)
	IF (EVENT_TYPE == EVENT_SCAN)
	{
		IF (laser_sk != 2) {END;}
		ELSE
		{
			PLAY_SOUND   sataus_wav, 60;
			REMOVE ME;
			END;
		}
	}

	// player touched the laser wall...
	MY.EVENT = NULL;
	MY.PASSABLE = 1;
	WAIT 1;
	PLAY_SOUND   a_wav, 60;
	my_leben = 0;	// kill player
}

// Desc: init laser wall
ACTION init_laserwand
{
	MY.ENABLE_SCAN = ON;
	MY.ENABLE_PUSH = ON;
	MY.PUSH = -10;
	MY.EVENT = laser_wand;
}


////////////////////////////////////////////////////////////////////////
// AUGEN HOEHE IM KANAL - STANDARD 0.8 - im Kanal 0.4 SKILL eye_height_up
// Set the eye height in the air vent

// Desc: reduce eye height to 0.4
function bin_klein()
{
//	SET		MY.PASSABLE,ON;
	eye_height_up = 0.4;
//	WAITT 6;
//	SET		MY.PASSABLE,0;
}

// Desc: init reduce eye height
ACTION init_klien
{
	MY.PUSH = -1;
	MY.ENABLE_PUSH = ON;
//	SET MY.INVISIBLE,ON;
	MY.EVENT = bin_klein;
}

// Desc: return eye height
function bin_gross()
{
	eye_height_up = 0.8;
	MY.PASSABLE = ON;
	WAITT 6;
	MY.PASSABLE = 0;
}

// Desc: init return eye height
ACTION init_gross
{
	MY.PUSH = -1;
	MY.ENABLE_PUSH = ON;
	MY.EVENT = bin_gross;
}


////////////////////////////////////////////////////////////////////////
// Player movable block

// Desc: player movable block event
function schiebe_block()
{
	// player scan within 150 units
	IF (indicator != _HANDLE) {END;}
	IF (RESULT > 150) {END;}

	// Space bar used to pull
	IF (KEY_SPACE == ON)
	{
		// make grunting/pulling noises
		PLAY_SOUND schwehr_wav,50;
		PLAY_LOOP  szur_wav, 60;
		wavehandle1 = RESULT;

		// while the spacebar is held down...
		WHILE((KEY_SPACE == ON) && (player.Y < (MY.Y - 70)))
		{
			// drag the
			MY_SPEED.X = 0;
			MY_SPEED.Z = 0;
			MY_SPEED.Y = -1;
	  		MOVE	ME,nullskill,MY_SPEED;

			// pulled all the way?
			IF (MY.Y < (MY.SKILL3 - MY.SKILL6))
			{
				MY.EVENT = NULL;
				break;
			}
			WAITT 1;
		}

 		STOP_SOUND  wavehandle1;
	}
}

// Desc: init the movable block
//			player can 'pull' the block by scanning it
ACTION init_block
{
	MY.ENABLE_SCAN = ON;
	MY.AMBIENT = -10;
	MY.PUSH = 10;
	MY.SKILL6 = 128;  // Wie weit geschoben ?? soll 128
	MY.SKILL3 = MY.Y;
	MY.EVENT = schiebe_block;
}


////////////////////////////////////////////////////////////////////////
// Desc: empty action
ACTION init_ventil
{
	END;
}

////////////////////////////////////////////////////////////////////////

// Desc: show closeup of pin-board
function zeige_pin()
{
	// player scan (under 80 units)
	IF (indicator != _HANDLE) {END;}
	IF (RESULT > 80) {END;}

	// disable esc, f1, & f10 keys
	ON_ESC = NULL;
	ON_F1 = NULL;
	ON_F10 = NULL;

	// select board to show
	IF (MY.FLAG1 == ON) {pinwand_pan.BMAP = pin1_map;}
	IF (MY.FLAG2 == ON) {pinwand_pan.BMAP = pin2_map;}

	// center board in view
	pinwand_pan.POS_Y = (SCREEN_SIZE.Y/2) - 240;
	pinwand_pan.POS_X = (SCREEN_SIZE.X/2) - 320;

	pinwand_pan.VISIBLE = ON;       // show board
	player._MOVEMODE = _MODE_STILL; // freeze player

	// continue showing board until player presses 'Q'
	WHILE (1)
	{
		IF (KEY_Q == 1) {BREAK;}
		WAIT 1;
	}

	pinwand_pan.VISIBLE = OFF;			// hide board

	// reset esc, f1, & f10 keys
	ON_ESC = menu_main;
	ON_F1 = game_help;
	ON_F10 = exit_yesno;

	player._MOVEMODE = _MODE_WALKING;	// un-freeze player
}

// Desc: init pin-board item
ACTION init_pinwand
{
	MY.EVENT = zeige_pin;	// show pin-board
	MY.ENABLE_SCAN = ON;
	MY.ORIENTED = ON;
   MY.PUSH = 10;
}


////////////////////////////////////////////////////////////////////////
// Misc trigger events (once offs)

//////////////// TRIGGER
///// FLAG1 - lift im Lager B
///// FLAG2 - Musik im Teleporter
///// FLAG3 - Musik im Åberalles
///// FLAG4 - Rocket
///// FLAG5 -

// Desc: misc trigger event
function trigger_lift()
{
	// unblock lager lift
	IF (MY.FLAG1 == ON)
 	{
 		lift_lager_sk = 1;
		REMOVE ME;
		END;
	}

	// play song #2
	IF (MY.FLAG2 == ON)
	{
		PLAY_SONG_ONCE song2,100;
		REMOVE ME;
		END;
	}

	// play soug #3
	IF (MY.FLAG3 == ON)
	{
		PLAY_SONG_ONCE song3,100;
		REMOVE ME;
		END;
	}

	// sound effect (in air vent)
	IF (MY.FLAG4 == ON)
	{
		rakieta.LIGHTRANGE = 0;
		rakieta.INVISIBLE = ON;
		rakieta.PASSABLE = ON;
		PLAY_SOUND   rocket_wav,85;
		REMOVE ME;
		END;
	}

	// sound effect (near exit)
	IF (MY.FLAG5 == ON)
	{
		// only activate (?)
		IF ((MY.SKILL1 == 1)||(alles_ok_sk != 3)) {END;}

		MY.SKILL1=1;
		rakieta.LIGHTRANGE = 50;
		rakieta.LIGHTGREEN = 15;
		rakieta.LIGHTBLUE = 15;
		SET rakieta.INVISIBLE,OFF;
		SET rakieta.PASSABLE,OFF;
		PLAY_SOUND   rocket_wav,85;
		BRANCH nach_hause;			// show ending screen
	}
}

// Desc: init misc trigger
ACTION init_trigger
{
	MY.PUSH = -10;
	MY.ENABLE_PUSH = ON;
	MY.INVISIBLE = ON;
   MY.EVENT = trigger_lift;
}


////////////////////////////////////////////////////////////////////////
////////////////BRUECKE
// bridge functions

// Desc: rotor bride event
function rotor_bruecke()
{
//	IF ((bruecke_sk != 2)||(MY.FLAG8 == ON)) {END;}
//		SET MY.FLAG8,ON;
	PLAY_SOUND machan_wav,50;
	WAITT 10;

	PLAY_LOOP  mach_wav, 40;
	wavehandle1 = RESULT;

	// rotate the bridge down
	WHILE (MY.SKILL5 < 80)
	{
		IF (MY.AMBIENT < 35) {MY.AMBIENT +=0.5;}
		MY.TILT += TIME;
		MY.SKILL5 += TIME;
		WAIT	1;
	}
	STOP_SOUND wavehandle1;
	PLAY_SOUND machaus_wav,50;
}

// Desc: init bridge
ACTION init_bruecke
{
	MY.ENABLE_SCAN = ON;
	bruecke_en = MY;
   MY.PUSH = 10;
}


////////////////////////////////////////////////////////////////////////

/////////RADAR ROTATE + SCHALTER
// Radar rotation functions

// Desc: on Q function (set in radar_schalter)
function wenn_q2()
{
	player._MOVEMODE = _MODE_WALKING;	// let player move
	radar_pan.VISIBLE = OFF;           	// turn off radar panel

	radar_reset_keys();	// reset keys

	PLAY_SOUND   radar_wav, 80;
	WHILE (radar_en.FLAG1 == ON)
	{
		WAIT 1;	// wait for radar to stop turning
	}
	WAITT 24;
	radar_an_ska = 0; // flag radar panel as 'off'

	PLAY_SOUND   radtop_wav, 80;
	radar2_en.Z -= 10;             // reset feet
}

SKILL aktual_pos { VAL 0;}

// Desc: on N (inc +) radar function
function	radar_links()
{
	STOP_SOUND wavehandle2;
	PLAY_LOOP   sat_wav, 40;
	wavehandle2 = RESULT;

	WHILE (KEY_N == 1)
	{
		angle_rad +=1;
		IF (angle_rad >= 360) {angle_rad = 0;}
		WAITT	3;
	}
	STOP_SOUND  wavehandle2;
}

// Desc: on B (dec -) radar function
function	radar_rechts()
{
	STOP_SOUND wavehandle2;
	PLAY_LOOP   sat_wav, 40;
	wavehandle2 = RESULT;
	WHILE (KEY_B == 1)
	{
		angle_rad -=1;
		IF (angle_rad < 0) {angle_rad = 359;}
		WAITT	3;
	}
	STOP_SOUND  wavehandle2;
}

var	radar_temp_value = 0;	// used to find shortest path

// Desc: on Enter (rotate radar to set angle) function
function radar_rotate()
{
	MY = radar_en;                 // set MY to radar entity
	IF(MY.FLAG1 == 1) {END;}       // make sure we aren't already moving
	MY.FLAG1 = ON;
	PLAY_SOUND radan_wav, 60;
	WAITT 32;

	STOP_SOUND wavehandle1;
	PLAY_LOOP rad_wav, 50;
	wavehandle1 = RESULT;

	// find shortest rotation path
	radar_temp_value = angle_rad - MY.PAN;
	if(radar_temp_value < 0)
	{
		if(radar_temp_value < -180)
		{
			// rotate up
			while(MY.PAN != angle_rad)
			{
				MY.PAN += 1;
				if(MY.PAN >= 360)
				{
					MY.PAN = 0;
				}
				waitt(2);
			}
		}
		else
		{
			// rotate down
			while(MY.PAN != angle_rad)
			{
				MY.PAN -= 1;
				if(MY.PAN < 0)
				{
					MY.PAN = 359;
				}
  				waitt(2);
			}
		}
 	}
	else   // (radar_temp_value > 0)
	{
		if(radar_temp_value > 180)
		{
			// rotate down
			while(MY.PAN != angle_rad)
			{
				MY.PAN -= 1;
				if(MY.PAN < 0)
				{
					MY.PAN = 359;
				}
  				waitt(2);
			}
		}
		else
		{
			// rotate up
			while(MY.PAN != angle_rad)
			{
				MY.PAN += 1;
				if(MY.PAN >= 360)
				{
					MY.PAN = 0;
				}
				waitt(2);
			}
		}
	}

	STOP_SOUND wavehandle1;
	PLAY_SOUND radaus_wav, 60;
	MY.FLAG1 = OFF;
	aktual_pos = angle_rad;
}


// Desc: radar switch function (set keys to handle input)
function radar_schalter()
{
	IF ((indicator != _HANDLE)||(radar_an_ska == 1)) {END;}

	radar_an_ska = 1; 		// flag radar panel as 'on'
	angle_rad = aktual_pos; // set panel 'target value' to aktual radar pan

	radar_set_keys();		// set radar keys

	player._MOVEMODE = _MODE_STILL;  // freeze player
	radar_pan.VISIBLE = ON;          // make radar panel visible

	PLAY_SOUND   radar_wav, 80;
	WAITT 12;

	PLAY_SOUND   radtop_wav, 80;
	radar2_en.Z += 10;                 // release 'feet'
}


ACTION init_radar2
{
	MY.PUSH = 9;
	radar2_en = MY;
}

// Desc: init radar dish
ACTION init_radar
{
	MY.PUSH = 10;
	radar_en = MY;
	aktual_pos = MY.PAN;	// set aktual_pos to radar pan value
}

// Desc: init radar control panel
ACTION init_rad_sch
{
	MY.EVENT = radar_schalter;
	MY.ENABLE_SCAN = ON;
   MY.PUSH = 10;
}

function radar_set_keys()
{
	ON_Q = wenn_q2;         // on 'Q' launch
	ON_ENTER = radar_rotate;// rotate radar
	ON_N = radar_links;     // inc value
	ON_B = radar_rechts;    // dec value
}

function radar_reset_keys()
{
	ON_Q = NULL;
	ON_ENTER = NULL;
	ON_B = NULL;
	ON_N = NULL;
}


////////////////////////////////////////////////////////////////////////
// Text terminals (activate on player scan) functions


/////////////////////////////
// TERMINALE
//
// FLAG1 an/aus !        / nicht benutzen !
// FLAG2 einmalige Meldung / nicht benutzen !
//
// SKILL1 WERTE 1 - LABOR B Raum 1        /x 1
//				2 - Steuerraum Klein      /x 1
//				3 - LABOR B Raum 2-Lift	  /x 1
//				4 - Startraum						/x1
//				5 - Raum mit 5 Schalter (ENDraum)	/xxxxxx
//				6 - Raum mit Sateliten				/xxxxxx
//				7 - Raum mit Poster LABOR A RAUM 2	/x1
//				10- STEUERRAUM

// Desc: show second console screen
function zeige_con2()
{
	// player scan within 70 units and not already active (flag1 set)
	IF ((indicator != _HANDLE) || (RESULT > 70)||(MY.FLAG1 == ON)) {END;}


	MY.FLAG1 = ON;	// console active

	MY.SKILL5 = 1;
	player._MOVEMODE = _MODE_STILL;	// freeze player

	// null keys
	ON_ESC = NULL;
	ON_F1  = NULL;
	ON_F10 = NULL;


	EXCLUSIVE_GLOBAL;    // stop other console actions

	PLAY_SOUND 	msg_sound,66;

	// center screen
	terminal_y = (SCREEN_SIZE.Y/2) - 240;
	terminal_x = (SCREEN_SIZE.X/2) - 320;
	ekran4_pan.POS_Y = terminal_y;
	ekran4_pan.POS_X = terminal_x;
	msgt.POS_Y = terminal_y + 50;
	msgt.POS_X = terminal_x + 50;

	msgt.STRING = book_1_str; 	// set the correct text for this console
	ekran0_pan.VISIBLE = ON;
	ekran4_pan.VISIBLE = ON;
	msgt.VISIBLE = ON;

	// display until player hits 'Q'
	WHILE (KEY_Q != ON)
	{
		// on 'N' goto next page, on 'B' goto prev page
		IF (KEY_N == ON) {MY.SKILL7=1; next_msg();}
		IF (KEY_B == ON) {MY.SKILL7=-1; next_msg();}
		WAIT 1;
	}

	// hide console
	msgt.STRING = nullstring;
	msgt.VISIBLE = OFF;
	ekran0_pan.VISIBLE = OFF;
	ekran4_pan.VISIBLE = OFF;

	PLAY_SOUND msg_sound,66;

	// un-freeze player and reset keys
	player._MOVEMODE = _MODE_WALKING;
	MY.FLAG1 = OFF; 		// console no longer active
	ON_ESC = menu_main;
	ON_F1  = game_help;
	ON_F10 = exit_yesno;
}

// Desc: change displayed text for type2 consoles
function next_msg()
{
	IF (MY.FLAG2 == ON) {END;}
	SET MY.FLAG2,ON;
	MY.SKILL5 +=MY.SKILL7;

	// use skill5 to select text page
	IF (MY.SKILL5 > 9) {MY.SKILL5=9;}
	IF (MY.SKILL5 < 0) {MY.SKILL5=2;}
	IF (MY.SKILL5 == 1) {msgt.STRING = book_1_str;}
	IF (MY.SKILL5 == 2) {msgt.STRING = book_2_str;}
	IF (MY.SKILL5 == 3) {msgt.STRING = book_3_str;}
	IF (MY.SKILL5 == 4) {msgt.STRING = book_4_str;}
	IF (MY.SKILL5 == 5) {msgt.STRING = book_5_str;}
	IF (MY.SKILL5 == 6) {msgt.STRING = book_6_str;}
	IF (MY.SKILL5 == 7) {msgt.STRING = book_7_str;}
	IF (MY.SKILL5 == 8) {msgt.STRING = book_8_str;}
	IF (MY.SKILL5 == 9) {msgt.STRING = book_9_str;}
	PLAY_SOUND 	msg_sound,66;
	WAITT 8;
	SET MY.FLAG2,OFF;
}



// Desc: show console (type #1)
function  zeige_con()
{
	// player scan within 70 units
	IF ((indicator != _HANDLE) || (RESULT > 70)) {END;}

	// don't double activate
	IF (MY.FLAG1 == ON) {END;}

	MY.FLAG1 = ON;	// mark console as active

	// display "No more functions available" message and exit
	IF (MY.FLAG2 == ON)
	{
		msge.STRING = con0_str;
		show_message_ekran();
		END;
	}

	// use skill1 to display the correct string and activate any switch
	IF (MY.SKILL1 == 1) {msge.STRING = con1_1_str;  tor_la_sk = 1; MY.FLAG3 = ON;}
	IF (MY.SKILL1 == 2) {msge.STRING = con2_1_str;  tor_sr_sk = 1; MY.FLAG3 = ON;}
	IF (MY.SKILL1 == 3) {msge.STRING = con3_1_str;  lift_block_sk = 1; SET MY.FLAG3,ON;}
	IF (MY.SKILL1 == 4) {msge.STRING = con4_1_str;  MY.FLAG3 = ON;}
	IF (MY.SKILL1 == 5)
	{
		// 5 switch puzzle, hardware key reprogrammer
		IF (5x_schalt_sk == 0)
		{
			// puzzle not solved..
			msge.STRING = con5_1_str;
		}
		ELSE
		{
			// puzzle solved...
			IF (h_key_sk == 0)
			{
				// player doesn't have the key...
				msge.STRING = con5_2_str;
			}
			ELSE
			{
				// player DOES have the key
				msge.STRING = con5_3_str;	// display message
				5x_schalt_sk = 2;       	// 'reprogram' key
			}
		}
	}
	IF (MY.SKILL1 == 6)
	{
		IF (h_key_sk == 0)
		{msge.STRING = con6_1_str; show_message_ekran(); END;}
		IF ((h_key_sk == 1)&&(5x_schalt_sk != 2))
		{msge.STRING = con6_2_str; show_message_ekran(); END;}
		IF ((angle_sat != 257)||(angle_rad != 129))
		{msge.STRING = con6_3_str;}
		IF ((angle_sat == 257)&&(angle_rad == 129)
		    &&(h_key_sk == 1)&&(5x_schalt_sk == 2))
		{
			msge.STRING = con6_4_str;
			show_message_ekran();
			WAITT 80;
			PLAY_SOUND 	msg_sound,66;
			msge.STRING = con6_5_str;
			alles_ok_sk = 1;
			MY.FLAG3 = ON;
			END;
		}
	}
	IF (MY.SKILL1 == 7) {msge.STRING = con7_1_str; laser_sk = 0; MY.FLAG3 = ON;}

	show_message_ekran();
}

// Desc: show console display message
function show_message_ekran()
{
	terminal_sk = 1;
	player._MOVEMODE = _MODE_STILL;	// freeze player

	// null keys
	ON_ESC = NULL;
	ON_F1  = NULL;
	ON_F10 = NULL;
	EXCLUSIVE_GLOBAL; // stop all other console display actions

	PLAY_SOUND 	msg_sound,66;
	//////////////  Format console screen
	terminal_y = (SCREEN_SIZE.Y/2) - 240;
	terminal_x = (SCREEN_SIZE.X/2) - 320;
	ekran1_pan.POS_Y = terminal_y;
	ekran1_pan.POS_X = terminal_x;
	ekran1a_pan.POS_Y = terminal_y + 80;
	ekran1a_pan.POS_X = terminal_x + 65;
	msge.POS_Y = terminal_y + 100;
	msge.POS_X = terminal_x + 100;
	ekran3_pan.POS_Y = terminal_y;
	ekran3_pan.POS_X = terminal_x;
	//////////// Display console screen
	ekran0_pan.VISIBLE = ON;
	ekran1_pan.VISIBLE = ON;
	ekran1a_pan.VISIBLE = ON;
	ekran3_pan.VISIBLE = ON;
	msge.VISIBLE = ON;

	// display until 'Q' is pressed
   WHILE (KEY_Q != ON)
	{
		// animate 'scan-line' effect
 		ekran1a_pan.POS_Y +=2;
	   IF (ekran1a_pan.POS_Y > (terminal_y +385))
	   {
			ekran1a_pan.POS_Y = terminal_y + 80;
		}
	   WAIT 1;
	}

	// black out the console
	msge.STRING = nullstring;
	msge.VISIBLE = OFF;
	ekran1a_pan.VISIBLE = OFF;
	ekran1_pan.VISIBLE = OFF;
	ekran0_pan.VISIBLE = OFF;
	ekran3_pan.VISIBLE = OFF;
	PLAY_SOUND msg_sound,66;
	player._MOVEMODE = _MODE_WALKING;
	MY.FLAG1 = OFF;
	IF (MY.FLAG3 == ON) {SET MY.FLAG2,ON;}

	// turn off terminal, reset keys
	terminal_sk = 0;
	ON_ESC = menu_main;
	ON_F1 = game_help;
	ON_F10 = exit_yesno;
}




// Desc: init terminal (text terminals, activate on player scan)
ACTION init_terminal
{
	MY.EVENT = zeige_con;
	IF (MY.SKILL1 == 10) {SET MY.EVENT,zeige_con2;}
	MY.ENABLE_SCAN = ON;
   MY.PUSH = 10;
}



////////////////////////////////////////////////////////////////////////
ACTION kugeltel
{
	MY.FACING = ON;
}

////////////////////////////////////////////////////////////////////////
//////// ROCKET -DIE LETZTE ACTIONEN
// Rocket functions

// Desc: init rocket (player's ride in) (lighting)
ACTION init_rocket
{
	rakieta = MY;
	MY.AMBIENT =65;
	MY.LIGHTRANGE = 50;
	MY.LIGHTGREEN = 15;	// fade to red
	MY.LIGHTBLUE = 15;	// fade to red
}

////////////////////////////////////////////////////////////////////////

// Desc: player finished level
function nach_hause()
{
	WHILE ((RESULT > 0)||(YOU != player))
	{
		WAIT 1;
		scan_sector.PAN = 360;
		scan_sector.TILT =180;
		scan_sector.Z = 280;
		SCAN rakieta.POS,rakieta.ANGLE,scan_sector;
	}

	alles_ok_sk = 4;
	msg.STRING = gutgut_str;
	show_message();
	player._MOVEMODE = _MODE_STILL;
	PLAY_SONG_ONCE song4,100;
	//	WAITT 32;
	total_ende();  // show ending screen
}

////////////////////////////////////////////////////////////////////////
////////////// INIT BEI START
// Desc: Start game
function start_init()
{
	game_pan.VISIBLE = OFF;	// hide "game over" panel
	my_leben = 110;         // restore health
	geld_sk = 0;            // reset money
	ammo1 = 100;            // init ammo values
	ammo2 = 30;
	ammo3 = 5;
	WAIT 1;
	bin_tod_sk = 0;         // player not dead
}

////////////////////////////ENDE PANEL

// Desc: call game exit
function total_ende()
{
	WAITT 64;
	game_exit();
}

// Desc: does the original menu.wdl game_exit commands
function	game_exit2()
{
	save_status();			// save global skills & strings
	EXIT	"3D GameStudio (c) conitec 1999\n";
}


// Desc: show ending game screen (override menu.wdl function)
function  game_exit()
{
	FREEZE_MODE = 1;   // freeze player

	// NULL KEYS
	ON_ESC = game_exit2;
	ON_F1 = game_exit2;
	ON_F2 = game_exit2;
	ON_F3 = game_exit2;
	ON_F4 = game_exit2;
	ON_F5 = game_exit2;
	ON_F6 = game_exit2;
	ON_F7 = game_exit2;
	ON_F8 = game_exit2;
	ON_F9 = game_exit2;
	ON_F10 = game_exit2;
	ON_F11 = game_exit2;
	ON_F12 = game_exit2;
	ON_SPACE = game_exit2;

	// center screen and display it
   terminal_y = (SCREEN_SIZE.Y/2) - 240;
   terminal_x = (SCREEN_SIZE.X/2) - 320;
	end_pan.POS_Y = terminal_y;
	end_pan.POS_X = terminal_x;
	ekran0_pan.VISIBLE = ON;
	end_pan.VISIBLE = ON;

	WAITT 480;	// wait half a minute
	game_exit2();
}


////////////////////////////////////////////////////////////////////////
// main

// Desc: run the intro level
ACTION main
{
	MAX_ENTITIES = 1500;
	load_status();	// load previous volume etc. settings


IFNDEF NOTEX; // disable d3d_texreserved with -d notex on weak cards
	D3D_TEXRESERVED = min(16000,D3D_TEXMEMORY/2);
ENDIF;
	LOAD_LEVEL	<level0.wmb>;	// load intro level
	WAIT 2;

	// skip into on esc/f1/f10/or SPACE

	ON_MOUSE_RIGHT = NULL; // disable mouse cursor
	ON_ESC = startbereit;
	ON_F1 = startbereit;
	ON_F10 = startbereit;
	ON_SPACE = startbereit;
}




// Desc: OVERRIDEs menu.wdl game_init
function game_init()
{
//	SET ON_LOAD,load_status;
//	LOAD "INIT",0;
//	CALL key_init;


	weapon_init();
	main1();
	main1_key_values();  	// set the keyboard
	main1_pan_values();     // set the panels
	main1_player_values();  // set player values

//	waffe_1();   // create a pistol (weapon #1)

	WAIT 5;
	// play music
	MIDI_VOL = 100;
	PLAY_SONG_ONCE song1,100;

	// create weapon #1
	CREATE <w_1.mdl>,nullskill,starting_weapon;
}


////////////////////////////////////////////////////////////////////////
// Desc: game main function (called after intro)
//
// Mod: 8/9/00 DCP
//		  Removed load_status and replaced it with init_global_vals to reset
//		all values
function main1()
{
	MIDI_VOL = 0;
	LOAD_LEVEL	<auftrag.wmb>;
	WAIT 5;                   // 5 ticks!
//-	MIDI_VOL = 0;
	MIP_FLAT = 1;
	ON_ESC = menu_main;
	ON_F1 = game_help;
	ON_F10 = exit_yesno;
	ON_SPACE = handle;
//--	load_status();   		// use LOAD_INFO to load last saved values
	reset_global_values();
	init_sky();
	show_panels();	//show player's current health, ammo, and money
}

////////////////////////////////////////////////////////////////////////
// functions to reset keys, panels, and player values at the beginning
// of the level

// Desc: reset keys
function main1_key_values()
{
	// set up keys
  	ON_ESC = menu_main;
	ON_F1 = game_help;
	ON_F10 = exit_yesno;
	ON_SPACE = handle;
	ON_F5 = NULL;
}

// Desc: set up start of game panels
function main1_pan_values()
{
	// set up panels
	msg1.VISIBLE = OFF;
	logo_pan.VISIBLE = OFF;
	grafix_pan.VISIBLE = OFF;
	titel2_pan.VISIBLE = OFF;
	titel1_pan.VISIBLE = OFF;
	kb1_pan.VISIBLE = OFF;
	kb2_pan.VISIBLE = OFF;
	kb3_pan.VISIBLE = OFF;
	kb4_pan.VISIBLE = OFF;
	kb5_pan.VISIBLE = OFF;
	kb6_pan.VISIBLE = OFF;
	kb7_pan.VISIBLE = OFF;
	kb8_pan.VISIBLE = OFF;
	kb9_pan.VISIBLE = OFF;

	game_pan.VISIBLE = OFF;	// hide "game over" panel
}

// Desc: set up player values
function main1_player_values()
{
	// reset player values
	WAIT 1;
	my_leben = 110;         // restore health
	geld_sk = 0;            // reset money
	ammo1 = 100;            // init ammo values
	ammo2 = 30;
	ammo3 = 5;
	WAIT 1;
	bin_tod_sk = 0;         // player not dead
}

// Desc: set all vars to their stating values (for a new game)
function reset_global_values()
{
//---turn_off_var_info();	// test! turn off all the var info values
	alles_ok_sk = 0; 	// DESTRUCTION - 0 /1 /2 /3
	my_leben = 100;   // 100 MEIN LEBEN (player's health)

	rotor_sat = 0;    // on/off Satelitenrotation - soll 0
							// satellite controls (on/off)

	angle_sat = 0; 	// Satelitenwinkel - soll 0, richtige Position 257
							// satellite rotation - start 0, correct position 257

	angle_rad = 0;     	// Radarwinkel - soll 0, richtige Position 129
							// radar rotation - start 0, correct position 129

	radar_an_ska = 0;	//ob der RADAR an ist 0/1 (radar on/off)

	gener_sk = 0; 		// Generator - soll 0 dann 1 (generator switch puzzle)
	lift_block_sk = 0; 	// Liftblokade - soll 0 dann 1

	//Generator switches (for generator switch puzzle)
	gener1_sk = 0;  		// Generatorschalter - soll 0 / 1
	gener2_sk = 0;  		// Generatorschalter - soll 0 / 0
	gener3_sk = 0;  		// Generatorschalter - soll 0 / 1
	gener4_sk = 0;		// Generatorschalter - soll 0 / 1


	// 5 switch puzzle (0-red/1-green)
	5x_1_sk = 0;  		// EndRaum 5 Schalter 1 - soll 0 / 1
	5x_2_sk = 0;  		// EndRaum 5 Schalter 2 - soll 0 / 0
	5x_3_sk = 0;  		// EndRaum 5 Schalter 3 - soll 0 / 0
	5x_4_sk = 0;  		// EndRaum 5 Schalter 4 - soll 0 / 1
	5x_5_sk = 0;  		// EndRaum 5 Schalter 5 - soll 0 / 1
	5x_schalt_sk = 0;  	// EndRaum 5 Schalter - soll 0 / 1 /2 wenn mit Password

	// laser wall (0-off/1-on)
	laser_sk = 1; 		// Laserwand - soll 1 /0 /2

	// Fuse-blown values (0-on/1-blown)
	// 1 - bedroom
	// 2 - speiseraum(?)
	// 3 - corridor
	// 4 - reactor
	// 5 - down reactor(?)
	kasten_1_sk = 0;	 	// ElectroKasten Schlafzimmer  - soll 0/1
	kasten_2_sk = 0;		// ElectroKasten Speiseraum - soll 0/1
	kasten_3_sk = 0; 	// ElectroKasten Korridor - soll 0/1
	kasten_4_sk = 0;		// ElectroKasten Reaktor -schrÑge- 0/1
	kasten_5_sk = 0;		// ElectroKasten Reaktor unten - 0/1

	// Gate switches (0-off/1-on)
	torschalt_1_sk = 0; //  Hausmeiser - 0 /1
	torschalt_2_sk = 0;	//  Krankenstation - 0 /1
	torschalt_3_sk = 0; //  Satelitenraum - 0 /1
	torschalt_4_sk = 0; //  Steuerraum - klein- 0 /1
	torschalt_5_sk = 0;	//  Schlafzimmer- 0 /1

	// Elevators (0-off/1-on)
	// 1 - hospital
	// 2 -
	// lager -
	lift_krank1_sk = 0;	// Lift zur Krankenstation Platte- 0/1
	lift_krank2_sk = 0; // Lift zur Krankenstation Schalter- 0/1
	lift_lager_sk  = 0; // Lift im Lager B - blockade- 0/1

	// platform in stock room B blocked
	platt_lager_sk = 0;	// Plattformt im Lager B - blockade- 0/1

	// gate in stock room A
	tor_lB_sk = 0; 		// Tor 2 im Lager A - blockade- 0/1

	// gates (0-off/1-on)
	tor_sb_sk = 0;		// Tor SCECTOR B - blockade- 0/1
	tor_st_sk = 0;		// Tor STEUERRAUM - blockade- 0/1
	tor_la_sk = 0;		// Tor LABOR A R2 - blockade- 0/1
	tor_sr_sk = 0; 		// Tor satelitenraum - blockade- 0/1

	// player has hardware key
	h_key_sk = 0; 		//  Hardwarekey - 0/1

	schacht_sk = 0;		// SChacht - 0

	fass_sk = 0; 			// fass - 0 (the 'exploding barrel' that blows a hole in the wall)

	schacht_sk = 0; 		// SChacht - 0
	bruecke_sk = 0; 		// Bruecke - 0 /1

	terminal_sk = 0;
	countdown_sk = 90; // soll 90

	geld_sk = 0;

}

function cheat_like_a_dog()
{
	// cheats
	lift_block_sk = 1; 	// Liftblokade - soll 0 dann 1
	gener_sk = 1; 		// Generator - soll 0 dann 1 (generator switch puzzle)
	5x_schalt_sk = 2;  	// EndRaum 5 Schalter - soll 0 / 1 /2 wenn mit Password
	h_key_sk = 1; 		//  Hardwarekey - 0/1
	lift_krank1_sk = 1;	// Lift zur Krankenstation Platte- 0/1
	lift_krank2_sk = 1; // Lift zur Krankenstation Schalter- 0/1
	lift_lager_sk  = 1; // Lift im Lager B - blockade- 0/1
}
//ON_T   cheat_like_a_dog;


/*
temp fix for pre-4.206 versions
function turn_off_var_info()
{
	alles_ok_sk.info = OFF; 	// DESTRUCTION - 0 /1 /2 /3
	my_leben = 100;   // 100 MEIN LEBEN (player's health)

	rotor_sat.info = OFF;    // on/off Satelitenrotation - soll 0
							// satellite controls (on/off)

	angle_sat.info = OFF; 	// Satelitenwinkel - soll 0, richtige Position 257
							// satellite rotation - start 0, correct position 257

	angle_rad.info = OFF;     	// Radarwinkel - soll 0, richtige Position 129
							// radar rotation - start 0, correct position 129

	radar_an_ska.info = OFF;	//ob der RADAR an ist 0/1 (radar on/off)

	gener_sk.info = OFF; 		// Generator - soll 0 dann 1 (generator switch puzzle)
	lift_block_sk.info = OFF; 	// Liftblokade - soll 0 dann 1

	//Generator switches (for generator switch puzzle)
	gener1_sk.info = OFF;  		// Generatorschalter - soll 0 / 1
	gener2_sk.info = OFF;  		// Generatorschalter - soll 0 / 0
	gener3_sk.info = OFF;  		// Generatorschalter - soll 0 / 1
	gener4_sk.info = OFF;		// Generatorschalter - soll 0 / 1


	// 5 switch puzzle (0-red/1-green)
	5x_1_sk.info = OFF;  		// EndRaum 5 Schalter 1 - soll 0 / 1
	5x_2_sk.info = OFF;  		// EndRaum 5 Schalter 2 - soll 0 / 0
	5x_3_sk.info = OFF;  		// EndRaum 5 Schalter 3 - soll 0 / 0
	5x_4_sk.info = OFF;  		// EndRaum 5 Schalter 4 - soll 0 / 1
	5x_5_sk.info = OFF;  		// EndRaum 5 Schalter 5 - soll 0 / 1
	5x_schalt_sk.info = OFF;  	// EndRaum 5 Schalter - soll 0 / 1 /2 wenn mit Password

	// laser wall (0-off/1-on)
	laser_sk.info = OFF; 		// Laserwand - soll 1 /0 /2

	// Fuse-blown values (0-on/1-blown)
	// 1 - bedroom
	// 2 - speiseraum(?)
	// 3 - corridor
	// 4 - reactor
	// 5 - down reactor(?)
	kasten_1_sk.info = OFF;	 	// ElectroKasten Schlafzimmer  - soll 0/1
	kasten_2_sk.info = OFF;		// ElectroKasten Speiseraum - soll 0/1
	kasten_3_sk.info = OFF; 	// ElectroKasten Korridor - soll 0/1
	kasten_4_sk.info = OFF;		// ElectroKasten Reaktor -schrÑge- 0/1
	kasten_5_sk.info = OFF;		// ElectroKasten Reaktor unten - 0/1

	// Gate switches (0-off/1-on)
	torschalt_1_sk.info = OFF; //  Hausmeiser - 0 /1
	torschalt_2_sk.info = OFF;	//  Krankenstation - 0 /1
	torschalt_3_sk.info = OFF; //  Satelitenraum - 0 /1
	torschalt_4_sk.info = OFF; //  Steuerraum - klein- 0 /1
	torschalt_5_sk.info = OFF;	//  Schlafzimmer- 0 /1

	// Elevators (0-off/1-on)
	// 1 - hospital
	// 2 -
	// lager -
	lift_krank1_sk.info = OFF;	// Lift zur Krankenstation Platte- 0/1
	lift_krank2_sk.info = OFF; // Lift zur Krankenstation Schalter- 0/1
	lift_lager_sk .info = OFF; // Lift im Lager B - blockade- 0/1

	// platform in stock room B blocked
	platt_lager_sk.info = OFF;	// Plattformt im Lager B - blockade- 0/1

	// gate in stock room A
	tor_lB_sk.info = OFF; 		// Tor 2 im Lager A - blockade- 0/1

	// gates (0-off/1-on)
	tor_sb_sk.info = OFF;		// Tor SCECTOR B - blockade- 0/1
	tor_st_sk.info = OFF;		// Tor STEUERRAUM - blockade- 0/1
	tor_la_sk.info = OFF;		// Tor LABOR A R2 - blockade- 0/1
	tor_sr_sk.info = OFF; 		// Tor satelitenraum - blockade- 0/1

	// player has hardware key
	h_key_sk.info = OFF; 		//  Hardwarekey - 0/1

	schacht_sk.info = OFF;		// SChacht - 0

	fass_sk.info = OFF; 			// fass - 0 (the 'exploding barrel' that blows a hole in the wall)

	schacht_sk.info = OFF; 		// SChacht - 0
	bruecke_sk.info = OFF; 		// Bruecke - 0 /1

	terminal_sk.info = OFF;
	countdown_sk.info = OFF; // soll 90

	geld_sk.info = OFF;
	my_leben.info = OFF;
	show_health.info = OFF;
}
*/

////////////////////////////////////////////////////////////////////////
// REST (health = 10)
ACTION modiv
{
	my_leben =10;
}


//INCLUDE <debug.wdl>;
//ON_D set_debug;
