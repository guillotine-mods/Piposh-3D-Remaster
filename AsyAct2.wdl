include <IO.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.

define CurrentInv,skill4;
define Anim,skill10;
synonym Pool { type entity; }
synonym Buttface { type entity; }
synonym ZvikaPik { type entity; }

var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode

var percent = 0;
var DialNow = 0;
var Belly = 0;

var Talking = 0;
var filehandle;
string tempstring = "                                                 ";
var cameratemp[3] = 0,0,0;

var cameraX[9] = 1557.189,1771.000,1558.198,2545.821,3367.745,2667.000,-440.022,279.866,423.612;
var cameraY[9] = -180.094,156.417,651.000,641.485,-43.302,-383.107,-473.489,-8.625,621.263;
//var cameraZ[2] = ;
var PiposhPhone [3] = 2176.928,-400.963,-89.303;
var PozmakPhone [3] = 1937.695,-271.696,-89.992;
var PipLook1[3] = 2032.103,120.075,-89.992;
var CameraLook1 [3] = 1909.027,457.467,-89.992;

var CameraEnabled = 1;
var MoviePlaying = 0;
var Movie = 0;
var TalkFrame = 0;

var KAN = 0;

var KnowNumber = 0;
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

var PIPOrig[3];

var delay = 0;

var n = 1;
var closest = 0;

var YoshiFree = 0;
var AirLeft = 0;

bmap wPanel = <wPanel.pcx>;
bmap wBar = <wBar.pcx>;
bmap bPaper = <paper.pcx>;
bmap bStomak = <stomak.pcx>;

panel pStomak
{
	bmap bStomak;
	flags = refresh,d3d;
}

panel pPaper
{
	bmap = bPaper;
	flags = refresh,d3d,overlay;
	
	button = 0,0,bPaper,bPaper,bPaper,ClosePaper,null,null;
}

function ClosePaper { pPaper.visible = off; }

panel BarImage
{
	layer = 4;
	pos_x = 340;
	bmap = wPanel;
	flags = refresh,overlay,d3d;
}

panel BreathBar
{
	layer = 3;
	pos_x = 340;
	window 10,9,280,20,wBar,AirLeft,0;
	flags = refresh,d3d;
}

sound Kitchen = <SFX045.WAV>   ; var SND1 = 0;
sound PlayGround = <SFX046.WAV>; var SND2 = 0;
sound Lab = <SFX047.WAV>       ; var SND3 = 0;
sound EffiSong = <SNG002.WAV>  ; var SND4 = 0;
sound BGMusic = <SNG022.WAV>   ; var BGM = 0;

bmap caseon = <caseon.pcx>;
bmap caseoff = <caseoff.pcx>;
bmap large = <large.pcx>;
bmap choose = <choose.pcx>;
bmap switch1 = <switch.pcx>;
bmap switch2 = <switch2.pcx>;

bmap bMov1 = <Mov1.pcx>;
bmap bMov2 = <Mov2.pcx>;
bmap bMov3 = <Mov3.pcx>;

var StopMovie = 0;

panel pMov
{
	bmap = bMov1;
	pos_x = 200;
	pos_y = 100;
	layer = 10;
	flags = d3d,refresh;

	button = 20,0,bMov2,bMov2,bMov2,ShowMov1,null,null;
	button = 20,120,bMov3,bMov3,bMov3,ShowMov2,null,null;
}

function sm { stopmovie = 1; }

function ShowMov1 { stop_sound (SND1);stop_sound (SND2);stop_sound (SND3);stop_Sound (SND4);stop_Sound (BGM); MoviePlaying = 1; pMov.visible = off; on_space = sm; stopmovie = 0; play_moviefile ("MOV\\Movie2.avi"); while ((movie_frame != 0) && (stopmovie == 0)) { wait(1); } stop_movie; on_space = FF; MoviePlaying = 0; }
function ShowMov2 { stop_sound (SND1);stop_sound (SND2);stop_sound (SND3);stop_Sound (SND4);stop_Sound (BGM); MoviePlaying = 1; pMov.visible = off; on_space = sm; stopmovie = 0; play_moviefile ("MOV\\Movie3.avi"); while ((movie_frame != 0) && (stopmovie == 0)) { wait(1); } stop_movie; on_space = FF; MoviePlaying = 0; }

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

	if MyStuff[player.CurrentInv] == 1  { morph (<InvCandy.mdl>,InventoryItem); InventoryName.string = "SJBD XFUMFU SVMM"; }
	if MyStuff[player.CurrentInv] == 2  { morph (<InvInvit.mdl>,InventoryItem); InventoryName.string = "YSFHL ENMGE"; }
	if MyStuff[player.CurrentInv] == 3  { morph (<InvBead.mdl>,InventoryItem); InventoryName.string = "VLGN IPM XP GFTH"; }
	if MyStuff[player.CurrentInv] == 4  { morph (<InvTube.mdl>,InventoryItem); InventoryName.string = "UFIJP VSBA"; }
	if MyStuff[player.CurrentInv] == 5  { morph (<InvTop.mdl>,InventoryItem); InventoryName.string = "XJRFMH VNRNR LU SSQ"; }
	if MyStuff[player.CurrentInv] == 6  { morph (<InvTofu.mdl>,InventoryItem); InventoryName.string = "FQFI '[JBDNO"; }
	if MyStuff[player.CurrentInv] == 7  { morph (<InvShekl.mdl>,InventoryItem); InventoryName.string = "DHA AIFLGFQGFQ"; }
	if MyStuff[player.CurrentInv] == 8  { morph (<InvTomat.mdl>,InventoryItem); InventoryName.string = "EJJTI EJJNBCP VLK"; }
	if MyStuff[player.CurrentInv] == 9  { morph (<InvTaxi.mdl>,InventoryItem); InventoryName.string = "PFRPR VJNFM"; }
	if MyStuff[player.CurrentInv] == 10 { morph (<InvTrash.mdl>,InventoryItem); InventoryName.string = "LBG HQ"; }
	if MyStuff[player.CurrentInv] == 11 { morph (<InvCow.mdl>,InventoryItem); InventoryName.string = "ENLIBO ETQE"; }
	if MyStuff[player.CurrentInv] == 12 { morph (<InvZimim.mdl>,InventoryItem); InventoryName.string = "XLFK VA FQOJA ,XJMJ'R EBFDE"; }
	if MyStuff[player.CurrentInv] == 13 { morph (<InvZiggy.mdl>,InventoryItem); InventoryName.string = "WTE DLJL VJTJTMR JCJG VBFB"; }
	if MyStuff[player.CurrentInv] == 14 { morph (<InvBetty.mdl>,InventoryItem); InventoryName.string = "YFUMU VLJJDE LU FDFFE VBFB"; }
	if MyStuff[player.CurrentInv] == 15 { morph (<InvMasor.mdl>,InventoryItem); InventoryName.string = "2 UFQJQM TFOME"; }
	if MyStuff[player.CurrentInv] == 16 { morph (<InvSnail.mdl>,InventoryItem); InventoryName.string = "YFTUE TFGAB DHA TQOM LFLBUE"; }
	if MyStuff[player.CurrentInv] == 17 { morph (<InvYoshi.mdl>,InventoryItem); InventoryName.string = "UFDSE JUFJ"; }
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
	
		if MyStuff[player.CurrentInv] == 1  { morph (<InvCandy.mdl>,CurrentlyUsedItem); }
		if MyStuff[player.CurrentInv] == 2  { morph (<InvInvit.mdl>,CurrentlyUsedItem); }
		if MyStuff[player.CurrentInv] == 3  { morph (<InvBead.mdl>,CurrentlyUsedItem);  }
		if MyStuff[player.CurrentInv] == 4  { morph (<InvTube.mdl>,CurrentlyUsedItem);  }
		if MyStuff[player.CurrentInv] == 5  { morph (<InvTop.mdl>,CurrentlyUsedItem);   }
		if MyStuff[player.CurrentInv] == 6  { morph (<InvTofu.mdl>,CurrentlyUsedItem);  }
		if MyStuff[player.CurrentInv] == 7  { morph (<InvShekl.mdl>,CurrentlyUsedItem); }
		if MyStuff[player.CurrentInv] == 8  { morph (<InvTomat.mdl>,CurrentlyUsedItem); }
		if MyStuff[player.CurrentInv] == 9  { morph (<InvTaxi.mdl>,CurrentlyUsedItem);  }
		if MyStuff[player.CurrentInv] == 10 { morph (<InvTrash.mdl>,CurrentlyUsedItem); }
		if MyStuff[player.CurrentInv] == 11 { morph (<InvCow.mdl>,CurrentlyUsedItem);   }
		if MyStuff[player.CurrentInv] == 12 { morph (<InvZimim.mdl>,CurrentlyUsedItem); }
		if MyStuff[player.CurrentInv] == 13 { morph (<InvZiggy.mdl>,CurrentlyUsedItem); }
		if MyStuff[player.CurrentInv] == 14 { morph (<InvBetty.mdl>,CurrentlyUsedItem); }
		if MyStuff[player.CurrentInv] == 15 { morph (<InvMasor.mdl>,CurrentlyUsedItem); }
		if MyStuff[player.CurrentInv] == 16 { morph (<InvSnail.mdl>,CurrentlyUsedItem); }
		if MyStuff[player.CurrentInv] == 17 { morph (<InvYoshi.mdl>,CurrentlyUsedItem); }

	}

	else 	// Use inventory item on inventory item
	{
		Inventory.visible = off;
		InventoryItem.visible = off;

		if MyStuff[player.CurrentInv] == 2 
		{ 
			if str_cmpi (MyInv,"Pencil") { wait(1); }
		}
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
		releaseitem();
		Inventory.visible = off;
		InventoryItem.visible = off;
		InventoryName.visible = off;
	}
}

function ReleaseItem 
{
	morph (<empty.mdl>,CurrentlyUsedItem);
	str_cpy (MyInv,"none");
	player.CurrentInv = 0;
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

function PreLoad
{
		n = 0;		

		while (n < cameraX.length) {

			cameratemp.x = cameraX[n];
			cameratemp.y = cameraY[n];
			cameratemp.z = -49;
			vec_set(camera.x, cameratemp);
			wait (1);

			cameratemp.z = 73;
			vec_set(camera.x, cameratemp);
			wait (1);

			cameratemp.z = 195;
			vec_set(camera.x, cameratemp);
			wait (1);

			n = n + 1;

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
	mouse_range = 200;

	load_level(<AsyAct2.WMB>);

	GUI.visible = on;

	str_cpy(MyInv,"                              ");
	MyStuff[0] = 0;
	MyStuff[1] = 0;
	MyStuff[2] = 0;
	MyStuff[3] = 0;
	MyStuff[4] = 0;
	MyStuff[5] = 0;
	MyStuff[6] = 0;
	MyStuff[7] = 0;
	MyStuff[8] = 0;
	MyStuff[9] = 0;
	str_cpy(ItemName,"                                                                      ");
	NumInv = 0;
	Quests = 0;

	VoiceInit();
	Initialize();

	MyStuff[0] = 0;
}

function ChangeItem {

	player.CurrentInv = player.CurrentInv + 1;
	if player.CurrentInv > NumInv { player.CurrentInv = 1; }
	UpdateItem();

}

action Dummy
{
	while(1)
	{
		if (MoviePlaying == 0)
		{
			if (my.skill1 == 1) { if (snd_playing(SND1) == 0) { play_entsound (my,playground,200); SND1 = result; } }
			if (my.skill1 == 2) { if (snd_playing(SND2) == 0) { play_entsound (my,kitchen,200); SND2 = result; } }
			if (my.skill1 == 3) { if (snd_playing(SND3) == 0) { play_entsound (my,Lab,200); SND3 = result; } }
			if (my.skill1 == 5) { if (snd_playing(SND4) == 0) { play_entsound (my,EffiSong,100); SND4 = result; } }
			if (my.skill1 == 5) 
			{ 
				if (snd_playing(BGM) == 0) { play_sound (BGMusic,75); BGM = result; }
				if (snd_playing(SND4) == 0) { play_entsound (my,EffiSong,100); SND4 = result; } 
			}
		}

		if (MoviePlaying == 1)
		{
			stop_sound (SND1);
			stop_sound (SND2);
			stop_sound (SND3);
			stop_Sound (SND4);
			stop_Sound (BGM);
		}

		wait(1);
	}
}

action KCam
{
	while(1)
	{
		if (KAN == 1)
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
		Inventoryitem.pan = Inventoryitem.pan + 10 * time;
		CurrentlyUsedItem.pan = CurrentlyUsedItem.pan + 10 * time;

		if (Talking == 1) { if (GetPosition(Voice) < 1000000) { Talk(); } else { Talking = 0; } } else { if (MoviePlaying == 0) { Blink2(); } else { Blink(); } }
		if (DialNow == 1) { morph (<PipCell2.mdl>,my); while (my.skill30 < 100) { ent_frame ("Dial",my.skill30); my.skill30 = my.skill30 + 2 * time; my.skill31 = my.skill31 + 1 * time; if (my.skill31 > 8) { sPlay("TIK.WAV"); my.skill31 = 0; } wait(1); } DialNow = 0; }
		if (DialNow == -1) { morph (<PipAsy.mdl>,my); DialNow = 0; }

		// if we are not in 'still' mode
		if((MY._MOVEMODE != _MODE_STILL) && (MoviePlaying == 0))
		{
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
					BarImage.visible = on;
					BreathBar.visible = on;
				
					if(ON_PASSABLE == ON) // && (IN_PASSABLE != ON)) -> Not need with version 4.193+
					{
						if (AirLeft > 0) { AirLeft = AirLeft - 5 * time; }

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

					if (IN_PASSABLE == ON) { AirLeft = AirLeft + 0.5 * time; }

					if (AirLeft > 278)
					{
						while(my.skill40 <= 20)
						{
							ent_frame ("Drown",0);
							my.z = my.z + 1 * time;
							my.skill40 = my.skill40 + 1 * time;
							wait(1);
						}

						BarImage.visible = off;
						BreathBar.visible = off;

						my.x = PIPOrig.x;
						my.y = PIPOrig.y;
						my.z = PIPOrig.z;
						my.skill40 = 0;

						AirLeft = 0;
								
						my._movemode = _mode_walking;
					}

				}// END swimming on/in a passable block
				else
				{
					BarImage.visible = off;
					BreathBar.visible = off;
					AirLeft = 0;
				}

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
//		if(client_moving == 0) { move_view(); }

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

ACTION Metal_Material
{
	MY.Metal = on;
}

ACTION player_walk2
{
	sPlay ("PIP451.WAV");
	Talking = 1;

	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 0.75;
	MY._BANKING = -0.1;
	MY.__JUMP = OFF;
	MY.__DUCK = OFF;
	MY.__STRAFE = ON;
	MY.__BOB = ON;
	MY.__TRIGGER = ON;

	PIPOrig.x = my.x;
	PIPOrig.y = my.y;
	PIPOrig.z = my.z;

	player_move2();
}

function changeview
{
	if (player.Skill1 == 1) { player.Skill1 = 2; } else { player.Skill1 = 1; }
}

ACTION CameraEngine
//***********************************************************************************************
//* Calculates the closest camera to the player and sets it as the active camera, uses 3 arrays *
//* of vector coordinates: cameraX, cameraY, cameraZ                           - Roy Lazarovich *
//***********************************************************************************************
{
	while (1)
	{

	if (KAN == 0)
	{

	if (CameraEnabled == 1)
	{
		move_view_3rd();

		if MyStuff[1] == 0 { str_cpy (MyInv,"none"); }
		if(player == NULL) { player = ME; }	
		vec_set(temp,player.x);
		vec_sub(temp,camera.x);
		if player.skill1 == 1 { vec_to_angle(camera.pan,temp); }
		
		n = 0;		
		temp = 100000;

		if player.Skill1 == 1 {
	
		while (n < cameraX.length) {

			cameratemp.x = cameraX[n];
			cameratemp.y = cameraY[n];
		
			if vec_dist(cameratemp.x,player.x) < temp {
				temp = vec_dist (cameratemp,player.x);
				closest = n;
			}
		n = n + 1;
		}

			cameratemp.x = cameraX[closest];
			cameratemp.y = cameraY[closest];

			if ((cameratemp.x == 1557.189) && (cameratemp.y == -180.094) && (player.z > -159))
			{ 
				cameratemp.z = 181.254; 
			}
			else
			{
				if (player.z < -160) { cameratemp.x = 1887; cameratemp.y = 86; cameratemp.z = -254; }
				if ((player.z < 28) && (player.z > -150)) { cameratemp.z =  -49; }
				if ((player.z > 32) && (player.z < 145)) { cameratemp.z = 73; }
				if (player.z > 150) { cameratemp.z = 195; }
			}
			// this is the stairs room which is not set to Piposh's Z

			vec_set(camera.x, cameratemp);
		}
		else {
			move_view_1st();
		}
	}
	}
	wait(1);
	}

}

ACTION celldoor			// Opens and close Asylum cell doors on second floor
{
	MY.EVENT = door_event;
	_doorevent_init();
	if(MY._FORCE == 0) { MY._FORCE = 5; }
	if(MY._ENDPOS == 0) { MY._ENDPOS = 90; }
}

ACTION Walkingtemp
{
	MY._FORCE = 10;
	MY.X = 30;
	MY.Y = 30;
	actor_move();
}

var prevx = 0;
var prevy = 0;

action Madman_run_amok
{

	if(MY._FORCE == 0) {  MY._FORCE = 1; }
	MY._FORCE = 50;
	if(MY._MOVEMODE == 0) { MY._MOVEMODE = _MODE_WALKING; }
	if(MY._WALKFRAMES == 0) { MY._WALKFRAMES = DEFAULT_WALK; }
	if(MY._RUNFRAMES == 0) { MY._RUNFRAMES = DEFAULT_RUN; }
	if(MY._WALKSOUND == 0) { MY._WALKSOUND = _SOUND_WALKER; }
	anim_init();

	// find next start position
	MY._TARGET_X = random (2000);
	MY._TARGET_Y = random (2000);
	MY._TARGET_Z = MY.Z;

	while(MY._MOVEMODE > 0)
	{

	// find direction
		MY_POS.X = MY._TARGET_X - MY.X;
		MY_POS.Y = MY._TARGET_Y - MY.Y;
		MY_POS.Z = 0;

		result = vec_to_angle(MY_ANGLE,MY_POS);   // 10/31/00 replace TO_ANGLE

		
		if (MY.X == prevx)
		
		{
			MY._TARGET_X = MY._TARGET_X * -1;
			MY._TARGET_Y = random (20000);
			MY._TARGET_Y = MY._TARGET_Y - 10000;
			MY._TARGET_Z = MY.Z;

		}

		if (MY.Y == prevy)
		
		{
			MY._TARGET_X = random (20000);
			MY._TARGET_Y = MY._TARGET_Y * -1;
			MY._TARGET_X = MY._TARGET_X - 10000;
			MY._TARGET_Z = MY.Z;

		}

		prevx = MY.X;
		prevy = MY.Y;

		force = MY._FORCE * 2;
		actor_turn();	// look to target

		force = MY._FORCE;
		if(abs(aforce.PAN) > MY._FORCE) 	// reduce speed if turning
		{
			force *= 0.5;
		}
		if(MY_ANGLE.Z < 40) 	// reduce speed near target
		{
			force *= 0.5;
		}
		actor_move();
		// Wait one tick, then repeat
		wait(1);
	}
}

ACTION Metal_Material
{
	MY.Metal = on;
}

ACTION Paint_Pad_Skin
{
	MY.Skin = MY.SKILL1;
}

ACTION LuluClick
{
	if (MoviePlaying == 1) { return; }

	MoviePlaying = 1;

	if MyStuff[player.CurrentInv] == 0
	{
		sPlay ("EFI019.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

		DoDialog (47);

		while (Dialog.visible == on) { Blink(); wait(1); }

		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP383.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("EFI020.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP384.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP385.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("EFI021.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP386.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("EFI022.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP387.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 3) 
		{
			sPlay ("PIP388.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}
	}

	else
	{
		if MyStuff[player.CurrentInv] == 1 
		{
			sPlay ("EFI023.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP389.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("EFI025.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP392.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("EFI026.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

			// Give him the vase piece and go on to the next act
			Asylum[1] = 1;
			WriteGameData (0);

			Run ("Intro14.exe");
		}

		else
		{
			sPlay ("EFI023.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP389.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("EFI024.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP390.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}
	}

	Talking = 0;
	MoviePlaying = 0;
}

ACTION ZvikaClick
{
	if (MoviePlaying == 1) { return; }

	MoviePlaying = 1;

	vec_set(temp,player.x);
	vec_sub(temp,my.x);
	vec_to_angle(my.pan,temp);
	my.tilt = 0; my.roll = 0;

	if MyStuff[player.CurrentInv] == 0
	{
		sPlay ("PIK001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

		DoDialog (38);

		while (Dialog.visible == on) { Blink(); wait(1); }

		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP296.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }

			my = player;

			morph (<PipCell2.mdl>,my);
			my.skill30 = 0;
			my.skill31 = - 6;
			while (my.skill30 < 100) { ent_frame ("Dial",my.skill30); my.skill30 = my.skill30 + 2 * time; my.skill31 = my.skill31 + 1 * time; if (my.skill31 > 8) { sPlay("TIK.WAV"); my.skill31 = 0; } wait(1); }
			ent_frame ("Stand",0);
			
			my = ZvikaPik;

			sPlay ("PIP297.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			morph (<PipAsy.mdl>,player);
			sPlay ("PIP298.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP299.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("PIK002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP300.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 3) 
		{
			sPlay ("PIP301.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("PIK004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP302.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("PIK005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		}
	}

	else
	{
		if MyStuff[player.CurrentInv] == 3
		{
			sPlay ("PIP538.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			MyStuff[player.CurrentInv] = 2;		// Replace the bead with the invitation
			ReleaseItem();
			sPlay ("SFX138.WAV");

			remove (me);
		}

		else
		{
			sPlay ("PIK006.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP303.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}
	}

	Talking = 0;
	MoviePlaying = 0;
}

ACTION HargolClick
{
	if (MoviePlaying == 1) { return; }

	MoviePlaying = 1;

	vec_set(temp,player.x);
	vec_sub(temp,my.x);
	vec_to_angle(my.pan,temp);
	my.tilt = 0; my.roll = 0;

	if MyStuff[player.CurrentInv] == 0
	{
		sPlay ("KRK001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

		DoDialog (40);

		while (Dialog.visible == on) { Blink(); wait(1); }

		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP312.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("KRK002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP313.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("KRK003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP314.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP315.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }

			KAN = 1;
			sPlay ("JOK0601.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("JOK0602.WAV"); Talking = 10; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("JOK0603.WAV"); Talking = 20; while (GetPosition(Voice) < 1000000) { wait(1); }
			sPlay ("laugh.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); }
			KAN = 0;

			sPlay ("PIP316.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("KRK004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP317.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("KRK005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		}

		if (DialogChoice == 3) 
		{
			sPlay ("PIP318.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}
	}

	else
	{
		if MyStuff[player.CurrentInv] == 4
		{
			sPlay ("PIP320.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("KRK008.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { ent_cycle ("Sneeze",GetPosition(Voice) / 10000); wait(1); }
			sPlay ("KRK007.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP321.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			MyStuff[player.CurrentInv] = 3;		// Replace the powder with the bead
			ReleaseItem();
			sPlay ("SFX138.WAV");

			remove (me);
		}

		else
		{
			sPlay ("KRK006.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP319.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}
	}

	Talking = 0;
	MoviePlaying = 0;
}

ACTION CrookClick
{
	if (MoviePlaying == 1) { return; }

	MoviePlaying = 1;

	vec_set(temp,player.x);
	vec_sub(temp,my.x);
	vec_to_angle(my.pan,temp);
	my.tilt = 0; my.roll = 0;

	if MyStuff[player.CurrentInv] == 0
	{
		sPlay ("MAF001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		sPlay ("PIP350.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		sPlay ("MAF002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

		DoDialog (44);

		while (Dialog.visible == on) { Blink(); wait(1); }

		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP351.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("MAF003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP352.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP353.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("PIP354.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("MAF004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP355.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("MAF008.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP356.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 3) 
		{
			sPlay ("PIP357.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("MAF006.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP358.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("MAF005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP359.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("MAF007.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

		}
	}

	else
	{
		if MyStuff[player.CurrentInv] == 9
		{
			sPlay ("PIP360.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("MAF009.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			MyStuff[player.CurrentInv] = 4;		// Replace the toy taxi with the powder
			ReleaseItem();
			sPlay ("SFX138.WAV");

			remove (me);
		}

		else
		{
			sPlay ("MAF007.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		}

		
	}

	Talking = 0;
	MoviePlaying = 0;

}

ACTION JarguyClick
{
	if (MoviePlaying == 1) { return; }

	MoviePlaying = 1;

	vec_set(temp,player.x);
	vec_sub(temp,my.x);
	vec_to_angle(my.pan,temp);
	my.tilt = 0; my.roll = 0;

	if MyStuff[player.CurrentInv] == 0
	{
		sPlay ("JAR001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		sPlay ("PIP361.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		sPlay ("JAR002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

		DoDialog (45);

		while (Dialog.visible == on) { Blink(); wait(1); }

		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP362.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("JAR003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP363.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("JAR004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP364.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("JAR005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP365.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("JAR006.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP366.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("JAR007.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP367.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP368.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("JAR008.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP369.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 3) 
		{
			sPlay ("PIP370.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			pStomak.visible = on;
			waitt(32);
			pStomak.visible = off;
			Belly = 1;
			sPlay ("PIP541.WAV"); while (GetPosition(Voice) < 1000000) { wait(1); }
			Belly = 2;
			sPlay ("PIP542.WAV"); while (GetPosition(Voice) < 1000000) { wait(1); }
			Belly = 0;
			sPlay ("PIP371.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}
	}

	else
	{
		if MyStuff[player.CurrentInv] == 8
		{
			sPlay ("JAR010.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP373.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			MyStuff[player.CurrentInv] = 5;		// Replace the tomato bride with the top
			ReleaseItem();
			sPlay ("SFX138.WAV");

			remove (me);
		}

		else
		{
			sPlay ("JAR010.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP372.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}
	}
	
	Talking = 0;
	MoviePlaying = 0;
}

ACTION TrashmanClick
{
	if (MoviePlaying == 1) { return; }

	MoviePlaying = 1;

	vec_set(temp,player.x);
	vec_sub(temp,my.x);
	vec_to_angle(my.pan,temp);
	my.tilt = 0; my.roll = 0;

	if MyStuff[player.CurrentInv] == 0
	{
		sPlay ("PIP336.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		sPlay ("CAN001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

		DoDialog (43);

		while (Dialog.visible == on) { Blink(); wait(1); }

		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP337.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("MSC001.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { wait(1); } // *** Do Animation **
			sPlay ("CAN002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP338.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP339.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("Can003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP340.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("CAN004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP341.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("CAN005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP342.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("CAN006.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP343.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("CAN007.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP344.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 3) 
		{
			sPlay ("PIP345.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("CAN008.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP346.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("CAN009.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		}
	}

	else
	{
		if MyStuff[player.CurrentInv] == 6
		{
			sPlay ("PIP347.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			MyStuff[player.CurrentInv] = 10;	// Replace the sandwich with the trash can
			ReleaseItem();
			sPlay ("SFX138.WAV");

			remove (me);
		}

		else
		{
			sPlay ("CAN010.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		}

	}

	Talking = 0;
	MoviePlaying = 0;
}

ACTION DefinePool
{
	Pool = my;
}

ACTION ButtClick
{
	if (MoviePlaying == 1) { return; }

	MoviePlaying = 1;

	vec_set(temp,player.x);
	vec_sub(temp,my.x);
	vec_to_angle(my.pan,temp);
	my.tilt = 0; my.roll = 0;

	if MyStuff[player.CurrentInv] == 0
	{
		sPlay ("TAX001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

		DoDialog (39);

		while (Dialog.visible == on) { Blink(); wait(1); }

		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP304.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("TAX002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP305.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }	
		}

		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP306.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("TAX003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		}

		if (DialogChoice == 3) 
		{
			sPlay ("PIP307.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}
	}
	
	else
	{
		sPlay ("PIP308.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }

		if MyStuff[player.CurrentInv] == 5
		{
			sPlay ("TAX005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP310.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("PIP311.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			MyStuff[player.CurrentInv] = 9;		// Replace the top with the toy taxi
			remove (Buttface);
			ReleaseItem();
			sPlay ("SFX138.WAV");

			remove (me);
		}
		else
		{
			sPlay ("TAX004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP309.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}
	}

	Talking = 0;
	MoviePlaying = 0;
}

ACTION DefineButtface
{
	my.event = ButtClick;
	my.enable_click = on;

	while (1)
	{
		if (Talking != 2) { ent_frame ("Stand",0); Blink(); }

		if (MoviePlaying == 0)
		{
			ent_cycle ("Stand",my.Anim);
			my.Anim = my.Anim + 10 * time;
			if my.Anim > 1000 { my.Anim = 0; }
		}

		wait(1);
	}

}

ACTION FoodMachineClick
{
	if MyStuff[player.CurrentInv] == 7
	{
		sPlay ("SFX137.WAV");
		MyStuff[player.CurrentInv] = 6;		// Replace the shekel with the sandwich
		ReleaseItem();
		while (GetPosition (Voice) < 1000000) { wait(1); }
		sPlay ("SFX138.WAV");
	}
	else
	{
		sPlay ("PIP568.WAV");
		Talking = 1;
		while (GetPosition (Voice) < 1000000) { wait(1); }
		Talking = 0;
	}
}

ACTION ShekelClick
{
	remove (me);
	NumInv = NumInv + 1;
	MyStuff[NumInv] = 7;	// Took shekel
	releaseitem();
}

ACTION TomatoClick
{
	if (MoviePlaying == 1) { return; }

	MoviePlaying = 1;

	vec_set(temp,player.x);
	vec_sub(temp,my.x);
	vec_to_angle(my.pan,temp);
	my.tilt = 0; my.roll = 0;

	if (MyStuff[player.CurrentInv] == 0)
	{
		sPlay ("TOM001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

		DoDialog (41);

		while (Dialog.visible == on) { Blink(); wait(1); }

		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP322.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("TOM002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP323.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("TOM003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP324.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("TOM004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

			DoDialog (42);

			while (Dialog.visible == on) { Blink(); wait(1); }

			if (DialogChoice == 1) 
			{ 
				sPlay ("PIP325.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			}

			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP326.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("TOM005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP327.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP328.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("TOM008.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP329.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("TOM009.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP330.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("TOM010.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP331.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("TOM011.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP332.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			}
		}

		if (DialogIndex == 41)
		{
			if (DialogChoice == 2) 
			{ 
				sPlay ("PIP333.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("TOM012.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP334.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("TOM006.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
				sPlay ("PIP543.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			}

			if (DialogChoice == 3) 
			{
				sPlay ("PIP532.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("AMI009.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP533.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("AMI010.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP536.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DialNow = 1;
				while (DialNow == 1) { Blink(); wait(1); }
				sPlay ("PIP537.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				DialNow = -1;
				sPlay ("PIP534.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("AMI011.WAV"); Talking = 0; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
				sPlay ("PIP535.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			}
		}
	}
	else
	{
		if MyStuff[player.CurrentInv] == 17
		{
			sPlay ("TOM007.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP502.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("TOM013.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP335.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			MyStuff[player.CurrentInv] = 8; // Replace yoshi with the tomato bride
			releaseitem();
			sPlay ("SFX138.WAV");

			remove (me);
		}
		else
		{
			sPlay ("TOM007.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP544.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}
	}

	Talking = 0;
	MoviePlaying = 0;
}

action Mandolin
{
	while(1)
	{
		if (my.skill1 == 1)
		{
			if (MoviePlaying == 0) { my.invisible = off; } else { my.invisible = on; }
		}

		if (my.skill1 == 2)
		{
			if (MoviePlaying == 0) { my.invisible = on; } else { my.invisible = off; }
		}

		wait(1);
	}
}

ACTION Lulu
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = LuluClick;

	while (1)
	{
		if (MoviePlaying == 0)
		{
			ent_cycle ("Play",my.Anim);
			my.Anim = my.Anim + 10 * time;
			talk2();
		}
		else
		{
			if (Talking != 2) { blink(); }
		}

		wait(1);
	}
}

ACTION FatsoClick
{
	if (MoviePlaying == 1) { return; }

	MoviePlaying = 1;

	if MyStuff[player.CurrentInv] == 0
	{
		sPlay ("FAT001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

		DoDialog (37);

		while (Dialog.visible == on) { Blink(); wait(1); }

		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP284.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("FAT002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP285.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("FAT003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP286.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP287.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("FAT004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP288.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("FAT005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		}

		if (DialogChoice == 3) 
		{
			sPlay ("PIP289.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("FAT006.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP290.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("FAT007.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP291.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("FAT008.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP292.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}
	}

	else
	{
		if MyStuff[player.CurrentInv] == 2
		{
			sPlay ("FAT009.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP294.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			MyStuff[player.CurrentInv] = 1;		// Replace the invitation with the sesame candy
			ReleaseItem();
			sPlay ("SFX138.WAV");

			remove (me);
		}
		else
		{
			sPlay ("FAT009.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP293.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

	}

	Talking = 0;
	MoviePlaying = 0;
}

function DoDialog (num)
{
	DialogChoice = 0;
	DialogIndex = num; 
	ShowDialog();
	Talking = 0;
}

ACTION Fatso
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = FatsoClick;
	while (1)
	{
		if (Talking != 2) { ent_frame ("Stand",0); Blink(); }

		if (MoviePlaying == 0)
		{
			ent_cycle ("Stand",my.Anim);
			my.Anim = my.Anim + 3;
			if my.Anim > 1000 { my.Anim = 0; }
		}

		wait(1);
	}
}

ACTION Zvika
{
	ZvikaPik = my;
	MY.ENABLE_CLICK = ON;
	MY.EVENT = ZvikaClick;
	while (1)
	{
		if (Talking != 2) { ent_frame ("Stand",0); Blink(); }

		if (MoviePlaying == 0)
		{
			ent_cycle ("Stand",my.Anim);
			my.Anim = my.Anim + 10 * time;
			if my.Anim > 1000 { my.Anim = 0; }
		}

		wait(1);
	}
}

ACTION Hargol
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = HargolClick;
	while (1)
	{
		if (Talking != 2) { Blink(); }

		if (MoviePlaying == 0)
		{
			ent_cycle ("Stand",my.Anim);
			my.Anim = my.Anim + 10 * time;
			if my.Anim > 1000 { my.Anim = 0; }
		}

		wait(1);
	}
}

ACTION Crook
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = CrookClick;
	while (1)
	{
		if (Talking != 2) { blink(); }

		if (MoviePlaying == 0)
		{
			ent_cycle ("Stand",my.Anim);
			my.Anim = my.Anim + 10 * time;
			if my.Anim > 1000 { my.Anim = 0; }
		}

		wait(1);
	}
}

ACTION Taxi
{
	Buttface = my;
}

ACTION Jarguy
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = JarguyClick;
	while (1)
	{
		if (Talking != 2) { ent_frame ("Stand",0); Blink(); }

		if (MoviePlaying == 0)
		{
			ent_cycle ("Stand",my.Anim);
			my.Anim = my.Anim + 10 * time;
			if my.Anim > 1000 { my.Anim = 0; }
		}

		wait(1);
	}
}

ACTION Trashman
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = TrashmanClick;
	while (1)
	{
		if (Talking != 2) { ent_frame ("Stand",0); Blink(); }

		if (MoviePlaying == 0)
		{
			ent_cycle ("Stand",my.Anim);
			my.Anim = my.Anim + 10 * time;
			if my.Anim > 1000 { my.Anim = 0; }
		}

		wait(1);
	}
}

ACTION FoodMachine
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = FoodMachineClick;
}

ACTION Shekel
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = ShekelClick;
}

ACTION Tomato
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = TomatoClick;

	while (1)
	{
		if (Talking != 2) { ent_frame ("Stand",0); Blink(); }

		if (MoviePlaying == 0)
		{
			ent_cycle ("Stand",my.Anim);
			my.Anim = my.Anim + 10 * time;
			if my.Anim > 1000 { my.Anim = 0; }
		}

		wait(1);
	}
}

ACTION YoshiClick
{
	if (MoviePlaying == 1) { return; }

	MoviePlaying = 1;

	if MyStuff[player.CurrentInv] == 0
	{
		sPlay ("PIP374.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		sPlay ("JEZ001.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }

		DoDialog (46);

		while (Dialog.visible == on) { Blink(); wait(1); }

		if (DialogChoice == 1) 
		{ 
			sPlay ("PIP375.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("JEZ002.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP376.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 2) 
		{ 
			sPlay ("PIP377.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("JEZ003.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP378.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("JEZ004.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP379.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}

		if (DialogChoice == 3) 
		{
			sPlay ("PIP380.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
			sPlay ("JEZ005.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
		}
	}

	else
	{
		if MyStuff[player.CurrentInv] == 10
		{
			sPlay ("JEZ006.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP382.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }

			BarImage.visible = off;
			BreathBar.visible = off;

			MyStuff[player.CurrentInv] = 17;	// Replace the trash can with yoshi
			releaseitem();

			remove (me);
			remove (Pool);

			sPlay ("SFX138.WAV");
		}
		else
		{
			sPlay ("JEZ006.WAV"); Talking = 2; while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			sPlay ("PIP381.WAV"); Talking = 1; while (GetPosition(Voice) < 1000000) { Blink(); wait(1); }
		}
	}

	Talking = 0;
	MoviePlaying = 0;
}

ACTION Yoshi
{
	MY.ENABLE_CLICK = ON;
	MY.EVENT = YoshiClick;
	while (1)
	{
		if (Talking != 2) { ent_frame ("Stand",0); Blink(); }

		if (MoviePlaying == 0)
		{
			ent_cycle ("Stand",my.Anim);
			my.Anim = my.Anim + 10 * time;
			if my.Anim > 1000 { my.Anim = 0; }
		}

		wait(1);
	}
}

action ScrnClick { pMov.visible = on; }

action Screen
{
	my.scale_x = 3;
	while(1)
	{
		if (my.skin == 2) { my.skin = 1; } else { my.skin = 2; }
		waitt(6);
	}
}

action MovCam
{
	my.event = ScrnClick;
	my.enable_click = on;
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) { if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } else { ent_frame ("Talk",int(random(5)) * 25); } }
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

function Blink2()
{
	if (my.skill22 > 0) { my.skill22 = my.skill22 - 1 * time; }
	if (my.skill22 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill22 = 5; }
	}
}


function Hold
{
	while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
}		

action TakeMe
{
	NumInv = NumInv + 1;
	MyStuff[NumInv] = my.skill1;
	my.shadow = off;
	remove (me);
	releaseitem();
}

action Useless
{
	my.shadow = on;
	my.enable_click = on;
	my.event = TakeMe;
}

action BellyCam
{
	while(1)
	{
		if (Belly > 0)
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

action Momma
{
	while(1)
	{
		my.skill45 = my.skill45 + 1 * time;
		if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
		if (belly == 1) { ent_frame ("stand",0); }
		if (belly == 2) { ent_frame ("slide",my.skill1); my.skill1 = my.skill1 + 3 * time; }
		wait(1);
	}
}

action KN
{
	while(1)
	{
		if (KAN == 1) { my.invisible = off; } else { my.invisible = on; }
		if (Talking == 10) { ent_cycle ("KTalk",my.skill1); }
		if (Talking == 20) { ent_cycle ("NTalk",my.skill1); }
		if (Talking == 0) { ent_cycle ("Stand",my.skill1); }
		my.skill1 = my.skill1 + 10 * time;
		wait(1);
	}
}

action ColaClick
{
	sPlay ("PIP567.WAV");
	Talking = 1;
	while (GetPosition(Voice) < 1000000) { wait(1); }
	Talking = 0;
}

action Cola
{
	my.enable_click = on;
	my.event = ColaClick;
}

action PieceX
{
	my.skill1 = 10;

	while(1)
	{
		my.ambient = my.ambient + my.skill1 * time;
		if (my.ambient > 50) { my.skill1 = -10; }
		if (my.ambient < -50) { my.skill1 = 10; }
		wait(1);
	}
}

action TakePaper
{
	pPaper.visible = on;
}

action NewsPaper
{
	my.event = TakePaper;
	my.enable_click = on;
}

on_F1 = changeview;
on_F2 = SwitchCase;
on_F3 = ReleaseItem();