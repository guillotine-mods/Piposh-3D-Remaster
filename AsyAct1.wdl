include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.

define pencils,skill2;	// Pencils Piposh can take
define dime,skill3;	// A dime Piposh need to use the payphone with
define CurrentInv,skill4;

synonym Pozmak  { type entity; }
synonym Hook    { type entity; }
synonym BadGuy1 { type entity; }
synonym BadGuy2 { type entity; }
synonym MadPip  { type entity; }

var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var HasUndies = 0;
var UnderWearTaken = 0;
var Pen1Taken = 0;
var Pen2Taken = 0;
var PlayerZ;

var Done1 = 0;
var Done2 = 0;
var Done3 = 0;

var Movie4 = 0;
var Movie5 = 0;
var Movie6 = 0;
var Scene = 0;
var YouBlink = 0;

var percent = 0;
var Dumm[3] = 0,0,0;
var Dumm2[3] = 0,0,0;

var filehandle;
string tempstring = "                                                 ";
var cameratemp[3] = 0,0,0;

var cameraX[2] = 2311,2064;
var cameraY[2] = -304,348;
var cameraZ[2] = -60,-40;
var PiposhPhone [3] = 2176.928,-400.963,-89.303;
var PozmakPhone [3] = 1937.695,-271.696,-89.992;
var PipLook1[3] = 2032.103,120.075,-89.992;
var CameraLook1 [3] = 1909.027,457.467,-89.992;

var CameraEnabled = 1;
var MoviePlaying = 0;
var Movie = 0;
var TalkFrame = 0;

var KnowNumber = 0;
var KnowPhoto = 0;
var TookBush = 0;

var invpos[3] = 20,20,20;
string MyInv,"                              ";
var MyStuff[10];
string ItemName,"                                                                      ";
var NumInv = 0;
var Quests = 0;

var PrevX;
var PrevY;
var PrevZ;

var TempX;
var TempY;
var TempZ;

var delay = 0;
var tempy = 0;

var n = 1;
var closest = 0;

var Stage = 0;

include <Movie1.wdl>;
include <Movie2.wdl>;
include <Movie3.wdl>;
include <SuprShik.wdl>;

bmap caseon = <caseon.pcx>;
bmap caseoff = <caseoff.pcx>;
bmap large = <large.pcx>;
bmap choose = <choose.pcx>;
bmap switch1 = <switch.pcx>;
bmap switch2 = <switch2.pcx>;

bmap bPhone = <phone.pcx>;
bmap bkey0 = <key0.pcx>;
bmap bkey1 = <key1.pcx>;
bmap bkey2 = <key2.pcx>;
bmap bkey3 = <key3.pcx>;
bmap bkey4 = <key4.pcx>;
bmap bkey5 = <key5.pcx>;
bmap bkey6 = <key6.pcx>;
bmap bkey7 = <key7.pcx>;
bmap bkey8 = <key8.pcx>;
bmap bkey9 = <key9.pcx>;

bmap bkey0B = <key0B.pcx>;
bmap bkey1B = <key1B.pcx>;
bmap bkey2B = <key2B.pcx>;
bmap bkey3B = <key3B.pcx>;
bmap bkey4B = <key4B.pcx>;
bmap bkey5B = <key5B.pcx>;
bmap bkey6B = <key6B.pcx>;
bmap bkey7B = <key7B.pcx>;
bmap bkey8B = <key8B.pcx>;
bmap bkey9B = <key9B.pcx>;

text Phon
{
	string = "         ";
	pos_x = 60;
	pos_y = 260;
	font = digit_font;
	layer = 4;
}

panel pPhone
{
	pos_x = 0;
	pos_y = 245;
	flags = refresh,overlay;
	bmap = bPhone;
	layer = 3;
	button = 43,74,bkey1B,bkey1,bKey1,AddNum1,null,null;
	button = 76,74,bkey2B,bkey2,bKey2,AddNum2,null,null;
	button = 113,74,bkey3B,bkey3,bKey3,AddNum3,null,null;

	button = 43,110,bkey4B,bkey4,bKey4,AddNum4,null,null;
	button = 76,110,bkey5B,bkey5,bKey5,AddNum5,null,null;
	button = 113,110,bkey6B,bkey6,bKey6,AddNum6,null,null;

	button = 43,144,bkey7B,bkey7,bKey7,AddNum7,null,null;
	button = 76,144,bkey8B,bkey8,bKey8,AddNum8,null,null;
	button = 113,144,bkey9B,bkey9,bKey9,AddNum9,null,null;

	button = 76,176,bkey0B,bkey0,bKey0,AddNum0,null,null;
}

function AddNum1 { str_cat (phon.string,"1"); }
function AddNum2 { str_cat (phon.string,"2"); }
function AddNum3 { str_cat (phon.string,"3"); }
function AddNum4 { str_cat (phon.string,"4"); }
function AddNum5 { str_cat (phon.string,"5"); }
function AddNum6 { str_cat (phon.string,"6"); }
function AddNum7 { str_cat (phon.string,"7"); }
function AddNum8 { str_cat (phon.string,"8"); }
function AddNum9 { str_cat (phon.string,"9"); }
function AddNum0 { str_cat (phon.string,"0"); }

entity InventoryItem
{
	type = <empty.mdl>;
	layer = 3;
	view = camera;
	x = 100;
	y = -4;
	z = -13;
}

entity CurrentlyUsedItem
{
	type = <empty.mdl>;
	layer = 3;
	flags = visible;
	view = camera;
	x = 90;
	y = -40;
	z = -30;
}

text InventoryName 
{
	layer = 5;
	pos_X = 340;
	pos_y = 380;
	font = standard_font;
	string = "              XFLK JL YJA              ";
	flags = center_x;
}

function UpdateItem 
{
	InventoryName.visible = on;

	if MyStuff[player.CurrentInv] == 1 {
		morph (<pencil.mdl>,InventoryItem); 
		InventoryName.string = "YFTQP";
	}

	if MyStuff[player.CurrentInv] == 2 {
		morph (<scissors.mdl>,InventoryItem); 
		InventoryName.string = "XJJTQOM";
	}

	if MyStuff[player.CurrentInv] == 3 {
		morph (<coin.mdl>,InventoryItem); 
		InventoryName.string = "PBIM";
	}

	if MyStuff[player.CurrentInv] == 4 {
		morph (<bush.mdl>,InventoryItem); 
		InventoryName.string = "HJJU";
	}

	if MyStuff[player.CurrentInv] == 5 {
		morph (<undies.mdl>,InventoryItem); 
		InventoryName.string = "FEUJM LU XJNFVHV";
	}

	if MyStuff[player.CurrentInv] == 6 {
		morph (<gum.mdl>,InventoryItem); 
		InventoryName.string = "UMFUM SJIOM";
	}

	if MyStuff[player.CurrentInv] == 7 {
		morph (<UndPen.mdl>,InventoryItem); 
		InventoryName.string = "PT YFJPT LU FVLJHV";
	}

	if MyStuff[player.CurrentInv] == 8 {
		morph (<UndPens.mdl>,InventoryItem); 
		InventoryName.string = "PT YFJPT";
	}
}

panel Inventory 
{
	pos_x = -10;
	pos_y = 20;
	flags = refresh,overlay;
	bmap = large;
	layer = 2;
	button = 450,300,switch2,switch1,switch2,ChangeItem,null,null;
	button = 200,200,choose,null,null,PickItem,null,null;
}

function PickItem 
{
	InventoryName.visible = off;

	if str_cmpi (MyInv, "none")
	{
		Inventory.visible = off;
		InventoryItem.visible = off;

		if MyStuff[player.CurrentInv] == 1 
		{ 
			morph (<pencil.mdl>,CurrentlyUsedItem);
			str_cpy (MyInv,"pencil"); 
		}

		if MyStuff[player.CurrentInv] == 2 
		{
			morph (<scissors.mdl>,CurrentlyUsedItem);
			str_cpy (MyInv,"scissors"); 
		}

		if MyStuff[player.CurrentInv] == 3 
		{ 
			morph (<coin.mdl>,CurrentlyUsedItem);	
			str_cpy (MyInv,"coin"); 
		}

		if MyStuff[player.CurrentInv] == 4 
		{ 
			morph (<bush.mdl>,CurrentlyUsedItem);	
			str_cpy (MyInv,"bush"); 
		}

		if MyStuff[player.CurrentInv] == 5 
		{ 
			morph (<undies.mdl>,CurrentlyUsedItem);	
			str_cpy (MyInv,"underwear"); 
		}

		if MyStuff[player.CurrentInv] == 6 
		{ 
			morph (<gum.mdl>,CurrentlyUsedItem);	
			str_cpy (MyInv,"used gum"); 
		}

		if MyStuff[player.CurrentInv] == 7 
		{ 
			morph (<UndPen.mdl>,CurrentlyUsedItem);	
			str_cpy (MyInv,"semi"); 
		}

		if MyStuff[player.CurrentInv] == 8 
		{ 
			morph (<UndPens.mdl>,CurrentlyUsedItem);	
			str_cpy (MyInv,"badidea"); 
		}
	}

	else 
	{	// Use inventory item on inventory item

		tempy = 1;

		Inventory.visible = off;
		InventoryItem.visible = off;

		if (MyStuff[player.CurrentInv] == 1)
		{ 
			if str_cmpi (MyInv,"Underwear") 
			{ 
				tempy = 0;
				releaseitem();
				MyStuff [player.currentinv] = 7;
				temp = 0;
				while (temp < 10)
				{
					if (MyStuff [temp] == 5) { MyStuff [temp] = 0; return; } // remove the underwear
					temp = temp + 1;
				}
			}

			if str_cmpi (MyInv,"Semi") 
			{ 
				tempy = 0;
				releaseitem();
				MyStuff [player.currentinv] = 8;
				temp = 0;
				while (temp < 10)
				{
					if (MyStuff [temp] == 7) { MyStuff [temp] = 0; return; } // remove the underwear
					temp = temp + 1;
				}
			}
		}

		if (MyStuff[player.CurrentInv] == 5)
		{ 
			if str_cmpi (MyInv,"Pencil") 
			{ 
				tempy = 0;
				releaseitem();
				MyStuff [player.currentinv] = 7;
				temp = 0;
				while (temp < 10)
				{
					if (MyStuff [temp] == 1) { MyStuff [temp] = 0; return; } // remove the pencil
					temp = temp + 1;
				}
			}
		}

		if (MyStuff[player.CurrentInv] == 7)
		{ 
			if str_cmpi (MyInv,"Pencil") 
			{ 
				tempy = 0;
				releaseitem();
				MyStuff [player.currentinv] = 8;
				temp = 0;
				while (temp < 10)
				{
					if (MyStuff [temp] == 1) { MyStuff [temp] = 0; return; } // remove the pencil
					temp = temp + 1;
				}
			}
		}

		if (tempy == 1) { DontWork(); }
	}
}

function Switchcase 
{

	if player.CurrentInv == 0 { player.CurrentInv = 1; }

	if Inventory.visible == off 
	{
		Inventory.visible = on;
		UpdateItem();
		InventoryItem.visible = on;
	}
	else 
	{
		Inventory.visible = off;
		InventoryItem.visible = off;
		InventoryName.visible = off;
	}
}

function ReleaseItem 
{
	morph (<empty.mdl>,CurrentlyUsedItem);
	str_cpy (MyInv,"none");
}

panel GUI 
{
	layer = 3;
	pos_x = 1; pos_y = 1;
	flags = refresh,visible,overlay;
	button = 1,1,caseon,caseoff,caseon,Switchcase,null,null;
}

ACTION Inv
{
	while (1)
	{
		temp.pan = 3*time;
		temp.tilt = 3*time;
		temp.roll = 0;
		rotate(my,temp,nullvector);
	}
}

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	varLevelID = _ASYLUM;

	str_cpy (MyInv,"none");

	warn_level = 0;
	tex_share = on;
	mouse_range = 500;
	clip_range = 3000;

	load_level(<AsyAct1.WMB>);
	GUI.visible = on;

	VoiceInit();
	Initialize();

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running

	sPlay ("ZIG001.WAV");
	SetPosition(Voice,1000000);
}

function ChangeItem 
{
	if (NumInv == 0) { return; }

	temp = 0;

	while (temp == 0)
	{
		player.currentinv = player.currentinv + 1;
		if (player.currentinv > numinv) { player.currentinv = 1; }

		if (MyStuff [player.currentinv] != 0) { temp = 1; }
	}

	UpdateItem();
}

ACTION player_move2
{
	if(MY.CLIENT == 0) { player = ME; } // created on the server?

	MY._TYPE = _TYPE_PLAYER;
	MY.ENABLE_SCAN = ON;	// so that enemies can detect me
	if((MY.TRIGGER_RANGE == 0) && (MY.__TRIGGER == ON)) { MY.TRIGGER_RANGE = 32; }

	if(MY._FORCE == 0) {  MY._FORCE = 1.5; }
	if(MY._MOVEMODE == 0) { MY._MOVEMODE = _MODE_WALKING; }
	if(MY._WALKFRAMES == 0) { MY._WALKFRAMES = DEFAULT_WALK; }
	if(MY._RUNFRAMES == 0) { MY._RUNFRAMES = DEFAULT_RUN; }
	if(MY._WALKSOUND == 0) { MY._WALKSOUND = _SOUND_WALKER; }

	anim_init();      // init old style animation
	perform_handle();	// react on pressing the handle key


	// while we are in a valid movemode
	while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
	{
		if (Movie5 == 1) { my.invisible = on; my.shadow = off; } else { my.invisible = off; my.shadow = on; }

		// if we are not in 'still' mode
		if ((MY._MOVEMODE != _MODE_STILL) && (MoviePlaying == 0))
		{
			if (Talking == 1) { Talk(); } else { Blink2(); }

			if ((Scene > 0) && (Movie5 == 0))
			{
				if (Scene == 1) 
				{ 
					sPlay ("PIP454.WAV"); 
					Talking = 1;
					Scene = 2;
				}

				if (Scene == 2)
				{
					if (GetPosition(Voice) < 1000000) { Talk(); } else { Scene = 0; Talking = 0; }
				}
			}

			Inventoryitem.pan = Inventoryitem.pan + 10 * time;

			// Get the angular and translation forces (set aforce & force values)
			_player_force();

			// find ground below (set my_height, my_floornormal, & my_floorspeed)
			scan_floor();

			// if they are on or in a passable block...
			if( ((ON_PASSABLE != 0) && (my_height_passable < -MY.MIN_Z + 5)) || (IN_PASSABLE != 0) )
			{

				// if not already swimming or wading...
				if((MY._MOVEMODE != _MODE_SWIMMING) && (MY._MOVEMODE != _MODE_WADING))
				{
  					play_sound(splash,50);
  					MY._MOVEMODE = _MODE_SWIMMING;

					// stay on/near surface of water
					MY._SPEED_Z = 0;
  				}

				// if swimming...
  				if(MY._MOVEMODE == _MODE_SWIMMING) // swimming on/in a passable block
				{
					if(ON_PASSABLE == ON) // && (IN_PASSABLE != ON)) -> Not need with version 4.193+
					{
						// check for wading
						temp.X = MY.X;
    					temp.Y = MY.Y;
    		  			temp.Z = MY.Z + MY.MIN_Z;	// can my feet touch?
						trace_mode = IGNORE_ME + IGNORE_PASSABLE + IGNORE_PASSENTS;
						trace(MY.POS,temp);

						if(RESULT > 0)
						{
							// switch to wading
							MY._MOVEMODE = _MODE_WADING;
 				 			MY.TILT = 0;       // stop tilting
							my_height = RESULT + MY.MIN_Z;	// calculate wading height
						}

 					}

				}// END swimming on/in a passable block

				// if wading...
 				if(MY._MOVEMODE == _MODE_WADING) // wading on/in a passable block
				{
  					// check for swimming
					temp.X = MY.X;
    					temp.Y = MY.Y;
    					temp.Z = MY.Z + MY.MIN_Z;	// can my feet touch?

    				//SHOOT MY.POS,temp;  // NOTE: ignore passable blocks
					trace_mode = IGNORE_ME + IGNORE_PASSABLE + IGNORE_PASSENTS;
					trace(MY.POS,temp);
					if(RESULT == 0)
					{
						// switch to swimming
						MY._MOVEMODE = _MODE_SWIMMING;
					}
					else	// use SOLID surface for height (can't walk on water)
					{
	 					my_height = RESULT + MY.MIN_Z;    // calculate wading height
 					}
				} // END wading on/in a passable block
	 		} // END if they are on or in a passable block...
			else  // not in or on a passable block
			{
				// if wading or swimming while *not* on/in a passable block...
				if((MY._MOVEMODE == _MODE_SWIMMING) || (MY._MOVEMODE == _MODE_WADING))
				{
					// get out of the water (go to walk mode)
					MY._MOVEMODE = _MODE_WALKING;
					MY.TILT = 0;       // stop tilting
				}
 			} // END not in or above water


  			// if he is on a slope, change his angles, and maybe let him slide down
			if(MY.__SLOPES == ON)
			{
				// Adapt the player angle to the floor slope
				MY_ANGLE.TILT = 0;
				MY_ANGLE.ROLL = 0;
				if((my_height < 10) && ((my_floornormal.X != 0) || (my_floornormal.Y != 0) ))
				{	// on a slope?
					// rotate the floor normal relative to the player
					MY_ANGLE.PAN = -MY.PAN;
					vec_rotate(my_floornormal,MY_ANGLE);
					// calculate the destination tilt and roll angles
					MY_ANGLE.TILT = -ASIN(my_floornormal.X);
					MY_ANGLE.ROLL = -ASIN(my_floornormal.Y);
				}
				// change the player angles towards the destination angles
				MY.TILT += 0.2 * ANG(MY_ANGLE.TILT-MY.TILT);
				MY.ROLL += 0.2 * ANG(MY_ANGLE.ROLL-MY.ROLL);
			}
			else
			{
				// If the ROLL angle was not equal to zero,
				// apply a ROLL force to set the angle back
				//jcl 07-08-00 fix loopings on < 3 fps systems
				MY.ROLL -= 0.2*ANG(MY.ROLL);
			}

			// Now accelerate the angular speed, and change his angles
			// -old method- ACCEL	MY._ASPEED,aforce,ang_fric;
			temp = max(1-TIME*ang_fric,0);     // replaced min with max (to eliminate 'creep')
			MY._ASPEED_PAN  = (TIME * aforce.pan)  + (temp * MY._ASPEED_PAN);    // vp = ap * dt + max(1-(af*dt),0)  * vp
			MY._ASPEED_TILT = (TIME * aforce.tilt) + (temp * MY._ASPEED_TILT);
			MY._ASPEED_ROLL = (TIME * aforce.roll) + (temp * MY._ASPEED_ROLL);

  			temp = MY._ASPEED_PAN * MY._SPEED_X * 0.05;
			if(MY.__WHEELS)
			{	// Turn only if moving ahead
				//jcl 07-03-00 patch to fix movement
				MY.PAN += temp * TIME;
			}
			else
			{
				MY.PAN += MY._ASPEED_PAN * TIME;
			}
			MY.ROLL += (temp * MY._BANKING + MY._ASPEED_ROLL) * TIME;

			// the head angle is only set on the player in a single player system.
			if (ME == player)
			{
				head_angle.TILT += MY._ASPEED_TILT * TIME;
				//jcl 07-03-00 end of patcht

				// Limit the TILT value
				head_angle.TILT = ang(head_angle.TILT);
				if(head_angle.TILT > 80) { head_angle.TILT = 80; }
				if(head_angle.TILT < -80) { head_angle.TILT = -80; }
			}

			// disable strafing
			if(MY.__STRAFE == OFF)
			{
				force.Y = 0;	// no strafe
			}


			// if swimming...
			if(MY._MOVEMODE == _MODE_SWIMMING)
			{
 				// move in water
  				swim_gravity();
			}
			else // not swimming
			{
			
				// if wading...
				if(MY._MOVEMODE == _MODE_WADING)
				{
					wade_gravity();
				}
				else // not swimming or wading (not in water)
				{
					// Ducking or crawling...
					if((MY._MOVEMODE == _MODE_DUCKING) || (MY._MOVEMODE == _MODE_CRAWLING))
					{
						if(force.Z >= 0)
						{
							MY._MOVEMODE = _MODE_WALKING;
						}
						else	// still ducking
						{
							// reduce height by ducking value
							my_height += duck_height;
						}

					}
					else  // not ducking or crawling
					{
						// if we have a ducking force and are not already ducking or crawling...
						if((force.Z < 0) && (MY.__DUCK == ON))		// dcp 7/28/00 added __DUCK
						{
							// ...switch to ducking mode
							MY._MOVEMODE = _MODE_DUCKING;
							MY._ANIMDIST = 0;
							force.Z = 0;
						}
					}

					// Decide whether the actor can jump or not. He can't if he is in the air
					if((jump_height <= 0)
						|| (MY.__JUMP == OFF)
						|| (my_height > 4)
						|| (force.Z <= 0))
					{
						force.Z = 0;
					}

					// move on land
					move_gravity();
				}  // END (not in water)
			}// END not swimming
		} // END not in 'still' mode

		// animate the actor
		if (MoviePlaying == 0) { actor_anim(); }

		// If I'm the only player, draw the camera and weapon with ME
		//move_view();

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

action SayMad
{
	if (my.flag1 != on) { return; }

	sPlay ("PIP471.WAV");
	Talking = 1;
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Talking = 0;
}

ACTION Metal_Material
{
	my.event = SayMad;
	my.enable_click = on;
	MY.Metal = on;
}

action Clickme
{
	if (MoviePlaying == 1) { return; }

	tempy = 1;

	if str_cmpi (MyInv,"underwear")	
	{
		if ((Pen1Taken == 1) && (Pen2Taken == 1) && (UnderWearTaken == 1))
		{
			if (Done3 == 0)
			{
				Pen1Taken = 0;
				Pen2Taken = 0;
				UnderWearTaken = 0;

				releaseitem();
				MyStuff [player.currentinv] = 0;
	
				tempy = 0;
				player.skill1 = 1;
				Movie4 = 1;
			}
		}
		else
		{
			tempy = 0;
			sPlay ("PIP480.WAV");
			Talking = 1;
			while (GetPosition(Voice) < 1000000) { wait(1); }
			Talking = 0;
		}
	}

	if str_cmpi (MyInv,"pencil")	
	{
		if ((Pen1Taken == 1) && (Pen2Taken == 1) && (UnderWearTaken == 1))
		{
			if (Done3 == 0)
			{
				Pen1Taken = 0;
				Pen2Taken = 0;
				UnderWearTaken = 0;

				releaseitem();
				MyStuff [player.currentinv] = 0;

				tempy = 0;
				player.skill1 = 1;
				Movie4 = 1;
			}
		}
		else
		{
			tempy = 0;
			sPlay ("PIP481.WAV");
			Talking = 1;
			while (GetPosition(Voice) < 1000000) { wait(1); }
			Talking = 0;
		}
	}

	if str_cmpi (MyInv,"badidea")	
	{
		if (Done3 == 0)
		{
			Pen1Taken = 0;
			Pen2Taken = 0;
			UnderWearTaken = 0;

			releaseitem();
			MyStuff [player.currentinv] = 0;

			tempy = 0;
			player.skill1 = 1;
			Movie4 = 1;
		}
	}

	if str_cmpi (MyInv,"bush")
	{
		if (Done2 == 0)	
		{ 
			tempy = 0;
			releaseitem();
			MyStuff [player.currentinv] = 0;
			Movie2(); 
		} 
	}

	if (tempy == 1) { DontWork(); }
}

ACTION player_walk2
{
	my.event = clickme;
	my.enable_click = on;
	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 0.75;
	MY._BANKING = 0;
	MY.__JUMP = OFF;
	MY.__DUCK = OFF;
	MY.__STRAFE = ON;
	MY.__BOB = ON;
	MY.__TRIGGER = ON;

	player_move2();
}

action Touch
{
	sPlay ("POZ009.WAV"); Talking = 2;
	while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
	Scene = 1; Talking = 0;
}

ACTION DefinePozmak
{
	Pozmak = my;
	my.event = Touch;
	my.enable_click = on;

	while (1)
	{
		if ((Done1 == 1) && (Done2 == 1) && (Done3 == 1))
		{
			Asylum[0] = 1;
			WriteGameData (0);

			Run ("Intro13.exe");
		}

		if (Talking != 2)
		{
			if (YouBlink == 1) { Blink(); }

			if (MoviePlaying == 0)
			{
				ent_cycle ("Stand",my.skill1);
				my.skill1 = my.skill1 + 5 * time;
				Blink();
			}
		}

		wait(1);
	}
}

action Guy2Click
{
	if (str_cmpi (MyInv,"Used Gum")	&& (HasUndies == 0))
	{
		HasUndies = player.currentinv;
		UnderWearTaken = 1;
		MoviePlaying = 1;
		my = player;
		sPlay ("PIP475.WAV");
		while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		ent_frame ("Stand",0); Blink();
		my = BadGuy2;
		sPlay ("KVC036.WAV");
		while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		Movie5 = 1;
	}
}

action Bad2
{
	my.event = Guy2Click;
	my.enable_click = on;
	BadGuy2 = my;

	while(1) 
	{ 
		if (Movie5 == 1) { my.invisible = on; my.shadow = off; } else { my.invisible = off; my.shadow = on; }

		if (MoviePlaying == 0)
		{
			Blink(); 
			if (my.skill1 > 0) { my.skill1 = my.skill1 - 1 * time; ent_cycle ("Sit",my.skill2); my.skill2 = my.skill2 + 5 * time; } else { if (HasUndies == 1) { ent_frame ("Shame",0); } else { ent_frame ("Stand",0); } }
			if (int(random(200)) == 100) { my.skill1 = random(50); }
			if (Movie5 == 1) { my.invisible = on; my.shadow = off; } else { my.invisible = off; my.shadow = on; }
		}

		wait(1); 
	}

}

action Guy1Click
{
	if str_cmpi (MyInv,"Used Gum")	
	{
		MoviePlaying = 1;
		my = player;
		sPlay ("PIP477.WAV");
		while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		ent_frame ("Stand",0); Blink();
		my = BadGuy1;
		sPlay ("MAR031.WAV");
		while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		MoviePlaying = 0;
	}
}

ACTION DefineBadGuy1
{
	BadGuy1 = my;
	my.event = Guy1Click;
	my.enable_click = on;

	while(1) 
	{ 
		if (MoviePlaying == 0)
		{
			Blink();
			if (my.skill1 > 0) { my.skill1 = my.skill1 - 1 * time; ent_cycle ("Sit",my.skill2); my.skill2 = my.skill2 + 5 * time; } else { ent_frame ("Sit",0); }
			if (int(random(200)) == 100) { my.skill1 = random(50); }
		}

		wait(1); 
	}
}

ACTION DefineHandle
{
	Hook = my;
}

function changeview
{
	if (MoviePlaying == 1) { return; }

	if (player.Skill1 == 1)
	{
		player.Skill1 = 2;
	}
	else 
	{
		player.Skill1 = 1;
	}
}

ACTION CameraEngine
//***********************************************************************************************
//* Calculates the closest camera to the player and sets it as the active camera, uses 3 arrays *
//* of vector coordinates: cameraX, cameraY, cameraZ                           - Roy Lazarovich *
//***********************************************************************************************
{
	while (1)
	{
		if (CameraEnabled == 1)
		{
			move_view_3rd();
			if(player == NULL) { wait(1); }	
			vec_set(temp,player.x);
			vec_sub(temp,camera.x);
			if (player.skill1 == 1) { vec_to_angle(camera.pan,temp); }
		
			n = 0;		
			temp = 100000;

			if (player.Skill1 == 1) 
			{
				while (n < cameraX.length) 
				{
					cameratemp.x = cameraX[n];
					cameratemp.y = cameraY[n];
					cameratemp.z = cameraZ[n];
			
					if (vec_dist(cameratemp.x,player.x) < temp) {
					temp = vec_dist (cameratemp,player.x);
					closest = n;
				}

				n = n + 1;
			}

			cameratemp.x = cameraX[closest];
			cameratemp.y = cameraY[closest];
			cameratemp.z = cameraZ[closest];

			vec_set(camera.x, cameratemp);
		}
		else { if (Movie4 == 0) { move_view_1st(); } }
	}
	wait(1);
	}

}

ACTION PencilPickup
{
	if (my.flag1 == on) { Pen1Taken = 1; } else { Pen2Taken = 1; }
	Remove (ME);
	sPlay ("PIP472.WAV");
	player.pencils = player.pencils + 1;
	NumInv = NumInv + 1;
	MyStuff[NumInv] = 1;

	Talking = 1;
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Talking = 0;

}

ACTION Pencil
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = PencilPickup;
}

ACTION ScissorsPickup
{
	Remove (ME);
	sPlay ("PIP474.WAV");
	NumInv = NumInv + 1;
	MyStuff[NumInv] = 2;

	Talking = 1;
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Talking = 0;
}

ACTION Scissors
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = ScissorsPickup;
}

ACTION PayPhoneUse
{

	if (player.dime == 0)
	{
		sPlay ("PIP504.WAV");

		Talking = 1;
		while (GetPosition(Voice) < 1000000) { wait(1); }
		Talking = 0;
	}

	if ((player.dime == 1) && (MoviePlaying == 0))
	{
		str_cpy (phon.string,"");

		sPlay ("ONLINE.wAV");

		phon.visible = on;
		pPhone.visible = on;

		while (str_len(phon.string) < 6) { wait(1); }

		phon.visible = off;
		pPhone.visible = off;

		if (str_cmpi (phon.string,"776997") == 1) { Movie1(); }
		else
		{
			if (str_cmpi (phon.string,"887554") == 1) { Movie3(); }
			else 
			{ 
				my.skill40 = int(random(2)) + 1;
				if (my.skill40 == 1) { sPlay("MSC007.WAV"); } else { sPlay ("SFX043.WAV"); }
			}
		}
	}
}

ACTION PayPhone
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = PayPhoneUse;
}

ACTION CoinPickup
{
	remove (me);
	
	player.dime = 1;
	NumInv = NumInv + 1;
	MyStuff[NumInv] = 3;

	sPlay ("PIP503.WAV");
	Talking = 1;

	while (GetPosition(Voice) < 1000000) { wait(1); }
	Talking = 0;
}

ACTION Coin
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = CoinPickup;
}

action PaperRead
{
	sPlay ("PIP456.WAV");
	Talking = 1;
	KnowPhoto = 1;
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Talking = 0;
}

ACTION Paper
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = PaperRead;
}

ACTION PlantCut
{
	if str_cmpi (MyInv,"Scissors")	
	{
		if (TookBush == 0) 
		{
			releaseitem();
			MoviePlaying = 1;
			sPlay ("PIP493.WAV");
			Talking = 1;
			Waitt (16);
			morph (<PlantCut.mdl>,MY);
			NumInv = NumInv + 1;
			MyStuff[NumInv] = 4;
			TookBush = 1;
			while (GetPosition (Voice) < 1000000) { wait(1); }

			CurrentlyUsedItem.visible = off;
			GUI.visible = off;

			Talking = 0;
			Stage = 1;
			while (Stage != 0) { wait(1); }

			CurrentlyUsedItem.visible = on;
			GUI.visible = on;

			MoviePlaying = 0;
		}
		else 
		{ 
			sPlay ("PIP505.WAV");

			Talking = 1;
			while (GetPosition(Voice) < 1000000) { wait(1); }
			Talking = 0;
		}

	}
	else 
	{ 
		if str_cmpi (MyInv,"None") { wait(1); }
		else { DontWork(); }
	}
}

ACTION Plant
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = PlantCut;
}

ACTION GumPickup
{
	remove (me);
	sPlay ("PIP473.WAV");
	NumInv = NumInv + 1;
	MyStuff[NumInv] = 6;
	Talking = 1;
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Talking = 0;
}

ACTION Gum
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = GumPickup;
}

function DontWork
{
	temp = int(random(2)) + 1;
	if (temp == 1) { sPlay ("PIP478.WAV"); }
	if (temp == 2) { sPlay ("PIP479.WAV"); }

	Talking = 1;
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Talking = 0;
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } else { ent_frame ("Talk",int(random(5)) * 25); } }
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

action Dummy
{
	Dumm.x = my.x;
	Dumm.y = my.y;
}

action Dummy2
{
	Dumm2.x = my.x;
	Dumm2.y = my.y;
	Dumm2.z = my.pan;
}

action Dummy3
{
	while(1)
	{
		if ((Movie4 > 0) && (CameraEnabled != 0))
		{
			vec_set(temp,MadPip.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			
			camera.pan = my.pan;
			camera.tilt = my.tilt;
			camera.roll = my.roll;

			player.invisible = on;
			player.shadow = off;
		}

		wait(1);
	}
}

action PipMad
{
	ent_frame ("Underwear",0);

	MadPip = my;

	while(1)
	{
		if (Movie4 > 0)
		{
			MoviePlaying = 1;
			sPlay ("PIP482.WAV");

			my.invisible = off;
			my.shadow = on;

			player.invisible = on;
			player.shadow = off;
			player.passable = on;
			playerz = player.z;
			player.z = player.z - 1000;

			wait(3);

			while (Movie4 < 100)
			{
				Talk();
				ent_frame ("Underwear",Movie4);
				Movie4 = Movie4 + 5 * time;
				wait(1);
			} 

			temp.pan = 360;
			temp.tilt = 180;
			temp.z = 1000;
			result = scan_path(my.x,temp);
			if (result == 0) { my._MOVEMODE = 0; }

			ent_waypoint(my._TARGET_X,1);
			my._movemode = 1;

			while (GetPosition(Voice) < 1000000)
			{
				Talk();

				temp.x = MY._TARGET_X - MY.X;
				temp.y = MY._TARGET_Y - MY.Y;
				temp.z = 0;
				result = vec_to_angle(my_angle,temp);

				if (result < 25) { ent_nextpoint(my._TARGET_X); }

				force = 6;
				actor_turnto(my_angle.PAN);
				force = 8;
				actor_move();

				ent_cycle ("Mad",my.skill41);
				my.skill41 = my.skill41 + 10 * time;
		
				wait(1);
			}

			CameraEnabled = 0;

			my.x = Dumm.x;
			my.y = Dumm.y;

			camera.x = Dumm2.x;
			camera.y = Dumm2.y;
			camera.pan = Dumm2.z;

			vec_set(temp,my.x);
			vec_sub(temp,camera.x);
			vec_to_angle(camera.pan,temp);

			vec_set(temp,camera.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

			my.tilt = 0;
			my.roll = 0;
			my.pan = my.pan - 45;

			ent_frame ("Underwear",0);

			sPlay ("POZ007.WAV");
			my = pozmak;
			while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

			DialogChoice = 0;
			DialogIndex = 53; 
			ShowDialog();

			YouBlink = 1;
			my = madpip;

			while (Dialog.visible == on) { Blink(); wait(1); }

			if (DialogChoice == 1) { sPlay ("PIP483.WAV"); }
			if (DialogChoice == 2) { sPlay ("PIP484.WAV"); }
			if (DialogChoice == 3) { sPlay ("PIP447.WAV"); }

			my.skill44 = random(500) + 200;
			my.skill42 = my.skill44;

			while (GetPosition(Voice) < 1000000) 
			{ 
				Talk(); 
				if (my.skill42 > 0)
				{
					ent_cycle ("Mad",my.skill41);
					my.skill41 = my.skill41 + 30 * time;
					my.pan = my.pan + 30 * time;
					my.skill42 = my.skill42 - 10 * time;
				}
				else
				{
					vec_set(temp,camera.x);
					vec_sub(temp,my.x);
					vec_to_angle(my.pan,temp);
					if (int(random(40)) == 20) { ent_frame ("Underwear",(int(random(8)) + 1) * 7); }
					my.skill43 = my.skill43 + 10 * time; if (my.skill43 > my.skill44) { my.skill44 = random(300) + 100; my.skill42 = my.skill44; my.skill43 = 0; }
				}

				wait(1); 
			}

			vec_set(temp,camera.x);
			vec_sub(temp,my.x);
			vec_to_angle(my.pan,temp);

			my.tilt = 0;
			my.roll = 0;
			my.pan = my.pan - 45;

			ent_frame ("Underwear",0);

			YouBlink = 0;
			my = pozmak;
			if ((DialogChoice == 1) || (DialogChoice == 3)) { sPlay ("POZ010.WAV"); } else { sPlay ("POZ008.WAV"); }
			while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			Blink();
			my = madpip;
			vec_set(temp,my.x);
			vec_sub(temp,camera.x);
			vec_to_angle(camera.pan,temp);

			if (DialogChoice != 2) 
			{
				sPlay ("PIP448.WAV"); 
				while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			}

			Movie4 = 0;
			Done3 = 1;

			my.invisible = on;
			my.shadow = off;

			player.passable = off;
			player.invisible = off;
			player.shadow = on;
			player.z = playerz;

			MoviePlaying = 0;
			CameraEnabled = 1;
		}

		wait(1);
	}
}

action Actor
{
	while(1)
	{
		ent_cycle ("Movie",my.skill2);
		my.skill2 = my.skill2 + 20 * time;
		if (Scene == 1) { Talk(); if (my.skill1 == 1) { my.invisible = off; } }
		if ((Scene == 2) || (Scene == 4)) { my.invisible = on; }
		if (Scene == 3) { Talk(); if (my.skill1 == 2) { my.invisible = off; } }
		if (Scene == 5) 
		{
			Scene = 0;
			Movie5 = 0; 
			MoviePlaying = 0; 
			MyStuff[HasUndies] = 5;
			HasUndies = 1; 
			ReleaseItem();
		}

		wait(1);
	}
}

action FCloud
{
	while(1)
	{
		ent_cycle ("Frame",my.skill1);
		my.skill1 = my.skill1 + 10 * time;
		my.pan = my.pan + 10 * time;

		if (Movie5 == 1) 
		{
			MoviePlaying = 1;
			my.invisible = off;
			my.skill2 = my.skill2 + 1 * time;
			if (GetPosition(Voice) >= 1000000) { my.skill2 = 0; Scene = Scene + 1; if (Scene == 1) { sPlay ("PIP476.WAV"); } if (Scene == 3) { sPlay ("KVC037.WAV"); } }
		} 
		else { my.invisible = on; }

		wait(1);
	}
}

action Cammy2
{
	while(1)
	{
		if (Movie6 == 1)
		{
			camera.x = my.x;
			camera.y = my.y;
			camera.z = my.z;
			camera.tilt = my.tilt;
			camera.roll = my.roll;
			camera.pan = my.pan;
		}

		wait(1);
	}
}

on_F1 = changeview;
on_F2 = switchcase();
on_F3 = ReleaseItem();
on_u = clickme;