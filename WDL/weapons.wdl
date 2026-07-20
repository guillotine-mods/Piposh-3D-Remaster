// Template file v5.202 (02/20/02)
////////////////////////////////////////////////////////////////////////
// File: weapons.wdl
//		WDL prefabs for weapon entities & effects
////////////////////////////////////////////////////////////////////////
//
//]- Mod Date: 8/31/00 DCP
//]-		Scaled entities that us _flashup and _blowup by actor_scale
//]-		Scaled bullet_shot and rocket_launch entities by actor_scale
//]-		Scaled bullet_shot and rocket_launch movement by movement_scale
//]-
//]- Mod Date: 10/3/00 DCP
//]-		Added 'wait' to ammo_pickup action if message is displayed,
//]-	  allows show_message to finish displaying
//]-
//]- Mod Date: 10/17/00 DCP
//]-		Replaced commands with "javascript" style commands
//]-		Add bullet holes
//]- Mod Date: 10/31/00 DCP
//]-				Changed to 4.30 format
//]-
//]-	Mod Date: 11/2/00 DCP
//]-		Added 'bullet_hole': creates a bullet_hole effect in map walls if
//]-	HIT_HOLE is set in weapon's _FIREMODE
//]-
//]- Mod Date: 11/17/00 DCP
//]-		Added DEFINE 'kMaxWeapons' to be equal to the maximum number of weapons
//]-	the player can have.
//]-		Added functions: 'gun_select_cycle_up' & 'gun_select_cycle_up' used
//]- to select the next or prev weapon in the player's list
//]- These new functions are called on 'E' and 'Q'
//]-
//]- Mod Date: 11/17/00 DCP
//]-		Added inverted bullet map (white)
//]-		Added 'laser_fire'  & 'FIRE_LASER' flag
//]-		Added 'GUNFX_BRASS' flag
//]-
//]- Mod Date: 12/11/00 DCP
//]-		Added weaponTmpSyn and code to gun_shot to store/restore YOU value
//]- when using a laser (so bullethole and other effects will continue to work).
//]-		To test new effects try the following FIREMODE with your weapon:
//]-			MY._FIREMODE = DAMAGE_SHOOT + HIT_FLASH + HIT_HOLE
//]-								+ HIT_SMOKE + HIT_SPARKS
//]-								+ FIRE_LASER + GUNFX_BRASS + 0.50;
//]-
//]- Mod Date: 01/24/01 JCL
//]-		Bullhole bitmaps fixed
//]-
//]- Mod Date: 02/06/01 DCP
//]-		In '_fireball_event':
//]-			Added wait before shoot command to remove 'Dangerous instruction error'
//]-
//]- Mod Date: 03/07/01 DCP
//]-		Added cross-hair panel and functions
//]-			- pan_cross_show(): position the cross-hair panel at the center
//]-			                   of the screen and make it visible.
//]-			- pan_cross_hide(): hide the cross-hair panel
//]-
//]-		Adjust the cross-hair offset using the following var	cross_pos[2]
//]-
//]- Mod Date: 04/08/01 DCP
//]-	 	Added functions/actions to automatically give the player a weapon
//]-	    	- gun_givePlayer(): init a gun, give it to the player, and select it
//]-	    	- function startgun1: demo on how to use the function gun_givePlayer
//]-									to give player the type 1 gun.
//]-
//]- Mod Date: 04/11/01 DCP
//]-		Changed STRING 'got_gun4_str' to "Got a laser gun!"
//]-		Added STRINGs 'got_ammo5_str', 'got_ammo6_str', 'got_ammo7_str'
//]-		Cleaned Code (added comments and grouped like values/functions)
//]-		Moved ON_KEYs to bottom
//]-		gun_select: Added weapon_number == 7 check
//]-		_ammo_limit: Added ammo5, ammo6, & ammo7
//]-		gun_pickup: Turned into function
//]-						Added ammo5, ammo6, & ammo7
//]-		ammo_pickup: Added ammo5, ammo6, & ammo7
//]-		ammopac: Added ammo5, ammo6, & ammo7
//]-		weapon_init: Added ammo5, ammo6, & ammo7
//]-		gun_fire: Added ammo5, ammo6, & ammo7
//]-
//]- Mod Date: 04/11/01 DCP
//]-		Added var 'gun_source'
//]-
//]- Mod:  04/13/01 DCP
//]-			gun_shot: Modify trace to calculate and use 'gun_source' instead of 'gun_muzzle'
//]-
//]- Mod:  04/17/01 DCP
//]-			Added Skills '_GUN_SOURCE_X', '_GUN_SOURCE_Y', and '_GUN_SOURCE_Z' to define
//]-		the source of a gun shot. If '_GUN_SOURCE_X == 0' then the default (gun_muzzle)
//]-		is used.
//]-			gun: added code to set the weapon source offset (if one is not already defined)
//]-			startgun1: Added _GUN_SOURCE_X/Y/Z values
//]-			gun_fire: Make player passable before calling 'gun_shot' (and nonpassable afterwords)
//]-			gun_shot: Use  MY._GUN_SOURCE_X/Y/Z to calculate 'gun_source' while in 1st person
//]-						 Changed to function.
//]-
//]- Mod:  04/18/01 DCP
//]-			gun_shot: Moved gun_source calculate outside, if gun_source[3] == 9, then use the
//]-		gun_source for tracing, else use gun_muzzle (backwards compatable)
//]-			gun_fire: Calculate 'gun_source' here now. Set 'gun_source[3] = 9' so gun_shot
//]-					knows to use the 'gun_source' vector for traces.
//]-	 					 Modified 3rd person 'gun_source', 'gun_muzzle', & 'gun_target' calculation
//]-					(no longer depends on cammera location)
//]-			rocket_launch:	Use 'vec_to_angle' and shot_speed to determine rocket orientation
//]-			laser_fire:	Use 'vec_to_angle' and shot_speed to determine beam orientation
//]-
//]- Mod:  04/19/01 DCP
//]-			_gun_fire_no_ammo: created (helper function for 'gun_fire')
//]-			gun_fire: Replaced goto no_ammo with branch _gun_fire_no_ammo
//]-
//]- Mod: 04/20/01 DCP
//]-			_gun_shot_damage_shoot: created (helper function for 'gun_shot')
//]-			gun_shot: Replace "damage shot" section of code with call to '_gun_shot_damage_shoot'
//]-						 Implemented HIT_SCATTER. If HIT_SCATTER flag is set in 'fire_mode' fire
//]-				'scatter_number' shots each randomly offset by the SCATTER_RAND amount.
//]-
//]- Mod: 04/25/01 DCP
//]-			Changed STRING got_gun5_str to "Got a shotgun!"
//]-			Added Action shotgun (type 5 weapon using HIT_SCATTER & HIT_HOLE)
//]-
//]- Mod: 05/04/01 DCP
//]-		gun_select_cycle_up: Fix endless loop when no weapon exists
//]-		gun_select_cycle_down: Fix endless loop when player has max weapon and no other
//]-		(Note: this would be cleaner with a do..while loop)
//]-
//]- Mod: 05/16/01 DCP
//]-		Remove all 'BRANCH' commands (replace with <foo>(); return;)
//]-
//]- Mod:  06/08/01 DCP
//]-		rocket_launch() & bullet_shot(): Replaced move() with ent_move()
//]-
//]- Mod:	06/21/01 DCP
//]-		Replaced SYNONYMs with pointers
//]-
//]- Mod:  06/25/01 DCP
//]-		Added function pan_cross_toggle(). Toggles cross-hair panel
//]-		Added ON_K to call pan_cross_toggle
//]-		Added fps weapons and ammo pack actions
//]-
//]- Mod Date: 07/14/01
//]-		bullet_hole(): Use new handles to turned it into an FIFO array
//]-
//]- Mod: 07/25/01
//]-		added "gun_animate()" function to animate gun model.
//]-		gun_fire(): Added check for gun animation (calls "gun_animate()").
//]-			- Gun must have animation frames labeled "shot1", "shot2", etc.
//]-			- gun action must set "GUNFX_ANIMATE" in "_FIREMODE"
//]-
//]-			ex) MY._FIREMODE = DAMAGE_SHOOT + GUNFX_ANIMATE + 0.25;
//]-
//]-		added action "weap_mg_animated" to use mgun.mdl
//]-
//]- Mod: 07/26/01 DCP
//]-		gun: broke out 'gun_restore' function
//]- 	gun_restore(): Created. Called from 'gun' action.
//]-			Restore a gun already owned by the player (from a previous level)
//]-
//]- Mod: 07/27/01 DCP
//]-		bullet_hole_remove_all(): Created. Remove all bullet holes
//]- 		Call this before changing levels to avoid a potential error when
//]-			trying to remove holes on the previous level.
//]-
//]- Mod: 08/01/01 DCP
//]-		laser_fire(): Made laser brighter
//]-
//]- Mod Date: 12/18/01
//]-		Added WED 'uses' comments to all WED editable fields
//]-		Changed weapon_carry from ACTION to function
//
// Mod: 02/13/02 DCP
// 		ACTION gun: Removed default _AMMOTYPE (if _AMMOTYPE = 0, gun has unlimited ammo)
//			gun_restore(): Added 'gun_loaded = 1' to reload repeating guns.
//
////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////

// change these sounds and graphics for your weapon
IFNDEF WEAPON_DEFS;
 SOUND gun_click,<empty.wav>;
 SOUND gun_wham,<wham.wav>;
 SOUND explo_wham,<explo.wav>;
 DEFINE hit_wham,explo_wham;
 SOUND gun_fetch,<beamer.wav>;
 DEFINE ammo_fetch,gun_fetch;
 DEFINE health_fetch,gun_fetch;

 DEFINE muzzle_flash,<particle.pcx>;
 DEFINE small_flash,<particle.pcx>;
 DEFINE fireball,<blitz.pcx>;
 DEFINE BULLET_EXPLO,<explo+7.pcx>;
 DEFINE EXPLO_FRAMES,7;
 DEFINE WEAPON_AMPL,0.2;	// swaying
ENDIF;

IFNDEF WEAPON_DEFS2;
 DEFINE bullethole_map,<bulhole.pcx>;    // bullet hole bitmap ***
 DEFINE ibullethole_map,<ibulhole.pcx>;    // inverted bullet hole bitmap (white) ***
ENDIF;

function rocket_launch();	// function prototype
string	strRocket_Model = <rocket.mdl>;	// rocket

string	strExplode_Sprite = <explo+7.pcx>;	// used in explosions
string 	strExplode_Model = <explosion.mdl>;

//////////////////////////////////////////////////////////////////////
// adapt those skills and strings to your game
// ammo starting and maximum values
var ammo1[3] = 0, 0, 200;
var ammo2[3] = 0, 0, 100;
var ammo3[3] = 0, 0,  40;
var ammo4[3] = 0, 0,  10;
var ammo5[3] = 0, 0,  10;
var ammo6[3] = 0, 0,  10;
var ammo7[3] = 0, 0,  10;

// dynamic light values
var light_explo[3]  =  50,  50, 255;// { RED 50; GREEN 50; BLUE 255; }
var light_flash[3]  = 200, 150,  50;// { RED 200; GREEN 150; BLUE 50; }
var light_muzzle[3] = 200,  20,  20;// { RED 200; GREEN 20; BLUE 20; }
var light_bullet[3] = 200,  50,  20;// { RED 200; GREEN 50; BLUE 20; }



// you'll probably want to redefine those strings. No problem.
STRING got_ammo1_str,"Got an ammo pack!";
STRING got_ammo2_str,"Got a big ammo pack!";
STRING got_ammo3_str,"Got a grenade pack!";
STRING got_ammo4_str,"Got a battery pack!";
STRING got_ammo5_str,"Got ammo5 pack!";
STRING got_ammo6_str,"Got a rocket pack!";
STRING got_ammo7_str,"Got ammo7 pack!";

STRING got_medi_str,"Got a first aid kit!";
STRING got_gun1_str,"Got a small gun!";
STRING got_gun2_str,"Got a medium gun!";
STRING got_gun3_str,"Got a large gun!";
STRING got_gun4_str,"Got a laser gun!";
STRING got_gun5_str,"Got a shotgun!";
STRING got_gun6_str,"Got a rocket launcher!";
STRING got_gun7_str,"Got a gun no. 7!";

//////////////////////////////////////////////////////////////////////
/* Gun Action

FLAG1  (__ROTATE from doors.wdl)
	If this flag is set, the gun model rotates before being picked up.

FLAG2  (__SILENT from doors.wdl)
	If this flag is set, the message on picking up the item will be
	suppressed.

FLAG5  (__BOB from movement.wdl)
   If this flag is marked, the gun sways a little if the camera is
	moving. The sway period is the same as used for head bobbing in the
	movement.wdl. If the flag is not marked, the gun stands still.

FLAG7  (__REPEAT)
   If this flag is marked, it's a machine gun. Otherwise, a single
	action gun.

SKILL1..SKILL3   (_OFFS_X, _OFFS_Y, _OFFS_Z)
	X Y Z position of the gun relative to the camera.

SKILL4  (_AMMOTYPE)
	Ammo type (1..7). If 0, the gun doesn't consume ammunition. The part
	after the decimal, times 100, gives the amount of ammo to be added
	on picking up the gun. E.g. 2.30 = Ammo type 2, 30 rounds are
	already in the gun.

SKILL5 (_BULLETSPEED)
	Speed of the bullet, default = 200 quants / tick. The part after the
	decimal, times 10, gives the strength of the recoil. If 0, then
	there is no recoil. If SKILL5 is above 0, the recoil is done by
	moving backwards. If SKILL5 is below 0, then the recoil is done by
	swinging upwards.

SKILL6  (_WEAPONNUMBER)
	Weapon number that determines the key (1..7) to be pressed to select
	that gun.

SKILL7  (_FIRETIME)
   The time (in ticks) the gun needs to reload. Includes the time for
   the gun animation, if any.

SKILL8 (_FIREMODE from movement.wdl)
   Fire mode, can be composed by adding the following numbers:

	1 - Damage is applied by a SHOOT instruction, without bullet (DAMAGE_SHOOT).
	2 - Damage is applied by IMPACT of the bullet (DAMAGE_IMPACT).
	3 - Damage is applied by a SCAN explosion of the bullet (DAMAGE_EXPLODE).

	4 - the gun fires line of particles (FIRE_PARTICLE).
	8 - the gun fires single particles (FIRE_DPARTICLE).
	12 - the gun fires orange fireballs, which radiate light (FIRE_BALL).
	16 - the gun fires a rocket model w/smoke trail (FIRE_ROCKET)
	20 - (NEW 11/17/00) the gun fires a laser (FIRE_LASER)
	24 - Reserved
	28 - Reserved

	32 - the bullets leave smoke trails(BULLET_SMOKETRAIL).

	64 - reserved

	128 - at hit point there will be a light flash (HIT_FLASH).
	256 - at hit point there will be an explosion (HIT_EXPLO).
	384 - at hit point there will be a big explosion (HIT_GIB).

	512 - at hit point a cloud of smoke will ascend (HIT_SMOKE).

	1024 - there will be multiple hit points, as by a shotgun (HIT_SCATTER).

	2048 - the gun spits out cartridge cases (GUNFX_BRASS).

	4096 - the bullets follow gravity.

	8192 - at hit point a shower of sparks (HIT_SPARKS).

	16384 - bullet hole at hit point (HIT_HOLE)

	32768 - gun has a "shot" animation (GUNFX_ANIMATE)

	The part after the decimal, times 100, gives the amount of damage
	the bullet produces (default = 10).  ***

SKILL11..SKILL13   (_GUN_SOURCE_X, _GUN_SOURCE_Y, _GUN_SOURCE_Z)
	X Y Z offset position of the bullet starting point (in 1st person view)
	if X == 0 then the gun muzzle will be used.

SKILL14 (_OFFS_FLASH )
	Muzzle flash offset in X direction.

SKILL15 (_RECOIL)
	Weapon recoil value.

SKILL16 (_DAMAGE)
	Damage from weapon

SKILL17 (_DISPLACEMENT)
	Distance weapon is 'displaced'

SKILL18 (

*/
///////////////////////////////////////////////////////////////////////

// Define Flags
//FLAG1 = __ROTATE from doors.wdl
//FLAG2 = __SILENT from doors.wdl
//FLAG5 = __BOB from movement.wdl
DEFINE __REPEAT,FLAG7;

// Define SKILLs
DEFINE _OFFS_X,SKILL1;
DEFINE _OFFS_Y,SKILL2;
DEFINE _OFFS_Z,SKILL3;
DEFINE _AMMOTYPE,SKILL4;
DEFINE _BULLETSPEED,SKILL5;
DEFINE _WEAPONNUMBER,SKILL6;
DEFINE _FIRETIME,SKILL7;
//SKILL8 = _FIREMODE from movement.wdl

DEFINE _GUN_SOURCE_X,SKILL11;
DEFINE _GUN_SOURCE_Y,SKILL12;
DEFINE _GUN_SOURCE_Z,SKILL13;


DEFINE _OFFS_FLASH,SKILL14;
DEFINE _RECOIL,SKILL15;
DEFINE _DAMAGE,SKILL16;
DEFINE _DISPLACEMENT,SKILL17;
DEFINE _FIRE,SKILL18;

DEFINE _PACKAMOUNT, SKILL5;	// ammo/med pack ammo amounts

// Constants
DEFINE MODE_DAMAGE,3;
DEFINE DAMAGE_SHOOT,1;
DEFINE DAMAGE_IMPACT,2;
DEFINE DAMAGE_EXPLODE,3;

DEFINE MODE_FIRE,28;
DEFINE FIRE_PARTICLE,4;
DEFINE FIRE_DPARTICLE,8;
DEFINE FIRE_BALL,12;
DEFINE FIRE_ROCKET,16;
DEFINE FIRE_LASER,20;

DEFINE BULLET_SMOKETRAIL,32;

DEFINE MODE_HIT,384;
DEFINE HIT_FLASH,128;
DEFINE HIT_EXPLO,256;
DEFINE HIT_GIB,384;

DEFINE HIT_SMOKE, 512;

DEFINE HIT_SCATTER,1024;
DEFINE GUNFX_BRASS,2048;		// gun drops brass

DEFINE HIT_SPARKS,8192;

DEFINE HIT_HOLE 16384;

DEFINE GUNFX_ANIMATE, 32768; 	// gun has a firing animation


///////////////////////////////////////////////////////////////////////
entity* weapon;
// The weapon must be a model pointing into X-direction,
// its center must be inside the barrel.

DEFINE	kMaxWeapons = 7;

entity* weapon1;
entity* weapon2;
entity* weapon3;
entity* weapon4;
entity* weapon5;
entity* weapon6;
entity* weapon7;

entity* weaponTmpSyn;     // tmp ENTITY pointer


var weapon_1 = 0; 	// set to 1 if the player owns that weapon
var weapon_2 = 0;
var weapon_3 = 0;
var weapon_4 = 0;
var weapon_5 = 0;
var weapon_6 = 0;
var weapon_7 = 0;

var gun_muzzle[3];
var gun_source[4];	// trace start point   (gun_source[3] = 9 if used)
var gun_target[3];
var gun_loaded = 1;
var fireball_speed = 0;

var weapon_number = 0;
var ammo_number = 0;

var range = 0;
var damage = 0;
var fire_mode = 0;
var weapon_firing = 0;

//////////////////////////////////////////////////////////////////////

// 'Default' First Person Shooter guns
/****************************************************************
	Weapon Actions - Some pre-defined weapons

	todo: perhaps come up with a way to have the world
	models (laying on the ground) separate and different
	from the view models (in player's hand).
******************************************************************/


// Desc: basic animated machinegun type weapon
//
// Created: 07/25/01 DCP
//
// uses _WEAPONNUMBER
// uses __ROTATE
action weap_mg_animated
{
	MY.__ROTATE = ON;		// gun rotates before being picked up
	MY.__REPEAT = ON;		// repeats (Auto-fire)
	MY.__BOB = ON;  		// 'bobs' when the player moves
	MY._OFFS_X = 45;   	// x,y,z pos of the gun
	MY._OFFS_Y = 15;
	MY._OFFS_Z = 15;
	MY._AMMOTYPE = 1.99; 	  		// type of ammo '.' rounds in gun

	if (MY._WEAPONNUMBER == 0) { MY._WEAPONNUMBER = 2; }    		// weapon number (press to equip)
	MY._BULLETSPEED = 1000.01;		// bulletspeed '.' recoil
	MY._FIRETIME = 2;          	// time to cycle (reload)

	// SHOOT damage (immediate)
	// + hole at hit point
	// + eject brass
	// + gun "shot" animation
	// 20 points of damage per shot
	MY._FIREMODE = DAMAGE_SHOOT + HIT_HOLE + GUNFX_BRASS + GUNFX_ANIMATE + 0.20;
	gun();
}


// Desc: basic 'M16' type weapon
//
// Created: MWS 06/25/01
//
// uses _WEAPONNUMBER
// uses __SILENT
action weap_m16
{
	MY.__ROTATE = ON;		// gun rotates before being picked up
	MY.__REPEAT = ON;		// repeats (Auto-fire)
	MY.__BOB = ON;  		// 'bobs' when the player moves
	MY._OFFS_X = 30;   	// x,y,z pos of the gun
	MY._OFFS_Y = 10;
	MY._OFFS_Z = 10;
	MY._AMMOTYPE = 1.30; 	  		// type of ammo '.' rounds in gun

	if (MY._WEAPONNUMBER == 0) { MY._WEAPONNUMBER = 1; }    		// weapon number (press to equip)
	MY._BULLETSPEED = 1000.01;		// bulletspeed '.' recoil
	MY._FIRETIME = 1;          	// time to cycle (reload)

	// SHOOT damage (immediate)
	// + flash at hit point
	// + sparks at hit point
	// 10 points of damage per shot
	MY._FIREMODE = DAMAGE_SHOOT + HIT_HOLE + HIT_FLASH + HIT_SPARKS + 0.10;
	gun();
}

// Desc: basic 'rocket launcher' type weapon
//
// Created: MWS 06/25/01
//
// uses _WEAPONNUMBER
// uses __SILENT
action weap_rocketlauncher
{
	MY.__ROTATE = ON;		// gun rotates before being picked up
	MY.__REPEAT = ON;		// repeats (Auto-fire)
	MY.__BOB = ON;  		// 'bobs' when the player moves
	MY._OFFS_X = 35;   	// x,y,z pos of the gun
	MY._OFFS_Y = 10;
	MY._OFFS_Z = 10;
	MY._AMMOTYPE = 6.10; 	  		// type of ammo '.' rounds in gun

	if (MY._WEAPONNUMBER == 0) { MY._WEAPONNUMBER = 6; }    		// weapon number (press to equip)
	MY._BULLETSPEED = 200.10;		// bulletspeed '.' recoil
	MY._FIRETIME = 10;          	// time to cycle (reload)

	// SHOOT damage (immediate)
	// + flash at hit point
	// + sparks at hit point
	// 50 points of damage per shot
	MY._FIREMODE = DAMAGE_EXPLODE + FIRE_ROCKET + HIT_GIB + HIT_SPARKS + 0.50;
	gun();
}

/**************************************************************
	Ammo Actions - Default ammopacs from weapons.wdl,
	but with specific ammunition types (to simplify
	things for the WED user).  Uses defines from weapons.wdl,
	thus must be included after it.

***************************************************************/

// Desc: ammo boxes (weapons 1-7)
//
// Created: MWS 06/25/01
//
// uses _PACKAMOUNT
// uses __SILENT
action ammo_type1
{
	MY.__ROTATE = ON;
	MY._AMMOTYPE = 1;
	ammopac();
}

// uses _PACKAMOUNT
// uses __SILENT
action ammo_type2
{
	MY.__ROTATE = ON;
	MY._AMMOTYPE = 2;
	ammopac();
}

// uses _PACKAMOUNT
// uses __SILENT
action ammo_type3
{
	MY.__ROTATE = 1;
	MY._AMMOTYPE = 3;
	ammopac();
}

// uses _PACKAMOUNT
// uses __SILENT
action ammo_type4
{
	MY.__ROTATE = 1;
	MY._AMMOTYPE = 4;
	ammopac();
}

// uses _PACKAMOUNT
// uses __SILENT
action ammo_type5
{
	MY.__ROTATE = 1;
	MY._AMMOTYPE = 5;
	ammopac();
}

// uses _PACKAMOUNT
// uses __SILENT
action ammo_type6
{
	MY.__ROTATE = 1;
	MY._AMMOTYPE = 6;
	ammopac();
}

// uses _PACKAMOUNT
// uses __SILENT
action ammo_type7
{
	MY.__ROTATE = 1;
	MY._AMMOTYPE = 7;
	ammopac();
}



// testgun, logangun, lasergun, sparkgun, & flashgun are all examples
//on how to create guns with the template code. Each one calls 'gun'.

// Desc: a testgun. This gun is special because it is removed if you do
//     not define 'TEST'.
ACTION testgun
{
IFNDEF TEST;
	remove(ME);
	return;
ENDIF;
	MY.__ROTATE = ON;
	MY.__REPEAT = ON;
	MY.__BOB = ON;
	MY.SKILL1 = 50;
	MY.SKILL2 = 20;
	MY.SKILL3 = 20;
	MY._AMMOTYPE = 1.50;
	MY._WEAPONNUMBER = 1;
	MY._BULLETSPEED = -500.05;
	MY._FIRETIME = 2;
	MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH+0.30;
	gun();
}

// Desc: "Logan's Run" type gun, used for testing
//
// uses _WEAPONNUMBER
// uses __SILENT
ACTION logangun
{
	MY.__ROTATE = ON;	// gun rotates before being picked up
	MY.__REPEAT = ON; // repeats (Auto-fire)
	MY.__BOB = ON;  	// 'bobs' when the player moves
	MY._OFFS_X = 42;   // x,y,z pos of the gun
	MY._OFFS_Y = 20;
	MY._OFFS_Z = 7;
	MY._AMMOTYPE = 0.0; 		// type of ammo '.' rounds in gun
									//(0 means no ammo needed)

	if(MY._WEAPONNUMBER == 0) { MY._WEAPONNUMBER = 3; }  	// weapon number (press 3 to equip)
	MY._BULLETSPEED = 1000.25;	// bulletspeed '.' recoil
	MY._FIRETIME = 5;          // time to cycle (reload)

	// SHOOT damage (immediate)
	// + flash at hit point
	// + smoke at hit point
	// + sparks at hit point
	// 50 points of damage per shot
	MY._FIREMODE = DAMAGE_SHOOT + HIT_FLASH + HIT_SMOKE + HIT_SPARKS + FIRE_PARTICLE + 0.50;
	gun();
}

// Desc: shotgun type gun
//
// uses _WEAPONNUMBER
// uses __SILENT
ACTION shotgun
{
	MY.__ROTATE = ON;	// gun rotates before being picked up
	MY.__REPEAT = ON; // repeats (Auto-fire)
	MY.__BOB = ON;  	// 'bobs' when the player moves
	MY._OFFS_X = 42;   // x,y,z pos of the gun
	MY._OFFS_Y = 20;
	MY._OFFS_Z = 7;
	MY._AMMOTYPE = 5.20; 		// type of ammo '.' rounds in gun
									//(0 means no ammo needed)

	if(MY._WEAPONNUMBER == 0) { MY._WEAPONNUMBER = 5; }	// weapon number (press 5 to equip)
	MY._BULLETSPEED = -300.50;	// bulletspeed '.' recoil
	MY._FIRETIME = 10;          // time to cycle (reload)

	// SHOOT damage (immediate)
	// + scatter shot
	// + bullet holes
	// 15 points of damage per shot
	MY._FIREMODE = DAMAGE_SHOOT + HIT_SCATTER + HIT_HOLE + 0.15;
	gun();
}


// Desc: Laser beam type gun
//
// uses _WEAPONNUMBER
// uses __SILENT
ACTION lasergun
{
	MY.__ROTATE = ON;	// gun rotates before being picked up
	MY.__REPEAT = OFF;// repeats (Auto-fire)
	MY.__BOB = ON;  	// 'bobs' when the player moves
	MY._OFFS_X = 42;   // x,y,z pos of the gun
	MY._OFFS_Y = 20;
	MY._OFFS_Z = 7;
	MY._AMMOTYPE = 0.0; 		// type of ammo '.' rounds in gun
									//(0 means no ammo needed)

	if( MY._WEAPONNUMBER == 0) { MY._WEAPONNUMBER = 4; }	// weapon number (press 4 to equip)
	MY._BULLETSPEED = 1000.25;	// bulletspeed '.' recoil
	MY._FIRETIME = 5;          // time to cycle (reload)

	// SHOOT damage (immediate)
	// + use laser beam
	// + flash at hit point
	// + smoke at hit point
	// + sparks at hit point
	// 50 points of damage per shot
	MY._FIREMODE = DAMAGE_SHOOT + FIRE_LASER + HIT_FLASH + HIT_SMOKE + HIT_SPARKS + 0.50;
	gun();
}

// Desc: simple particle gun
//
// uses _WEAPONNUMBER
// uses __SILENT
ACTION sparkgun
{
	MY.__ROTATE = ON;
	MY.__REPEAT = ON;
	MY.__BOB = ON;
	MY._OFFS_X = 50;
	MY._OFFS_Y = 20;
	MY._OFFS_Z = 20;
	MY._AMMOTYPE = 1.50;
	if(MY._WEAPONNUMBER == 0) { MY._WEAPONNUMBER = 1; }
	MY._BULLETSPEED = -500.05;
	MY._FIRETIME = 2;
	MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH+0.30;
	gun();
}

// Desc: Fires orange fireballs
//
// uses _WEAPONNUMBER
// uses __SILENT
ACTION flashgun
{
	MY.__ROTATE = ON;
	MY.__REPEAT = ON;
	MY.__BOB = ON;
	MY.SKILL1 = 42;
	MY.SKILL2 = 20;
	MY.SKILL3 = 7;
	MY._AMMOTYPE = 0.0;//--?? 2.15;
	if(MY._WEAPONNUMBER == 0) { MY._WEAPONNUMBER = 2; }
	MY._BULLETSPEED = 150.05;
	MY._FIRETIME = 5;
	MY._FIREMODE = DAMAGE_EXPLODE+FIRE_BALL+HIT_EXPLO+BULLET_SMOKETRAIL+0.50;
	gun();
}

////////////////////////////////////////////////////////////////////////

// Desc: Called from player_move action; player must exist here
//
// Mod Date: 05/01/02
//		major re-write
//		No longer invisible in 3rd person view
//		NEAR flag only set in 1st player view
function weapon_carry()
{
  	if(weapon == NULL || player == NULL) { return; }
   weapon.passable = on;
	if(person_3rd != 0)
	{
		weapon.INVISIBLE = OFF;//?ON;
		weapon.NEAR = OFF;     // clip to player view

		player._FIREMODE = weapon._FIRE;  //show the attack animation for the player
  		if(player.shadow == on) { weapon.shadow = on; }
  		vec_set(weapon.x,player.x);
  		vec_set(weapon.pan,player.pan);
  		weapon.frame = player.frame;
  		weapon.next_frame = player.next_frame;

	/*	// if firing in 3rd person mode, calculate the player's attack frame
		if(weapon._FIRE > 0)
		{
			temp = (weapon._FIRETIME - weapon._FIRE) / weapon._FIRETIME;
			if(temp < 0) { temp = 0; }
			if(temp > 0.9) { temp = 0.9; }
			player.FRAME = 1 + player._WALKFRAMES + player._RUNFRAMES + 1 + player._ATTACKFRAMES * temp;
		}
	*/
	}
	else
	{
		weapon.NEAR = ON;     // don't clip to player view
		weapon.INVISIBLE = OFF;
		MY_POS.X = weapon.SKILL1;
		MY_POS.Y = -weapon.SKILL2;
		MY_POS.Z = -weapon.SKILL3;
		if(weapon._RECOIL > 0)
		{
			MY_POS.X -= weapon._DISPLACEMENT;
		}
		if(player.__BOB == ON)
		{
			MY_POS.Y += headwave * WEAPON_AMPL;
			MY_POS.X += headwave * WEAPON_AMPL;
			MY_POS.Z -= headwave * WEAPON_AMPL;
		}

		_set_pos_ahead_xyz();
		weapon.X = MY_POS.X ;
		weapon.Y = MY_POS.Y;
		weapon.Z = MY_POS.Z;
		weapon.PAN = CAMERA.PAN;
		weapon.TILT = CAMERA.TILT;
		if(weapon._RECOIL < 0)
		{
			weapon.TILT -= weapon._DISPLACEMENT;
		}
	}
}


////////////////////////////////////////////////////////////////////////
// Gun select functions
ACTION _gun_select1 { weapon_number = 1; gun_select(); }
ACTION _gun_select2 { weapon_number = 2; gun_select(); }
ACTION _gun_select3 { weapon_number = 3; gun_select(); }
ACTION _gun_select4 { weapon_number = 4; gun_select(); }
ACTION _gun_select5 { weapon_number = 5; gun_select(); }
ACTION _gun_select6 { weapon_number = 6; gun_select(); }
ACTION _gun_select7 { weapon_number = 7; gun_select(); }

// Desc: select the 'next' weapon
//
// Mod Date: 05/04/01 DCP
//		Fix endless loop when no weapon exists
//		(Note: this would be cleaner with a do..while loop)
function	gun_select_cycle_up()
{

	temp = weapon_number; // save the current weapon_number
	weapon_number += 1;
	while(temp != weapon_number)
	{
		if(weapon_number > kMaxWeapons)
		{
			weapon_number = 0;
			if(temp == 0)  // started with no weapon
			{
				return(0);
			}
		}
		if(gun_select() != -1)
		{
			return(weapon_number);
		}
		weapon_number += 1;   // try next weapon
	}
}

// Desc: select the 'prev' weapon
//
// Mod Date: 05/04/01 DCP
//		Fix endless loop when player has max weapon and no other
//		(Note: this would be cleaner with a do..while loop)
function	gun_select_cycle_down()
{
	temp = weapon_number; // save the current weapon_number
	weapon_number -= 1;
	while(temp != weapon_number)
	{
		if(weapon_number < 0)
		{
			weapon_number = kMaxWeapons;
			if(temp == kMaxWeapons)  // started with max weapon
			{
				return(kMaxWeapons);
			}
		}
		if(gun_select() != -1)
		{
			return(weapon_number);
		}
		weapon_number -= 1;   // try next weapon
	}
}



// Desc: select/switch weapon
//
//]- Mod 11/17/00 DCP
//]- Function returns -1 if no weapon is found (ME == NULL)
//]-	Function returns new weapon_number is a weapon is selected
//]-
//]- Mod:  04/11/01 DCP
//]-		Added weapon_number == 7
//]-
//]-	Mod: 07/25/01 DCP
//]-		Changed to function
function gun_select()
{
	if(weapon != NULL)
	{	// remove old weapon
		weapon.INVISIBLE = ON;
		weapon.PASSABLE = ON;
	}

	if(weapon_number == 1) {  ME = weapon1; }
	if(weapon_number == 2) {  ME = weapon2; }
	if(weapon_number == 3) {  ME = weapon3; }
	if(weapon_number == 4) {  ME = weapon4; }
	if(weapon_number == 5) {  ME = weapon5; }
	if(weapon_number == 6) {  ME = weapon6; }
	if(weapon_number == 7) {  ME = weapon7; }
	if(ME == NULL) { return(-1); }

	ammo_number = MY._AMMOTYPE;
	MY.INVISIBLE =  OFF;
	MY.PASSABLE = ON;	// prevent collision with obstacles
	MY.NEAR = ON;	// prevent clipping
	weapon = ME;		// I'm the current weapon now
	carry = weapon_carry;

	EXCLUSIVE_GLOBAL;

	// handle firing
	while(weapon == ME)
	{
		if(weapon_firing && (gun_loaded > 0) && (MY._FIRE <= 0) )
		{
			gun_fire();
		}

		if((weapon_firing == 0) && (gun_loaded == 0) && (MY.__REPEAT == OFF))
		{
			gun_loaded = 1;
		}
		wait(1);
	}
	return(weapon_number);
}

//////////////////////////////////////////////////////////////////////
// Pickup functions



// Desc: limit ammo to maximum values
//
// Mod:  04/11/01 DCP
//		Added ammo5, ammo6, & ammo7
function _ammo_limit()
{
	if(ammo1 > ammo1.Z) { ammo1 = ammo1.Z; }
	if(ammo2 > ammo2.Z) { ammo2 = ammo2.Z; }
	if(ammo3 > ammo3.Z) { ammo3 = ammo3.Z; }
	if(ammo4 > ammo4.Z) { ammo4 = ammo4.Z; }
	if(ammo5 > ammo5.Z) { ammo5 = ammo5.Z; }
	if(ammo6 > ammo6.Z) { ammo6 = ammo6.Z; }
	if(ammo7 > ammo7.Z) { ammo7 = ammo7.Z; }
}

// Desc: handle gun pickup event
//
// Mod:  04/11/01 DCP
//		Turned into function
//		Added ammo5, ammo6, & ammo7
function gun_pickup()
{
	if(EVENT_TYPE == EVENT_SCAN && indicator != _HANDLE) { return; }
	if(EVENT_TYPE == EVENT_PUSH && YOU != player) { return; }

	MY.ENABLE_SCAN = OFF;
	MY.ENABLE_CLICK = OFF;
	MY.ENABLE_PUSH = OFF;

	if(INT(MY._AMMOTYPE) == 1) { ammo1 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5); }
	if(INT(MY._AMMOTYPE) == 2) { ammo2 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5); }
	if(INT(MY._AMMOTYPE) == 3) { ammo3 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5);	}
	if(INT(MY._AMMOTYPE) == 4) { ammo4 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5);	}
	if(INT(MY._AMMOTYPE) == 5) { ammo5 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5);	}
	if(INT(MY._AMMOTYPE) == 6) { ammo6 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5);	}
	if(INT(MY._AMMOTYPE) == 7) { ammo7 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5);	}
	MY._AMMOTYPE = INT(MY._AMMOTYPE);	// ammo type
	_ammo_limit();

	weapon_number = MY._WEAPONNUMBER;
	if(weapon_number == 1) {  weapon1 = ME; weapon_1 = 1;  ON_1 = _gun_select1;  msg.STRING = got_gun1_str; }
	if(weapon_number == 2) {  weapon2 = ME; weapon_2 = 1;  ON_2 = _gun_select2;  msg.STRING = got_gun2_str; }
	if(weapon_number == 3) {  weapon3 = ME; weapon_3 = 1;  ON_3 = _gun_select3;  msg.STRING = got_gun3_str; }
	if(weapon_number == 4) {  weapon4 = ME; weapon_4 = 1;  ON_4 = _gun_select4;  msg.STRING = got_gun4_str; }
	if(weapon_number == 5) {  weapon5 = ME; weapon_5 = 1;  ON_5 = _gun_select5;  msg.STRING = got_gun5_str; }
	if(weapon_number == 6) {  weapon6 = ME; weapon_6 = 1;  ON_6 = _gun_select6;  msg.STRING = got_gun6_str; }
	if(weapon_number == 7) {  weapon7 = ME; weapon_7 = 1;  ON_7 = _gun_select7;  msg.STRING = got_gun7_str; }

	if(MY.__SILENT != ON) { show_message(); }
	gun_select();
}


// Desc: handle ammo pickup event
//]- Mod: 10/3/00 Added 'wait' if message is displayed, allows show_message
//]- 				to finish displaying
// Mod:  04/11/01 DCP
//		Added ammo5, ammo6, & ammo7
function ammo_pickup()
{
	if(EVENT_TYPE == EVENT_SCAN && indicator != _HANDLE) { return; }
	if(EVENT_TYPE == EVENT_PUSH && YOU != player) { return; }

	if(MY._AMMOTYPE == 1) { ammo1 += MY._PACKAMOUNT;  msg.STRING = got_ammo1_str; }
	if(MY._AMMOTYPE == 2) { ammo2 += MY._PACKAMOUNT;  msg.STRING = got_ammo2_str; }
	if(MY._AMMOTYPE == 3) { ammo3 += MY._PACKAMOUNT;  msg.STRING = got_ammo3_str; }
	if(MY._AMMOTYPE == 4) { ammo4 += MY._PACKAMOUNT;  msg.STRING = got_ammo4_str; }
	if(MY._AMMOTYPE == 5) { ammo5 += MY._PACKAMOUNT;  msg.STRING = got_ammo5_str; }
	if(MY._AMMOTYPE == 6) { ammo6 += MY._PACKAMOUNT;  msg.STRING = got_ammo6_str; }
	if(MY._AMMOTYPE == 7) { ammo7 += MY._PACKAMOUNT;  msg.STRING = got_ammo7_str; }
	if(MY.__SILENT != ON) { show_message(); }
	_ammo_limit();
	PLAY_SOUND ammo_fetch,50;


	if(MY.__SILENT != ON)
	{
		// hide item..
		MY.EVENT = NULL;
		MY.PASSABLE = ON;
		MY.INVISIBLE = ON;

		waitt(MSG_TICKS);	// wait for message to vanish
	}

	remove(ME);
}


// Desc: ammo pack entity
//
// Mod:  04/11/01 DCP
//		Added ammo5, ammo6, & ammo7
//
// uses _AMMOTYPE, _PACKAMOUNT
// uses __ROTATE, __SILENT
ACTION ammopac
{
	// default ammo type is 1
	if(MY._AMMOTYPE == 0) { MY._AMMOTYPE = 1; }

	// default ammo amount is a quarter of ammo maximum
	if(MY._PACKAMOUNT == 0)
	{
		if(MY._AMMOTYPE == 1) { MY._PACKAMOUNT = ammo1.Z * 0.25; }
		if(MY._AMMOTYPE == 2) { MY._PACKAMOUNT = ammo2.Z * 0.25; }
		if(MY._AMMOTYPE == 3) { MY._PACKAMOUNT = ammo3.Z * 0.25; }
		if(MY._AMMOTYPE == 4) { MY._PACKAMOUNT = ammo4.Z * 0.25; }
		if(MY._AMMOTYPE == 5) { MY._PACKAMOUNT = ammo5.Z * 0.25; }
		if(MY._AMMOTYPE == 6) { MY._PACKAMOUNT = ammo6.Z * 0.25; }
		if(MY._AMMOTYPE == 7) { MY._PACKAMOUNT = ammo7.Z * 0.25; }
	}

	MY.EVENT = ammo_pickup;
	item_pickup();
}

// Desc: handle medipac event
function medi_pickup()
{
	if(EVENT_TYPE == EVENT_SCAN && indicator != _HANDLE) { return; }
	if(EVENT_TYPE == EVENT_PUSH && YOU != player) { return; }

	if(YOU == NULL) {  YOU = player; }
	if(YOU == NULL) { return; }

	YOUR._HEALTH += MY.SKILL5;
	if(YOUR._HEALTH > 100) { YOUR._HEALTH = 100; }  // health max at 100%

	PLAY_SOUND health_fetch,50;
	msg.STRING = got_medi_str;

	if(MY.__SILENT != ON) { show_message(); }
	remove(ME);
}

// Desc: medipac entity
//
// uses _PACKAMOUNT
// uses __ROTATE, __SILENT
ACTION medipac
{
	if(MY._PACKAMOUNT == 0) { MY._PACKAMOUNT = 25; }
	MY.EVENT = medi_pickup;
	item_pickup();
}


// Desc: restore a gun already owned by the player (from a previous level)
//
// Note: keep the gun in the level
//
// Mod Date: 02/13/02 DCP
//		Added 'gun_loaded = 1' to reload repeating guns.
function gun_restore()
{
	// weapon was already picked up by the player
	MY._AMMOTYPE = INT(MY._AMMOTYPE);	// happens on pickup

	MY.INVISIBLE = ON;
	MY.PASSABLE = ON;
	MY.ENABLE_SCAN = OFF;
	MY.ENABLE_CLICK = OFF;
	MY.ENABLE_PUSH = OFF;
	MY.EVENT = NULL;
	// Was it the last weapon the player carried?
	if(weapon_number == MY._WEAPONNUMBER) { gun_select(); }
	if(MY.__REPEAT == ON)
	{
		//reload repeating guns (in case they were in 'mid-fire')
		wait(1);    		// allow the gun to move 'in place'
		gun_loaded = 1;   // reload
	}
}

// Desc: set up a gun
//
//]- Mod: 04/17/01 DCP
//]-		set the weapon source offset (if one is not already defined)
//]-
//]- Mod: 07/26/01 DCP
//]-		broke out 'gun_restore' function
//]-
// Mod: 12/18/01 DCP
//		Moved _OFFS_FLASH (made it user definable)
//		Added default _AMMOTYPE
//
// Mod: 02/13/02 DCP
// 	Removed default _AMMOTYPE (if _AMMOTYPE = 0, gun has unlimited ammo)
//
// uses _OFFS_X, _OFFS_Y, _OFFS_Z, _GUN_SOURCE_X, _GUN_SOURCE_Y, _GUN_SOURCE_Z
// uses _OFFS_FLASH, _WEAPONNUMBER, _FIREMODE, _BULLETSPEED, _AMMOTYPE, _FIRETIME
// uses __ROTATE, __SILENT, __REPEAT, __BOB
ACTION gun
{
	// set the weapon camera offset (if one is not already defined)
	if(MY._OFFS_X == 0)
	{
		MY._OFFS_X = 50;
		MY._OFFS_Y = 20;
		MY._OFFS_Z = 20;
	}


	if(MY._OFFS_FLASH == 0)
	{
		MY._OFFS_FLASH = MY.MAX_X + 1; 	// Muzzle flash offset
	}

	// set the weapon source offset (if one is not already defined)
	if(MY._GUN_SOURCE_X == 0)
	{
		MY._GUN_SOURCE_X = MY._OFFS_X + MY._OFFS_FLASH;
		MY._GUN_SOURCE_Y = -MY._OFFS_Y;
		MY._GUN_SOURCE_Z = -MY._OFFS_Z;
	}

	// make sure we have a valid _WEAPONNUMBER
	if(MY._WEAPONNUMBER <= 0 || MY._WEAPONNUMBER > 7)
	{ MY._WEAPONNUMBER = 1; }

	// set damage
	MY._DAMAGE = FRC(MY._FIREMODE) * 100;
 	if(MY._DAMAGE == 0)
	{ MY._DAMAGE = 20; } // default to 20 damage

	// set firemode
	MY._FIREMODE = INT(MY._FIREMODE);
	if(MY._FIREMODE == 0)
	{ MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH; }   // default to

	// set recoil (up or back)
	MY._RECOIL = FRC(MY._BULLETSPEED) * 100;

	// set bullet speed
	MY._BULLETSPEED = ABS(MY._BULLETSPEED);
	if(MY._BULLETSPEED < 1)
	{ MY._BULLETSPEED = 200; }   // default to 200

/* removed 021302
	// make sure we have an ammotype
	if(MY._AMMOTYPE == 0)
	{ MY._AMMOTYPE = 1; } // default ammotype
*/

	MY.EVENT = gun_pickup;
	item_pickup();

	// check whether this gun was picked up before in another level,
	// and has to be re-created for this level
	if(MY._WEAPONNUMBER == 1 && weapon_1 == 1 && weapon1 == NULL)
	{ weapon1 = ME; gun_restore(); return; }
	if(MY._WEAPONNUMBER == 2 && weapon_2 == 1 && weapon2 == NULL)
	{ weapon2 = ME; gun_restore(); return; }
	if(MY._WEAPONNUMBER == 3 && weapon_3 == 1 && weapon3 == NULL)
	{ weapon3 = ME; gun_restore(); return; }
	if(MY._WEAPONNUMBER == 4 && weapon_4 == 1 && weapon4 == NULL)
	{ weapon4 = ME; gun_restore(); return; }
	if(MY._WEAPONNUMBER == 5 && weapon_5 == 1 && weapon5 == NULL)
	{ weapon5 = ME; gun_restore(); return; }
	if(MY._WEAPONNUMBER == 6 && weapon_6 == 1 && weapon6 == NULL)
	{ weapon6 = ME; gun_restore(); return; }
	if(MY._WEAPONNUMBER == 7 && weapon_7 == 1 && weapon7 == NULL)
	{ weapon7 = ME; gun_restore(); return; }
}



// Desc: start the player with this gun
// Use:  CREATE(<WAFFE1.MDL>,nullskill,startgun1);
//
// Mod:  04/17/01 DCP
//		Added _GUN_SOURCE_X/Y/Z values
function	startgun1()
{
	// NOTE: these are the stats you should adjust in your 'startgun'
	MY.__REPEAT = ON;
	MY.__BOB = ON;
	MY._OFFS_X = 50;
	MY._OFFS_Y = 20;
	MY._OFFS_Z = 20;

	MY._GUN_SOURCE_X = -1;
	MY._GUN_SOURCE_Y = 2;
	MY._GUN_SOURCE_Z = -1;

	MY._AMMOTYPE = 0.0;            // type 0 with unlimited ammo
	MY._WEAPONNUMBER = 1;          // weapon 1
	MY._BULLETSPEED = -500.05;     // speed/range . 5 recoil
	MY._FIRETIME = 2;
	MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_SPARKS+HIT_FLASH+0.30+GUNFX_BRASS;

	// Always end with a call to 'gun_givePlayer'
	gun_givePlayer();
}

// Desc: init a gun, give it to the player, and select it
// Note: see the Action 'startgun1' to see how to use this function
function	gun_givePlayer()
{
	gun();   // init the gun

	MY.ENABLE_SCAN = OFF;
	MY.ENABLE_CLICK = OFF;
	MY.ENABLE_PUSH = OFF;

	if(INT(MY._AMMOTYPE) == 1) { ammo1 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5); }
	if(INT(MY._AMMOTYPE) == 2) { ammo2 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5); }
	if(INT(MY._AMMOTYPE) == 3) { ammo3 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5);	}
	if(INT(MY._AMMOTYPE) == 4) { ammo4 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5);	}
	if(INT(MY._AMMOTYPE) == 5) { ammo5 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5);	}
	if(INT(MY._AMMOTYPE) == 6) { ammo6 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5);	}
	if(INT(MY._AMMOTYPE) == 7) { ammo7 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5);	}
	MY._AMMOTYPE = INT(MY._AMMOTYPE);	// ammo type
	_ammo_limit();

	weapon_number = MY._WEAPONNUMBER;
	if(weapon_number == 1) {  weapon1 = ME; weapon_1 = 1;  ON_1 = _gun_select1;  msg.STRING = got_gun1_str; }
	if(weapon_number == 2) {  weapon2 = ME; weapon_2 = 1;  ON_2 = _gun_select2;  msg.STRING = got_gun2_str; }
	if(weapon_number == 3) {  weapon3 = ME; weapon_3 = 1;  ON_3 = _gun_select3;  msg.STRING = got_gun3_str; }
	if(weapon_number == 4) {  weapon4 = ME; weapon_4 = 1;  ON_4 = _gun_select4;  msg.STRING = got_gun4_str; }
	if(weapon_number == 5) {  weapon5 = ME; weapon_5 = 1;  ON_5 = _gun_select5;  msg.STRING = got_gun5_str; }
	if(weapon_number == 6) {  weapon6 = ME; weapon_6 = 1;  ON_6 = _gun_select6;  msg.STRING = got_gun6_str; }
	if(weapon_number == 7) {  weapon7 = ME; weapon_7 = 1;  ON_7 = _gun_select7;  msg.STRING = got_gun7_str; }

	if(MY.__SILENT != ON) { show_message(); }
	gun_select();
}



//////////////////////////////////////////////////////////////////////

// Desc: fire weapon
function weapon_fire()
{
	weapon_firing = 1;
 	while(KEY_CTRL || MOUSE_LEFT) { wait(1); }
	weapon_firing = 0;
}

// Desc: deselect weapon
function weapon_remove()
{
	if(weapon != NULL)
	{
		weapon.INVISIBLE = ON;
		weapon = NULL;
		weapon_number = 0;
	}
}

// Desc: put weapons and ammo to inital state
//
//]- Mod: 04/11/00 DCP
//]-Added ammo5, ammo6, & ammo7
function weapon_init()
{
	weapon_remove();
	ammo1 = 0;
	ammo2 = 0;
	ammo3 = 0;
	ammo4 = 0;
	ammo5 = 0;
	ammo6 = 0;
	ammo7 = 0;
	weapon_1 = 0;
	weapon_2 = 0;
	weapon_3 = 0;
	weapon_4 = 0;
	weapon_5 = 0;
	weapon_6 = 0;
	weapon_7 = 0;
	weapon_number = 0;
}

//////////////////////////////////////////////////////////////////////

string	anim_gun_shot = "shot"; 	// gun animation string
												// used in 'gun_animate()'

// Desc: animate the gun model using _FIRETIME and _FIRE
//
// Mod: 07/25/01	DCP
//		Created
function	gun_animate()
{
	while(MY._FIRE > 0)
	{
		// play one cycle
		temp = ((MY._FIRETIME - MY._FIRE)/ MY._FIRETIME) * 100;
		ent_cycle(anim_gun_shot,temp);
		wait(1);
	}
	ent_frame(anim_gun_shot,0); 	// return to base frame
}


// Desc:  Handle the player firing the gun
//
//]- Mod: 6/14/00 DCP
//]-			Added a WAIT 1 so bullet does not collide with muzzle_flash
//]-
// Mod:  04/11/01 DCP
//		Added ammo5, ammo6, & ammo7
//
// Mod:  04/17/01 DCP
//		Make player passable before calling 'gun_shot' (restore afterwords)
//
// Mod:  04/18/01 DCP
//		Calculate 'gun_source' here now. Set 'gun_source[3] = 9' so gun_shot
//	knows to use the 'gun_source' vector for traces.
//	 	Modified 3rd person 'gun_source', 'gun_muzzle', & 'gun_target' calculation
//	(no longer depends on cammera location)
//
// Mod:  04/18/01 DCP
//		Replaced goto no_ammo with _gun_fire_no_ammo();
//
// Mod: 07/25/01 DCP
//	Added check for gun animation (calls "gun_animate()").
//
// Mod: 05/13/02 DCP
//	Added a local var "my_gun_target" to save the gun_target value during a wait command
function gun_fire()
{
	// check to make sure we have ammo
	// if so, reduce ammo# count by one
	// else got 'no_ammo'
	if(MY._AMMOTYPE == 1)
	{
		if(ammo1 > 0) { ammo1 -= 1; }
		else{ _gun_fire_no_ammo(); return; }
	}
	if(MY._AMMOTYPE == 2)
	{
		if(ammo2 > 0) { ammo2 -= 1; }
		else{ _gun_fire_no_ammo(); return; }
	}
	if(MY._AMMOTYPE == 3)
	{
		if(ammo3 > 0) { ammo3 -= 1; }
		else{ _gun_fire_no_ammo(); return; }
	}
	if(MY._AMMOTYPE == 4)
	{
		if(ammo4 > 0) { ammo4 -= 1; }
		else{ _gun_fire_no_ammo(); return; }
	}
	if(MY._AMMOTYPE == 5)
	{
		if(ammo5 > 0) { ammo5 -= 1; }
		else{ _gun_fire_no_ammo(); return; }
	}
	if(MY._AMMOTYPE == 6)
	{
		if(ammo6 > 0) { ammo6 -= 1; }
		else{ _gun_fire_no_ammo(); return; }
	}
	if(MY._AMMOTYPE == 7)
	{
		if(ammo7 > 0) { ammo7 -= 1; }
		else{ _gun_fire_no_ammo(); return; }
	}

   gun_loaded = 0;

	// place muzzle flash
	if((person_3rd != 0) && (player != NULL))
	{
		MY_POS.X = player.MAX_X - player.MIN_X;
		MY_POS.Y = 0;
		MY_POS.Z = 0;
 		vec_rotate(MY_POS,player.PAN);
		MY_POS.X += player.X;
 		MY_POS.Y += player.Y;
 		MY_POS.Z += player.Z;
	}
	else
	{
		MY_POS.X = MY.SKILL1 + MY._OFFS_FLASH;
		MY_POS.Y = -MY.SKILL2;
		MY_POS.Z = -MY.SKILL3;
		_set_pos_ahead_xyz();
	}
	vec_set(gun_muzzle.X,MY_POS.X);
	create(muzzle_flash,gun_muzzle,_flashup);

	// calculate target
	MY_POS.X = MY._BULLETSPEED;
	if((person_3rd != 0) && (player != NULL))
	{
		MY_POS.Y = 0;
		MY_POS.Z = 0;
 		vec_rotate(MY_POS,player.PAN);
		MY_POS.X += player.X;
 		MY_POS.Y += player.Y;
 		MY_POS.Z += player.Z;
	}
	else
	{
		MY_POS.Y = -MY.SKILL2;
		MY_POS.Z = -MY.SKILL3;
		_set_pos_ahead_xyz();
	}
	var	my_gun_target[3];            // use local var to save gun_target value over the wait command
	vec_set(my_gun_target.X,MY_POS.X);

	wait(1); // allow muzzle_flash to become passable (so bullet does not hit it!)

	vec_set(gun_target.x,my_gun_target.x);

	// place gun trace source back (DCP fix 04/13/01)
	if((person_3rd != 0) && (player != NULL))
	{
		MY_POS.X = (player.MAX_X - player.MIN_X);
		MY_POS.Y = 0;
		MY_POS.Z = 0;

 		vec_rotate(MY_POS,player.PAN);
		MY_POS.X += player.X;
 		MY_POS.Y += player.Y;
 		MY_POS.Z += player.Z;
	}
	else
	{
		MY_POS.X = MY._GUN_SOURCE_X;//?-(player.MAX_X - player.MIN_X)/2; //--MY.SKILL1 + MY._OFFS_FLASH;
		MY_POS.Y = MY._GUN_SOURCE_Y;//? -MY.SKILL2;
		MY_POS.Z = MY._GUN_SOURCE_Z;//?-MY.SKILL3;
  		_set_pos_ahead_xyz();
	}
	vec_set(gun_source.X,MY_POS.X);
	gun_source[3] = 9;             // mark this as 'player fired'

   // emit a bullet or particle
	shot_speed.X = (gun_target.X - gun_source.X);
	shot_speed.Y = (gun_target.Y - gun_source.Y);
	shot_speed.Z = (gun_target.Z - gun_source.Z);

	damage = MY._DAMAGE;
	fire_mode = MY._FIREMODE;

	// if player is not already passable
	if(player.passable == OFF)
	{
		player.passable = ON;   // make it so the gun doesn't hit the player

		gun_shot();   				// fire the shot
 		player.passable = OFF;
	}
	else
	{
		gun_shot();
	}

	MY._FIRE = MY._FIRETIME;

	// animate gun?
	if((fire_mode & GUNFX_ANIMATE) != 0)
	{
	 	gun_animate(); // animate gun cycle
	}

	MY._DISPLACEMENT = MY._RECOIL;
	while(MY._FIRE > 0)
	{
		wait(1);
 		// rock back into place from recoil
		MY._DISPLACEMENT *= 0.6;
		MY._FIRE -= TIME;
	}
	MY._DISPLACEMENT = 0 ;
	MY._FIRE = 0 ;

	if(MY.__REPEAT == ON) { gun_loaded = 1;}
}

// Desc: handle gun_fire's no ammo case
//		(play 'gun_click' noise at half volume)
//
// Note: entity (ME) must be valid
//
// Mod 04/19/01 DCP
//		Created
function _gun_fire_no_ammo()
{
	PLAY_ENTSOUND(ME,gun_click,50);
}

var	_gun_shot_temp[3];     // 'local' temp vector
var	_gun_shot_sCount;      // 'local' counter
var	scatter_number = 6;   	// number of SCATTER rounds
DEFINE	SCATTER_RAND, 160;      // SCATTER width
DEFINE	SCATTER_HALF_RAND, 80;

// Desc: select and handle shot type using 'fire_mode'
//
// needs gun_muzzle,shot_speed,damage,fire_mode
//
//]- Mod:	6/14/00 Doug Poston
//]-			uses _hit_point_effect() for SHOOT bullets
//]- Mod:	6/14/00 Doug Poston
//]-			added placeholder for darkshot particles
//]-			when functions can take parameters, use a color para for particle_shot()
//]- Mod:	8/15/00 JCL
//]-			modified FIRE_PARTICLE to produce a particle_line effect
//]- Mod:  10/18/00 DCP
//]-			replace SHOOT with trace
//]- Mod:  12/11/00 DCP
//]-			add weaponTmpSyn to store/restore YOU value when using a laser
//]-		 (so bullethole and other effects will continue to work).
//]- Mod:  04/13/01 DCP
//]-			Modify trace to calculate and use 'gun_source' instead of 'gun_muzzle'
//]- Mod:  04/17/01 DCP
//]-			Use  MY._GUN_SOURCE_X/Y/Z to calculate 'gun_source' while in 1st person
//]-			Changed to function.
//]- Mod:  04/18/01 DCP
//]-			Moved gun_source calculate outside, if gun_source[3] == 9, then use the
//]-		gun_source for tracing, else use gun_muzzle (backwards compatable)
//]-
//]- Mod: 04/20/01 DCP
//]-			Replace "damage shot" section of code with call to '_gun_shot_damage_shoot'
//]-			Implemented HIT_SCATTER. If HIT_SCATTER flag is set in 'fire_mode' fire
//]-		'scatter_number' shots each randomly offset by the SCATTER_RAND amount.
function gun_shot()
{
	// select and handle shot type using 'fire_mode'

	// particle trail shot (line of particles)
	if((fire_mode & MODE_FIRE) == FIRE_PARTICLE)
	{
		vec_set(p,gun_muzzle);
		vec_set(p2,gun_target);
		particle_line();
	}

	// single particle
	if((fire_mode & MODE_FIRE) == FIRE_DPARTICLE)
	{ emit(1,gun_muzzle,particle_shot); }

	// fireball
	if((fire_mode & MODE_FIRE) == FIRE_BALL)
	{ create(fireball,gun_muzzle,bullet_shot); }

	// rocket model
	if((fire_mode & MODE_FIRE) == FIRE_ROCKET)
	{ ent_create(strRocket_Model,gun_muzzle,rocket_launch); }

	// eject brass?
	if((fire_mode & GUNFX_BRASS) != 0)
	{
	 	emit(1,gun_muzzle,particle_gunBrass); // emit brass
	}


	// bullet damage is done with a trace
	if((fire_mode & MODE_DAMAGE) == DAMAGE_SHOOT)
	{
		// set gun_target
		gun_target.X = 2*shot_speed.X + gun_muzzle.X;
		gun_target.Y = 2*shot_speed.Y + gun_muzzle.Y;
		gun_target.Z = 2*shot_speed.Z + gun_muzzle.Z;

		if((fire_mode & HIT_SCATTER) != 0)	// scatter gun?
		{
			vec_set(_gun_shot_temp.X, gun_target.X);	// save base gun_target

			_gun_shot_sCount = 0;
			while(_gun_shot_sCount < scatter_number)
			{
				// offset each shot by a random amount
				gun_target.X = _gun_shot_temp.X + (Random(SCATTER_RAND)-SCATTER_HALF_RAND);
				gun_target.Y = _gun_shot_temp.Y + (Random(SCATTER_RAND)-SCATTER_HALF_RAND);
				gun_target.Z = _gun_shot_temp.Z + (Random(SCATTER_RAND)-SCATTER_HALF_RAND);
				_gun_shot_damage_shoot();
				_gun_shot_sCount += 1;
			}
			vec_set(gun_target.X, _gun_shot_temp.X);	// restore  gun_target
 		}
		else
		{
			// fire one shot
 			_gun_shot_damage_shoot();
		}

	}
}


// Desc: handle DAMAGE_SHOOT shots from function 'gun_shot'
//
// Note: helper function for gun_shot
//
/* help The follow must be set before calling:
		gun_source: source of the shot (x,y,z)
				NOTE: gun_source used "only" if gun_source[3] is set to 9
				NOTE2: if gun_source[3] == 9, then it is set to 0
		gun_muzzle: source of the shot (x,y,z) if gun_source[3] != 9
		gun_target: target of the weapon fire (x,y,z)
		shot_speed: used for effects such as the laser

*/
// Mod 04/20/01 DCP
//		Created
//
// Mod 05/13/02 DCP
//		Calculate/Recalculate 'shot_speed' for laser effect.
function _gun_shot_damage_shoot()
{
		indicator = _GUNFIRE;	// indicator for the entity that was hit
		trace_mode = IGNORE_ME + IGNORE_PASSABLE + ACTIVATE_SHOOT;
		if(gun_source[3] == 9) 	// player firing?
		{
			// use gun_source
//--CREATE(<ARROW.PCX>,gun_source,_test_arrow);   // used to test gun_source
 			RESULT = trace(gun_source,gun_target);
			gun_source[3] = 0;	// reset value
			vec_set(gun_muzzle,gun_source);				// important for when/if we calculate shot_speed
		}
		else
		{
			// use gun_muzzle
//--CREATE(<ARROW.PCX>,gun_muzzle,_test_arrow);   // used to test gun_muzzle
	 		RESULT = trace(gun_muzzle,gun_target);
		}

		if((fire_mode & MODE_FIRE) == FIRE_LASER)
		{
			weaponTmpSyn = YOU;  // save YOU value (used for bullet holes)
			vec_diff(shot_speed,gun_target,gun_muzzle);
			create(<lbeam.mdl>,gun_muzzle,laser_fire);  // uses TARGET & RESULT
			YOU = weaponTmpSyn;	// restore YOU value
		}

   	if(RESULT > 0)
		{ // hit something?
			_hit_point_effect();	// send fire_mode and TARGET
		}
}

///////////////////////////////////////////////////////////////////////
// Desc: hit flash
//
//]- Mod Date: 8/31/00 DCP
//]-		Scaled by actor_scale
function _blowup()
{
	MY.SCALE_X = 2;
	MY.SCALE_Y = 2;
	vec_scale(MY.SCALE_X,actor_scale);

	MY.PASSABLE = ON;
	MY.FACING = ON;
	MY.NEAR = ON;
	MY.FLARE = ON;
	MY.AMBIENT = 100;
	MY.LIGHTRED = light_flash.RED;
	MY.LIGHTGREEN = light_flash.GREEN;
	MY.LIGHTBLUE = light_flash.BLUE;
	MY.LIGHTRANGE = 64;
	wait(1);
	PLAY_ENTSOUND ME,hit_wham,300;
	remove(ME);
}

// Desc: muzzle flash
//
//]- Mod Date: 8/31/00 DCP
//]-		Scaled by actor_scale
function _flashup()
{
	MY.SCALE_X = 2;
	MY.SCALE_Y = 2;
	vec_scale(MY.SCALE_X,actor_scale);

	MY.PASSABLE = ON;
	// Set flare only in D3D mode
	if(VIDEO_MODE > 8) { MY.FLARE = ON; }
	else{ MY.TRANSPARENT = ON; }

	MY.FACING = ON;
	MY.AMBIENT = 100;
	MY.LIGHTRED = light_muzzle.RED;
	MY.LIGHTGREEN = light_muzzle.GREEN;
	MY.LIGHTBLUE = light_muzzle.BLUE;
	MY.LIGHTRANGE = 100;
	wait(1);
	PLAY_SOUND gun_wham,50;
	remove(ME);
}


//]- Mod Date: 02/06/01 DCP
//]-			Added wait before shoot command to remove 'Dangerous instruction error'
function _fireball_event()
{
	// check for all collision events
	if(EVENT_TYPE == EVENT_BLOCK
		|| EVENT_TYPE == EVENT_ENTITY
		|| EVENT_TYPE == EVENT_STUCK
		|| EVENT_TYPE == EVENT_IMPACT
		|| EVENT_TYPE == EVENT_PUSH)
	{
		wait(1);// added to avoid Dangerous instruction
		EXCLUSIVE_ENTITY;	// terminate other actions, to stop moving
		MY.EVENT = NULL;

 		range = MY._DAMAGE * 3;
		damage = MY._DAMAGE;
 		temp.PAN = 360;
		temp.TILT = 180;
		temp.Z = range;
		indicator = _EXPLODE;	// must always be set before scanning
		scan(MY.POS,MY_ANGLE,temp);

		morph BULLET_EXPLO,ME;
		MY._DIEFRAMES = EXPLO_FRAMES;
		actor_explode();
	}
}


// Desc: event attached to rocket
//			Explode the rocket.
//
//]- Mod Date: 6/13/00 Doug Poston
//]-				Created
//
// Mod Date: 6/07/02 DCP
//		Added wait before scan to avoid "dangerous instruction in event"
function _rocket_event()
{
	proc_kill(1);	//EXCLUSIVE_ENTITY;	// terminate other functions started by 'my' to stop moving
	MY.EVENT = NULL;
	MY.SKILL9 = -1;   // stop movement


	wait(1);	// to avoid dangerous instruction in event warning
	// Apply damage
	range = MY._DAMAGE * 6;
	damage = MY._DAMAGE;
 	temp.PAN = 360;
	temp.TILT = 360;
	temp.Z = range;
	indicator = _EXPLODE;	// must always be set before scanning
	scan(MY.POS,MY_ANGLE,temp);

  	// Explode
	morph <explo+7.pcx>, ME;
	MY.AMBIENT = 100;
	MY.FACING = ON;
	MY.NEAR = ON;
  	MY.FLARE = ON;

	MY.PASSABLE =  ON;
	MY.AMBIENT = 100;
	MY.LIGHTRED = light_flash.RED;
	MY.LIGHTGREEN = light_flash.GREEN;
	MY.LIGHTBLUE = light_flash.BLUE;
	MY.LIGHTRANGE = 64;
	wait(1);

	play_entsound ME,hit_wham,300;
	while(MY.CYCLE <= 7)
	{
		MY.CYCLE += TIME;
		waitt(1);
	}

	remove(ME);
}




// runs a bullet; requires shot_speed, damage, fire_mode to be set
//
// Note: called from gun_shot
//
//]- Mod Date: 8/31/00 DCP
//]-				Scale fireball_speed by movement_scale
//]-				Scaled entity by actor_scale
//]-
// Mod Date: 05/17/01 DCP
//			Changed to function.
//
// Mod Date: 06/08/01 DCP
//			Replaced move() with ent_move()
//
function bullet_shot()
{
	vec_scale(MY.SCALE_X,actor_scale);	// use actor_scale

	MY.ENABLE_BLOCK = ON;
	MY.ENABLE_ENTITY = ON;
	MY.ENABLE_STUCK = ON;
	MY.ENABLE_IMPACT = ON;
	MY.ENABLE_PUSH = ON;
	MY.EVENT = _fireball_event;

	MY.FACING = ON;	// in case of fireball

	MY.LIGHTRED = light_bullet.RED;
	MY.LIGHTGREEN = light_bullet.GREEN;
	MY.LIGHTBLUE = light_bullet.BLUE;
	MY.LIGHTRANGE = 100;
	MY.AMBIENT = 100;

	MY.SKILL2 = shot_speed.x;
	MY.SKILL3 = shot_speed.y;
	MY.SKILL4 = shot_speed.z;
	MY._DAMAGE = damage;
	MY._FIREMODE = fire_mode;

  	// my.near is set by the explosion
	while(MY.NEAR != ON)
	{
		wait(1); // wait at the loop beginning, to let it appear at the start position

		temp = TIME;
		if(temp > 1.5) { temp = 1.5; }	// make bullet slower on slow PCs
// MOVE moves by a distance, so multiply the speed by time.
		fireball_speed.x = MY.SKILL2 * temp;
		fireball_speed.y = MY.SKILL3 * temp;
		fireball_speed.z = MY.SKILL4 * temp;

		if((MY._FIREMODE & BULLET_SMOKETRAIL) == BULLET_SMOKETRAIL)
		{
			temp = 3 * TIME;
			if(temp > 6) { temp = 6; }	// generate max 6 particels
			emit(temp,MY.POS,particle_fade); 	// smoke trail
		}

		vec_scale(fireball_speed,movement_scale);	// scale fireball_speed by movement_scale
 		//--move(ME,nullskill,fireball_speed);
		move_mode = ignore_you + ignore_passable + activate_trigger;
		result = ent_move(nullskill,fireball_speed);
	}
}




// Desc: launch a rocket (models)
//
//]- Mod Date: 6/13/00 Doug Poston
//]-				Created
//]- Mod Date: 8/31/00 DCP
//]-				Scale rocket movement by movement_scale
//]-				Scale rocket size by actor_scale
//]-
//]- Mod:  04/18/01 DCP
//]-    	Use 'vec_to_angle' and shot_speed to determine rocket orientation
//
// Mod:  06/08/01 DCP
//			Replaced move() with ent_move()
function rocket_launch()
{
	vec_scale(MY.SCALE_X,actor_scale);	// use actor_scale

 	MY.ENABLE_BLOCK =  ON;      // collision with map surface
	MY.ENABLE_ENTITY =  ON;     // collision with entity
 	MY.ENABLE_STUCK = ON;
	MY.ENABLE_IMPACT = ON;
	MY.ENABLE_PUSH = ON;
 	MY.EVENT = _rocket_event;

	MY.AMBIENT = 100;  // bright
	MY.LIGHTRANGE = 150;
	MY.LIGHTRED = 250;
	MY.LIGHTGREEN = 50;
	MY.LIGHTBLUE = 50;

//- 	MY.PAN = YOUR.PAN; // the rocket start in the same direction than this 'emitter'
//- 	MY.TILT = YOUR.TILT;
//- 	MY.ROLL = YOUR.ROLL;
	vec_to_angle(MY.PAN, shot_speed);

	MY.SKILL2 = shot_speed.x;
	MY.SKILL3 = shot_speed.y;
	MY.SKILL4 = shot_speed.z;
	MY._DAMAGE = damage;
	MY._FIREMODE = fire_mode;

	MY.SKILL9 = 250; // 'burn time'  (fuel)
	while(MY.SKILL9 > 0)
	{
		temp.X = MY.SKILL2 * TIME;
		temp.Y = MY.SKILL3 * TIME;
		temp.Z = MY.SKILL4 * TIME;
  		vec_scale(temp,movement_scale);	// scale distance by movement_scale
//--		move(ME,NULLSKILL,temp);
		move_mode = ignore_you + ignore_passable + activate_trigger;
		result = ent_move(nullskill,temp);

		emit(3,MY.POS,particle_smoke);	// emit( smoke
		MY.SKILL9 -= TIME;  // burn fuel
		wait(1);     // update position once per tick
	}
	_rocket_event();   // explode when out of fuel
}



// Desc: actor "explode" :
//				face camera
//				play explosion sound
//				animate frames
//		  		remove
ACTION actor_explode
{
	MY.FACING = ON;	// face the camera
	MY.NEAR = ON;
	MY.FLARE = ON;
	MY.PASSABLE = ON;	// don't push the player through walls
	MY.FRAME = 1;
	wait(1);

	PLAY_ENTSOUND ME,explo_wham,1000;
	MY.LIGHTRED = light_explo.RED;
	MY.LIGHTGREEN = light_explo.GREEN;
	MY.LIGHTBLUE = light_explo.BLUE;
	MY.AMBIENT = 100;
	MY.LIGHTRANGE += 50;

	// use the new sprite animation
	while(MY.FRAME < MY._DIEFRAMES)
	{
		wait(1);
		MY.LIGHTRANGE += 15;
		MY.LIGHTRED += 20 * TIME;	// fade to red
		MY.LIGHTBLUE -= 20 * TIME;
		MY.FRAME += TIME;
	}
	wait(1);
	remove(ME);
}


// Desc: create a hit point 'effect' depending on (fire_mode & MODE_HIT) value
//
// Input:fire_mode
//			TARGET
//
//]- 		6/14/00 Doug Poston
//]-
function _hit_point_effect()
{
	// flash at hit point?
	if((fire_mode & MODE_HIT) == HIT_FLASH)
	{
		weaponTmpSyn = YOU;  // save YOU value
		create(small_flash,TARGET,_blowup);
		YOU = weaponTmpSyn;
	}

	// smoke at hit point?
	if(fire_mode & HIT_SMOKE)
	{
	 	emit(20,TARGET,particle_smoke); // emit smoke
	}

	if(fire_mode & HIT_SPARKS)
	{
		emit(20,TARGET,particle_scatter); // emit sparks
	}

	// bullet hole ***
	if(fire_mode & HIT_HOLE)
	{
		if(YOU == NULL)	// hit wall (not entity)
		{
			create(bullethole_map,TARGET,bullet_hole);  // create bullet hole
		}
	}
}


var	bullet_hole_index = 0;
DEFINE	kMaxBulletHole	100;
var	h_bullet_hole_array[kMaxBulletHole];
entity* p_bullet_hole_temp;

// Desc: bullet hole
//
// Mod Date: 07/14/01
//		Use new handles to turned it into an FIFO array
// Mod Date: 07/16/01
//		Fixed index problem with remove (use SKILL4 to store local index)
// PROBLEM: 07/26/01
//		If you change levels with 'outstanding' bullet holes you will get
//	'WDL Crash' errors when this function tries to remove the hole from the
//	previous level. Solution: clear all bullet_holes before switching levels
//	by calling 'bullet_hole_remove_all()'.
function bullet_hole()
{
	// check for maximum bullet holes at any time
	if(bullet_hole_index >= kMaxBulletHole)
	{
		bullet_hole_index = 0;
	}

	// check to see if its already in use
	temp = h_bullet_hole_array[bullet_hole_index];
	if(temp != 0)
	{
		// remove old hole
		p_bullet_hole_temp = ptr_for_handle(temp);
		remove(p_bullet_hole_temp);
	}

	// assign this as the new value in the array
	h_bullet_hole_array[bullet_hole_index] = handle(ME);
	MY.SKILL4 = bullet_hole_index;  // save index for removal

	bullet_hole_index += 1;		// increament index

	MY.TRANSPARENT = ON;
	MY.FLARE = ON;
	MY.PASSABLE = ON;

	MY.ORIENTED = ON;

	vec_to_angle(MY.PAN,NORMAL);	// rotate to target normal

	waitt(160);          // time bullet stays before vanishing

	// alpha fade
	while(MY.ALPHA > 0)
	{
		MY.ALPHA -= TIME;
		waitt(1);
	}

	h_bullet_hole_array[MY.SKILL4] = 0;	// zero out pointer
	remove(ME);
}

// Desc: remove all bullet holes
// Note: Call this before changing levels.
function	bullet_hole_remove_all()
{
	bullet_hole_index = 0;
	while(bullet_hole_index < kMaxBulletHole)
	{
		temp = h_bullet_hole_array[bullet_hole_index];
		if(temp != 0)
		{
			// remove old hole
			p_bullet_hole_temp = ptr_for_handle(temp);
			remove(p_bullet_hole_temp);
			h_bullet_hole_array[bullet_hole_index] = 0;	// zero out pointer
		}
		bullet_hole_index += 1;
	}
}



// Desc: scale and remove the laser beam
//
// Uses: TARGET,
//
// ToDo: make work in 3D player mode
//
// Mod:  04/18/01 DCP
// 	Use 'vec_to_angle' and shot_speed to determine beam orientation
//
// Mod: 08/01/01 DCP
//		Made laser brighter
function	laser_fire()
{
	MY.PASSABLE = ON;
   MY.LIGHT = ON;       // illuminate myself
	MY.LIGHTRED = 255;   // red laser
	MY.TRANSPARENT = ON;
	MY.ALPHA = 95;
	MY.BLEND = ON;
	MY.FLARE = ON;

	if(RESULT == 0)
	{
		// set the lightrange
		MY.LIGHTRANGE =  vec_length(shot_speed)/2;
		// scale the beam
		MY.SCALE_X = MY.LIGHTRANGE/50;
		// move the beam (center halfway to target)
		vec_add(MY.X,shot_speed.X);

	}
	else
	{
		// set the lightrange
		MY.LIGHTRANGE = RESULT/2;//200;

		MY.SCALE_X = RESULT/200.0; // 200 = beam length
		// move the beam (center halfway to target)
		vec_set(temp,TARGET);	// temp = TARGET
		vec_sub(temp,ME.X);     // temp = TARGET - ME.X
		vec_scale(temp,0.5);    // temp = (TARGET - ME.X)/2
		vec_add(MY.X,temp);
	}
//-	vec_set(MY.PAN,YOUR.PAN);	// rotate the beam
	vec_to_angle(MY.PAN, shot_speed);



	WAITT(4);
	REMOVE(ME);

}

////////////////////////////////////////////////////////////////////////
// Cross-hair panel and functions
//
// Use the var 'cross_pos.x' and 'cross_pos.y' you adjust the position
//of the cross-hair on the screen

BMAP	cross_bmp, <cross.pcx>;
var cross_pos[2] = 0, 0;	// position of cross-hair on screen

PANEL	cross_pan
{
	bmap = cross_bmp;
	layer = 1;
	flags = overlay, transparent, refresh, d3d;
}

// Desc: position the cross-hair panel at the center of the screen
//		and make it visible.
function	pan_cross_show()
{
	cross_pan.pos_x = (screen_size.x / 2) + cross_pos.x;
	cross_pan.pos_y = (screen_size.y / 2) + cross_pos.y;
	cross_pan.visible = ON;

}

// Desc: hide the cross-hair panel
function	pan_cross_hide()
{
	cross_pan.visible = OFF;
}


// Desc: toggle cross-hair panel
function	pan_cross_toggle()
{
	if(cross_pan.visible == OFF) { pan_cross_show(); }
	else { pan_cross_hide(); }
}



// desc: helper function for "do_explosion". Draws an animated sprite.
function _do_explosion_sprite()
{
	MY.AMBIENT = 100;
	MY.FACING = ON;
	MY.NEAR = ON;
  	MY.FLARE = ON;

	MY.PASSABLE =  ON;
	MY.AMBIENT = 100;
	MY.LIGHTRED = light_flash.RED;
	MY.LIGHTGREEN = light_flash.GREEN;
	MY.LIGHTBLUE = light_flash.BLUE;
	MY.LIGHTRANGE = 64;
	wait(1);
	// play sound
	// must wait one turn before we can play the sound
   ent_playsound(ME,hit_wham,3000);

	// animate
 	while(MY.CYCLE <= 16)
	{
		MY.CYCLE += TIME;
		wait(1);
	}

	remove(me);
}


// desc: helper function for "do_explosion". Draws an animated model.
function _do_explosion_model()
{
	var	my_scale_max;

	my_scale_max = range/32;    // explosion model has a width of 32 quants

	MY.TRANSPARENT = ON;
	MY.ALPHA = 45;
	MY.PASSABLE = ON;	// don't push the player through walls

	MY.LIGHTRED = 255;
	MY.LIGHTGREEN = 128;
	MY.LIGHTBLUE = 128;
	MY.AMBIENT = 100;
	MY.LIGHTRANGE = 50;

	MY.SCALE_X = 1;

	wait(1);
	// play sound
	// must wait one turn before we can play the sound
   ent_playsound(ME,hit_wham,(my_scale_max*64));

	// use the new sprite animation
	while(MY.SCALE_X < my_scale_max)
	{
		MY.LIGHTRANGE = 64 * MY.SCALE_X;
		MY.PAN += 15*TIME;
		MY.TILT += 5*TIME;
		temp = 0.95 * TIME;
		MY.SCALE_X += temp;
		MY.SCALE_Y += temp;
		MY.SCALE_Z += temp;
 		wait(1);
	}
	remove(ME);
}


// desc: handle an explosion which does 'blast damage' by using scan_entity
//
//		my_blast_range: range in quants of the blast
//		my_blast_damage: max damage (damage goes from 100% at center to 0% at the edge)
//		my_graphic_type: type of 'blast animation' to use
//					0 - explosion sprite
//					1 - explosion model
//
// help: my must be defined to use this function.
function do_explosion(my_blast_range,my_blast_damage,my_graphic_type)
{
	range = my_blast_range;

	// choose graphic type
	if(my_graphic_type == 0)
	{
		ent_create(strExplode_Sprite,my.x,_do_explosion_sprite); // create an explosion sprite
	}
	else
	{
		if(my_graphic_type == 1)
		{
			ent_create(strExplode_Model,my.x,_do_explosion_model); // create an explosion sprite
		}
	}



	// Apply damage
	damage = my_blast_damage;
 	temp.PAN = 360;
	temp.TILT = 360;
	temp.Z = range;
	indicator = _EXPLODE;	// must always be set before scanning
	scan_entity(MY.x,temp);


}

// skills for demolision pack
DEFINE _DEMOPACK_TIMER,SKILL1;
DEFINE _DEMOPACK_BLASTRANGE,SKILL2;
DEFINE _DEMOPACK_DAMAGE,SKILL3;

// desc: count down from a set value and explode
//
// uses _DEMOPACK_TIMER, _DEMOPACK_BLASTRANGE, _DEMOPACK_DAMAGE
action	demolition_pack
{
	waitt(my._DEMOPACK_TIMER * 16);

  	do_explosion(MY._DEMOPACK_BLASTRANGE,MY._DEMOPACK_DAMAGE,1); // Explode

	remove(me);
}

/////////////////////////////////////////////////////////////
// ON_KEY Define
ON_CTRL weapon_fire;
ON_MOUSE_LEFT weapon_fire;

ON_E gun_select_cycle_up;
ON_Q gun_select_cycle_down;

ON_K	pan_cross_toggle;