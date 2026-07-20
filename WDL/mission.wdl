///////////////////////////////////////////////////////////////////////////////////
// THE MISSION by Czeslav Gorski
///////////////////////////////////////////////////////////////////////////////////
PATH "..\\TEMPLATE";  // Change this, depending on your directory location!

///////////////////////////////////////////////////////////////////////////////////
// redefinitions for the template wdl scripts
DEFINE MSG_DEFS;
DEFINE MSG_X,4;	// from left
DEFINE MSG_Y,4;	// from above
DEFINE BLINK_TICKS,6;
DEFINE MSG_TICKS,64;
DEFINE PANEL_POSX,4;	// from left
DEFINE PANEL_POSY,-20;	// from below
FONT digit_font,<digfont.pcx>,12,16;
FONT standard_font,<ackfont.pcx>,6,9;
FONT msg_font,<msgfont.pcx>,12,16;
SOUND	msg_sound,<msg.wav>;

///////////////////////////////////////////////////////////////////////////////////
INCLUDE <movement.wdl>;
INCLUDE <messages.wdl>;
INCLUDE <menu.wdl>;
INCLUDE <particle.wdl>;
INCLUDE <doors.wdl>;
INCLUDE <actors.wdl>;
INCLUDE <weapons.wdl>;
INCLUDE <war.wdl>;

///////////////////////////////////////////////////////////////////////////////////
// The following predefined 'keys' for operating the doors are used:
// key1 - CD, operates PC elevator
// key2 - 'door program', set by PC elevator, unlocks big_tor door
// key3 - MacGuffin, activates final message

IFDEF GERMAN;
STRING mission_str,
"IHRE MISSION - DEN MACGUFFIN SUCHEN!
HINWEIS - EIN MACGUFFIN SIEHT AUS WIE
EIN UEBERDIMENSIONALER LAMPENSCHIRM.";
IFELSE;
STRING mission_str,
"YOUR MISSION - GET THE MACGUFFIN!
HINT - A MACGUFFIN LOOKS LIKE
A GIANT LAMPSHADE.";
ENDIF;

IFDEF GERMAN;
STRING need_key1_str,"BITTE CD-ROM EINLEGEN";
STRING got_key1_str,"CD-ROM GEFUNDEN";
STRING ok_cd,"TORSPERRE DEAKTIVIERT";
STRING need_key2_str,"TORPROGRAMM LAEUFT NICHT!";
STRING got_key3_str,"MACGUFFIN GEFUNDEN!!\nJETZT AB NACH HAUSE";
STRING final_str,"DANKE, DASS SIE MISSION\nGESPIELT HABEN...";
IFELSE;
STRING need_key1_str,"PLEASE INSERT CD-ROM";
STRING got_key1_str,"FOUND A CD-ROM";
STRING ok_cd,"DOOR LOCK DEACTIVATED";
STRING need_key2_str,"DOOR SOFTWARE NOT RUNNING!";
STRING got_key3_str,"GOT MACGUFFIN!!\nNOW OUT OF HERE...";
STRING final_str,"THANK YOU FOR PLAYING MISSION...";
ENDIF;

//////////////////////////////////////////////////////////////
ACTION swingdoor { BRANCH door; }
ACTION klappe { BRANCH lid; }

ACTION init_med { SET MY.__ROTATE,ON; BRANCH medipac; }
ACTION ammo { SET MY.__ROTATE,ON; MY._AMMOTYPE = 1; BRANCH ammopac; }
ACTION init_ammo1 { SET MY.__ROTATE,ON; MY._AMMOTYPE = 1; BRANCH ammopac; }
ACTION init_ammo2 { SET MY.__ROTATE,ON; MY._AMMOTYPE = 2; BRANCH ammopac; }

ACTION init_cd { SET MY.__ROTATE,ON; MY._KEYTYPE = 1; BRANCH key; }

ACTION init_cdschalt {
	MY._KEYTYPE = 1;		// activated by CD (Key 1)
	CALL elevator;
	SET MY.EVENT,cdschalt;	// change event to display a message
}

ACTION cdschalt {
	IF (MY.SKILL17 == 1) { END; }	// must only move once
	CALL elevator_event;
	IF (MY.__MOVING == ON) {	// elevator started?
		MY.SKILL17 = 1;	// prevent repeated operation
		key2 = 1;			// unlock big_tor
		SET msg.STRING,ok_cd;
		CALL 	show_message;
	}
}

ACTION big_tor_norm { MY._PAUSE = 80; BRANCH gate; }
ACTION big_tor { MY._PAUSE = 80; MY._KEYTYPE = 2; BRANCH gate; }

ACTION init_crisstoff {	// that is the macguffin!
	SET MY.__ROTATE,ON; MY._KEYTYPE = 3; BRANCH key;
}

ACTION init_endlift { CALL	elevator; SET MY.EVENT,endlift_operate; }

ACTION endlift_operate {
	CALL	elevator_event;
	IF (key3) {	// macguffin taken?
		WAITT	32;
		SET	msg.STRING,final_str;
		CALL 	show_message;
	}
}

///////////////////////////////////////////////////////////////////////////////////
BMAP splashmap,<splash.pcx>;
PANEL splashscreen { BMAP splashmap; FLAGS REFRESH; }
SKILL VIDEO_MODE { VAL 6; }
SKILL VIDEO_DEPTH { VAL 16; }

MAIN main;
ACTION main {
	SET splashscreen.VISIBLE,ON;
	WAIT 2;
	LOAD_LEVEL <mission.wmb>;
	CALL load_status;	// restore global skills
IFNDEF test;
	WAITT	8;
ENDIF;
	SET  splashscreen.VISIBLE,OFF;
	CALL show_panels; // for Health und Ammo
	CALL init_sky;
	WAIT 1;
	SET  msg.STRING,mission_str;
	CALL show_message;
IFDEF test;
	mouseview = 0;	// prevent mouse movements while testing
	CALL set_debug;
ENDIF;
}




// OVERRIDE DEFAULT STRINGS in MOVEMENT.WDL
STRING anim_swim_str,"swimming";
STRING anim_jump_str, "jumpinwater";		// redefine the jump animation string
STRING anim_stand_str,"normal";
STRING anim_wade_str,"walk";//"wading";   // redefine wading animation to walking
														// (model wading looks like water treading)
// Desc: set up the player
//
// Mod: 6/14/00 Doug Poston
//		Converted to new movement code
ACTION player_prog
{
	MY.NARROW = ON;	// use narrow hull!
	MY.FAT = OFF;
 	MY.TRIGGER_RANGE = 5;
	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 0.75;
	MY._BANKING = -0.1;
	SET MY.__STRAFE,ON;
	SET MY.__BOB,ON;
	SET MY.__TRIGGER,ON;

	CALL player_walk;
	CALL player_fight;
	CALL drop_shadow;
}

///////////////////////////////////////////////////////////////////////////////////
ACTION init_sky {
	SKY_SPEED.X = 1;
	SKY_SPEED.Y = 1.5;
	CLOUD_SPEED.X = 3;
	CLOUD_SPEED.Y = 4.5;
	SKY_SCALE = 0.4;
	SKY_CURVE = 1;
}

SKILL TURB_SPEED { VAL 1; }
SKILL TURB_RANGE { VAL 1; }

/////////////////////////////////////////////////////////////////
// The following definitions are for the WDFC window composer
// to define the start and exit window of the application.
WINDOW WINSTART
{
	TITLE			"The Mission - A4 demo level";
	SIZE			480,320;
	MODE			IMAGE;	//STANDARD;
	BG_COLOR		RGB(240,240,240);
	FRAME			FTYP1,0,0,480,320;
	BUTTON		BUTTON_QUIT,SYS_DEFAULT,"Abort",400,288,72,24;
	TEXT_STDOUT	"Arial",RGB(0,0,0),10,10,460,280;
}

// Double jump_height (lower gravity)
VAR jump_height = 200; 	// maximum jump height above ground


INCLUDE <debug.wdl>;
/////////////////////////////////////////////////////////////////