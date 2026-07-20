//@
# VR GAMES                       WDL-Script                      Project: DEMO ADEPTUS
#
# Auftraggeber   : Conitec GmbH
#
#*********************************************************************
# Module        : adept2.wdl - Kundenversion
# Version       : 2.1 (Made with WDL-STUDIO & Beautyfier)
# Date          :  19.8.99
# Responsible   : Harald Schmidt
# Description   : Conitec Demo-RPG
# *********************************************************************
// Revision 1 02-04-00 JC: Cleaned up everything a little
//
// Revision 2 03-20-00 DP: Commented code
//@
////////////////////////////////////////////////////////////////////////

///////////INCLUDES/////////////////////////////////////////////////////
PATH "..\\template";

INCLUDE <movement.wdl>;
INCLUDE <messages.wdl>;
INCLUDE <menu.wdl>;
INCLUDE <particle.wdl>;
INCLUDE <doors.wdl>;
////////////////////////////////////////////////////////////////////////
var d3d_panels = 1;
var scene_nofilter = 1;

//////////// OVERRIDE VENTURE.WDL ////////////////////////////////////////////

DEFINE ADV_DEF_ADVENTURE_TEXT;	// override general adventure text



STRING wrong_key_str, "This key doesn't fit!";
STRING wrong_item_str, "Try another item!";
STRING wrong_type_str, "Nothing happend!";
STRING level_info_str, "You made a level!
You may share   bonus points!";

STRING start1_str, "


        Start new game

        Load game

        Exit Game";



STRING bonus_info_str,
  "\nYou may share   bonus points!      Finished";

  STRING char_pan_str, "             Character Skills


   Hitpoints:   /       Bravery:

   Mana:        /       Intuition:

   Strength:    /       Level:

   Agility:             Experiencep.:

                        Next Level:
                        ";


////////Online hilfe ////////////////////////
STRING help_str"Keyboard commands

F1  - Help           C  - Character
F2  - Save           I  - Inventory
F3  - Load       Space  - Weapon on/off
F10 - Exit         Home - Jump

Mouse Right       - Mouse on/off
Mouse Left / Ctrl - Fight
Pg Up / Pg Dn     - Look up/down";
/////////////////// Menu //////////////////////////////////
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
STRING admenu_str, //*
"


        Start new game

        Save game

        Load game

        Exit game

        Help

        Credits
        ";
STRING exit_str, "
Back to your boring desktop?



        Yep!

        Nope!";

STRING vstr_exit_txt,
"Thank You for playing this demo!
This adventure was created by Harald Schmidt\nat Invoked Game Development (www.invoked.de)\nfor CONITEC Datensysteme (www.conitec.com)
____________________________________________
The entire demo was developed with 3D GameStudio / A4.
____________________________________________
";


STRING credit_str, "This tutorial adventure was created by
______________________________________________
Invoked Developement     (invoked.de)
for Conitec Datensysteme (www.conitec.com)
______________________________________________

Leveldesign, Programming:     Harald Schmidt
Concept:                      Harald Schmidt
Test:                    Alexander Diekmeyer
All grafics and sounds:       Harald Schmidt
Add. grafics and sounds:   Reinhard Wissdorf
She who made it possible:         Karin Born
______________________________________________
The entire demo was developed with the ACKNEX
engine and toolkit: 3D GAME STUDIO (tm)
Visit the ACKNEX USERS MAGAZINE:
www.conitec.com/aum";


STRING vent_blank_str, "


                      ";

// END PREDEFINE ADV_DEF_ADVENTURE_TEXT


DEFINE ADV_DEF_SAVE_LOAD;	// "predefine" to change default 'venture' definitions
 DEFINE PICSIZE_X 128;  	// size of save game bitmaps
 DEFINE PICSIZE_Y 96;

 BMAP slot1_map, <save1.pcx>; // default save/load game bitmaps
 BMAP slot2_map, <save2.pcx>;
 BMAP slot3_map, <save3.pcx>;
 BMAP slot4_map, <save4.pcx>;

 DEFINE PICSAVE_BKGD;	// panel has background
 DEFINE picsavebk_map info1_map;        // save panel background bitmap
 DEFINE picloadbk_map info1_map;        // load panel background bitmap



 DEFINE PICSAVE_TEXT;	// titles for each slot

 DEFINE PICSLOT1_X 40;   // location of save/load game bitmaps
 DEFINE PICSLOT1_Y 10;
 DEFINE PICSLOT2_X 240;
 DEFINE PICSLOT2_Y 10;
 DEFINE PICSLOT3_X 40;
 DEFINE PICSLOT3_Y 105;
 DEFINE PICSLOT4_X 240;
 DEFINE PICSLOT4_Y 105;
 DEFINE PICEXIT_X  375;  // location of exit button
 DEFINE PICEXIT_Y  174;
// END "SAVE/LOAD" predefines


//////////////// OVERRIDE INVENTORY ////////////////////////////////////
DEFINE ADV_DEF_INVENT_P;      	     // uncomment to override venture inventory bitmaps
 	BMAP invent_map, <bg611i.pcx>;     // 12 box inventory panel map
	BMAP invent_item_map, <inv_ov.pcx>;// inventory items map

	BMAP i1_map, <bg611i.pcx>, 2, 2, 62, 70;	// 1 box of the 12 box inventory panel
	BMAP i2_map, <bg611i.pcx>, 66, 2, 62, 70;
	BMAP i3_map, <bg611i.pcx>, 2, 72, 62, 62;
	BMAP i4_map, <bg611i.pcx>, 66, 72, 62, 62;
	BMAP i5_map, <bg611i.pcx>, 2, 135, 62, 62;
	BMAP i6_map, <bg611i.pcx>, 66, 135, 62, 62;
	BMAP i7_map, <bg611i.pcx>, 2, 197, 62, 62;
	BMAP i8_map, <bg611i.pcx>, 66, 197, 62, 62;
	BMAP i9_map, <bg611i.pcx>, 2, 260, 62, 58;
	BMAP i10_map, <bg611i.pcx>, 66, 260, 62, 58;
	BMAP i11_map, <bg611i.pcx>, 2, 320, 62, 62;
	BMAP i12_map, <bg611i.pcx>, 66, 320, 62, 62;


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


	DEFINE INVENT_P_LAYER	4;		// inventory panel layer


///// OVERRIDE PLAYER INTERFACE DEFINES
DEFINE ADV_DEF_SCREEN_MAPS;
  BMAP button_map, <bg611bt.pcx>;    		// button bitmap

  BMAP char_button_map, <bg611.pcx>, 535, 0, 60, 100;          // icon for character button
  BMAP inv_button_map, <bg611.pcx>, 530, 120, 70, 85;          // icon for inventory button
  BMAP menu_button_map, <bg611.pcx>, 570, 210, 70, 70;         // icon for menu button
  BMAP screen_map, <bg611.pcx>;                                // the entire screen map
  BMAP hpbar_map, <redbar.pcx>;                                // hitpoint bar map
  BMAP strbar_map, <grnbar.pcx>;                               // strenth bar map
  BMAP manabar_map, <bluebar.pcx>;                             // mana bar map
  BMAP info1_map, <bg611nf1.pcx>;        								// info1 panel bitmap (used for save and load)
  BMAP info2_map, <bg611nf2.pcx>;    									// small info-text panel



   FONT panel_font, <font3a.pcx>,8,10;    // panel font bitmap

  DEFINE  SCREEN_STAT_HP_BAR_X     540;      // X offset for the hitpoints bar
  DEFINE  SCREEN_STAT_HP_BAR_Y      10;      // Y offset for the hitpoints bar
  DEFINE  SCREEN_STAT_STR_BAR_X    555;      // X offset for the strength bar
  DEFINE  SCREEN_STAT_STR_BAR_Y     10;      // Y offset for the strength bar
  DEFINE  SCREEN_STAT_MANA_BAR_X   570;      // X offset for the mana bar
  DEFINE  SCREEN_STAT_MANA_BAR_Y    10;      // Y offset for the mana bar

  DEFINE  SCREEN_STAT_BAR_HEIGHT    80;      // the height of the stat bars

  DEFINE  SCREEN_STAT_BAR_FACTOR   1.0;      // vertical shifting factor

  BMAP blood_splash_map <redf.pcx>;          // blood red splash (shown when player is damaged)
  BMAP black_map <blackf.pcx>;               // blackout bitmap (used for fades)

// end screen define override




DEFINE ADV_DEF_CURSOR_MAP;
	BMAP mouse_l_map, <curs_l.pcx>;  	// mouse cursor image map

/**/


INCLUDE <venture.wdl>;    // INCLUDE venture script file

/*
 * Redefine venture skills
 */

//// Redefine venture save/load skills /////////////////////////////////
var picsave_pos[2] = 60,265;	// panel position
var pictext_offs = 84;		// distance picture to title


////////////////////////////////////////////////////////////////////////
// new default values for predefined skills
var VIDEO_MODE = 6;
var VIDEO_DEPTH = 16;

////// common skills, synonyms and definitions //////////////////////////
DEFINE KEY, SKILL33;


DEFINE TRUE, 1;
DEFINE FALSE, 0;
DEFINE YES, 1;
DEFINE NO, 0;
DEFINE OPEN, 1;
DEFINE CLOSED, 0;


DEFINE M_MENU, -2; # normale Menumaus u. Infos ?ber Items im Inventory

// ADEPT invent_temp_item IDs
DEFINE M_KEY1, 1;
DEFINE M_KEY2, 2;
DEFINE M_GEM, 3;
DEFINE M_RUBY, 4;
DEFINE M_BLATT, 5;
DEFINE M_FISH, 6;
DEFINE M_SWORD, 7;
DEFINE M_WATEREMPTY, 8;
DEFINE M_WATERFULL, 9;


DEFINE M_ANGEL, 21; #friendlies
DEFINE M_CYNTHIA, 22;
DEFINE M_SORC, 23; #kleiner Infotext
DEFINE M_SCORP, 31; #Bad Ones
DEFINE M_DOOR, 41; #Doors
DEFINE M_SPELLDOOR, 42;
DEFINE M_DOOR1, 46;
DEFINE M_DOOR2, 47;
DEFINE M_BOOK, 51; #groáer Infotext
DEFINE M_STATUE, 62;
DEFINE M_FIRE, 63;
DEFINE M_FOUNTAIN, 64;
DEFINE M_VASE, 65;
DEFINE M_MOBILE, 66;
DEFINE M_CHAIN1, 71;
DEFINE M_CHAIN2, 72;
DEFINE M_CHAIN3, 73;
DEFINE M_CHAIN4, 74;
DEFINE M_CHAIN5, 75;
DEFINE M_PYR1, 81;
DEFINE M_PYR2, 82;
DEFINE M_PYR3, 83;
DEFINE M_PYR4, 84;
DEFINE M_GLOW, 85;
DEFINE S_BONUS, 1;
DEFINE S_CHAR, 2;
DEFINE S_INV, 3;
DEFINE S_DIAL, 4;
DEFINE S_START1, 5;
DEFINE S_MENU, 6;
DEFINE S_HELP, 7;
DEFINE S_CREDIT, 8;
DEFINE S_SAVE, 9;
DEFINE S_LOAD, 10;

////////////////////////////////////////////////////////////////
SYNONYM DPAN {TYPE PANEL;}

SYNONYM CHAR_SYN {TYPE ACTION;DEFAULT vpst_show_char;}
SYNONYM DEBUG_ACT {TYPE ENTITY;}
SYNONYM PLATE {TYPE ENTITY;}
SYNONYM PLATE1 {TYPE ENTITY;}
SYNONYM PLATE2 {TYPE ENTITY;}
SYNONYM PLATE3 {TYPE ENTITY;}
SYNONYM PLATE4 {TYPE ENTITY;}# strings

// Player Save vars
//
var chain1_skill = 0;
var chain2_skill = 0;
var chain3_skill = 0;
var chain4_skill = 0;
var __HAS_DIAMOND = FALSE;

var cynth_exp = 80;     // exp from cynth

//////////// INCLUDES  /////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
IFNDEF german;
INCLUDE <string_e.wdl>;
IFELSE;
INCLUDE <string.wdl>;
ENDIF;

INCLUDE <material.wdl>; # fonts, sounds, skies etc.
INCLUDE <aparticl.wdl>;


///////////// CURSOR ACTIONS ///////////////////////////////////////////

// Desc: set the mouse map image to that of an item
//
// Note: This action is an override of a empty venture.wdl action
ACTION vinp_set_mouse_map_to_item
{
	MOUSE_SPOT.X = 35;
	MOUSE_SPOT.Y = 35;
	IF (mouse_object == M_KEY1)
	{
		SET MOUSE_MAP, key1_map;
	}
	IF (mouse_object == M_KEY2)
	{
		SET MOUSE_MAP, key2_map;
	}
	IF (mouse_object == M_GEM)
	{
		SET MOUSE_MAP, gem1_map;
	}
	IF (mouse_object == M_RUBY)
	{
		SET MOUSE_MAP, ruby_map;
	}
	IF (mouse_object == M_BLATT)
	{
		SET MOUSE_MAP, blatt_map;
	}
	IF (mouse_object == M_FISH)
	{
		SET MOUSE_MAP, fish_map;
	}
	IF (mouse_object == M_SWORD)
	{
		SET MOUSE_MAP, sword_map;
	}
	IF (mouse_object == M_WATEREMPTY)
	{
		SET MOUSE_MAP, waterempty_map;
	}
	IF (mouse_object == M_WATERFULL)
	{
		SET MOUSE_MAP, waterfull_map;
	}
}


INCLUDE <entity.wdl>; # initialisation of level entities (npc's, items, doors)
INCLUDE <a4panel.wdl>; # player screens - menues, inventory etc.
INCLUDE <adoors.wdl>; # common door, lift and trigger methods
INCLUDE <debug.wdl>;


// OVERRIDE
// Desc: Initialize key mapping
//
// NOTE: this action is overriden to change your key settings
ACTION vinp_init_keys
{
	SET ON_F5, NULL; //toggle_detail;
	SET ON_ESC, vscr_close_all;
	SET ON_F11, toggle_gamma;
	SET ON_F1, vscr_toggle_help;
	SET ON_F2, vpic_save;
	SET ON_F3, vpic_load;
	SET ON_F7, vscr_toggle_credits;
  	SET ON_F8 _save;
	SET ON_F9 _load;
 	SET ON_F10, vscr_show_exit;
	SET ON_F12 console;

	SET ON_H handle;
	SET ON_I, vinv_toggle_inventory;
	SET ON_C, vpst_toggle_Char;
	SET ON_M, vscr_toggle_menu;
	SET ON_Y, NULL;
	SET ON_J, NULL;
	SET ON_N, NULL;
	SET ON_ANYKEY, NULL;
}


/////////////////// ACTOR DIALOG ///////////////////////////////////////
// Desc: This action handles dialog between the player and the NPC's.
//
//	Note: This code is specific to the adventure being writen.  It overrides
//      the 'dummy' action in venture.wdl
ACTION vdia_make_talk
{
	CALL vscr_close_all;
	CALL vinp_reset_keys;

	__ICON_ACTIVE = OFF;     // don't let player use buttons
	SET exit1, NO;
	SET exit2, NO;
	SET exit3, NO;
	IF (PLAYER._DIALOG_STATE == 51)
	{
		NPC_ENTITY._DIALOG_STATE = 51;
	}

	IF (NPC_ENTITY.ENT_ID == M_ANGEL)
	{
		IF (NPC_ENTITY._DIALOG_STATE == 11)
		{
			SET dialog_txt.STRING angel11_str;
			SET dialog1_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b1, 13;
			SET actor_dialog_b2, 12;
			SET exit2, YES;
		}
		IF (NPC_ENTITY._DIALOG_STATE == 12)
		{
			SET dialog_txt.STRING angel12_str;
			SET dialog1_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b1, 14;
			SET actor_dialog_b2, 12;
			SET exit2, YES;
		}
		IF (NPC_ENTITY._DIALOG_STATE == 13)
		{
			SET dialog_txt.STRING angel13_str;
			SET dialog1_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b1, 14;
			SET actor_dialog_b2, 12;
			SET exit2, YES;
		}
		IF (NPC_ENTITY._DIALOG_STATE == 14)
		{
			SET dialog_txt.STRING angel14_str;
			SET dialog1_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b1, 21;
			SET actor_dialog_b2, 12;
			SET exit2, YES;
		}
		IF (NPC_ENTITY._DIALOG_STATE == 21)
		{
			SET dialog_txt.STRING angel21_str;
			SET dialog1_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b1, 32;
			SET actor_dialog_b2, 12;
			SET exit1, YES;
			SET exit2, YES;
		}
		IF (NPC_ENTITY._DIALOG_STATE == 32)
		{
			SET dialog_txt.STRING angel32_str;
			SET dialog1_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b1, 32;
			IF (__HAS_DIAMOND == TRUE)
			{
				SET actor_dialog_b1, 42;
			}
			SET actor_dialog_b2, 41;
			#	SET exit1, YES;
		}

		IF (NPC_ENTITY._DIALOG_STATE == 41)
		{
			SET dialog_txt.STRING angel41_str;
			SET dialog2_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b3, 32;
			SET exit3, YES;
		}

		IF (NPC_ENTITY._DIALOG_STATE == 42)
		{
			SET dialog_txt.STRING angel42_str;
			SET dialog2_button_panel.VISIBLE, TRUE;
			SET give_exp, 200;
			__HAS_DIAMOND = FALSE;
			invent_temp_item = M_GEM;
			CALL vinv_delete_item_inventory;
			spelldoor_open = TRUE;
			CALL vpst_check_exp;
			SET actor_dialog_b3, 51;
			SET exit3, YES;
		}
		IF (NPC_ENTITY._DIALOG_STATE == 51)
		{
			SET dialog_txt.STRING angel51_str;
			SET dialog2_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b3, 51;
			SET exit3, YES;
		}
		IF (NPC_ENTITY._DIALOG_STATE == 61)
		{
			SET dialog_txt.STRING angel61_str;
			SET dialog2_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b3, 61;
			SET exit3, YES;
		}
	}
	IF (NPC_ENTITY.ENT_ID == M_CYNTHIA)
	{
		IF (NPC_ENTITY._DIALOG_STATE == 11)
		{
			SET dialog_txt.STRING cynth11_str;
			SET dialog1_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b1, 21;
			SET actor_dialog_b2, 22;
		}
		IF (NPC_ENTITY._DIALOG_STATE == 21)
		{
			SET dialog_txt.STRING cynth21_str;
			SET dialog1_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b1, 31;
			SET actor_dialog_b2, 11;
			SET exit2, YES;       // button 2 exits the conversation
		}
		IF (NPC_ENTITY._DIALOG_STATE == 22)
		{
			SET dialog_txt.STRING cynth22_str;
			SET dialog1_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b1, 31;
			SET actor_dialog_b2, 11;
			SET exit2, YES;
			SET give_exp, cynth_exp;
			CALL vpst_check_exp;
			SET cynth_exp, 0;
		}
		IF (NPC_ENTITY._DIALOG_STATE == 31)
		{
			SET dialog_txt.STRING cynth31_str;
			SET dialog2_button_panel.VISIBLE, TRUE;
			SET invent_temp_item, M_KEY2;
			CALL vinv_put_item_inventory;
			SET actor_dialog_b3, 41;
			SET exit3, YES;
		}
		IF (NPC_ENTITY._DIALOG_STATE == 41)
		{
			SET dialog_txt.STRING cynth41_str;
			SET dialog2_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b3, 41;
			SET exit3, YES;
		}
		IF (NPC_ENTITY._DIALOG_STATE == 51)
		{
			SET dialog_txt.STRING cynth51_str;
			SET dialog2_button_panel.VISIBLE, TRUE;
			SET actor_dialog_b3, 51;
			SET exit3, YES;
			create_pos.X = -1150;
			create_pos.Y = -1082;
			create_pos.Z = -180;
			CREATE <tp+7.pcx>, create_pos, tp_ani;
		}
	}
	CALL vdia_show_dialog;
}



/////////////////////////////////////////////////////////////////
// The following definitions are for the WDFC window composer
// to define the start and exit window of the application.
WINDOW WINSTART
{
	TITLE"Adeptus Ver 2.0";
	SIZE 300, 600; # 135;
	MODE IMAGE; //      STANDARD;
	BG_COLOR RGB (50, 50, 50);
	#FRAME FTYP3, 20, 20, 320, 300;
	#BUTTON BUTTON_START, SYS_DEFAULT, "Start", 290, 0, 10, 10;
	//BUTTON BUTTON_QUIT, SYS_DEFAULT, "ABORT", 70, 60, 64, 32;
	TEXT_STDOUT"ARIAL", RGB (150, 255, 150), 5, 150, 290, 420;
	PROGRESS RGB (200, 200, 200), 73, 0, 120, 305, 15;
	PICTURE < logo.bmp > , OPAQUE, 0, 0;
}
WINDOW WINEND
{
	TITLE"Adeptus Ver 2.0";
	SIZE 300, 600; # 135;
	MODE IMAGE; //      STANDARD;
	BG_COLOR RGB (50, 50, 50);
	#FRAME FTYP3, 20, 20, 320, 300;
	//BUTTON BUTTON_START, SYS_DEFAULT, "Start", 290, 0, 10, 10;
	BUTTON BUTTON_QUIT, SYS_DEFAULT, "Ok", 250, 580, 48, 16;
	TEXT_STDOUT"ARIAL", RGB (150, 255, 150), 5, 125, 290, 450;
	PROGRESS RGB (200, 200, 200), 73, 0, 120, 305, 5;
	PICTURE < logo.bmp > , OPAQUE, 0, 0;
}
SAVEDIR "savegame";

/////////////////////debugging////////////////////////////////
STRING enter_cmd, "Enter instruction(s) below:";
STRING exec_buffer, // just an 80-char string
"                                                                              ";

TEXT console_text
{
	POS_X 4;
	POS_Y 180;
	FONT standard_font;
	STRINGS 2;
	STRING enter_cmd;
	STRING exec_buffer;
}

////////////////////////////////////////////////////////////////
ACTION main
{
	CALL vinp_reset_keys;
	CALL init_screen;
	CALL init_game;
	CALL init_sky;
ifndef NOTEX;
   D3D_TEXRESERVED = min(10000,D3D_TEXMEMORY*0.75);
endif;
//	CALL set_debug;
}

ACTION init_game
{
	CALL start_intro;
	wait(2);
	LOAD_LEVEL <adept2.wmb>;
	waitt(8);
	CALL load_status;
	SET FREEZE_MODE,1;
	CALL vinp_show_mouse;
//	CALL toggle_detail;
	CALL vinv_reset_critical_items;
	CALL vinv_reset_inventory;

	SET FREEZE_MODE,0;	// un-freeze game
}




ACTION init_screen
{
	SET blood_pan.VISIBLE, FALSE;
	SET GAMMA, 1.0;
	SET CAMERA.ARC, 80;
	SET CAMERA.AMBIENT, 20;
	SET CAMERA.POS_X, 3;
	SET CAMERA.POS_Y, 4;
	SET CAMERA.SIZE_X, 528;
	SET CAMERA.SIZE_Y, 386;
}



////////////////////skies,backdrops//////////////////////////////////////////////
ACTION init_sky # default sky
{
	SET CLOUD_MAP, cld_map;
	SET SKY_MAP, sk_map;
	SET SCENE_MAP, mt_map;
	SCENE_FIELD = 120;
	SCENE_ANGLE.TILT = -14;
	SCENE_NOFILTER = ON;
	SKY_SPEED.X = 1;
	SKY_SPEED.Y = 1.5;
	CLOUD_SPEED.X = 3;
	CLOUD_SPEED.Y = 4.5;
	SKY_SCALE = 1;
	SKY_CURVE = 0.8;
	SUN_ANGLE.PAN = 180;
	SUN_ANGLE.TILT = 45;
}

// The GAMMA skill will perform a palette gamma correction
ACTION toggle_gamma
{
	GAMMA += 0.15;
	IF (GAMMA > 2)
	{
		GAMMA = 1;
	}
}
ACTION console
{
	SET console_text.VISIBLE, 1;
	INKEY exec_buffer;
	IF (RESULT == 13)
	{
		// terminated with RETURN?
		EXECUTE exec_buffer;
	} // will execute the string
	SET console_text.VISIBLE, 0;
	BEEP;
}

ACTION back
{
	exit;
}

ACTION testmovie
{
	WHILE (1)
	{
		IF (KEY_A)
		{
			SUN_ANGLE.PAN += 1;
		}
		IF (KEY_S)
		{
			SUN_ANGLE.PAN -= 1;
		}
		IF (KEY_D)
		{
			SUN_ANGLE.TILT += 1;
		}
		IF (KEY_F)
		{
			SUN_ANGLE.TILT -= 1;
		}
		IF (KEY_G)
		{
			SUN_LIGHT += 1;
		}
		IF (KEY_H)
		{
			SUN_LIGHT -= 1;
		}
		IF (KEY_V)
		{
			DEBUG_ACT.AMBIENT += 1;
		}
		IF (KEY_B)
		{
			DEBUG_ACT.AMBIENT -= 1;
		}


		WAIT 1;
	}

}





///////////////////////////////////////////////////////////////////////



// OVERRIDE: player is not allowed to gain mana with bonus points
// Desc: Use a bonus point to increase player's base mana
ACTION _vpst_bonus_mana
{
	IF (player_bonus_pts > 0)
	{
 		BEEP;
	}
	ELSE
	{
		CALL vscr_close_all;
	}
}

//////////////////////Inventory////////////////////////////////////////////////////

// Adeptus Inventory/Items


// Desc: reset the player's critical items at game start
//
// NOTE: this action overrides the dummy action in venture.wdl
ACTION vinv_reset_critical_items
{
	__HAS_SWORD = FALSE;
	SET ON_SPACE, NULL;
	__HAS_DIAMOND = FALSE;
}


// Desc: This action is used to track 'critical' items in the player's inventory.
//       Call this action whenever something is added or removed from inventory.
//
// NOTE: this action overrides the dummy action in venture.wdl
ACTION vinv_critical_items
{
	IF (invent_box_content == M_SWORD)
	{
		__HAS_SWORD = TRUE;
		SET ON_SPACE, vcom_create_sword;
	}
	IF (invent_box_content == M_GEM)
	{
		__HAS_DIAMOND = TRUE;
	}
}









////////////////// CHEATS //////////////////////////////////////////////


// Desc: cheat to restore hitpoints and strength
ACTION hp_cheat
{
	SET player_current_hp, player_hp;
	SET player_current_str, player_str;
}

ACTION exp_cheat
{
	give_exp = 1000;
	CALL vpst_check_exp;
}

// Cheat 'code' (add all items to the list)
// DCP(3/21/00)- updated invent_box_content before each vinv_critical_items check
ACTION inv_cheat
{
	SET i1_status, 0;
	SET invent_box_content, i1_status;
	CALL vinv_critical_items;

	SET i2_status, 1;
	SET invent_box_content, i2_status;
	CALL vinv_critical_items;

	SET i3_status, 2;
 	SET invent_box_content, i3_status;
   CALL vinv_critical_items;

	SET i4_status, 3;
 	SET invent_box_content, i4_status;
   CALL vinv_critical_items;

	SET i5_status, 4;
 	SET invent_box_content, i5_status;
   CALL vinv_critical_items;

	SET i6_status, 5;
 	SET invent_box_content, i6_status;
   CALL vinv_critical_items;

	SET i7_status, 6;
 	SET invent_box_content, i7_status;
   CALL vinv_critical_items;

	SET i8_status, 7;
 	SET invent_box_content, i8_status;
   CALL vinv_critical_items;

	SET i9_status, 8;
 	SET invent_box_content, i9_status;
   CALL vinv_critical_items;

	SET i10_status, 9;
 	SET invent_box_content, i10_status;
   CALL vinv_critical_items;

	SET i11_status, 10;
 	SET invent_box_content, i11_status;
   CALL vinv_critical_items;

	CALL _vinv_update_inventory_content;
}

//testing ...
//ON_F9 inv_cheat;
//ON_Q vmsc_exit;
//ON_E  exp_cheat;
//ON_E  vspl_player_cast_fireball;