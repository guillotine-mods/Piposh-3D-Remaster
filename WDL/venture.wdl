// Template file v5.202 (02/20/02)
////////////////////////////////////////////////////////////////////////
// File: venture.wdl
//		This script file contains actions that can be used to help create
//	adventure (RPG) type games.
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
//
// Notes: must be included after MENU.WDL
////////////////////////////////////////////////////////////////////////


/// GENERAL VENTURE SKILLS, STRINGS, AND DEFINES ////////////////////////
var venture_temp;			// temporary value used by venture.wdl actions
var venture_return;		// return value used by venture.wdl actions
var __ICON_ACTIVE = OFF;// flag: ON-let player view inventory, character stats,
								//      and the main menu.
DEFINE __BUSY,FLAG8; 	// used to avoid double triggered actions (similar to "MY_MOVING")

SOUND klick_snd, <klick.wav>;       // "klick" sound





/// GENERAL ADVENTURE TEXT PREDEFINE ////////////////////////
IFNDEF ADV_DEF_ADVENTURE_TEXT;		// predefine keyword
// use general purpose adventure text
STRING wrong_key_str, "This key doesn't fit!";
STRING wrong_item_str, "Try another item!";
STRING wrong_type_str, "Nothing happened!";
STRING level_info_str, "You made a level!
You may share   bonus points!";

// starting menu chooses
STRING start1_str, "


        Start new game

        Load game

        Exit Game";

STRING bonus_info_str,
  "\nYou may share   bonus points!      Finished";

// Character stats
STRING char_pan_str, "             Character Skills


   Hitpoints:   /       Bravery:

   Mana:        /       Intuition:

   Strength:    /       Level:

   Agility:             Experiencep.:

                        Next Level:
                        ";


// Online help
STRING help_str"Keyboard commands

F1  - Help           C  - Character
F2  - Save           I  - Inventory
F3  - Load       Space  - Weapon on/off
F10 - Exit         Home - Jump

Mouse Right       - Mouse on/off
Mouse Left / Ctrl - Fight
Pg Up / Pg Dn     - Look up/down";


// Main Menu string
STRING menu_str, //*
"


        Start new game

        Save game

        Load game

        Exit game

        Resume game

        Help

        Credits
        ";

// AD (after death) Menu string
STRING admenu_str, //*
"


        Start new game

        Save game

        Load game

        Exit game

        Help

        Credits
        ";

// Exit menu (yes/no)
STRING exit_str, "
Quit your adventure?



        Yes

        No";

// exit text (displayed in exit window)
STRING vstr_exit_txt,
"Thank You for playing this demo!
CONITEC Datensysteme (www.conitec.com)
____________________________________________
The entire demo was developed with 3D GameStudio / A4.
____________________________________________
";


// credit string
STRING credit_str, "
Developed with the ACKNEX engine and toolkit:
3D GAME STUDIO (tm)
Visit the Conitec Website:
www.conitec.com";

STRING vent_blank_str, "


                      ";

ENDIF; // end general purpose adventure text




//////////////////////// SCREEN /////////////////////////////////////////


IFNDEF ADV_DEF_SCREEN_MAPS;    // predefine keyword
  BMAP button_map, <ventbutt.pcx>;    		// button bitmap

  BMAP char_button_map, <ventback.bmp>, 535, 0, 60, 100;       // icon for character button
  BMAP inv_button_map, <ventback.bmp>, 530, 120, 70, 85;       // icon for inventory button
  BMAP menu_button_map, <ventback.bmp>, 570, 210, 70, 70;      // icon for menu button
  BMAP screen_map, <ventback.bmp>;                             // the entire screen map
  BMAP hpbar_map, <redbar.pcx>;                                // hitpoint bar map
  BMAP strbar_map, <grnbar.pcx>;                               // strength bar map
  BMAP manabar_map, <bluebar.pcx>;                             // mana bar map
  BMAP info1_map, <ventinfo.bmp>;        								// info1 panel bitmap (used for save and load)
  BMAP info2_map, <ventdia.bmp>;   										// small info-text panel

  FONT panel_font, <ventfont.pcx>,8,10;    	// panel font bitmap

  DEFINE  SCREEN_STAT_HP_BAR_X     540;      // X offset for the hitpoints bar
  DEFINE  SCREEN_STAT_HP_BAR_Y      10;      // Y offset for the hitpoints bar
  DEFINE  SCREEN_STAT_STR_BAR_X    555;      // X offset for the strength bar
  DEFINE  SCREEN_STAT_STR_BAR_Y     10;      // Y offset for the strength bar
  DEFINE  SCREEN_STAT_MANA_BAR_X   570;      // X offset for the mana bar
  DEFINE  SCREEN_STAT_MANA_BAR_Y    10;      // Y offset for the mana bar

  DEFINE  SCREEN_STAT_BAR_HEIGHT    80;      // the height of the stat bars

  DEFINE  SCREEN_STAT_BAR_FACTOR  1.0;// 0.8;      // vertical shifting factor

  BMAP blood_splash_map <redf.pcx>;          // blood red splash (shown when player is damaged)
  BMAP black_map <blackf.pcx>;               // blackout bitmap (used for fades)

ENDIF;



/// screen skills ////////////////////////

var statbar_pan_hp;            		// player's stat bar panel values (hp, strength, mana)
var statbar_pan_str;
var statbar_pan_mana;


/// screen text ////////////////////////

// Desc: information text
TEXT info1_txt
{
	POS_X 80;
	POS_Y 280;
	LAYER 5;
	FONT panel_font;
	STRING vent_blank_str;
}

// Desc: information text
TEXT info2_txt
{
	POS_X 80;
	POS_Y 355;
	LAYER 5;
	FONT panel_font;
	STRING vent_blank_str;
}

// Desc: bonus info text
TEXT bonus_info_txt
{
	POS_X 84;
	POS_Y 430;
	LAYER 5;
	FONT panel_font;
	STRING bonus_info_str;
}


/// screen panels ////////////////////////

// Desc: 3 vertical bar graphs to display the player's stats (hp, str, & mana)
PANEL statbar_pan
{
	// Vertical bar graph display for the player's stats
	VBAR SCREEN_STAT_HP_BAR_X, SCREEN_STAT_HP_BAR_Y, SCREEN_STAT_BAR_HEIGHT,
	    hpbar_map, SCREEN_STAT_BAR_FACTOR, statbar_pan_hp;
	VBAR SCREEN_STAT_STR_BAR_X, SCREEN_STAT_STR_BAR_Y, SCREEN_STAT_BAR_HEIGHT,
	    strbar_map, SCREEN_STAT_BAR_FACTOR, statbar_pan_str;
	VBAR SCREEN_STAT_MANA_BAR_X, SCREEN_STAT_MANA_BAR_Y, SCREEN_STAT_BAR_HEIGHT,
	    manabar_map, SCREEN_STAT_BAR_FACTOR, statbar_pan_mana;
	LAYER 7;
	FLAGS REFRESH, VISIBLE;
}

// Desc: Main screen panel
PANEL screen_pan
{
	BMAP screen_map;
	BUTTON 535, 0, char_button_map, NULL, NULL, vpst_toggle_char, NULL, NULL;
	BUTTON 530, 120, inv_button_map, NULL, NULL, vinv_toggle_inventory, NULL, NULL;
	BUTTON 570, 210, menu_button_map, NULL, NULL, vscr_toggle_menu, NULL, NULL;
	LAYER 2;
	FLAGS OVERLAY, REFRESH, VISIBLE;
}


// Desc: large information panel (used for stats, ??? ??? and ???)
PANEL info1_pan
{
	POS_X 61;
	POS_Y 265;
	BMAP info1_map;
	LAYER 3;
	FLAGS REFRESH, OVERLAY;
}


// Desc: this panel is used to display information at the bottom of the
//      player's screen.
PANEL info2_pan
{
	POS_X 61;
	POS_Y 344;
	BMAP info2_map;
	LAYER 3;
	FLAGS REFRESH, OVERLAY;
}



/// button panels ////////////////////////
// (postfix '_vbpan')

// Desc: common vscr_close_all button (lower center)
PANEL info_exit_vbpan
{
	POS_X 61;
	POS_Y 265;
	BUTTON 200, 180, button_map, button_map, button_map, vscr_close_all, NULL, NULL;
	LAYER 4;
	FLAGS REFRESH, OVERLAY;
}

// Desc: common vscr_close_all button (lower right side)
PANEL info_exit_right_vbpan
{
	POS_X 61;
	POS_Y 265;
	BUTTON 375, 175, button_map, button_map, button_map, vscr_close_all, NULL, NULL;
	LAYER 4;
	FLAGS REFRESH, OVERLAY;
}

// Desc: button in lower right that brings up the startmenu
PANEL intro_exit_vbpan
{
	POS_X 61;
	POS_Y 265;
	BUTTON 375, 175, button_map, button_map, button_map, vscr_show_startmenu, NULL, NULL;
	LAYER 4;
	FLAGS REFRESH, OVERLAY;
}

// Desc: start menu buttons
PANEL start_menu_vbpan
{
	POS_X 61;
	POS_Y 265;
	LAYER 4;
	BUTTON 45, 40, button_map, button_map, button_map, vpst_show_create_character, NULL, NULL;
	BUTTON 45, 60, button_map, button_map, button_map, vpic_load, NULL, NULL;
	BUTTON 45, 80, button_map, button_map, button_map, vscr_show_start_exit, NULL, NULL;
	FLAGS REFRESH, OVERLAY;
}

// Desc: button panel for main menu
PANEL main_menu_vbpan
{
	POS_X 61;
	POS_Y 265;
	LAYER 4;
	BUTTON 45, 40, button_map, button_map, button_map, main, NULL, NULL;
	BUTTON 45, 60, button_map, button_map, button_map, vpic_save, NULL, NULL;
	BUTTON 45, 80, button_map, button_map, button_map, vpic_load, NULL, NULL;
	BUTTON 45, 100, button_map, button_map, button_map, vscr_show_exit, NULL, NULL;
	BUTTON 45, 120, button_map, button_map, button_map, vscr_close_all, NULL, NULL;   // resume
	BUTTON 45, 140, button_map, button_map, button_map, vscr_show_help, NULL, NULL;
	BUTTON 45, 160, button_map, button_map, button_map, vscr_show_credits, NULL, NULL;
	FLAGS REFRESH;
}

// Desc: button panel for admenu
PANEL admenu_vbpan
{
	POS_X 61;
	POS_Y 265;
	LAYER 4;
	BUTTON 45, 40, button_map, button_map, button_map, main, NULL, NULL;
	BUTTON 45, 60, button_map, button_map, button_map, vpic_save, NULL, NULL;
	BUTTON 45, 80, button_map, button_map, button_map, vpic_load, NULL, NULL;
	BUTTON 45, 100, button_map, button_map, button_map, vscr_show_exit, NULL, NULL;
	BUTTON 45, 120, button_map, button_map, button_map, vscr_show_help, NULL, NULL;
	BUTTON 45, 140, button_map, button_map, button_map, vscr_show_credits, NULL, NULL;
	FLAGS REFRESH;
}

// Desc: button panel to confirm exit
PANEL exit_vbpan
{
	POS_X 61;
	POS_Y 344;
	LAYER 4;
	BUTTON 40, 60, button_map, button_map, button_map, vmsc_exit, NULL, NULL;
	BUTTON 40, 80, button_map, button_map, button_map, vscr_close_all, NULL, NULL;
	FLAGS REFRESH;
}

// Desc: button panel to confirm exit (that returns to the startmenu on no)
PANEL start_exit_vbpan
{
	POS_X 61;
	POS_Y 344;
	LAYER 4;
	BUTTON 40, 60, button_map, button_map, button_map, vmsc_exit, NULL, NULL;
	BUTTON 40, 80, button_map, button_map, button_map, vscr_show_startmenu, NULL, NULL;
	FLAGS REFRESH;
}


/// screen 'fx' panels ////////////////////////

// Desc: blood splash panel (used to notify the player's been hit)
PANEL blood_pan
{
	POS_X 3;
	POS_Y 4;
	LAYER 2;
	BMAP blood_splash_map;
	FLAGS REFRESH, OVERLAY;
}

// Desc: Blackout panels set at different levels (13, 14, 15, 16)
PANEL blackTop16_pan
{
	BMAP black_map;
	LAYER 16;
	FLAGS REFRESH;
}
PANEL blackTop15_pan
{
	BMAP black_map;
	LAYER 15;
	FLAGS REFRESH, TRANSPARENT;
}
PANEL blackTop14_pan
{
	BMAP black_map;
	LAYER 14;
	FLAGS REFRESH, TRANSPARENT;
}
PANEL blackTop13_pan
{
	BMAP black_map;
	LAYER 13;
	FLAGS REFRESH, TRANSPARENT;
}




/// screen actions ////////////////////////

// Desc: fade out to black.
function vscr_fade_out()
{
	blackTop13_pan.VISIBLE = ON;
	waitt(1);
	blackTop14_pan.VISIBLE = ON;
	waitt(1);
	blackTop15_pan.VISIBLE = ON;
	waitt(1);
	blackTop16_pan.VISIBLE = ON;
	waitt(1);
}

// Desc: fade in from black
function vscr_fade_in()
{
	blackTop16_pan.VISIBLE = OFF;
	waitt(1);
	blackTop15_pan.VISIBLE = OFF;
	waitt(1);
	blackTop14_pan.VISIBLE = OFF;
	waitt(1);
	blackTop13_pan.VISIBLE = OFF;
	waitt(1);
}

// Desc: black out screen
function vscr_black_out()
{
	blackTop13_pan.VISIBLE = ON;
	blackTop14_pan.VISIBLE = ON;
	blackTop15_pan.VISIBLE = ON;
	blackTop16_pan.VISIBLE = ON;

}

// Desc: Toggle synonyms
//--SYNONYM menu_toggle_syn {TYPE ACTION;DEFAULT vscr_show_menu;}   // switch between vscr_show_menu and vscr_close_all
//--SYNONYM help_toggle_syn {TYPE ACTION; DEFAULT vscr_show_help;}  // switch between vscr_show_help and vscr_close_all
//--SYNONYM credit_toggle_syn {TYPE ACTION; DEFAULT vscr_show_credits;}  // switch between vscr_show_credits and vscr_close_all
action* menu_toggle_syn = vscr_show_menu;
action* help_toggle_syn = vscr_show_help;
action* credit_toggle_syn = vscr_show_credits;

// Desc: Toggle synonym actions
function vscr_toggle_menu()
{
	menu_toggle_syn();      // show/hide menu
}
function vscr_toggle_help()
{
	help_toggle_syn();      // show/hide menu
}
function vscr_toggle_credits()
{
	credit_toggle_syn();      // show/hide menu
}


// Desc: show the main menu
function vscr_show_menu()
{
	// if icons are not active...
	if(__ICON_ACTIVE == OFF)
	{
		// do not show main menu
		return;
	}
	vscr_close_all();                // close all the other panels
	info1_pan.VISIBLE = ON;          // use info1_pan as background
	main_menu_vbpan.VISIBLE = ON;    // show main menu button panel
	info1_txt.STRING = menu_str;     // set menu string
	info1_txt.VISIBLE = ON;          // show text
	menu_toggle_syn = vscr_close_all;// set toggle to close all panels (including menu)
}

// Desc: show the 'after-death' menu
function vscr_show_admenu()
{
	vscr_close_all_at_end();        	// close all the other panels
	info1_pan.VISIBLE = ON;          // use large panel
	admenu_vbpan.VISIBLE = ON;       // show buttons
	info1_txt.STRING = admenu_str;   // set text
	info1_txt.VISIBLE = ON;       	// show text
}

// Desc: show the help panel
function vscr_show_help()
{
	vscr_close_all();                   // close all the other panels
	info1_pan.VISIBLE = ON;        		// use large panel
	info_exit_right_vbpan.VISIBLE = ON;	// exit button (vscr_close_all)
	info1_txt.STRING = help_str;        // set string
	info1_txt.VISIBLE = ON;              // show string
	help_toggle_syn = vscr_close_all;   // set toggle to close all
}

// Desc: show the credit screen
function vscr_show_credits()
{
	vscr_close_all();                   // close all the other panels
	info1_pan.VISIBLE = ON;         		// use large panel
	info_exit_right_vbpan.VISIBLE = ON;	// exit button (vscr_close_all)
	info1_txt.STRING = credit_str;      // set string
	info1_txt.VISIBLE = ON;             // show string
	credit_toggle_syn = vscr_close_all; // set toggle to close all
}

// Desc: show the startmenu
function vscr_show_startmenu()
{
	vscr_close_all_at_start();       // close all the other panels
	info1_pan.VISIBLE = ON;          // use large panel
	start_menu_vbpan.VISIBLE = ON;	// startmenu buttons
	info1_txt.STRING = start1_str;   // set string
	info1_txt.VISIBLE = ON;          // show string
	ON_ESC = vscr_show_start_exit;   // exit on ESC
	ON_F10 = vscr_show_start_exit;   // exit on F10
}



// Desc: show the exit menu
function vscr_show_exit()
{
	vscr_close_all();                // close all
	info2_pan.VISIBLE = ON;       	// use smaller panel
	exit_vbpan.VISIBLE = ON;         // show buttons
	info2_txt.STRING = exit_str;     // set string
	info2_txt.VISIBLE = ON;          // show string
 	ON_ESC = vscr_close_all;		  	// ON_ESC or N	 close all
	ON_N = vscr_close_all;
	ON_Y = vmsc_exit;                // ON_Y or J exit
	ON_J = vmsc_exit;
}

// Desc: show exit menu, on no return to the start menu
function vscr_show_start_exit()
{
	vscr_close_all_at_start();       // close all, reset keys
	info2_pan.VISIBLE = ON;          // use smaller panel
	start_exit_vbpan.VISIBLE = ON;   // show buttons
	info2_txt.STRING = exit_str;     // set string
	info2_txt.VISIBLE = ON;          // show string
	ON_ESC = vscr_show_startmenu;    // ON_ESC or N return to start menu
	ON_N = vscr_show_startmenu;
	ON_Y = vmsc_exit;              	// ON_Y or J exit
	ON_J = vmsc_exit;
}


// Desc: Show the info text for an object
//
// NOTE: ME must have a valid STRING2.
function vscr_show_info()
{
	vscr_close_all();
	info2_pan.VISIBLE = ON;
	info_exit_right_vbpan.VISIBLE = ON;
	info2_txt.STRING = MY.STRING2;
	info2_txt.VISIBLE = ON;
}


// NOTE: SCREEN ACTIONS CONTINUE AT BOTTOM OF FILE!



//////////////////////// PICTURE SAVE ///////////////////////////////////

/// picture save predefines ////////////////////////
IFNDEF ADV_DEF_SAVE_LOAD;
 DEFINE PICSIZE_X 64; // 320x240 shrinked by 5
 DEFINE PICSIZE_Y 48;

 BMAP slot1_map <white.pcx>,0,0,PICSIZE_X,PICSIZE_Y;  // default save image
 BMAP slot2_map <white.pcx>,0,0,PICSIZE_X,PICSIZE_Y;
 BMAP slot3_map <white.pcx>,0,0,PICSIZE_X,PICSIZE_Y;
 BMAP slot4_map <white.pcx>,0,0,PICSIZE_X,PICSIZE_Y;

 DEFINE PICSAVE_BKGD;											// panel has background
 BMAP picsavebk_map <black.pcx>,0,0,170,140;
 DEFINE picloadbk_map picsavebk_map;

 DEFINE panel_font,standard_font;

 DEFINE PICSLOT1_X 10;
 DEFINE PICSLOT1_Y 10;
 DEFINE PICSLOT2_X 84;
 DEFINE PICSLOT2_Y 10;
 DEFINE PICSLOT3_X 10;
 DEFINE PICSLOT3_Y 68;
 DEFINE PICSLOT4_X 84;
 DEFINE PICSLOT4_Y 68;
 DEFINE PICEXIT_X  160;
 DEFINE PICEXIT_Y  130;
// DEFINE PICSAVE_TEXT;	// uncomment to have titles for each slot
ENDIF;






/// picture save skills ////////////////////////
var picsave_pos[2] = 4, 4;	// panel position
var pictext_offs = 60;		// distance picture to title
var __SAVING = OFF;
var picfreeze_fac = 5;

/// picture save panels ////////////////////////
// Desc: save panel
PANEL picsave_pan
{
IFDEF PICSAVE_BKGD;
	BMAP picsavebk_map;
ENDIF;
	LAYER 10;
	BUTTON PICSLOT1_X,PICSLOT1_Y,slot1_map,slot1_map,slot1_map,_vpic_save1,NULL,NULL;
	BUTTON PICSLOT2_X,PICSLOT2_Y,slot2_map,slot2_map,slot2_map,_vpic_save2,NULL,NULL;
	BUTTON PICSLOT3_X,PICSLOT3_Y,slot3_map,slot3_map,slot3_map,_vpic_save3,NULL,NULL;
	BUTTON PICSLOT4_X,PICSLOT4_Y,slot4_map,slot4_map,slot4_map,_vpic_save4,NULL,NULL;
	BUTTON PICEXIT_X,PICEXIT_Y,button_map,button_map,button_map,_vpic_save_hide,NULL,NULL;
	FLAGS REFRESH;
}

// Desc: load panel
PANEL picload_pan
{
IFDEF PICSAVE_BKGD;
	BMAP picloadbk_map;
ENDIF;
	LAYER 10;
	BUTTON PICSLOT1_X,PICSLOT1_Y,slot1_map,slot1_map,slot1_map,_vpic_load1,NULL,NULL;
	BUTTON PICSLOT2_X,PICSLOT2_Y,slot2_map,slot2_map,slot2_map,_vpic_load2,NULL,NULL;
	BUTTON PICSLOT3_X,PICSLOT3_Y,slot3_map,slot3_map,slot3_map,_vpic_load3,NULL,NULL;
	BUTTON PICSLOT4_X,PICSLOT4_Y,slot4_map,slot4_map,slot4_map,_vpic_load4,NULL,NULL;
	BUTTON PICEXIT_X,PICEXIT_Y,button_map,button_map,button_map,_vpic_save_hide,NULL,NULL;
	FLAGS REFRESH;
}

/// picture save text ////////////////////////
IFDEF PICSAVE_TEXT;
	TEXT picsave1_txt { LAYER 11; FONT panel_font; STRING name1_str; }
	TEXT picsave2_txt { LAYER 11;	FONT panel_font; STRING name2_str; }
	TEXT picsave3_txt { LAYER 11; FONT panel_font; STRING name3_str; }
	TEXT picsave4_txt { LAYER 11;	FONT panel_font; STRING name4_str; }
ENDIF;


/// picture save actions ////////////////////////
// Desc: toggle the save game panel on and off
function vpic_save()
{
	_buttonclick();
// let panel disappear on second key press
	if(picsave_pan.VISIBLE == ON)
	{
		_vpic_save_hide();
	}
	else
	{
		picsave_pan.VISIBLE = ON;
		_vpic_save_show();
	}
}

// Desc: toggle load game panel on and off
function vpic_load()
{
	_buttonclick();

	// hide panel if visible
	if(picload_pan.VISIBLE == ON)
	{
		_vpic_save_hide();
	}
	else	// show panel if hidden
	{
		picload_pan.VISIBLE =ON;
		_vpic_save_show();
	}
}



// Desc: set everything visible
function _vpic_save_show()
{
	picsave_pan.POS_X = picsave_pos.X;
	picsave_pan.POS_Y = picsave_pos.Y;
	picload_pan.POS_X = picsave_pos.X;
	picload_pan.POS_Y = picsave_pos.Y;
IFDEF PICSAVE_TEXT;
	picsave1_txt.POS_X = picsave_pos.X + PICSLOT1_X;
	picsave1_txt.POS_Y = picsave_pos.Y + PICSLOT1_Y + pictext_offs;
	picsave2_txt.POS_X = picsave_pos.X + PICSLOT2_X;
	picsave2_txt.POS_Y = picsave_pos.Y + PICSLOT2_Y + pictext_offs;
	picsave3_txt.POS_X = picsave_pos.X + PICSLOT3_X;
	picsave3_txt.POS_Y = picsave_pos.Y + PICSLOT3_Y + pictext_offs;
	picsave4_txt.POS_X = picsave_pos.X + PICSLOT4_X;
	picsave4_txt.POS_Y = picsave_pos.Y + PICSLOT4_Y + pictext_offs;
	picsave1_txt.VISIBLE = ON;
	picsave2_txt.VISIBLE = ON;
	picsave3_txt.VISIBLE = ON;
	picsave4_txt.VISIBLE = ON;
ENDIF;
	return;
}


// Desc: hide everything
function _vpic_save_hide()
{
	picsave_pan.VISIBLE = OFF;
	picload_pan.VISIBLE = OFF;
IFDEF PICSAVE_TEXT;
	picsave1_txt.VISIBLE = OFF;
	picsave2_txt.VISIBLE = OFF;
	picsave3_txt.VISIBLE = OFF;
	picsave4_txt.VISIBLE = OFF;
ENDIF;
	picfreeze_fac = SCREEN_SIZE.X / PICSIZE_X;
	return;
}


// Desc: save actions for each button
function _vpic_save1()
{
	if(__SAVING != OFF)
	{
		return; 	// prevent clicking a pic during save
	}
	slot = 1;
	mystring = name1_str;
	_vpic_save_hide();	// hide panel to do the screenshot
	FREEZE_MAP slot1_map,picfreeze_fac,0;
	_vpic_save();
}

function _vpic_save2()
{
	if(__SAVING != OFF)
	{
		return; 	// prevent clicking a pic during save
	}
	slot = 2;
	_vpic_save_hide();
	freeze_map(slot2_map,picfreeze_fac,0);
	mystring = name2_str;
	_vpic_save();
}
function _vpic_save3()
{
	if(__SAVING != OFF)
	{
		return; 	// prevent clicking a pic during save
	}
	slot = 3;
	_vpic_save_hide();
	freeze_map(slot3_map,picfreeze_fac,0);
	mystring = name3_str;
	_vpic_save();
}
function _vpic_save4()
{
 	if(__SAVING != OFF)
	{
		return; 	// prevent clicking a pic during save
	}
	slot = 4;
	_vpic_save_hide();
	freeze_map(slot4_map,picfreeze_fac,0);
	mystring = name4_str;
	_vpic_save();
}

// Desc: finish saving action (called from _vpic_save1..4)
function _vpic_save()
{
	__SAVING = ON;		// prevent clicking another picture
	wait(1);				// at this time the screenshot is done
	picsave_pan.VISIBLE = ON;
	_vpic_save_show();	// so the panel may appear again
IFDEF PICSAVE_TEXT;
	inkey(mystring);		// enter title
	if(RESULT != 13) {	// Aborted with ESC
		__SAVING = OFF;		// enable picsaving again
		load_status();	// restore old picture
		_vpic_save_hide();
		END;
	}
IFELSE;
	WAIT 2;
ENDIF;
	__SAVING = OFF;	// enable picsaving again
	_vpic_save_hide();
	save_status();
	save(SAVE_NAME,slot);
	if(RESULT > 0) { _buttonclick(); }
	wait(1);
	load_status();	// to be performed in LOAD: restore old picture
}

// Desc: load for each panel
function _vpic_load1()
{
	slot = 1;
	_vpic_load();
}
function _vpic_load2()
{
	slot = 2;
	_vpic_load();
}
function _vpic_load3()
{
	slot = 3;
	_vpic_load();
}
function _vpic_load4()
{
	slot = 4;
	_vpic_load();
}

// Desc: load game
function _vpic_load()
{
	_buttonclick();
	load(SAVE_NAME,slot);
	if(RESULT < 0) { beep; }
	wait(1);
	_vpic_save_hide();
}





//////////////////////// NPC ////////////////////////////////////////////
// action used to control NPC (non-player characters)

/// entity defines ////////////////////////
DEFINE ENT_SCALE, SKILL33;	// entity scale
DEFINE ENT_ID, SKILL34; 			// entity ID


/// npc defines ////////////////////////
//--SYNONYM NPC_ENTITY {TYPE ENTITY;}	// hold NPC entity
entity* NPC_ENTITY;		// hold NPC entity

DEFINE _NPC_WALK, 1; 	// npc standard navigation
DEFINE _NPC_COME, 2; 	// npc follows
DEFINE _NPC_ATTACK, 3; 	// npc attacks
DEFINE _NPC_RETREAT 4; 	// npc retreats
DEFINE _NPC_STOP, 5; 	// npc waits
DEFINE _NPC_TALK, 6; 	// npc starts talking
DEFINE _NPC_DEAD, 7;		// npc is dead


/// npc predefines ////////////////////////
IFNDEF ADV_DEF_NPC;
	var vsk_nav_speed[3] = 10,0,0;	// navigation speed vector
ENDIF;


/// npc skills ////////////////////////
var vsk_time_nav_speed;		// navigation speed adjusted for time


/// npc actions ////////////////////////

// Desc: if the navigator collides anywhere it changes its direction randomly
function _vnpc_random_nav_event()
{
	if( (EVENT_TYPE == EVENT_BLOCK) ||  (EVENT_TYPE == EVENT_ENTITY))
	{
		MY.PAN = random(180) + MY.PAN;
	}
}

// Desc: used to control the invisible navigation entity
//       "CREATE <arrow.pcx>, MY.POS, vnpc_random_navigation;"
//
// Mod Date: 06/11/01
//			Replace move() with ent_move()
ACTION vnpc_random_navigation
{
	YOUR.ENTITY1 = ME;
	MY.INVISIBLE = ON;
	MY.PAN = 0;
	MY.ROLL = 0;
	MY.TILT = 0;
	MY.EVENT = _vnpc_random_nav_event;
	MY.ENABLE_BLOCK = 1;
	MY.ENABLE_ENTITY = 1;
	while(1)
	{
		vsk_time_nav_speed = vsk_nav_speed * TIME;
		YOU = NULL;
		vec_scale(vsk_time_nav_speed,movement_scale);	// scale absolute distance by movement_scale
//--		move(ME, vsk_time_nav_speed, nullskill);
		move_mode = ignore_you + ignore_passable + ignore_push + activate_trigger + glide;
		result = ent_move(vsk_time_nav_speed,nullskill);
		wait(1);
	}
}



//////////////////////// PLAYER STAT ////////////////////////////////////

/// player stat predefines ////////////////////////
IFNDEF ADV_DEF_PLAYERSTATS;
 	DEFINE	PLAYER_LEVEL_TWO_EXP		1000;   // experience need for each level
	DEFINE	PLAYER_LEVEL_THREE_EXP	2500;
	DEFINE	PLAYER_LEVEL_FOUR_EXP	5000;
	DEFINE	PLAYER_LEVEL_FIVE_EXP	8000;   // this value is then doubled for each level after this one
														  // (ex. 6 = 16000, 7 = 32000, 8 = 64000)



  ///////// player skills /////////////////
  var player_hp = 20;  				// player's base hitpoints
  var player_mana = 0;         	// player's base mana level
  var player_str = 15;          	// player's base strength
  var player_gew = 15;          	// player's base agility
  var player_mut = 15;          	// player's base bravery
  var player_int = 15;          	// player's base intuition

  DEFINE	PLAYER_RAND_HP 5;					// the random amount of hitpoints added
  DEFINE	PLAYER_RAND_MANA 0;				// the random amount of mana added
  DEFINE	PLAYER_RAND_STR 25;				// the random amount of strength added
  DEFINE	PLAYER_RAND_GEW 25;				// the random amount of agility added
  DEFINE	PLAYER_RAND_MUT 25;				// the random amount of bravery added
  DEFINE	PLAYER_RAND_INT 25;				// the random amount of intuition added

  DEFINE PLAYER_BONUS_PER_LVL	10;		// number of bonus points awarded each level

  DEFINE PLAYER_PERIODIC_HP	0.008; 	// number of hitpoints points regenerated every tick
  DEFINE PLAYER_PERIODIC_STR	0.050; 	// number of strength points regenerated every tick
  DEFINE PLAYER_PERIODIC_MANA	0.008; 	// number of mana points regenerated every tick
ENDIF;


/// player stat skills ////////////////////////
var next_lvl_exp = PLAYER_LEVEL_TWO_EXP;      // number of experience points need for the next level

var player_current_hp;		// player's current hitpoints
var player_current_mana;  	// player's current mana level
var player_current_str;  	// player's current strength

var player_bonus_pts = PLAYER_BONUS_PER_LVL;     	// player's bonus points (to spend on stats)

var player_exp = 0;           	// player's experience points

var player_lvl = 1;           	// player's current level

var give_exp = 0;              	// the amount of exp to give the player


/// player stat panels ////////////////////////

// Desc: bonus points panel
PANEL bonus_pan
{
	POS_X 61;
	POS_Y 265;
	BUTTON 15, 40, button_map, button_map, button_map, _vpst_bonus_hp, NULL, NULL;
	BUTTON 15, 60, button_map, button_map, button_map, _vpst_bonus_mana, NULL, NULL;
	BUTTON 15, 80, button_map, button_map, button_map, _vpst_bonus_str, NULL, NULL;
	BUTTON 15, 100, button_map, button_map, button_map, _vpst_bonus_gew, NULL, NULL;
	BUTTON 180, 40, button_map, button_map, button_map, _vpst_bonus_mut, NULL, NULL;
	BUTTON 180, 60, button_map, button_map, button_map, _vpst_bonus_int, NULL, NULL;
	DIGITS 130, 175, 2, panel_font, 1, player_bonus_pts;
	LAYER 4;
	FLAGS REFRESH, OVERLAY;
}

// Desc: character stats panel
PANEL char_pan
{
	POS_X 65;
	POS_Y 265;
	DIGITS 125, 45, 2, panel_font, 1, player_current_hp;
	DIGITS 150, 45, 2, panel_font, 1, player_hp;
	DIGITS 125, 65, 2, panel_font, 1, player_current_mana;
	DIGITS 150, 65, 2, panel_font, 1, player_mana;
	DIGITS 125, 85, 2, panel_font, 1, player_current_str;
	DIGITS 150, 85, 2, panel_font, 1, player_str;
	DIGITS 150, 105, 2, panel_font, 1, player_gew;
	DIGITS 350, 45, 2, panel_font, 1, player_mut;
	DIGITS 350, 65, 2, panel_font, 1, player_int;
	DIGITS 350, 85, 2, panel_font, 1, player_lvl;
	DIGITS 325, 105, 5, panel_font, 1, player_exp;
	DIGITS 325, 125, 5, panel_font, 1, next_lvl_exp;
	LAYER 4;
	FLAGS REFRESH, OVERLAY;
}


/// player stat actions ////////////////////////

// Desc: initialize the player's base stats
function vpst_init_stats()
{
   player_hp += random(PLAYER_RAND_HP);     	// calculate base hitpoints
	player_current_hp = player_hp;
   player_mana += random(PLAYER_RAND_MANA);    // calculate base mana
	player_current_mana = player_mana;
  	player_str += random(PLAYER_RAND_STR);      // calculate base strength
	player_current_str = player_str;

	player_gew += random(PLAYER_RAND_GEW);
	player_mut += random(PLAYER_RAND_MUT);
	player_int += random(PLAYER_RAND_INT);
}


// Desc: create the character and show the bonus panel
function vpst_show_create_character()
{
	vpst_init_stats();
	vpst_show_bonus();
}


//--SYNONYM char_toggle_syn {TYPE ACTION;DEFAULT vpst_show_char;}   // switch between vscr_show_menu and vscr_close_all
action* char_toggle_syn = vpst_show_char;		// switch between vscr_show_menu and vscr_close_all

// Desc: toggle between showing and hiding the character window
function vpst_toggle_char()
{
	char_toggle_syn();      // show/hide inventory
}


// Desc: show the player's stats panel
function vpst_show_char()
{
	// if icons are not active...
	if(__ICON_ACTIVE == OFF)
	{
		// don't show character stat panel
		return;
	}
	if(player_bonus_pts > 0)
	{
		vpst_show_bonus();
		return;
	}
	vscr_close_all();
	info1_pan.VISIBLE = ON;
	char_pan.VISIBLE = ON;
	info_exit_vbpan.VISIBLE = ON;
	info1_txt.STRING = char_pan_str;
	info1_txt.VISIBLE = ON;
	char_toggle_syn = vscr_close_all;           // set toggle to close all panels (including character)
}


// Desc: show the player's stats panel and allow them to spend their bonus
//      points to increase their skills
function vpst_show_bonus()
{
	vscr_close_all();
	info1_pan.VISIBLE = ON;
	char_pan.VISIBLE = ON;
	bonus_pan.VISIBLE = ON;
	bonus_info_txt.VISIBLE = ON;
	info1_txt.STRING = char_pan_str;
	info1_txt.VISIBLE = ON;
	info_exit_right_vbpan.VISIBLE = ON;
	char_toggle_syn = vscr_close_all;
}

// Desc: enable updates of the player's stats every tick by calling
//      _vpst_periodic_update action every tick
function vpst_enable_periodic_update()
{
	while(1)
	{
		_vpst_periodic_update();
		waitt(1);
	}
}




// Desc: regenerate stats over time
//       update levels in life panel
//
// Called from vpst_stats_update
function _vpst_periodic_update()
{
	if(player_current_hp < player_hp)
	{
		// regenerate hitpoints
		player_current_hp += PLAYER_PERIODIC_HP * TIME;
		if(player_current_hp > player_hp)
		{
			player_current_hp = player_hp;
		}
	}
	if(player_current_str < player_str)
	{
		// regenerate strength
		player_current_str += PLAYER_PERIODIC_STR * TIME;
		if(player_current_str > player_str)
		{
			player_current_str = player_str;
		}
	}
	if(player_current_mana < player_mana)
	{
		// regenerate mana
		player_current_mana += PLAYER_PERIODIC_MANA * TIME;
		if(player_current_mana > player_mana)
		{
			player_current_mana = player_mana;
		}
	}

	// Update stat VBARs
	// the VBAR shows the percent of total hp/str/mana the player currently has
	// ( 100% = full bar, 50% = half bar, 0% = empty bar)
  	if(player_hp > 0) // avoid divide by zero error
	{
		statbar_pan_hp = SCREEN_STAT_BAR_HEIGHT - INT (( player_current_hp/player_hp ) * SCREEN_STAT_BAR_HEIGHT);
	}
	else   // empty bar
	{
		statbar_pan_hp = SCREEN_STAT_BAR_HEIGHT;
	}

	if(player_str > 0)
	{
		statbar_pan_str = SCREEN_STAT_BAR_HEIGHT - INT (( player_current_str/player_str ) * SCREEN_STAT_BAR_HEIGHT);
	}
	else
	{
		statbar_pan_mana = SCREEN_STAT_BAR_HEIGHT;
	}

	if(player_mana > 0)
	{
		statbar_pan_mana = SCREEN_STAT_BAR_HEIGHT - INT (( player_current_mana/player_mana ) * SCREEN_STAT_BAR_HEIGHT);
	}
	else
	{
		statbar_pan_mana = SCREEN_STAT_BAR_HEIGHT;
	}
}


// Desc: Use a bonus point to increase player's base hitpoints
function _vpst_bonus_hp()
{
	if(player_bonus_pts > 0)
	{
		player_hp += 1;
		player_current_hp += 1;
		player_bonus_pts -= 1;
	}
	else
	{
		vscr_close_all();
	}
}


// Desc: Use a bonus point to increase player's base strength
function _vpst_bonus_str()
{
	if(player_bonus_pts > 0)
	{
		player_str += 1;
		player_current_str += 1;
		player_bonus_pts -= 1;
	}
	else
	{
		vscr_close_all();
	}
}

// Desc: Use a bonus point to increase player's base mana
function _vpst_bonus_mana()
{
	if(player_bonus_pts > 0)
	{
		player_mana += 1;
		player_current_mana += 1;
		player_bonus_pts -= 1;
	}
	else
	{
		vscr_close_all();
	}
}

// Desc: Use a bonus point to increase player's agility
function _vpst_bonus_gew()
{
	if(player_bonus_pts > 0)
	{
		player_gew += 1;
		player_bonus_pts += -1;
	}
	else
	{
		vscr_close_all();
	}
}


// Desc: Use a bonus point to increase player's bravery
function _vpst_bonus_mut()
{
	if(player_bonus_pts > 0)
	{
		player_mut += 1;
		player_bonus_pts += -1;
	}
	else
	{
		vscr_close_all();
	}
}

// Desc: Use a bonus point to increase player's intuition
function _vpst_bonus_int()
{
	if(player_bonus_pts > 0)
	{
		player_int += 1;
		player_bonus_pts += -1;
	}
	else
	{
		vscr_close_all();
	}
}

// Desc: Add the given experience (give_exp) to the player's experience (player_exp)
//      and check to see if the player has reached the next level.
//			If the player has reached the next level, CALL next_level
//
function vpst_check_exp()
{
	player_exp += give_exp;
	if(player_exp >= next_lvl_exp)
	{
		_vpst_next_level();
	}
	give_exp = 0;
}


// Desc: Set the player's level (player_lvl) and next level's experience goal
//      (next_lvl_exp).
//       Give the player ten bonus points for stats and open up their stats window.
function _vpst_next_level()
{
	if(next_lvl_exp == PLAYER_LEVEL_FOUR_EXP)
	{
		next_lvl_exp = PLAYER_LEVEL_FIVE_EXP;
		player_lvl = 4;
	}
	if(next_lvl_exp == PLAYER_LEVEL_THREE_EXP)
	{
		next_lvl_exp = PLAYER_LEVEL_FOUR_EXP;
		player_lvl = 3;
	}
	if(next_lvl_exp == PLAYER_LEVEL_TWO_EXP)
	{
		next_lvl_exp = PLAYER_LEVEL_THREE_EXP;
		player_lvl = 2;
	}

	if(player_lvl >= 4)
	{
		next_lvl_exp *= 2;
		player_lvl += 1;
	}

	player_bonus_pts += 10;
	bonus_info_txt.STRING = level_info_str;
	vpst_show_char();
}




//////////////////////// ITEM ///////////////////////////////////////////

/// item predefines ////////////////////////
IFNDEF ADV_DEF_ITEMS;
  SOUND item_hit_snd,<sack.wav>;   // sound played when item hits ground
ENDIF;

/// item defines ////////////////////////
DEFINE _EMPTY, 0; 					// define inventory empty value

/// item skills ////////////////////////
var mouse_object = -1;	// current object connected to mouse pointer
var drop_dist = 0;      //

// item throwing
var throw_grav = 2;
var throw_speed[3] = 35, 0, 35;
var throw_angle[3] = 0, 0, 0;
var throw_aspeed[3] = 0, 5, 0;



/// item actions ////////////////////////

// Desc: handle item event
//
// Mod: 05/23/01  DCP
//		Added wait(1) before remove(ME) (dangerous instrution warning)
//		Added call to '_hide_touch()' function before remove(ME)
function _vitm_item_event()
{
	if(EVENT_TYPE == EVENT_CLICK)// mouseclick on item
	{
		if(mouse_object <= _EMPTY)// if not empty, nothing will happen
		{
			// PICKUP ITEM
			mouse_object = MY.ENT_ID;	// the mouse gets the ENT_ID
			_hide_touch();					// hind any 'touch' message
			wait(1);
			remove(ME); 					// the item disappears
			return;
		}
	}
	// if the item was thrown away and collides:
	if( (EVENT_TYPE == EVENT_BLOCK) ||  (EVENT_TYPE == EVENT_ENTITY))
	{
		MY._SPEED = 0;          // stop moving
		MY.ENABLE_BLOCK = OFF;  // block off
		MY.ENABLE_ENTITY = OFF;  // collision with other entities off
		return;
	}
	handle_touch();	// show/hide touch text
}


// Desc: initialize item
ACTION vitm_init_item
{
	// SET FLAGS
	MY.ENABLE_TOUCH = ON; 	// mouse touch on
	MY.ENABLE_RELEASE = ON; // mouse release on
	MY.ENABLE_CLICK = ON;   // mouse click on
	MY.ENABLE_BLOCK = ON;  // block on
	MY.ENABLE_ENTITY = ON;  // collision with other entities on
	MY.EVENT = _vitm_item_event; 	// will be called at each event
	MY.PASSABLE = ON;

	// SCALE ITEM
	// make sure we have a valid item scale value
	if(MY.ENT_SCALE == 0)
	{
		MY.ENT_SCALE = 1;
	}
	MY.SCALE_X = MY.ENT_SCALE;
	MY.SCALE_Y = MY.ENT_SCALE;
	MY.SCALE_Z = MY.ENT_SCALE;
}



// Desc: 'Use' an item
//       The default action for an item is to drop it
function _vitm_use_item()
{
   // NOT over something that produces touch_text...
	if(touch_txt.VISIBLE == OFF)
	{
			vitm_release_item(); 	// drop_item
	}
}


// Desc: item is thrown from the player
//
// NOTE: ME must be set to an item
function vitm_throw_item()
{
	if(player == NULL) { return; }

	MY.FAT = OFF;
	MY.NARROW = ON;
	MY.PASSABLE = OFF;

	MY.X = player.X;
	MY.Y = player.Y;
	MY.Z = player.Z;

	MY.PAN = player.PAN + 180; 	//face the player
	MY.ROLL = 0;
	MY.TILT = 0;

	MY._SPEED_X = throw_speed.X;
	MY._SPEED_Y = 0;
	MY._SPEED_Z = throw_speed.Z;
	vec_rotate(MY._SPEED,player.PAN);


	_vitm_falling_item();

}

// Desc: item is dropped at player's feet
//
// NOTE: ME must be set to an item
function vitm_drop_item()
{
	if(player == NULL)
	{
		return;
	}

	MY.FAT = OFF;
	MY.NARROW = ON;
	MY.PASSABLE = OFF;

	MY.X = player.X;
	MY.Y = player.Y;
	MY.Z = player.Z;

	MY.PAN = player.PAN + 180; 	//face the player
	MY.ROLL = 0;
	MY.TILT = 0;

	// no speed
	MY._SPEED_X = 0;
	MY._SPEED_Y = 0;
	MY._SPEED_Z = 0;
	vec_rotate(MY._SPEED,player.PAN);


	_vitm_falling_item();

}


// Desc: create and 'release' the mouse_object item
function vitm_release_item()
{
	vitm_create_item(); 		// create an item depending on mouse_object
	wait(1);
	mouse_object = _EMPTY;  // empty the mouse object
}


//
// Mod Date: 06/11/01 DCP
//				Replaced move() with ent_move()
//
function	_vitm_falling_item()
{
	WHILE (1)
	{
// check whether it hit the ground
		sonar ME,1000;
		if(RESULT <= 5)
		{
			play_entsound(ME,item_hit_snd,300);
			return;
		}

// rotate the item
		MY.TILT += throw_aspeed.TILT*TIME;

// Add the world gravity force
		absforce.X = 0;
		absforce.Y = 0;
		absforce.Z = -throw_grav;

		// -old method- ACCEL	MY._SPEED,absforce,air_fric;
		temp = min(TIME*air_fric,1);
		MY._SPEED_X += /*(TIME * absforce.x) -*/ (temp * MY._SPEED_X);  // NOTE! absforce.X == 0
		MY._SPEED_Y += /*(TIME * absforce.y) -*/ (temp * MY._SPEED_Y);  // NOTE! absforce.y == 0
		MY._SPEED_Z += (TIME * absforce.z) - (temp * MY._SPEED_Z);

		absdist.x = MY._SPEED_X * TIME;
		absdist.y = MY._SPEED_Y * TIME;
		absdist.z = MY._SPEED_Z * TIME;

		YOU = player;	// don't get stuck within the player
		vec_scale(absdist,movement_scale);	// scale absolute distance by movement_scale
//--		move(ME,NULLSKILL,absdist);
		move_mode = ignore_you + ignore_passable + ignore_push + activate_trigger + glide;
		result = ent_move(nullskill,absdist);
		wait(1);
	}

}


// Desc: create an item with an attached action depending on the cursor sprite
// NOTE: this action should be OVERRIDDEN by the game script
function vitm_create_item()
{
	wait(1);
}




//////////////////////// INVENTORY //////////////////////////////////////

/// inventory predefines ////////////////////////
IFNDEF ADV_DEF_INVENT_P;
	BMAP invent_map, <invent.bmp>;     // 12 box inventory panel
	BMAP invent_item_map, <items.bmp>;// inventory items

	BMAP i1_map, <invent.bmp>, 2, 2, 62, 70;	// 1 box of the 12 box inventory panel
	BMAP i2_map, <invent.bmp>, 66, 2, 62, 70;
	BMAP i3_map, <invent.bmp>, 2, 72, 62, 62;
	BMAP i4_map, <invent.bmp>, 66, 72, 62, 62;
	BMAP i5_map, <invent.bmp>, 2, 135, 62, 62;
	BMAP i6_map, <invent.bmp>, 66, 135, 62, 62;
	BMAP i7_map, <invent.bmp>, 2, 197, 62, 62;
	BMAP i8_map, <invent.bmp>, 66, 197, 62, 62;
	BMAP i9_map, <invent.bmp>, 2, 260, 62, 58;
	BMAP i10_map, <invent.bmp>, 66, 260, 62, 58;
	BMAP i11_map, <invent.bmp>, 2, 320, 62, 62;
	BMAP i12_map, <invent.bmp>, 66, 320, 62, 62;

	DEFINE INVENT_P_invent_temp_item_DX		70;	// width of each item stored in invent_item_map

	DEFINE INVENT_P_X		387;	 		// inventory panel upper left border position
	DEFINE INVENT_P_Y		  4;

	DEFINE INVENT_P_WIN_DX		70;	// cutout window size
	DEFINE INVENT_P_WIN_DY		70;

	DEFINE INVENT_P_ROW_1		  2;	// row offsets for inventory panel
	DEFINE INVENT_P_ROW_2		 72;
	DEFINE INVENT_P_ROW_3		135;
	DEFINE INVENT_P_ROW_4		197;
	DEFINE INVENT_P_ROW_5		260;
	DEFINE INVENT_P_ROW_6		320;

	DEFINE INVENT_P_COL_1		 2;   // column offsets for inventory panel
	DEFINE INVENT_P_COL_2		66;


ENDIF;


/// inventory skills ////////////////////////
var i1_window = 0;
var i2_window = 0;
var i3_window = 0;
var i4_window = 0;
var i5_window = 0;
var i6_window = 0;
var i7_window = 0;
var i8_window = 0;
var i9_window = 0;
var i10_window = 0;
var i11_window = 0;
var i12_window = 0;


var i1_status = 0;	// selects the item to be shown in this inv.box
var i2_status = 0;
var i3_status = 0;
var i4_status = 0;
var i5_status = 0;
var i6_status = 0;
var i7_status = 0;
var i8_status = 0;
var i9_status = 0;
var i10_status = 0;
var i11_status = 0;
var i12_status = 0;


var __INVENT_STATE = OFF;	// Inventory State: ON = Open, OFF = Closed


//--SYNONYM invent_toggle_syn {TYPE ACTION;DEFAULT vinv_show_inventory;}   // switch between vinv_show_inventory and vinv_hide_inventory
action* invent_toggle_syn = vinv_show_inventory;	// switch between vinv_show_inventory and vinv_hide_inventory

var invent_temp_item = _EMPTY;    // temp hold the current item

var invent_box_number = 0;}		// inventory box number (1..12)
var invent_box_content = _EMPTY; // temporary buffer: box content


/// inventory panels ////////////////////////
//
// Desc: The 12-box inventory panel.  Uses the defines set in  ADV_DEF_INVENT_P
PANEL invent_pan
{
	POS_X INVENT_P_X;     // set position
	POS_Y INVENT_P_Y;

	BMAP invent_map;      // inventory panel bitmap

	BUTTON INVENT_P_COL_1, INVENT_P_ROW_1, i1_map, NULL, NULL, _vinv_check_i1, NULL, NULL; // each box is a button
	BUTTON INVENT_P_COL_2, INVENT_P_ROW_1, i2_map, NULL, NULL, _vinv_check_i2, NULL, NULL;
	BUTTON INVENT_P_COL_1, INVENT_P_ROW_2, i3_map, NULL, NULL, _vinv_check_i3, NULL, NULL;
	BUTTON INVENT_P_COL_2, INVENT_P_ROW_2, i4_map, NULL, NULL, _vinv_check_i4, NULL, NULL;
	BUTTON INVENT_P_COL_1, INVENT_P_ROW_3, i5_map, NULL, NULL, _vinv_check_i5, NULL, NULL;
	BUTTON INVENT_P_COL_2, INVENT_P_ROW_3, i6_map, NULL, NULL, _vinv_check_i6, NULL, NULL;
	BUTTON INVENT_P_COL_1, INVENT_P_ROW_4, i7_map, NULL, NULL, _vinv_check_i7, NULL, NULL;
	BUTTON INVENT_P_COL_2, INVENT_P_ROW_4, i8_map, NULL, NULL, _vinv_check_i8, NULL, NULL;
	BUTTON INVENT_P_COL_1, INVENT_P_ROW_5, i9_map, NULL, NULL, _vinv_check_i9, NULL, NULL;
	BUTTON INVENT_P_COL_2, INVENT_P_ROW_5, i10_map, NULL, NULL, _vinv_check_i10, NULL, NULL;
	BUTTON INVENT_P_COL_1, INVENT_P_ROW_6, i11_map, NULL, NULL, _vinv_check_i11, NULL, NULL;
	BUTTON INVENT_P_COL_2, INVENT_P_ROW_6, i12_map, NULL, NULL, _vinv_check_i12, NULL, NULL;

	// cutout windows from the inventory items map displayed in the proper item boxes
	WINDOW INVENT_P_COL_1, INVENT_P_ROW_1, INVENT_P_WIN_DX, INVENT_P_WIN_DY, invent_item_map, i1_window, 0;  // cutout windows
	WINDOW INVENT_P_COL_2, INVENT_P_ROW_1, INVENT_P_WIN_DX, INVENT_P_WIN_DY, invent_item_map, i2_window, 0;
	WINDOW INVENT_P_COL_1, INVENT_P_ROW_2, INVENT_P_WIN_DX, INVENT_P_WIN_DY, invent_item_map, i3_window, 0;
	WINDOW INVENT_P_COL_2, INVENT_P_ROW_2, INVENT_P_WIN_DX, INVENT_P_WIN_DY, invent_item_map, i4_window, 0;
	WINDOW INVENT_P_COL_1, INVENT_P_ROW_3, INVENT_P_WIN_DX, INVENT_P_WIN_DY, invent_item_map, i5_window, 0;
	WINDOW INVENT_P_COL_2, INVENT_P_ROW_3, INVENT_P_WIN_DX, INVENT_P_WIN_DY, invent_item_map, i6_window, 0;
	WINDOW INVENT_P_COL_1, INVENT_P_ROW_4, INVENT_P_WIN_DX, INVENT_P_WIN_DY, invent_item_map, i7_window, 0;
	WINDOW INVENT_P_COL_2, INVENT_P_ROW_4, INVENT_P_WIN_DX, INVENT_P_WIN_DY, invent_item_map, i8_window, 0;
	WINDOW INVENT_P_COL_1, INVENT_P_ROW_5, INVENT_P_WIN_DX, INVENT_P_WIN_DY, invent_item_map, i9_window, 0;
	WINDOW INVENT_P_COL_2, INVENT_P_ROW_5, INVENT_P_WIN_DX, INVENT_P_WIN_DY, invent_item_map, i10_window, 0;
	WINDOW INVENT_P_COL_1, INVENT_P_ROW_6, INVENT_P_WIN_DX, INVENT_P_WIN_DY, invent_item_map, i11_window, 0;
	WINDOW INVENT_P_COL_2, INVENT_P_ROW_6, INVENT_P_WIN_DX, INVENT_P_WIN_DY, invent_item_map, i12_window, 0;

	LAYER 3;    //set layer
	FLAGS REFRESH, OVERLAY;  //redrawn every frame cycle, color #0 not drawn
}





/// inventory actions ////////////////////////

// NOTE: the actions vinv_reset_critical_items and vinv_critical_items should be
//      overriden in the local WDL file

// Desc: reset all critical items
//
// NOTE: override is action in local WDL
function vinv_reset_critical_items()
{
	wait(1);
}

// Desc: check to see if a critical item has been picked up or lost
//
// NOTE: override is action in local WDL
function vinv_critical_items()
{
	wait(1);
}


// Desc: reset inventory at game start
function vinv_reset_inventory()
{
	i1_status = 0;
	i2_status = 0;
	i3_status = 0;
	i4_status = 0;
	i5_status = 0;
	i6_status = 0;
	i7_status = 0;
	i8_status = 0;
	i9_status = 0;
	i10_status = 0;
	i11_status = 0;
	i12_status = 0;
	_vinv_update_inventory_content();
}


// Desc: hide the inventory from player
function vinv_hide_inventory()
{
	invent_pan.VISIBLE = OFF; // hide the inventory panel
	invent_toggle_syn = vinv_show_inventory;   // toggle to vinv_show_inventory
   play_sound(klick_snd,0.5);
	__INVENT_STATE = OFF;            // flag inventory as closed
}

// Desc: show the inventory to player
function vinv_show_inventory()
{
	// if buttons are not active...
 	if(__ICON_ACTIVE == OFF)
 	{
		// don't show inventory
		return;
 	}
	invent_pan.VISIBLE = ON;  // show the inventory panel
	invent_toggle_syn = vinv_hide_inventory;   // toggle to vinv_hide_inventory
	__INVENT_STATE = ON;             // flag inventory as open
}



// Desc: toggle the visability of the player's inventory
function vinv_toggle_inventory()
{
	invent_toggle_syn();      // show/hide inventory
}






// Desc: put the value stored in invent_temp_item into the next empty box
//      in inventory.  If no room, 'release' item (drop, throw, etc)
function vinv_put_item_inventory()
{
	invent_box_content = invent_temp_item;
	if(i1_status == _EMPTY)
	{
		i1_status = invent_temp_item;
		_vinv_update_inventory_content();
		vinv_critical_items();
		return;
	}
	if(i2_status == _EMPTY)
	{
		i2_status = invent_temp_item;
		_vinv_update_inventory_content();
		vinv_critical_items();
		return;
	}
	if(i3_status == _EMPTY)
	{
		i3_status = invent_temp_item;
		_vinv_update_inventory_content();
		vinv_critical_items();
		return;
	}
	if(i4_status == _EMPTY)
	{
		i4_status = invent_temp_item;
		_vinv_update_inventory_content();
		vinv_critical_items();
		return;
	}
	if(i5_status == _EMPTY)
	{
		i5_status = invent_temp_item;
		_vinv_update_inventory_content();
		vinv_critical_items();
		return;
	}
	if(i6_status == _EMPTY)
	{
		i6_status = invent_temp_item;
		_vinv_update_inventory_content();
		vinv_critical_items();
		return;
	}
	if(i7_status == _EMPTY)
	{
		i7_status = invent_temp_item;
		_vinv_update_inventory_content();
		vinv_critical_items();
		return;
	}
	if(i8_status == _EMPTY)
	{
		i8_status = invent_temp_item;
		_vinv_update_inventory_content();
		vinv_critical_items();
		return;
	}
	if(i9_status == _EMPTY)
	{
		i9_status = invent_temp_item;
		_vinv_update_inventory_content();
		vinv_critical_items();
		return;
	}
	if(i10_status == _EMPTY)
	{
		i10_status = invent_temp_item;
		_vinv_update_inventory_content();
		vinv_critical_items();
		return;
	}
	if(i11_status == _EMPTY)
	{
		i11_status = invent_temp_item;
		_vinv_update_inventory_content();
		vinv_critical_items();
		return;
	}
	if(i12_status == _EMPTY)
	{
		i12_status = invent_temp_item;
		_vinv_update_inventory_content();
		vinv_critical_items();
		return;
	}

	// no room in inventory, item is released
	vitm_release_item();
}



// Desc: go through the player's inventory, if the value in invent_temp_item matches
// on of the items in inventory remove it.
//       venture_return is set to 1 if item is found in inventory, 0 otherwise
function vinv_delete_item_inventory()
{

	if(i1_status == invent_temp_item)
	{
		i1_status = _EMPTY;
		_vinv_update_inventory_content();
		venture_return = 1;
		return;
	}
	if(i2_status == invent_temp_item)
	{
		i2_status = _EMPTY;
		_vinv_update_inventory_content();
		venture_return = 1;
		return;
	}
	if(i3_status == invent_temp_item)
	{
		i3_status = _EMPTY;
		_vinv_update_inventory_content();
		venture_return = 1;
		return;
	}
	if(i4_status == invent_temp_item)
	{
		i4_status = _EMPTY;
		_vinv_update_inventory_content();
		venture_return = 1;
		return;
	}
	if(i5_status == invent_temp_item)
	{
		i5_status = _EMPTY;
		_vinv_update_inventory_content();
		venture_return = 1;
		return;
	}
	if(i6_status == invent_temp_item)
	{
		i6_status = _EMPTY;
		_vinv_update_inventory_content();
		venture_return = 1;
		return;
	}
	if(i7_status == invent_temp_item)
	{
		i7_status = _EMPTY;
		_vinv_update_inventory_content();
		venture_return = 1;
		return;
	}
	if(i8_status == invent_temp_item)
	{
		i8_status = _EMPTY;
		_vinv_update_inventory_content();
		venture_return = 1;
		return;
	}
	if(i9_status == invent_temp_item)
	{
		i9_status = _EMPTY;
		_vinv_update_inventory_content();
		venture_return = 1;
		return;
	}
	if(i10_status == invent_temp_item)
	{
		i10_status = _EMPTY;
		_vinv_update_inventory_content();
		venture_return = 1;
		return;
	}
	if(i11_status == invent_temp_item)
	{
		i11_status = _EMPTY;
		_vinv_update_inventory_content();
		venture_return = 1;
		return;
	}
	if(i12_status == invent_temp_item)
	{
		i12_status = _EMPTY;
		_vinv_update_inventory_content();
		venture_return = 1;
		return;
	}

	// item not found, nothing removed
	venture_return = 0;
}


// Desc: If we have a mouse_object, put/swap the object into inventory (by Calling inventory_put)
//       Else, get an item out of inventory and place it in the mouse_object
//
// Notes: Called from i1_check ... i12_check,
//        box should be set to the selected inventory box and invent_box_content should be
//       set to the content of that box before calling this action.
function _vinv_check_inventory()
{
	if(mouse_object == _EMPTY)	// if we have nothing on the mouse....
	{
		_vinv_get_inventory(); 		// ...get item from inventory
		return;
	}
	_vinv_put_inventory(); 			// else put/swap items in inventory
}


// Desc: put the mouse_object item into inventory
//			if an item already exists in that box, exchange them
//
// Called by _vinv_check_inventory
function _vinv_put_inventory()
{
	if(invent_box_content > _EMPTY)	// if an item already exists in that box...
	{
		_vinv_exchange_inventory();	// exchange mouse item with box item
		return;
	}
	invent_box_content = mouse_object; 	// else place mouse_object into inventory
	mouse_object = _EMPTY; 	 	// and clear the mouse_object

	_vinv_update_inventory();     	// update the inventory
}


// Desc: exchange the item on the mouse with the item in the inventory
// box the player clicked on.
//
// Called by _vinv_put_inventory
function _vinv_exchange_inventory()
{
	// swap items
	venture_temp =  mouse_object;
	mouse_object =  invent_box_content; 	// place inventory item on mouse
	invent_box_content =  venture_temp; 	// place what was on the mouse into inventory
	_vinv_update_inventory();   		// update the inventory
}


// Desc: get the item from the current box and place it in the mouse_object
//
// Called by _vinv_check_inventory
function _vinv_get_inventory()
{
	if(invent_box_content > _EMPTY)
	{
		mouse_object = invent_box_content; # inventory -> mouse
		invent_box_content = _EMPTY; # clear inventory
	}
	_vinv_update_inventory();
}


// Desc: update the player's inventory after inventory_put, inventory_exchange,
//      or inventory_get is called.
//
// Called by inventory_put, inventory_exchange, and inventory_get
function _vinv_update_inventory()
{
	if(invent_box_number == 1)
	{
		i1_status = invent_box_content;
	} # copy the temporary buffer to the box
	if(invent_box_number == 2)
	{
		i2_status = invent_box_content;
	}
	if(invent_box_number == 3)
	{
		i3_status = invent_box_content;
	}
	if(invent_box_number == 4)
	{
		i4_status = invent_box_content;
	}
	if(invent_box_number == 5)
	{
		i5_status = invent_box_content;
	}
	if(invent_box_number == 6)
	{
		i6_status = invent_box_content;
	}
	if(invent_box_number == 7)
	{
		i7_status = invent_box_content;
	}
	if(invent_box_number == 8)
	{
		i8_status = invent_box_content;
	}
	if(invent_box_number == 9)
	{
		i9_status = invent_box_content;
	}
	if(invent_box_number == 10)
	{
		i10_status = invent_box_content;
	}
	if(invent_box_number == 11)
	{
		i11_status = invent_box_content;
	}
	if(invent_box_number == 12)
	{
		i12_status = invent_box_content;
	}
	vinv_critical_items();
	_vinv_update_inventory_content();
	play_sound(klick_snd, 1);
}


// Desc: set each widow box in the inventory to show the proper content
function _vinv_update_inventory_content()
{
	i1_window = i1_status * INVENT_P_invent_temp_item_DX;
	i2_window = i2_status * INVENT_P_invent_temp_item_DX;
	i3_window = i3_status * INVENT_P_invent_temp_item_DX;
	i4_window = i4_status * INVENT_P_invent_temp_item_DX;
	i5_window = i5_status * INVENT_P_invent_temp_item_DX;
	i6_window = i6_status * INVENT_P_invent_temp_item_DX;
	i7_window = i7_status * INVENT_P_invent_temp_item_DX;
	i8_window = i8_status * INVENT_P_invent_temp_item_DX;
	i9_window = i9_status * INVENT_P_invent_temp_item_DX;
	i10_window = i10_status * INVENT_P_invent_temp_item_DX;
	i11_window = i11_status * INVENT_P_invent_temp_item_DX;
	i12_window = i12_status * INVENT_P_invent_temp_item_DX;
}






// Desc: actions to check each of the 12 boxes
//
//  Called when an inventory box button is clicked
//
//  These actions are attached to each of the inventory panel’s 12 item box
// buttons. When an inventory button is clicked on by the player one of two
// things will happen.
//
// 1) If the player has an item on the mouse cursor that item is placed into
// inventory and any item already in that inventory box is place on the mouse
// cursor.
//
// 2) If the player doesn’t have an item on the mouse cursor, any item in
// the inventory box is place on the mouse cursor.
//
//  These actions call _vinv_check_inventory, vinv_inventory_exchange, vinv_inventory_put,
// inventory_get, and inventory_result.
function _vinv_check_i1()
{
	 invent_box_number = 1;		// store the box number
	 invent_box_content = i1_status; 	// store box contents
	 _vinv_check_inventory(); 		//  '_vinv_check_inventory' to preform the appropriate action
}
function _vinv_check_i2()
{
	 invent_box_number = 2;
	 invent_box_content = i2_status;
	 _vinv_check_inventory();
}
function _vinv_check_i3()
{
	 invent_box_number = 3;
	 invent_box_content = i3_status;
	 _vinv_check_inventory();
}
function _vinv_check_i4()
{
	 invent_box_number = 4;
	 invent_box_content = i4_status;
	 _vinv_check_inventory();
}
function _vinv_check_i5()
{
	 invent_box_number = 5;
	 invent_box_content = i5_status;
	 _vinv_check_inventory();
}
function _vinv_check_i6()
{
	 invent_box_number = 6;
	 invent_box_content = i6_status;
	 _vinv_check_inventory();
}
function _vinv_check_i7()
{
	 invent_box_number = 7;
	 invent_box_content = i7_status;
	 _vinv_check_inventory();
}
function _vinv_check_i8()
{
	 invent_box_number = 8;
	 invent_box_content = i8_status;
	 _vinv_check_inventory();
}
function _vinv_check_i9()
{
	 invent_box_number = 9;
	 invent_box_content = i9_status;
	 _vinv_check_inventory();
}
function _vinv_check_i10()
{
	 invent_box_number = 10;
	 invent_box_content = i10_status;
	 _vinv_check_inventory();
}
function _vinv_check_i11()
{
	 invent_box_number = 11;
	 invent_box_content = i11_status;
	 _vinv_check_inventory();
}
function _vinv_check_i12()
{
	 invent_box_number = 12;
	 invent_box_content = i12_status;
	 _vinv_check_inventory();
}




//////////////////////// COMBAT /////////////////////////////////////////

/// combat predefines ////////////////////////
IFNDEF ADV_DEF_COMBAT_SND;
  SOUND weapon_swing_snd, <swing.wav>;
  SOUND weapon_hit_snd, <hit.wav>;
  SOUND player_hurt_snd, <ahh.wav>;      // sound played when player takes damage
ENDIF;



/// combat skills ////////////////////////
var player_hp_minus;				// damage applied to player

var vent_npc_str;             // current STRENGTH, AGILITY, BRAVERY, and INTUITION values of the NPC
var vent_npc_gew;
var vent_npc_mut;
var vent_npc_int;

var vent_attack_value;       	// current attack value
var vent_defense_value;       // current defense value

var hp_minus; 						// damage taken from last attack


/// combat actions ////////////////////////

// Desc:	This action is called to handle attacks on the player.
//
//			Use the STR, MUT, and GEW skills (defined else ware) to calculate an
//      attack on the player.  The player uses their player_mut, gew, and int
//      skills to defend.
//
//       Damage to the player is calculated (player_current_hp is reduced)
//		  and (if damage is greater than zero) player hit is called.
function vcom_player_defense()
{
	vent_attack_value =  (vent_npc_str + vent_npc_mut + vent_npc_gew) / 3; // calculate the NPC attack value
	venture_temp =  (player_mut + player_gew + player_int) / 3; 														// calculate player defense value
	player_hp_minus = random(vent_attack_value / venture_temp * 10); // calculate the damage done by the attack
	player_hp_minus = int(player_hp_minus);
	player_current_hp = player_current_hp - player_hp_minus;
	if(player_hp_minus > 0)                                          // apply damage
	{
		vcom_player_hit();
	}
}


// Desc: This action is called to handle attack by the player.
//
//			Use the player's player_mut, gew, and str to calculate there attack.
//			Use the INT, MUT, and GEW skills (defined else ware) to calculate
//      the defense from the player's attack.
//
//       Damage is calculated and applied to the calling entity's _HEALTH
//      skill. If the entity's _HEALTH skill < 0, its _STATE is set to _NPC_DEAD.
function vcom_player_attack()
{
	vent_defense_value =  (vent_npc_gew + vent_npc_mut + vent_npc_int) / 3; // calculate the NPC defense value
		venture_temp =  (player_mut + player_gew + player_str) / 3; 														// calculate the player attack value
	hp_minus = random(venture_temp / vent_defense_value * 10); // calculate the damage done by the attack
	hp_minus = int(hp_minus);
	MY._HEALTH = MY._HEALTH - hp_minus;                         // apply damage

	if(MY._HEALTH <= 0)
	{
		MY._STATE = _NPC_DEAD;
	}
}

// Desc: This action is called to handle when the player gets hit.
//
//			If the hit has reduced the player's hitpoints to zero or less
//      BRANCH to player_dead.
//
//       Else, play the hurt sound, and flash the blood panel.
function vcom_player_hit()
{
	if(player_current_hp <= 0)
	{
		vcom_player_dead();
		return;
	}
	if(PLAYER.__BUSY)
	{
		return;
	}
	PLAYER.__BUSY = ON;
	play_sound(player_hurt_snd, 40);
	blood_pan.TRANSPARENT = ON;
	blood_pan.VISIBLE = ON;
	waitt(1);
	blood_pan.VISIBLE = OFF;
	PLAYER.__BUSY = OFF;
}



// Desc: This action is called to handle when the player dies.
//
//			Reset the keys, flash blood panel, FREEZE the character, and
//		  show the main menu.
function vcom_player_dead()
{
	vinp_reset_keys();   // restrict player input
 	blood_pan.VISIBLE = ON;
	blood_pan.TRANSPARENT = ON;
	waitt(1);
	blood_pan.TRANSPARENT = OFF;
	vscr_show_admenu();   // show the after death menu
   FREEZE_MODE = 1;	// freeze the game
}





/// combat sword defines ////////////////////////
IFNDEF ADV_DEF_COMBAT;
	DEFINE	COMBAT_SWORD_LENGTH	50;
ENDIF;

DEFINE	_VWEAPON_TYPE,SKILL19;	// used to define the type of weapon this is
DEFINE	_VWEAPON_TYPE_MELEE,1;	// melee weapon
DEFINE	_VWEAPON_TYPE_DIRECT,2;	// direct damage weapon (fireball)

var __HAS_SWORD = OFF; 		// set 'ON' to allow player to use sword
var __WIELD_SWORD = OFF;	// 'ON' to wield the sword ('OFF' to shieth)
var __SHEATHE_SWORD = OFF;	// 'ON' to temp sheathe sword while pointer is on
var __BLOODY;             	// 'ON' for blood, 'OFF' for sparks

/// combat sword skills ////////////////////////
var sw_dist;
var sw_pos;
var sw_temp;
var sw_normal;
var strike_dir;
var strike_angle;


/// combat sword actions ////////////////////////

// Desc: set the sword carry flag to off
function _vcom_remove_sword()
{
	__WIELD_SWORD = OFF;
}

// Desc: create a sword object, set SPACE to remove sword
//       __HAS_SWORD flag must be set ON
function vcom_create_sword()
{
	if(__HAS_SWORD == ON)
	{
		__WIELD_SWORD = ON;
		create(<sw_arm.mdl>, MY_POS, _vcom_carry_sword);
		ON_SPACE = _vcom_remove_sword;
	}
}

// Desc: carry the sword, action attached to the sword model
// Note: the sword's tilt is attached to the camera view to allow the user
//      to aim up and down.
//
function _vcom_carry_sword()
{
	MY.SCALE_X = 0.5;
	MY.SCALE_Y = 0.5;
	MY.SCALE_Z = 0.5;
	MY.NEAR = ON;
	MY.PASSABLE = ON;

	MY._VWEAPON_TYPE = _VWEAPON_TYPE_MELEE;

	while(1)
	{

		// sheathe the sword while mouse pointer is on
		if(__SHEATHE_SWORD == ON)
		{
			remove(ME);
			return;		// exit carry sword action
		}


  		// remove sword...
		if(__WIELD_SWORD == OFF)
		{

			__SHEATHE_SWORD = OFF;	// don't draw sword when mouse pointer is off
			remove(ME);
			ON_SPACE = vcom_create_sword;
			return;		// exit carry sword action
		}

		// Line the sword model up with the player and camera
		sw_dist = 13 + 0.2 * CAMERA.TILT;
		venture_temp.X = COS (PLAYER.PAN);
		venture_temp.Y = SIN (PLAYER.PAN);
		venture_temp.Z = sw_dist * COS (CAMERA.TILT);
		MY.X = PLAYER.X + venture_temp.Z * venture_temp.X;
		MY.Y = PLAYER.Y + venture_temp.Z * venture_temp.Y;
		MY.Z = PLAYER.Z + SIN (CAMERA.TILT);
		MY.PAN = PLAYER.PAN - 180;
		MY.TILT = -CAMERA.TILT + 10;


		// swing the sword...
		if(MY.__BUSY == OFF &&  (KEY_CTRL == ON || MOUSE_LEFT == ON))
		{
			// swing sword
			_vcom_swing_sword();

			// reduce player's strength
 			player_current_str -= 2;
			if(player_current_str <= 0)
			{
				// note: you shouldn't die just because you're out of str
				player_current_str = 0;
			}
		}


		wait(1);
	}
}


// Calculate a 3d position relative to the camera angles
// Input:  p (distance)
// Output: MY_POS
function _vcom_find_sword_edge()
{
   venture_temp.Z = p * cos(CAMERA.TILT);
	venture_temp.X = cos(PLAYER.PAN);
	venture_temp.Y = sin(CAMERA.PAN);

	MY_POS.X = MY.X + venture_temp.Z * venture_temp.X;
	MY_POS.Y = MY.Y + venture_temp.Z * venture_temp.Y;
	MY_POS.Z = MY.Z + p * sin(CAMERA.TILT);
}

//Desc: Animate the sword, check to see if it hit anything
function _vcom_swing_sword()
{
	MY.__BUSY = ON;
	MY.CYCLE = 2;

	while(MY.CYCLE != 1)
	{
		MY.CYCLE += 1;

		// shoot a ray out twice during the swinging action
		if(MY.CYCLE == 10 || MY.CYCLE == 18)
		{
			p = COMBAT_SWORD_LENGTH;     // set p to the sword length
			_vcom_find_sword_edge();
			PLAYER.PASSABLE = ON;   // don't hit self
			SHOOT PLAYER.POS, MY_POS;  // shoot ray from player to sword edge
			PLAYER.PASSABLE = OFF;  // re-enable

			// If we hit something with SHOOT...
			if(RESULT != 0)
			{
				sw_temp = RESULT;

				PLAY_SOUND weapon_hit_snd, 50;
				if(__BLOODY == ON)
				{
					// show hit on target
					_vcom_show_blood_strike();
				}
				else
				{
					// show 'spark' hit (no-blood)
					_vcom_show_wall_strike();
				}
			}
		}
		if(MY.CYCLE == 8 || MY.CYCLE == 15)
		{
			play_sound(weapon_swing_snd, 50);
		}
		if(MY.CYCLE > 18)
		{
			MY.CYCLE = 1;
			MY.__BUSY = OFF;
		}
		waitt(1);
	}
}


// Desc: show a hit on a 'flesh' target
function _vcom_show_blood_strike()
{
	create(<blood+4.pcx>, TARGET, _vcom_splat);
}


// Desc: show a hit on a 'non-flesh' target
function _vcom_show_wall_strike()
{
	create(<glow+4.pcx>, TARGET, _vcom_splat);
}


// Desc: wall and blood strike actions
function _vcom_splat()
{
	if(__BLOODY == ON)
	{
		scatter_init();
		scatter_size = 1;
		scatter_color.RED = 255;
		scatter_color.GREEN = 0;
		scatter_color.BLUE = 0;
		fade_color.RED = 255;
		fade_color.GREEN = 0;
		fade_color.BLUE = 0;
		emit(100, particle_pos, particle_traces);
	}
	else
	{
		scatter_init();
		emit(100, particle_pos, particle_range);
	}
	MY.SCALE_X = 0.1;
	MY.SCALE_Y = 0.1;
	MY.FACING = ON;
	MY.PASSABLE = ON;
	MY.NEAR = ON;
	MY.TRANSPARENT = ON;
	MY.CYCLE = 1;
	sw_normal = 0.1;
	WHILE (MY.CYCLE < 4)
	{
		MY.CYCLE += 0.5 * TIME;
		strike_dir.X = player.X - MY.X;
		strike_dir.Y = player.Y - MY.Y;
		strike_dir.Z = player.Z - MY.Z;
		TO_ANGLE, strike_angle, strike_dir;
		MY.PAN += ang(strike_angle.PAN - MY.PAN);
		YOU = NULL;
 //--		move(ME sw_normal, NULLSKILL);
		move_mode = ignore_you + ignore_passable + ignore_push + activate_trigger + glide;
		result = ent_move(sw_normal,nullskill);
		waitt(1);
	}
	remove(ME);
}




// Desc: Apply damage directly to the entity
// NOTE: hp_minus must be set before calling this action
function vcom_direct_attack()
{
 	hp_minus = int(hp_minus);
	MY._HEALTH = MY._HEALTH - hp_minus;                         // apply damage

	if(MY._HEALTH <= 0)
	{
		MY._STATE = _NPC_DEAD;
	}
}




//////////////////////// DIALOG /////////////////////////////////////////

/// dialog skills ////////////////////////
var actor_dialog_b1;
var actor_dialog_b2;
var actor_dialog_b3;
var exit1;
var exit2;
var exit3;


/// dialog defines ////////////////////////
DEFINE _DIALOG_STATE, SKILL33;  // Used to store the current dialog state


/// dialog strings ////////////////////////
// a blank text string for initializing the
STRING blank_dialog_str, "






                ";



/// dialog text ////////////////////////
TEXT dialog_txt
{
	POS_X 100;
	POS_Y 355;
	LAYER 5;
	FONT panel_font;
	STRING blank_dialog_str;
	FLAGS CONDENSED;
}



/// dialog panels ////////////////////////

// Desc: Two button dialog panel
PANEL dialog1_button_panel
{
	POS_X 61;
	POS_Y 265;
	BUTTON 15, 130, button_map, button_map, button_map, _vdia_button1, NULL, NULL;
	BUTTON 15, 160, button_map, button_map, button_map, _vdia_button2, NULL, NULL;
	LAYER 5;
	FLAGS REFRESH, OVERLAY;
}

// Desc: Single button dialog panel
PANEL dialog2_button_panel
{
	POS_X 61;
	POS_Y 265;
	BUTTON 200, 180, button_map, button_map, button_map, _vdia_button3, NULL, NULL;
	LAYER 5;
	FLAGS REFRESH, OVERLAY;
}


/// dialog actions ////////////////////////

// Desc: This action handles dialog between the player and the NPC's.
//
//	Note: This code is specific to the adventure being written.  It over-
//		  rides the 'dummy' action in venture.wdl
function vdia_make_talk()
{
	beep;
}


// Desc: Make the info2 panel and dialog text visible.
function vdia_show_dialog()
{
	info2_pan.VISIBLE = ON;
	dialog_txt.VISIBLE = ON;
}


// Desc: button 1 action
function _vdia_button1()
{
	NPC_ENTITY._DIALOG_STATE = actor_dialog_b1;
	if(exit1 == ON)
	{
		vscr_close_all();
		NPC_ENTITY._STATE = _NPC_WALK;
		return;
	}
	vdia_make_talk();
}

// Desc: button 2 action
function _vdia_button2()
{
	NPC_ENTITY._DIALOG_STATE = actor_dialog_b2;
	if(exit2 == ON)
	{
		vscr_close_all();
		NPC_ENTITY._STATE = _NPC_WALK;
		return;
	}
	vdia_make_talk();
}

// Desc: button 3 action
function _vdia_button3()
{
	NPC_ENTITY._DIALOG_STATE = actor_dialog_b3;
	if(exit3 == ON)
	{
		vscr_close_all();
		NPC_ENTITY._STATE = _NPC_WALK;
		return;
	}
	vdia_make_talk();
}




//////////////////////// SPELLS /////////////////////////////////////////
// The following actions deal with spell casting and their effects
//

/// spell skills ////////////////////////
var vsk_fb_speed[3] = 30, 0, 0;

/// spell sounds ////////////////////////
SOUND zisch_snd, <whosh.wav>;
SOUND schuss_snd, <explosin.wav>;


/// spell actions ////////////////////////

// Desc: have the player cast a fireball
function vspl_player_cast_fireball()
{
	ME = PLAYER;
	vspl_cast_fireball();
}


// Desc: cast a fireball
// NOTE: MY should be set to the caster.
function vspl_cast_fireball()
{
   venture_temp.Z = 35 * cos(MY.TILT);
	venture_temp.X = cos(MY.PAN);
	venture_temp.Y = sin(MY.PAN);


	MY_POS.X = MY.X + venture_temp.Z * venture_temp.X;
	MY_POS.Y = MY.Y + venture_temp.Z * venture_temp.Y;
	MY_POS.Z = MY.Z + 35 * sin(MY.TILT);


 	create(<fball.pcx>, MY_POS, _vspl_fball_action);   // create a fireball entity
}

// Desc: fireball event
function _vspl_fball_event()
{
	EXCLUSIVE_ENTITY;	// stop all actions started by this one

	if(YOU == PLAYER)
	{
		_vspl_fball_hit_player();
		MY.ENABLE_TRIGGER = OFF;
	}

	// Explode
	play_entsound(ME,schuss_snd,100);
	morph(<explo+7.pcx>, ME);
	MY.AMBIENT = 100;
	MY.PASSABLE = ON;
	while(MY.CYCLE <= 7)
	{
		MY.CYCLE += TIME;
		waitt(1);
	}
	remove(ME);
}

// Desc: fireball action
function _vspl_fball_action()
{
	MY._VWEAPON_TYPE = _VWEAPON_TYPE_DIRECT;
	MY.ENTITY1 = YOU;		// link back to the caster
	MY.AMBIENT = 100;
	//	MY.TRANSPARENT = ON;
	//	MY.SCALE_X = 1;
	MY.LIGHTRANGE = 400;
	MY.LIGHTRED = 50;
	MY.LIGHTGREEN = 50;
	MY.LIGHTBLUE = 200;
	MY.PAN =  YOUR.PAN; // let it fly in view direction = like a bullet
	MY.ROLL = YOUR.ROLL;
	MY.TILT = YOUR.TILT;
	MY.EVENT = _vspl_fball_event;
	MY.ENABLE_BLOCK = ON;
	MY.ENABLE_ENTITY = ON;
	MY.ENABLE_TRIGGER = ON;
	MY.TRIGGER_RANGE = 35;
	wait(1);	// for play_entsound

	play_entsound(ME, zisch_snd, 400);


 	while(1)
	{
		//YOU = NULL;
 //--		move(ME, vsk_fb_speed, nullskill);
		move_mode = ignore_you + ignore_passable + ignore_push + activate_trigger;
		result = ent_move(vsk_fb_speed,nullskill);
		_vspl_fball_particle_init();
		wait(1);
	}
}


// Desc: handle a fireball hit on the player
function _vspl_fball_hit_player()
{
	player_current_hp -= 15;
	vcom_player_hit();
}


// Desc: initialize the particles falling from the fireball.
function _vspl_fball_particle_init()
{
	particle_pos.X = MY.X;
	particle_pos.Y = MY.Y;
	particle_pos.Z = MY.Z;
	emit(40, particle_pos, _vspl_fball_particle);
}

// Desc: fireball particles
function _vspl_fball_particle()
{
	if(MY_AGE == 0)
	{
		MY_MAP = scatter_map;
		MY_FLARE = ON;
		MY_SPEED.X = scatter_speed.X + random(scatter_spread);
		MY_SPEED.Y = scatter_speed.Y + random(scatter_spread);
		MY_SPEED.Z = scatter_speed.Z + random(scatter_spread);
		MY_SIZE = 80;
		MY_COLOR.RED = 255;
		MY_COLOR.GREEN = 255;
		MY_COLOR.BLUE = 255;
	}
	MY_COLOR.RED -= 20;
	MY_COLOR.GREEN -= 15;
	MY_COLOR.BLUE -= 10;
	#if(MY_AGE > shot_lifetime)
	if(MY_COLOR.RED <= 20)
	{
		MY_ACTION = NULL;
	}
}




//////////////////////// INPUT //////////////////////////////////////////
// These are actions manage the user's input (mouse/keyboard)
//

/// input predefines ////////////////////////
IFNDEF ADV_DEF_CURSOR_MAP;
	BMAP mouse_l_map, <arrow.pcx>;  	// mouse cursor image map
ENDIF;

/// input defines ////////////////////////
DEFINE MOUSE_WALK, -1; // mouse walk mode

/// input skills ////////////////////////
//--SYNONYM vinp_left_mouse_action_syn {TYPE ACTION;}  // action preformed by the left mouse button
action* vinp_left_mouse_action_syn;						// action preformed by the left mouse button
var	  old_mouse_object = -1;							// used for comparisons


/// input actions ////////////////////////

// Desc: initialize the mouse settings
function vinp_init_mouse()
{
	MOUSE_RANGE = 400;
}

// Desc: switches the mouse pointer on and off
//
// NOTE: if MOUSE_MODE > 2, _vinp_mouse_hnadler will turn it off and put
//      any mouse_objects into inventory
function vinp_toggle_mouse()
{
	MOUSE_MODE += 2;
 	_vinp_update_mouse();
}

// Desc: switch mouse on
function vinp_show_mouse()
{
	MOUSE_MODE = 2; // switches the mouse on
	_vinp_update_mouse();
}

// Desc: switch mouse off
function vinp_hide_mouse()
{
	MOUSE_MODE = 0; // switches the mouse off
	_vinp_update_mouse();
}

// Desc: if there is an object on the mouse, place it in the first empty slot
// in the inventory
function vinp_clear_mouse_to_inventory()
{
	if(mouse_object > _EMPTY)
	{
		//place the mouse object into the first empty space
		invent_temp_item = mouse_object;     // set the item to the mouse_object
		vinv_put_item_inventory(); // put the item in the next empty slot in inventory
		mouse_object = _EMPTY; // clear the mouse_object
   }
}

// Desc: handle updates to the mouse (movement, mouse_object change, etc)
function _vinp_update_mouse()
{
	MOUSE_RANGE = 400;

	//
	if(MOUSE_MODE > 2)// hide mouse pointer
	{
		vinp_clear_mouse_to_inventory(); // place mouse_object into inventory
		mouse_object = MOUSE_WALK;          // mouse can be used to walk
		MOUSE_MODE = 0;
		vttx_hide_touch_text();          // no touch text
		vinv_hide_inventory();           // hide inventory box

	 	// draw sheathed sword (if it was drawn before)
		if(__SHEATHE_SWORD == ON)
		{
			__SHEATHE_SWORD = OFF;	// sword no longer sheathed
			vcom_create_sword();
		}

		return;
	}

	// sheathe sword before showing mouse pointer
	if(__WIELD_SWORD == ON)
	{
		__SHEATHE_SWORD = ON;
	}

	vinp_left_mouse_action_syn = NULL;
	MOUSE_MAP = mouse_l_map;
	MOUSE_POS.X = 256;
	MOUSE_POS.Y = 190;
	mouse_object = MOUSE_WALK;
	old_mouse_object = mouse_object; //save the current mouse_object temporary


	while(MOUSE_MODE > 0)
	{
		// update the mouse's position
		MOUSE_POS.X = POINTER.X;
		MOUSE_POS.Y = POINTER.Y;
		// check to see if the mouse_object has changed
		if(old_mouse_object != mouse_object)
		{
			_vinp_change_mouse_map(); //change the mouse sprite

			// update the old_mouse_object to the current mouse object
			old_mouse_object = mouse_object;
		}


		// If the mousesprite is an item...
		if(mouse_object > _EMPTY)
		{

			// ...and it is over the inventory and then inventory is closed...
			// !!!DcP- add code to make 'over the inventory' more general
			if((MOUSE_POS.X > 512) && (__INVENT_STATE == OFF))
			{
				invent_toggle_syn();         // toggle inventory
				vinp_left_mouse_action_syn = NULL;	// deactivate any mouse action
			}

			// ...and it is over the open inventory panel or side bar...
			if( (MOUSE_POS.X > 380) && (__INVENT_STATE == ON) )
			{
				vinp_left_mouse_action_syn = NULL;     // deactivate any mouse action
			}

			// ...and it is NOT over the open inventory ...
			if( (MOUSE_POS.X < 380) && (__INVENT_STATE == ON) )
			{
				invent_toggle_syn();	// close the inventory box
			}

			// ...and it is NOT over the inventory...
			if(MOUSE_POS.X < 380)
			{
 				vinp_left_mouse_action_syn = _vitm_use_item; 	// set left mouse button to use_item
 			}


			}
		else // (mouse_object <= _EMPTY)
		{
			vinp_left_mouse_action_syn = NULL;
		}


		ON_MOUSE_LEFT = vinp_left_mouse_action_syn;
		wait(1);
	}
}

// Desc: change the mouse map to whatever item the user may be holding
//
// Note: calls the user defined action 'vinp_set_mouse_map_to_item'
//
// Called from '_vinp_update_mouse'
function _vinp_change_mouse_map()
{
	if(mouse_object > _EMPTY)
	{
		// set the mouse map to the current mouse_object's map
		vinp_set_mouse_map_to_item();
	}
	else
	{
		// no mouse item, revert to mouse cursor
		MOUSE_MAP = mouse_l_map;
		MOUSE_SPOT.X = 0;
		MOUSE_SPOT.Y = 0;
	}
}


// Desc: set the mouse map image to that of an item
//
// NOTE: OVERRIDE THIS ACTION IN YOU GAME WDL
function vinp_set_mouse_map_to_item()
{
	wait(1);
}



// Desc: deactivate keyboard input
function vinp_reset_keys()
{
	ON_F1 = NULL;
	ON_F2 = NULL;
	ON_F3 = NULL;
	ON_F4 = NULL;
	ON_F5 = NULL;
	ON_F6 = NULL;
	ON_F7 = NULL;
	ON_F8 = NULL;
	ON_F9 = NULL;
	ON_F10 = NULL;
	ON_F11 = NULL;
	ON_F12 = NULL;
	ON_ESC = NULL;
	ON_ANYKEY = NULL;
	ON_MOUSE_RIGHT = vinp_toggle_mouse;
}


// Desc: Initialize key mapping
//
// NOTE: override this action to change your key settings
function vinp_init_keys()
{
	ON_F1 = vscr_toggle_help;
	ON_F2 = vpic_save;
	ON_F3 = vpic_load;
	ON_F5 = NULL;//toggle_detail;
	ON_F7 = vscr_toggle_credits;
	ON_F10 = vscr_show_exit;
	ON_F11 = NULL;//toggle_gamma;
	ON_ESC = vscr_close_all;
	ON_I = vinv_toggle_inventory;
	ON_C = vpst_toggle_char;
	ON_M = vscr_toggle_menu;
	ON_Y = NULL;
	ON_J = NULL;
	ON_N = NULL;
	ON_ANYKEY = NULL;
}



//////////////////////// TOUCH TEXT /////////////////////////////////////
// These actions handle 'touch' text (item text that appears when the
// player 'touches' something with the mouse cursor).
//

/// touch text strings ////////////////////////
STRING vent_null_str, " ";

/// touch text text ////////////////////////
TEXT touch_txt_old
{
	POS_X 320;
	POS_Y 410;
	LAYER 2;
	FONT panel_font;
	STRING vent_null_str;
	FLAGS VISIBLE,CENTER_X;
}
TEXT wrong_item_txt
{
	POS_X 320;
	POS_Y 410;
	LAYER 2;
	FONT panel_font;
	STRING wrong_item_str;
	FLAGS CENTER_X;
}


/// touch text actions ////////////////////////

// Desc: show touch text
function vttx_show_touch_text()
{
	 touch_txt_old.STRING = MY.STRING1;
}

// Desc: hide touch text
function vttx_hide_touch_text()
{
	touch_txt_old.STRING = vent_null_str;
	touch_txt.visible = off;
}


// Desc: indicate that this is the wrong item
// (hide the touch text and display the wrong item text
// for 2-seconds)
function vttx_show_wrong_item_text()
{
	touch_txt_old.VISIBLE = OFF;
	wrong_item_txt.VISIBLE = ON;
	waitt(32);

	touch_txt_old.VISIBLE = ON;
	wrong_item_txt.VISIBLE = OFF;
}



//////////////////////// MISC ///////////////////////////////////////////


/// misc actions ////////////////////////

// Desc: fade to black and exit game.  Display the vstr_exit_txt exit
//      string in the exit window.
function vmsc_exit()
{
	blood_pan.VISIBLE = OFF;

 	blackTop13_pan.VISIBLE = ON;
	waitt(1);
	blackTop14_pan.VISIBLE = ON;
	waitt(1);
	blackTop15_pan.VISIBLE = ON;
	waitt(1);
	blackTop16_pan.VISIBLE = ON;
	waitt(1);


  	EXIT  vstr_exit_txt;
}





/// screen actions (cont.) ////////////////////////
// Screen actions that require all the venture panels to be defined.

// Desc: Hide all panels and text.
function _vscr_hide_all()
{
	_vpic_save_hide();               		// hide save panel

	blackTop16_pan.VISIBLE = OFF;          // hide blackout panels
	blackTop15_pan.VISIBLE = OFF;
	blackTop14_pan.VISIBLE = OFF;
	blackTop13_pan.VISIBLE = OFF;

	info1_pan.VISIBLE = OFF;              	// hide info1 panel and text
	info1_txt.VISIBLE = OFF;
	info2_pan.VISIBLE = OFF;               // hide info2 panel and text
	info2_txt.VISIBLE = OFF;

	start_menu_vbpan.VISIBLE = OFF;        // hide button panels
	info_exit_vbpan.VISIBLE = OFF;
	intro_exit_vbpan.VISIBLE = OFF;
	info_exit_right_vbpan.VISIBLE = OFF;
	main_menu_vbpan.VISIBLE = OFF;
	admenu_vbpan.VISIBLE = OFF;
	exit_vbpan.VISIBLE = OFF;
	start_exit_vbpan.VISIBLE = OFF;

	char_pan.VISIBLE = OFF;               	// hide character panels
	bonus_pan.VISIBLE = OFF;
	bonus_info_txt.VISIBLE = OFF;

	dialog_txt.VISIBLE = OFF;              // hide dialog text and panels
	dialog1_button_panel.VISIBLE = OFF;
	dialog2_button_panel.VISIBLE = OFF;


	//  toggles
	menu_toggle_syn = vscr_show_menu;		//  menu toggle to show menu
	help_toggle_Syn = vscr_show_help;		//  help toggle to show help
	credit_toggle_Syn = vscr_show_credits;//  help toggle to show credits
	char_toggle_syn = vpst_show_char;		//  char toggle to show char
}




// Desc: Hide all panels, init the keys, enable icons.
function vscr_close_all()
{
	_vscr_hide_all();					// hide all panels and text

	vinp_init_keys();       		// init/reactivate keys

	__ICON_ACTIVE = ON;              // allow player to use icons

	play_sound(klick_snd, 50);
}


// Desc: Hide all panels, reset the keys, disable icons.
function vscr_close_all_at_start()
{
	_vscr_hide_all();				  	// hide all panels and text

	vinp_reset_keys();            // reset/disable the keys
	__ICON_ACTIVE = OFF;            	// disable player from using icons
	play_sound(klick_snd, 50);
}


// Desc: Hide all panels, reset the keys, enable icons.
function vscr_close_all_at_end()
{
	_vscr_hide_all();					// hide all panels and text

	vinp_reset_keys();          	// reset/disable the keys
	__ICON_ACTIVE = ON;             	// enable player to use icons
	play_sound(klick_snd, 50);

}