// Template file v5.202 (02/20/02)
////////////////////////////////////////////////////////////////////////
// File: doors.wdl
//		WDL prefabs for doors, platforms, gates, switchs, etc
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
// ACTIONS:
//
//	FUNCTIONS:
//
//
////////////////////////////////////////////////////////////////////////

IFNDEF DOORS_DEF;
 SOUND gate_snd <gate.wav>;		// elevators
 SOUND open_snd <door_op.wav>;
 SOUND close_snd <door_cl.wav>;
 SOUND key_fetch <beamer.wav>;
 SOUND trigger_snd <click.wav>;
ENDIF;

IFNDEF DOORS_DEF2;
 SOUND teleport_snd <beamer.wav>;
ENDIF;
////////////////////////////////////////////////////////////////////////
// Strings for needing and picking up keys; can be redefined
STRING need_key1_str "Red key required";
STRING need_key2_str "Green key required";
STRING need_key3_str "Blue key required";
STRING need_key4_str "Silver key required";
STRING need_key5_str "Golden key required";
STRING need_key6_str "Black key required";
STRING need_key7_str "White key required";
STRING need_key8_str "Yet another key required";
STRING got_key1_str "Found a red key!";
STRING got_key2_str "Found a green key!";
STRING got_key3_str "Found a blue key!";
STRING got_key4_str "Found a silver key!";
STRING got_key5_str "Found a golden key!";
STRING got_key6_str "Found a black key!";
STRING got_key7_str "Found a white key!";
STRING got_key8_str "Found a yet another key!";

// These skills may not only be set by keys, but can also be set by
// dedicated actions, dialogues in adventures, and so on.
// If a key skill is set to 1, the door or elevator will work.
var key1 = 0;
var key2 = 0;
var key3 = 0;
var key4 = 0;
var key5 = 0;
var key6 = 0;
var key7 = 0;
var key8 = 0;


var		temp_dist = 0; 		// temp store a distance (used in range trigger)
var		temp_dist2 = 0; 		// temp store a distance (used in range trigger)
//SYNONYM	temp_elevator	{ TYPE ENTITY; }  // store the current elevator  (dcp - changed from temp_ent because of name conflict in movement.wdl)
entity*	temp_elevator;			// store the current elevator  (dcp - changed from temp_ent because of name conflict in movement.wdl)

///////////////////////////////////////////////////////////////////////
DEFINE _ENDPOS_X,SKILL1;	// target position for elevator
DEFINE _ENDPOS_Y,SKILL2;
DEFINE _ENDPOS_Z,SKILL3;	// target height for elevator
DEFINE _ENDPOS,SKILL3;		// opening angle for doors
DEFINE _KEY,SKILL4;			// key number, 0 = no key needed
DEFINE _KEYTYPE,SKILL4;		// legacy
DEFINE _PAUSE,SKILL6;		// wait time at end positions
DEFINE _TRIGGER_RANGE,SKILL7;	// door/elevator may be triggered
DEFINE _SWITCH,SKILL8;		// remote switch number for operating

DEFINE _ENTROT_PAN, SKILL1;  // ent_rotate() pan speed
DEFINE _ENTROT_TILT, SKILL2; // ent_rotate() tilt speed
DEFINE _ENTROT_ROLL, SKILL3; // ent_rotate() roll speed

DEFINE _CURRENTPOS,SKILL9;
DEFINE _TRIGGERFRAME,SKILL10;	// Frame number of the last received trigger
DEFINE _STARTPOS_X,SKILL27;	// start position for elevator
DEFINE _STARTPOS_Y,SKILL28;
DEFINE _STARTPOS_Z,SKILL29;	// start height for elevator

DEFINE __ROTATE,FLAG1;	// key item rotates
DEFINE __SILENT,FLAG2;	// no message
DEFINE __GATE,FLAG5;		// elevator is a gate   (DCP: changed from 7 to 5)
DEFINE __REMOTE,FLAG6;	// platform can be remote started from the target position
DEFINE __LID,FLAG7;		// door is a lid (opens vertically)

DEFINE __MOVING,FLAG8;  // set during movement


//////////////////////////////////////////////////////////////////////////////////////////////////
var	doorswitch_states = 0;		// the states of each door switch (0-off, 1-on)


// Desc: the door switch event
//			if the _doorevent_check returns a valid value, set/reset (XOR)
//		  the doorswitch_states value using the switch's _SWITCH value
//
function doorswitch_event()
{
	_doorevent_check();
	if(RESULT) { doorswitch_states ^= MY._SWITCH; }	// set/reset door switch
}

// Desc: action attached to door switch
//			can be used to active both doors and/or elevators
//
//
// uses _TRIGGER_RANGE, _SWITCH
ACTION	doorswitch
{
	MY.EVENT = doorswitch_event;
	_doorevent_init();

	if(MY._SWITCH == 0) { MY._SWITCH = 1; }	// default to switch 1

}

// Desc: Reset all the door switches
//
function	_doorswitch_reset_all()
{
	doorswitch_states = 0;
}


// Desc: check the switch once every 24 ticks
//       if it's state has changed, activate
//
function	_elevator_use_switch()
{
	while(1)
	{
		if((MY._SWITCH & doorswitch_states) != 0)
		{
			// state has changed (0->1), activate
			elevator_move();

			while((MY._SWITCH & doorswitch_states) != 0)
			{
				waitt(24);
			}
			// state has changed (1->0), activate
			elevator_move();

		}
		waitt(24);

	}
}

// Desc: check the switch once every 16 ticks
//       if it's state has changed, activate
//
function	_door_use_switch()
{
	while(1)
	{
		// assert(MY._SWITCH & doorswitch_states == 0)

		if((MY._SWITCH & doorswitch_states) != 0)
		{
			// state has changed (0->1), activate
			_door_swing();

			while((MY._SWITCH & doorswitch_states) != 0)
			{
				// assert(MY._SWITCH & doorswitch_states != 0)
				waitt(16);
			}
			// state has changed (1->0), activate
			_door_swing();

		}
		waitt(16);
 	}
}


////////////////////////////////////////////////////////////////////////


// Desc: Rotates an entity as long as it is visible and stays at the same place
//
// uses _ENTROT_PAN, _ENTROT_TILT, _ENTROT_ROLL
ACTION ent_rotate
{
	// by default, rotate horizontally
	if((MY._ENTROT_PAN == 0) && (MY._ENTROT_TILT == 0) && (MY._ENTROT_ROLL == 0))
	{
		MY._ENTROT_PAN = 3;
	}

	//store the current position
	MY._STARTPOS_X = MY.X;
	MY._STARTPOS_Y = MY.Y;
	MY._STARTPOS_Z = MY.Z;

	// rotate it as long as it isn't picked up
	while(MY.INVISIBLE == OFF
		&& MY._STARTPOS_X == MY.X
		&& MY._STARTPOS_Y == MY.Y
		&& MY._STARTPOS_Z == MY.Z)
	{
		MY.PAN  += MY._ENTROT_PAN*TIME;
		MY.TILT += MY._ENTROT_TILT*TIME;
		MY.ROLL += MY._ENTROT_ROLL*TIME;
		wait(1);
	}
}

////////////////////////////////////////////////////////////////////////
// Key actions.

// Desc: rotate an item horizontally
//
// no WED defined skills
ACTION item_rotate
{
	//store the current position
	MY._STARTPOS_X = MY.X;
	MY._STARTPOS_Y = MY.Y;
	MY._STARTPOS_Z = MY.Z;

	// rotate it als long as it isn't picked up
	while(MY.INVISIBLE == OFF
		&& MY._STARTPOS_X == MY.X
		&& MY._STARTPOS_Y == MY.Y
		&& MY._STARTPOS_Z == MY.Z)
	{
		MY.PAN += 3*TIME;
		wait(1);
	}
}

// Desc: action to enable an entity to be picked up
//
// uses __ROTATE
ACTION item_pickup
{
	MY.PUSH = -1;
	MY.ENABLE_SCAN = ON;		// pick up pressing SPACE..
	MY.ENABLE_CLICK = ON;	// clicking with the mouse...
	MY.ENABLE_PUSH = ON;		// or touching the item

	if(MY.__ROTATE == ON) { item_rotate(); }
}

// Desc: called when a "key" receives an EVENT
//			set corisponding key value to 1, display string, play sound, and remove key
//
//
//	Mod Date: 9/21/01 DCP
//				Remove key message after removing key
function _key_pickup()
{
	if(EVENT_TYPE == EVENT_SCAN && indicator != _HANDLE) { return; }
	if(EVENT_TYPE == EVENT_PUSH && YOU != player) { return; }

	if(MY._KEY == 1) { key1 = 1; msg.STRING = got_key1_str; }
	if(MY._KEY == 2) { key2 = 1; msg.STRING = got_key2_str; }
	if(MY._KEY == 3) { key3 = 1; msg.STRING = got_key3_str; }
	if(MY._KEY == 4) { key4 = 1; msg.STRING = got_key4_str; }
	if(MY._KEY == 5) { key5 = 1; msg.STRING = got_key5_str; }
	if(MY._KEY == 6) { key6 = 1; msg.STRING = got_key6_str; }
	if(MY._KEY == 7) { key7 = 1; msg.STRING = got_key7_str; }
	if(MY._KEY == 8) { key8 = 1; msg.STRING = got_key8_str; }
	if(MY.__SILENT != ON) { show_message(); }
	play_sound(key_fetch,50);
	wait(1);
	remove(ME);
	waitt(MSG_TICKS);
	msg.string = empty_str;
}

// Desc: This entity must not look like a key at all...
//
// uses _KEY
// uses __ROTATE
ACTION key
{
	if(MY._KEY == 0) { MY._KEY = 1; }
	MY.EVENT = _key_pickup;
	item_pickup();
}


// Desc: reset key values to zero
//
function key_init()
{
	key1 = 0;
	key2 = 0;
	key3 = 0;
	key4 = 0;
	key5 = 0;
	key6 = 0;
	key7 = 0;
	key8 = 0;
}

////////////////////////////////////////////////////////////////////////

// Desc: handle "teleporter" events
//
function _tele_event()
{
	handle_touch();	// show mouse touch text, if any

	// entity walked over it while performing SONAR, or touched it
	if(  EVENT_TYPE == EVENT_SONAR
		|| EVENT_TYPE == EVENT_IMPACT)
	{
		wait(1);	// the entity was already moving, so this must be finished before displacing it

		YOUR.X = MY.SKILL1;	// displace the entity
		YOUR.Y = MY.SKILL2;
		YOUR.Z = MY.SKILL3;
		YOUR.PAN = MY.SKILL5;
		CAMERA.AMBIENT += 30;	// a short flash
		PLAY_SOUND teleport_snd,50;
		waitt(2);

		CAMERA.AMBIENT -= 20;
		waitt(2);

		CAMERA.AMBIENT -= 10;
	}
}

// Desc:  Teleporter action. Transports an entity to the SKILL1,2,3 position
// 		it touched. SKILL5 gives an angle.
//
// uses _TRIGGER_RANGE
ACTION teleporter
{
	MY.EVENT = _tele_event;
	MY.ENABLE_IMPACT = ON;

	// enable operating on stepping onto (for platform teleporters)
	if(MY._TRIGGER_RANGE == 1) {	MY.ENABLE_SONAR = ON; }

	// enable mouse text
	if(MY.STRING1 != NULL) { MY.ENABLE_TOUCH = ON; }
}


////////////////////////////////////////////////////////////////////////

// Desc: handle door events. Opens if a SCAN instruction was performed.
function door_event()
{
	_doorevent_check();
	if(RESULT) { _door_swing(); }
}


// Desc: set __LID flag to on, continue as a door
//
// uses _FORCE, _ENDPOS, _TRIGGER_RANGE, _SWITCH
ACTION lid
{
	MY.__LID = ON;
	door();
}

//Desc: a door.
//
// uses _FORCE, _ENDPOS, _TRIGGER_RANGE, _SWITCH
ACTION door
{
	MY.EVENT = door_event;
	_doorevent_init();
	if(MY._FORCE == 0) { MY._FORCE = 5; }
	if(MY._ENDPOS == 0) { MY._ENDPOS = 90; }
}

/*
ACTION trigger_beep {
	MY.EVENT = signal;
	MY.ENABLE_TRIGGER = 1;
	MY.TRIGGER_RANGE = 10;
	MY.PASSABLE = 1;
}
*/

// closes the door again if no trigger was received within the last 4 framesa second
function _doorevent_close()
{
	wait(4);

	// close door of no trigger received again, and yet open and not moving
	if((TOTAL_FRAMES > MY._TRIGGERFRAME + 3)
		&& (MY._CURRENTPOS == MY._ENDPOS)
		&& (MY.__MOVING == OFF))
	{
		_door_swing();
		return;
	}
}


function	_move_to_target()
{
	wait(1);
}

// Desc: active the door
//
// Mod: 06/07/01 DCP
//		Replace move() with ent_move() in GATE section
//
// Mod 07/03/01 DCP
//		Fixed error when gate moves over long distances
function _door_swing()
{
	MY.__MOVING = ON;

	if(MY.__GATE == ON)
	{
		if(MY.__SILENT == OFF) { PLAY_ENTSOUND ME,open_snd,66; }

		// open gate
		while(MY.__MOVING == ON)
		{
			wait(1);			// DcP - moved wait to the start of this block, before the __MOVING flag is set to OFF

			// calculate the 3D direction to move to
			MY._SPEED_X = MY._TARGET_X - MY.X;
			MY._SPEED_Y = MY._TARGET_Y - MY.Y;
			MY._SPEED_Z = MY._TARGET_Z - MY.Z;

			temp = MY._FORCE * TIME;  // use force for elevator speed

			// check the length to the target position to the normal speed
			if(vec_length(my._speed) > temp)
			{
				// if we still have room to move, move
				vec_normalize(MY._SPEED,temp);
			}
			else
			{
				// else, move to target position and stop
				MY.__MOVING = OFF;
			}
/*---    OLD CODE: REMOVE

			// check the distance to the target position, using pythagoras
			temp = MY._SPEED_X*MY._SPEED_X + MY._SPEED_Y*MY._SPEED_Y + MY._SPEED_Z*MY._SPEED_Z;

			// we have now the square of the distance to the target,
			// and must compare it with the square of the distance to move
			if(temp > MY._FORCE * TIME * MY._FORCE * TIME)
			{
				// if far, move with normal speed
				temp = MY._FORCE * TIME;
				vec_normalize(MY._SPEED,temp); // adjust the speed vector's length
			}
			else
			{	// if near, stop after moving the rest distance
				MY.__MOVING = OFF;
			}
*/
  			// move in that direction
			move_mode = ignore_passable + ignore_push + activate_trigger + glide;
			result = ent_move(NULLSKILL,MY._SPEED);


			// check to see if the door is stuck
			if(RESULT == 0)
			{
				// stop trying to move the gate
				break;
			}

			MY._SPEED_X = MY_SPEED.X;	// set the speed to the real distance covered
			MY._SPEED_Y = MY_SPEED.Y;	// for moving the player with the platform
			MY._SPEED_Z = MY_SPEED.Z;
		}

		MY._SPEED_X = 0;
		MY._SPEED_Y = 0;
		MY._SPEED_Z = 0;

		MY.__MOVING = OFF;

		// at end position, reverse the direction
		if(  (MY._TARGET_X == MY._ENDPOS_X)
			&&(MY._TARGET_Y == MY._ENDPOS_Y)
			&&(MY._TARGET_Z == MY._ENDPOS_Z))
		{
			MY._TARGET_X = MY._STARTPOS_X;
			MY._TARGET_Y = MY._STARTPOS_Y;
			MY._TARGET_Z = MY._STARTPOS_Z;

			// check to see if it closes automagically
			if(MY._PAUSE > 0)
			{
 				waitt(MY._PAUSE);
				_door_swing();	// do it again
				return;
			}

		}
		else
		{
			MY._TARGET_X = MY._ENDPOS_X;
			MY._TARGET_Y = MY._ENDPOS_Y;
			MY._TARGET_Z = MY._ENDPOS_Z;
		}

		return; // END GATE movement
	} // END if(MY.__GATE == ON)

	// check whether to open or to close
	if(MY._CURRENTPOS < MY._ENDPOS)
	{
		if(MY.__SILENT == OFF) { PLAY_ENTSOUND ME,open_snd,66; }
		while(MY._CURRENTPOS < MY._ENDPOS)
		{
			if(MY.__LID == ON)
			{
				MY.ROLL += MY._FORCE*TIME;
			}
			else
			{
				MY.PAN -= MY._FORCE*TIME;
			}
			MY._CURRENTPOS += ABS(MY._FORCE)*TIME;
			wait(1);
		}
		if(MY.__LID == ON)
		{
			MY.ROLL -= MY._CURRENTPOS-MY._ENDPOS;
		}
		else
		{
			MY.PAN += MY._CURRENTPOS-MY._ENDPOS;
		}
		MY._CURRENTPOS = MY._ENDPOS;
		if(MY.__LID == ON)
		{
			MY.PASSABLE = ON;	// otherwise the player won't fit through
		}
	}
	else  // MY._CURRENTPOS >= MY._ENDPOS
	{
		if(MY.__SILENT == OFF) { play_entsound(ME,close_snd,66); }
		while(MY._CURRENTPOS > 0)
		{
			if(MY.__LID == ON)
			{
				MY.ROLL -= MY._FORCE*TIME;
			}
			else
			{
				MY.PAN += MY._FORCE*TIME;
			}
			MY._CURRENTPOS -= abs(MY._FORCE)*TIME;
			wait(1);
		}
		if(MY.__LID == ON)
		{
			MY.ROLL -= MY._CURRENTPOS;
		}
		else
		{
			MY.PAN += MY._CURRENTPOS;
		}
		MY._CURRENTPOS = 0;
		if(MY.__LID == ON)
		{
			MY.PASSABLE = 0;
		}
	}
	MY.__MOVING = OFF;
}

////////////////////////////////////////////////////////////////////////

// Desc: handle elevator events
function elevator_event()
{
	_doorevent_check();
	if(RESULT) { elevator_move(); return; }
}

//	 Desc: set up the elevator
//
//
// uses _FORCE, _ENDPOS_X, _ENDPOS_Y, _ENDPOS_Z
// uses _TRIGGER_RANGE, __REMOTE, _SWITCH
ACTION elevator
{
	if(MY._FORCE == 0) { MY._FORCE = 5; }
	if(MY._ENDPOS_X == 0) { MY._ENDPOS_X = MY.X; }
	if(MY._ENDPOS_Y == 0) { MY._ENDPOS_Y = MY.Y; }
	if(MY._ENDPOS_Z == 0) { MY._ENDPOS_Z = MY.Z; }


	MY._TYPE = _TYPE_ELEVATOR;
	MY.EVENT = elevator_event;
	_elevatorevent_init();       // DCP - changed from _doorevent_init


	// initialize the movement parameters of the elevator
	MY._STARTPOS_X = MY.X;
	MY._STARTPOS_Y = MY.Y;
	MY._STARTPOS_Z = MY.Z;

	MY._TARGET_X = MY._ENDPOS_X;
	MY._TARGET_Y = MY._ENDPOS_Y;
	MY._TARGET_Z = MY._ENDPOS_Z;


 	if((MY._TRIGGER_RANGE > 1) || (MY.__REMOTE == ON))
 	{
 		// create a remote trigger to recall elevator
   	create(<arrow.pcx>,MY._TARGET_X,_elevator_target);
 	}


	MY.__MOVING = OFF;


	// if it's a paternoster, start its movement action
	if((MY.__GATE == OFF) && (MY._PAUSE > 0))
	{
		waitt(MY._PAUSE);
		elevator_move();
	}

}



/* old gate action
// will open and close a gate vertically
ACTION gate
{
	MY.__GATE = ON;	// define a gate - very similar to an elevator
	MY._ENDPOS_Z = MY.Z + 0.9*(MY.MAX_Z - MY.MIN_Z);
	elevator();
}
*/

// Desc: will open and close a gate
//
//_ENDPOS_X (SKILL1): percent of entity's width the door will travel in the X direction (default 0)
//_ENDPOS_Y (SKILL2): percent of entity's depth the door will travel in the Y direction (default 0)
//_ENDPOS_Z (SKILL3): percent of entity's width the door will travel in the Z direction (default 0)
//
//_KEYTYPE (SKILL4): key number (1..4) needed to open gate (default 0).
//
//_FORCE (SKILL5): gives the gate speed in quants per tick (default 5).
//
//_PAUSE (SKILL6): amount of time gate will remain open (default 0).  If value
//is 0, gate will stay open until it is activated again.
//
//_TRIGGER_RANGE (SKILL7): range, in quants, within which an entity must be to
//automatically open the gate (default 0).  If value is 0, the door will not
//open automatically.
//
//_SWITCH (SKILL8): remote switch number for operating (default 0).  If a
//switch value is changed all matching gates with the same number will be
//activated.
//
//__SILENT (FLAG2): if ON gate makes no noise (default OFF).
//
//
//
// uses _TRIGGER_RANGE, _SWITCH
// uses _FORCE, _ENDPOS_X, _ENDPOS_Y, _ENDPOS_Z
ACTION gate
{
	MY.__GATE = ON;	// define this entity as a gate

	// give the gate a default speed (if it doesn't already have one)
	if(MY._FORCE == 0) { MY._FORCE = 5; }

	// Set _ENDPOS_[X,Y,Z] values
	if((MY._ENDPOS_X == 0) && (MY._ENDPOS_Y == 0) && (MY._ENDPOS_Z == 0) )
	{
		// set default values
		MY._ENDPOS_X = MY.X;
		MY._ENDPOS_Y = MY.Y;
		MY._ENDPOS_Z = MY.Z + (0.9*(MY.MAX_Z - MY.MIN_Z));
	}
	else
	{
		// check individulal endpos
		if(MY._ENDPOS_X == 0) { MY._ENDPOS_X = MY.X; }
		else { MY._ENDPOS_X = MY.X + ((MY._ENDPOS_X/100)*(MY.MAX_X - MY.MIN_X)); }

		if(MY._ENDPOS_Y == 0) { MY._ENDPOS_Y = MY.Y; }
		else { MY._ENDPOS_Y = MY.Y + ((MY._ENDPOS_Y/100)*(MY.MAX_Y - MY.MIN_Y)); }

		if(MY._ENDPOS_Z == 0) { MY._ENDPOS_Z = MY.Z; }
		else { MY._ENDPOS_Z = MY.Z + ((MY._ENDPOS_Z/100)*(MY.MAX_Z - MY.MIN_Z)); }
	}


 	MY.EVENT = door_event;
	_doorevent_init();

	// initialize the movement parameters of the gate
	MY._STARTPOS_X = MY.X;
	MY._STARTPOS_Y = MY.Y;
	MY._STARTPOS_Z = MY.Z;

	MY._TARGET_X = MY._ENDPOS_X;
	MY._TARGET_Y = MY._ENDPOS_Y;
	MY._TARGET_Z = MY._ENDPOS_Z;


	MY.__MOVING = OFF;
}




// Desc: handle ranged trigger events
function _elevator_target_event()
{
	// entity performed SCAN nearby (by pressing SPACE)
	if((EVENT_TYPE == EVENT_SCAN) && (indicator == _HANDLE))
	{
		MY = MY.ENTITY1;		// pretend that I'm the elevator
		elevator_event();  // and received a SCAN myself
		return;
	}


	// if we receive a trigger event...
	// DcP - NOTE: EVENT_CLICK ADDED TO TEST RECALL CODE (4/4/00)
	if((EVENT_TYPE == EVENT_TRIGGER) || (EVENT_TYPE == EVENT_CLICK))
	{
 		// check to see if the player is closer to the elevator or this trigger
		// calculate the distance squared to the trigger (You = player, me = trigger)
   	temp.X = YOUR.X - MY.X;
	  	temp.Y = YOUR.Y - MY.Y;
	  	temp.Z = YOUR.Z - MY.Z;

		vec_to_angle(temp_dist, temp);
		// DcP- replaced with vec_to_angle()
		//temp_dist.Z = (temp.X * temp.X) + (temp.Y * temp.Y) + (temp.Z * temp.Z);

 	  	ME = MY.ENTITY1;	   // become the elevator

		// calculate the distance squared to the elevator (You = player, me = elevator)
    	temp.X = YOUR.X - MY.X;
	  	temp.Y = YOUR.Y - MY.Y;
	  	temp.Z = YOUR.Z - MY.Z;
		vec_to_angle(temp_dist2, temp);

	   //	if(temp_dist < ((temp.X * temp.X) + (temp.Y * temp.Y) + (temp.Z * temp.Z)))

	   // DcP - NOTE: These lines commented out to test trigger without compairing it to the elevator pos.
 		if(temp_dist.Z < temp_dist2.Z)
 	  	{
			elevator_event();	// activate the elevator
			return;
 	  	}
	}
}


// Desc: invisible target entity action to remote call the elevator
//
// this entity is linked to the calling entity through its ENTITY1 skill
// this entity uses the calling entity's _RECALL_TRIGGER_RANGE value
//
// Mod: 06/08/01 DCP
//		Replace move() with ent_move()
function _elevator_target()
{
 	MY.INVISIBLE = ON;
	MY.PASSABLE = ON;
 	MY.ENTITY1 = YOU;	// store the adept_elevator pointer

	// ranged trigger is set here
	if(YOUR._TRIGGER_RANGE > 1)
	{
		MY.TRIGGER_RANGE = YOUR._TRIGGER_RANGE;
   	MY.ENABLE_TRIGGER = ON;
	   // DcP - NOTE: EVENT_CLICK ADDED TO TEST RECALL CODE (4/4/00)
   	MY.ENABLE_CLICK = ON;
 	}

	// here the REMOTE must also be considered
	if(YOUR.__REMOTE == ON)
	{
		MY.ENABLE_SCAN = ON;
	}

 	MY.EVENT = _elevator_target_event;
  	YOUR.ENTITY1 = ME;	// link the calling entity (elevator) to this target
}



// Action - elevator_move
//
// DCP- added code to move 'triggers' to the opposite ends from the elevator  (3//22/00)
//
// Mod 07/03/01 DCP
//		Fixed error when elevator travels over long distances
function elevator_move()
{
again:
	// start moving the elevator
	MY.__MOVING = ON;
	if(MY.__SILENT == OFF) { play_entsound(ME,gate_snd,66); }


	// DCP - if we're using a remote trigger
	if((MY._TRIGGER_RANGE > 1) || (MY.__REMOTE == ON))
	{
		temp_elevator = MY.ENTITY1;   			// the ranged target
  		temp_elevator.ENABLE_SCAN = OFF;     // disable scan on this trigger
		temp_elevator.ENABLE_TRIGGER = OFF;  // disable range on this trigger
	}


	while(MY.__MOVING == ON)
	{

		wait(1);			// DcP - moved wait to the start of this block, before the __MOVING flag is set to OFF

		// calculate the 3D direction to move to
		MY._SPEED_X = MY._TARGET_X - MY.X;
		MY._SPEED_Y = MY._TARGET_Y - MY.Y;
		MY._SPEED_Z = MY._TARGET_Z - MY.Z;



 		temp = MY._FORCE * TIME;  // use force for elevator speed

		// check the length to the target position to the normal speed
		if(vec_length(my._speed) > temp)
		{
			// if we still have room to move, move
			vec_normalize(MY._SPEED,temp);
		}
		else
		{
			// else, move to target position and stop
			MY.__MOVING = OFF;
		}


/*---- OLD CODE !!REMOVE!!
		// check the distance to the target position, using pythagoras
		temp = MY._SPEED_X*MY._SPEED_X + MY._SPEED_Y*MY._SPEED_Y + MY._SPEED_Z*MY._SPEED_Z;

		// we have now the square of the distance to the target,
		// and must compare it with the square of the distance to move
		if(temp > MY._FORCE * TIME * MY._FORCE * TIME)
		{
			// if far, move with normal speed
			temp = MY._FORCE * TIME;
			vec_normalize(MY._SPEED,temp);	// adjust the speed vector's length
		}
		else
		{	// if near, stop after moving the rest distance
			MY.__MOVING = OFF;
		}
*/

		// move into that direction
  		move_mode = ignore_you + ignore_passable + ignore_push + activate_trigger + glide;
		result = ent_move(NULLSKILL,MY._SPEED);


		MY._SPEED_X = MY_SPEED.X;	// set the speed to the real distance covered
		MY._SPEED_Y = MY_SPEED.Y;	// for moving the player with the platform
		MY._SPEED_Z = MY_SPEED.Z;
	}

	MY._SPEED_X = 0;
	MY._SPEED_Y = 0;
	MY._SPEED_Z = 0;

	// at end position, reverse the direction
	if(MY._TARGET_X == MY._ENDPOS_X
		&& MY._TARGET_Y == MY._ENDPOS_Y
		&& MY._TARGET_Z == MY._ENDPOS_Z )
	{
		MY._TARGET_X = MY._STARTPOS_X;
		MY._TARGET_Y = MY._STARTPOS_Y;
		MY._TARGET_Z = MY._STARTPOS_Z;
	}
	else
	{
		MY._TARGET_X = MY._ENDPOS_X;
		MY._TARGET_Y = MY._ENDPOS_Y;
		MY._TARGET_Z = MY._ENDPOS_Z;
	}


	// DCP - if a ranged trigger is used,
   if((MY._TRIGGER_RANGE > 1) || (MY.__REMOTE == ON))
	{
		temp_elevator = MY.ENTITY1;   // the ranged target

		temp_elevator.X = MY._TARGET_X; // move the ranged target to the elevator's target point
	  	temp_elevator.Y = MY._TARGET_Y;
	  	temp_elevator.Z = MY._TARGET_Z;

  		if(MY.__REMOTE == ON)
		{
			temp_elevator.ENABLE_SCAN = ON; 		// re-activate the scan event
		}

		// ranged trigger is set here
		if(MY._TRIGGER_RANGE > 1)
		{
	  		temp_elevator.ENABLE_TRIGGER = ON;	// re-activate the trigger event
 		}
  	}


   // DcP - reset the elevator's _TRIGGERFRAME to the current TOTAL_FRAMES    (4/7/00)
	//
	//      _TRIGGERFRAME is used in _doorevent_check to allow the user time
	//      to step off the lift before accepting new SONAR events
	MY._TRIGGERFRAME = TOTAL_FRAMES;


	// if a gate or paternoster, close it or restart
	if(((MY.__GATE == ON) && (MY._PAUSE > 0) && (MY.Z > MY._STARTPOS_Z))
		// close gate again
		|| ((MY.__GATE == OFF) && (MY._PAUSE > 0)))
	{
		// start paternoster in reverse direction
		waitt(MY._PAUSE);
		goto(again);
	}
}






////////////////////////////////////////////////////////////////////////
// helper actions for the events

// Desc: init the elevator
//
function _elevatorevent_init()
{
	MY.ENABLE_SCAN  = ON;
	MY.ENABLE_CLICK = ON;

	// enable operating on stepping onto (for elevators)
	if(MY._TRIGGER_RANGE > 0)
	{
		MY.ENABLE_SONAR = ON;
	}

	// enable mouse text
	if(MY.STRING1 != NULL)
	{
		MY.ENABLE_TOUCH = ON;
	}

	MY._TRIGGERFRAME = 0;
	MY.PUSH = 10;	// move through the level blocks

	// if it is switch activated...
	if(MY._SWITCH != 0)
	{
		_elevator_use_switch();
	}

}


function _doorevent_init()
{
	MY.ENABLE_SCAN = ON;
	MY.ENABLE_CLICK = ON;

	// enable triggering
	if(MY._TRIGGER_RANGE >= 2)
	{
		MY.ENABLE_TRIGGER = ON;
		MY.TRIGGER_RANGE = MY._TRIGGER_RANGE;
	}

	// enable operating on stepping onto (for elevators)
	if(MY._TRIGGER_RANGE == 1)
	{
		MY.ENABLE_SONAR = ON;
	}

	// enable mouse text
	if(MY.STRING1 != NULL)
	{
		MY.ENABLE_TOUCH = ON;
	}

	MY._TRIGGERFRAME = 0;
	MY.PUSH = 10;	// move through the level blocks

	// if it is switch activated...
	if(MY._SWITCH != 0)
	{
		_door_use_switch();
	}
}

// Desc: action checks whether an event can operate the door or platform
//
function _doorevent_check()
{
	handle_touch();	// show mouse touch text, if any

	if(MY.__MOVING == ON) { goto(ignore); }	// don't handle a moving door


	// entity performed SCAN nearby (by pressing SPACE)
	if((EVENT_TYPE == EVENT_SCAN) && (indicator == _HANDLE))
		|| (EVENT_TYPE == EVENT_CLICK)
	{
		if(MY.__SILENT == OFF) { play_sound(trigger_snd,50); }
		goto(try_key);
	}

	// player or entity with TRIGGER_RANGE walked nearby.
	// trigger only opens the door, closing is automatically
	if(EVENT_TYPE == EVENT_TRIGGER)
	{
		// not already open, and no trigger since the last 2 frames ?
		if((MY._CURRENTPOS != MY._ENDPOS)
			&& (TOTAL_FRAMES > (MY._TRIGGERFRAME + 2)))
		{
			MY._TRIGGERFRAME = TOTAL_FRAMES;
			goto(try_key);
		}
		MY._TRIGGERFRAME = TOTAL_FRAMES;
		// each trigger starts an action which closes the door again
		// if the triggering entity is outside range after some time
		_doorevent_close();
	}

	// entity walked over it while performing SONAR
	// sonar starts the platform
	if(EVENT_TYPE == EVENT_SONAR)
	{
		// no sonar or trigger since the last 5 frames (this is to make sure the
		// entity has walked off the platform before re-triggering)
		if(TOTAL_FRAMES > (MY._TRIGGERFRAME + 5))
		{
			MY._TRIGGERFRAME = TOTAL_FRAMES;
			goto(try_key);
		}

		MY._TRIGGERFRAME = TOTAL_FRAMES;
	}

// no operating condition happened, so tell the door not to move
ignore:
	RESULT = 0;
	return(0);

try_key:
	if((MY._KEY == 1)&&(key1 == 0)) { msg.STRING = need_key1_str; GOTO message; }
	if((MY._KEY == 2)&&(key2 == 0)) { msg.STRING = need_key2_str; GOTO message; }
	if((MY._KEY == 3)&&(key3 == 0)) { msg.STRING = need_key3_str; GOTO message; }
	if((MY._KEY == 4)&&(key4 == 0)) { msg.STRING = need_key4_str; GOTO message; }
	if((MY._KEY == 5)&&(key5 == 0)) { msg.STRING = need_key5_str; GOTO message; }
	if((MY._KEY == 6)&&(key6 == 0)) { msg.STRING = need_key6_str; GOTO message; }
	if((MY._KEY == 7)&&(key7 == 0)) { msg.STRING = need_key7_str; GOTO message; }
	if((MY._KEY == 8)&&(key8 == 0)) { msg.STRING = need_key8_str; GOTO message; }

operate:
	RESULT = 1;
	return(1);

message: // and don't operate
	if(MY.__SILENT != ON) { show_message(); }
	RESULT = 0;
	return(0);
}


///////////////////////////////////////////////////////////////////////