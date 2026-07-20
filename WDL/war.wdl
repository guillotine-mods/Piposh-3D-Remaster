// Template file v5.202 (02/20/02)
////////////////////////////////////////////////////////////////////////
// File: war.wdl
//		WDL prefabs for hostile entities
////////////////////////////////////////////////////////////////////////
//]- Mod Date: 8/22/00 DCP
//]-				Changed '_gib' function to take a parameter to determine
//]-			the number of pieces to create in the gib explosion.
//]- Mod Date: 8/31/00 DCP
//]-				Modified '_gib_action' function to scale absdist vector by movement_scale
//]-				Modified '_gib_action' function to scale the gibbits down by the actor_scale
//]- Mod Date: 10/31/00 DCP
//]-				Changed to 4.30 format
//]- Mod Date: 11/8/00 DCP
//]-          'attack_fire' & 'state_die': Replace set_frame with ent_frame
//]-
//]- Mod Date: 02/06/01 DCP
//]-		In 'fight_event':
//]-			Added wait before shoot command to remove 'Dangerous instruction error'
//]-	 	   Replaced SHOOT with trace()
//]-
//]-
//]- Mod: 05/05/01 DCP
//]-		In 'fight_event':
//]-			Modified damage from ranged explosion (replaced ABS with MAX)
//]-
//]- Mod Date: 05/16/01 DCP
//]-				Remove all 'BRANCH' commands (replace with <foo>(); return;)
//]-
//]- Mod Date: 05/18/01 DCP
//]-				Fixed "double shots" (the cause of robot1's self hits)
//]-
//]- Mod Date: 06/05/01 DCP
//]-		attack_approach(), avoid_walls(): Replaced TO_ANGLE with vec_to_angle()
//]-
//]- Mod Date: 06/21/01 DCP
//]-				Replaced SYNONYMs with pointers
//]-
//]- Mod: 07/19/01 MWS
//]-		state_wait(): Use specified cowardice value instead of universal 30.
//]-				Use specified alertness instead of universal 1000.
//]-				Also now skips the player scan entirely if alertness is zero.
//]-
//]-		attack_fire(): MY_ANGLE used in shooting at player now varies by a random
//]-				amount between -MY._I_ACCURACY to +MY._I_ACCURACY
//]-
//]- Mod Date: 7/26/01 MWS
//]-		attack_transitions(): Made "escape" branch test for MY._I_COWARDICE
//]-				instead of default 30.
//]-
//]- Mod Date: 12/18/01
//]-		Added WED 'uses' comments to all WED editable fields
//]-
//]- 7/12/02 JCL - menu_default re-renamed to menu_main
////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////


//DEFINE WAR_CHAT_ON;	// display 'thought' actions for the AIs
IFDEF WAR_CHAT_ON;
	STRING war_wait_str,"Waiting...";
	STRING war_attack_str,"Attacking!!!";
	STRING war_hunt_str,"Searching...";
	STRING war_escape_str,"Retreat!!!";
	STRING war_dead_str,"I have been undone!";
ENDIF;



//////////////////////////////////////////////////////////////////////
// WAR.WDL - fighting behaviour
///////////////////////////////////////////////////////////////////////
IFNDEF WAR_DEFS;
 DEFINE ACTOR_EXPLO,<explo+7.pcx>;
 DEFINE ACTOR_EXPLO_FRAMES,7;
ENDIF;

///////////////////////////////////////////////////////////////////////
var freeze_actors = 0;	// 1,2 for testing purposes


///////////////////////////////////////////////////////////////////////
DEFINE _STATE_WAIT,1;
DEFINE _STATE_ATTACK,2;
DEFINE _STATE_ESCAPE,3;
DEFINE _STATE_DIE,4;
DEFINE _STATE_FREEZE,5;       // 05/15/01 DCP: Changed from 4->5
DEFINE _STATE_HUNT,6;

DEFINE _MUZZLE_VERT,SKILL32;
DEFINE _I_ACCURACY,SKILL33;		// 07/19/01 MWS: Added
DEFINE _I_COWARDICE,SKILL34;		// 07/19/01 MWS: Added
DEFINE _I_ALERTNESS,SKILL35;		// 07/19/01 MWS: Added


// DEFINE USER INPUT SKILLs
// These skill will be inputted from WED and work with entities that use the actions:
//    "player_walk_fight" and "actor_walk_fight"
DEFINE	_WALKSWIM_DIST, SKILL1;   // Walk Distance . Swim Distance
DEFINE	_RUNCRAWL_DIST, SKILL2;   // Run Distance . Crawl Distance
DEFINE	_STANDJUMP_TIME, SKILL3;  // Stand Time . Jump Time
DEFINE	_ATTACKDUCK_TIME, SKILL4; // Attack Time . Duck Time
DEFINE	_RUNTHRESHOLD, SKILL14;	// Run Threshold
//DEFINE	_FORCE, SKILL5;			// Force
//DEFINE	_BANKING, SKILL6;			// Banking amount (player only)
//DEFINE	_HITMODE, SKILL6;			// Hitmode (actor only)
//DEFINE	_MOVEMODE, SKILL7;		// Starting movemode
//DEFINE	_FIREMODE, SKILL8;		// Firemode
//DEFINE	_HEALTH, SKILL9;			// Heath
//DEFINE	_ARMOR, SKILL10;			// Armor
DEFINE	_ALERTNESS, SKILL11;    // Alertness
DEFINE	_ACCURACY, SKILL12; 		// Accuracy
DEFINE	_COWARDICE, SKILL13;		// Cowardice
DEFINE	_MUZZLEATTACH, SKILL15;	// Muzzle vertex . Attach vertex
DEFINE	_WEAPONRANGE, SKILL16;	// weapon range for AI actors


string actor_explosion_mdl = <explosion.mdl>;


///////////////////////////////////////////////////////////////////////
entity* test_actor;	// test actor entity pointer. Used in robot_test

entity* ent_marker;	// marker entity, used in hunting


STRING	robot_attack_str, "attack";	// attack frame names used by robot

// Desc: test robot, removed if 'test' not defined
// 	No WED defined skills
ACTION robot_test
{
IFNDEF test;
	ent_remove(ME);
	return;
ENDIF;

	test_actor = ME;
	MY._WALKFRAMES = 8.030;
	MY._RUNFRAMES = 4.050;
	MY._ATTACKFRAMES = 6;
	MY._DIEFRAMES = 1;
	MY._FORCE = 2;
	MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH+0.05;
	MY._HITMODE = HIT_GIB;//HIT_EXPLO;
	MY._WALKSOUND = _SOUND_ROBOT;
	drop_shadow();
	anim_init();
	actor_fight();
}

// Desc: Action for robot #1
//			Init values and call actor_fight
// 	No WED defined skills
ACTION robot1
{
	MY._FORCE = 0.7;
	MY._FIREMODE = DAMAGE_EXPLODE+FIRE_BALL+HIT_EXPLO+BULLET_SMOKETRAIL+0.20;
	MY._HITMODE = 0;
	MY._WALKSOUND = _SOUND_ROBOT;
 	anim_init();
	drop_shadow();	// attach shadow to robot
	actor_fight();
//	if(MY.FLAG4 == ON) { CALL patrol; }
}


// Desc: Action for robot #2
//			Init values and call actor_fight
// 	No WED defined skills
ACTION robot2
{
	MY._FORCE = 2;
	MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH+0.05;
	MY._HITMODE = HIT_GIB;//HIT_EXPLO;
	MY._WALKSOUND = _SOUND_ROBOT;
	anim_init();
	drop_shadow(); // attach shadow to robot
	actor_fight();
//	if(MY.FLAG4 == ON) { patrol(); }
//	create(<arrow.pcx>,MY.POS,_ROBOT_TEST_WATCHER);  // used to activate watcher drone
}


// Desc: Action for robot #3
//			Init values and call actor_fight
//
// NOTE: robot #3 removes itself from the game!
// 	No WED defined skills
ACTION robot3
{
	ent_remove(ME);
	return;

	MY._FORCE = 0.7;
	MY._FIREMODE = DAMAGE_EXPLODE+FIRE_BALL+HIT_EXPLO+BULLET_SMOKETRAIL+0.20;
	anim_init();
	drop_shadow();
	actor_fight();
//	if(MY.FLAG4 == ON) { patrol(); }
}


// Desc: Debugging utility, watches a ROBOT and sets flags using its values
//
//]- Mod Date: 7/11/00 DCP
//]-				removed tst_values
entity* ent_test_watcher;		// marker entity, used in hunting
function _ROBOT_TEST_WATCHER()
{
	MY.PASSABLE = ON;
//	MY.INVISIBLE = ON;
	MY.ENTITY1 = YOU;

	WHILE(MY.ENTITY1 != 0)
	{
		ent_test_watcher = MY.ENTITY1;
		wait(1);

	}

	ent_remove(ME);
}
///////////////////////////////////////////////////////////////////////


// Desc: the wait state
//
//]-	Mod:	6/15/00	Doug Poston
//]-			Added call to actor_move
//]-
//]- Mod: 05/17/01 DCP
//]-			Changed Waitt(4) to Waitt(1) (faster reaction time and smoother
//]-		reaction to external forces)
//]-
// Mod: 07/19/01 MWS
//			Use specified cowardice value instead of universal 30.
//			Use specified alertness instead of universal 1000.
//			Also now skips the player scan entirely if alertness is zero.
function state_wait()
{
IFDEF WAR_CHAT_ON;
msg.STRING = war_wait_str;
show_message();
ENDIF;

	// init values here for backwards compatibility
	if(MY._I_COWARDICE == 0)
	{ MY._I_COWARDICE = 30; }		// use default cowardice
	if(MY._I_ALERTNESS == 0)
	{ MY._I_ALERTNESS = 1000; }	// use default alertness


	MY._STATE = _STATE_WAIT;
	while(MY._STATE == _STATE_WAIT)
	{

		if(MY._HEALTH <= 0)      // no health? Die
		{
			EXCLUSIVE_ENTITY;
			wait(1);
			state_die();
			return;
		}

		// Note: changed, negative cowardice means never retreat
		if(MY._HEALTH <= MY._I_COWARDICE  &&  MY._I_COWARDICE >= 0)     // low health? Escape
		{
			EXCLUSIVE_ENTITY;
			wait(1);
			state_escape();
			return;
		}


		if (MY._I_ALERTNESS > 0)	// dont be alert if negative alertness
		{
			// scan for the player coming near
			temp.PAN = 180;
			temp.TILT = 180;
			temp.Z = MY._I_ALERTNESS;
			indicator = _WATCH;
			scan(MY.POS,MY.ANGLE,temp);

			// if the player has been detected...
			if(MY._SIGNAL == _DETECTED)
			{
				MY._SIGNAL = 0;
				state_attack();	// ATTACK!
				return;
			}
		}

		force = 0;     // no force from this actor
		actor_move();	// react to outside forces (gravity, etc) even while waiting
		waitt(1);
	}
}

// Desc: The attack state
//
//]- Mod Date: 6/27/00 Doug Poston
//]-				Added longer (timed) waits in attack states
function state_attack()
{
	MY._STATE = _STATE_ATTACK;
IFDEF WAR_CHAT_ON;
msg.STRING = war_attack_str;
show_message();
ENDIF;
	MY._MOVEMODE = _MODE_ATTACK;	// stop patrolling etc.
	attack_transitions();      // branch to other states depending on values


	// fire and close distance
	while(MY._STATE == _STATE_ATTACK)
	{

		// fire two or three times
		MY._COUNTER = 1.5 + RANDOM(1);

 		// check to see if player is shootable,
 		if((attack_fire()) == -1)
 		{
 			// cannot see player
 		  	EXCLUSIVE_ENTITY;
			wait(1);
			state_hunt();
			return;
 		}
		while(MY._COUNTER > 0) { waitt(1); }	// don't continue until attack_fire is finished

 		// walk towards player for one to three seconds
		MY._COUNTER = 16 + RANDOM(32);
		attack_approach();
		while(MY._COUNTER > 0) { waitt(1); } // don't continue until attack_approach is finished
	}


}

// Desc: Use internal and external values to branch to other states
//
//]- Mod Date: 7/8/00 DCP
//]-				Added EXCLUSIVE_ENTITY before each BRANCH
// Mod Date: 7/26/01 MWS
//				Made "escape" branch test for MY._I_COWARDICE instead of default 30
function attack_transitions()
{
	while(MY._STATE == _STATE_ATTACK)
	{
		if(MY._HEALTH <= 0)    // goto die state
		{
			EXCLUSIVE_ENTITY;
			wait(1);
			state_die();
			return;
		}
		if(MY._HEALTH <= MY._I_COWARDICE  &&  MY._I_COWARDICE >= 0)     // low health? Escape
		{
			EXCLUSIVE_ENTITY;
			wait(1);
			state_escape();
			return;
		}
		if(freeze_actors > 0)   // goto freeze state
		{
			EXCLUSIVE_ENTITY;
			wait(1);
			state_freeze();
			return;
		}
		wait(1);
	}
}



//	Desc: attack the player:
//				-turn towards player
//				-check if entity can see the player
//				-play fire animation
//				-fire shot
//
//]- Mod Date: 5/9/00 @ 908 by Doug Poston
//]-           Modified to use new animation system (SET_CYCLE/FRAME)
//]-
//]- Mod Date: 10/24/00 DCP
//]-				 Added ent_vertex() to use the _WEAPON_VERT (skill32) to select a
//]-				vertex on the model to be used as the weapon muzzle point.
//]-
//]- Mod Date: 11/1/00 DCP
//]-				 Replaced SHOOT with trace()
//]-
//]- Mod Date: 11/8/00 DCP
//]-          Replace set_frame with ent_frame
//]-
// Mod Date: 05/18/01 DCP
//				Fixed "double shots" (the cause of robot1's self hits)
//
// Mod Date: 07/19/01 MWS
//				MY_ANGLE used in shooting at player now varies by a random
//				amount between -MY._I_ACCURACY to +MY._I_ACCURACY
//
// Mod Date: 08/22/01 DCP
//			Added "Advanced" Animation for firing
function attack_fire()
{
	while((MY._STATE == _STATE_ATTACK) && (MY._COUNTER > 0))
	{
		// turn towards player
		temp.X = player.X - MY.X;
		temp.Y = player.Y - MY.Y;
		temp.Z = player.Z - MY.Z;
		vec_to_angle(MY_ANGLE,temp);
		force = MY._FORCE * 2;
		actor_turn();

		// watch out if player visible. If yes, then shoot at him
		indicator = _WATCH;
		//SHOOT MY.POS,player.POS;
		trace_mode = IGNORE_ME + IGNORE_PASSABLE + IGNORE_PASSENTS;
		trace(MY.POS,player.POS);

		if((RESULT > 0) && (YOU == player))	// spotted him!
		{
			// fire at player
			// 1) PLAY ATTACK ANIMATION
			// check for *ADVANCED ANIMATION* (frame names and entity tick/dist values)
			if(int(MY._WALKFRAMES) < 0)
			{
				// reset entity's animation time to zero
				MY._ANIMDIST = 0;

				while(MY._ANIMDIST < 50)
				{
					// if you have more than one attacking animation, here's where you would test for it...
					// calculate a percentage out of the animation time
					MY._ANIMDIST +=  100*(TIME / (INT(((-MY._ADVANIM_TICK)&MASK_ANIM_ATTACK_TICKS)>>10)));
					// set the frame from the percentage
					ent_frame(robot_attack_str,MY._ANIMDIST);
					wait(1);
				}
			}
			else
			{
				// decide whether it's a frame number (old) or frame name (new) animation
				if(frc(MY._WALKFRAMES) > 0)// OLD STYLE ATTACK ANIMATION
				{
					// play attack animation
					MY.FRAME = 1 + MY._WALKFRAMES + MY._RUNFRAMES + 1;   // set frame to start
					MY.NEXT_FRAME = 0;	// inbetween to the real next frame
					while(MY.FRAME > 1 + MY._WALKFRAMES + MY._RUNFRAMES + MY._ATTACKFRAMES)
					{
						wait(1);
 						MY.FRAME += 0.4 * TIME;
					}
  					MY.FRAME = 1 + MY._WALKFRAMES + MY._RUNFRAMES + 1;  // end at start frame
				}// END OLD STYLE ATTACK ANIMATION
				else // new animation format    (frc(MY._WALKFRAMES) == 0)
				{
					// reset entity's animation time to zero
					MY._ANIMDIST = 0;

					while(MY._ANIMDIST < 50)
					{
						wait(1);
 						// calculate a percentage out of the animation time
						MY._ANIMDIST += 8.0 * TIME;   // attack in ~1 second
						// set the frame from the percentage
	  					// -old- SET_FRAME	ME,robot_attack_str,MY._ANIMDIST;
						ent_frame(robot_attack_str,MY._ANIMDIST);
					}
				}// END NEW STYLE ATTACK ANIMATION
			} // END NOT ADVANCED

			// 2) fire shot
			damage = frc(MY._FIREMODE) * 100;
			fire_mode = MY._FIREMODE;
			if((fire_mode & MODE_DAMAGE) == DAMAGE_SHOOT)
			{
				shot_speed.X = 500;
			}
			else
			{
				shot_speed.X = 100;
			}
			shot_speed.Y = 0;
			shot_speed.Z = 0;
			MY_ANGLE.PAN = MY.PAN;	// TILT is already set from TO_ANGLE

			// Add in a random amount according to MY._I_ACCURACY
			if (MY._I_ACCURACY != 0)
			{
		 		MY_ANGLE.PAN  += random(MY._I_ACCURACY*2) - MY._I_ACCURACY;
		  		MY_ANGLE.TILT += random(MY._I_ACCURACY*2) - MY._I_ACCURACY;
			}

			vec_rotate(shot_speed,MY_ANGLE);
			// now shot_speed points ahead

			// check to see if the model is using a muzzle vertice
			if(MY._MUZZLE_VERT == 0)
			{
				// default gun muzzle
				vec_set(gun_muzzle.X,MY.X);
			}
			else
			{
				ent_vertex(gun_muzzle.X,MY._MUZZLE_VERT);
			}

			play_entsound(ME,gun_wham,150);
			gun_shot();

			// check for *ADVANCED ANIMATION* (frame names and entity tick/dist values)
			if(int(MY._WALKFRAMES) < 0)
			{
				// set entity's animation to halfway
				MY._ANIMDIST = 50;

				while(MY._ANIMDIST < 100)
				{
					// if you have more than one attacking animation, here's where you would test for it...
					// calculate a percentage out of the animation time
					MY._ANIMDIST +=  100 * (TIME / (INT(((-MY._ADVANIM_TICK)&MASK_ANIM_ATTACK_TICKS)>>10)));
					// set the frame from the percentage
					ent_frame(robot_attack_str,MY._ANIMDIST);
					wait(1);
				}
			}
			else
			{
				if(frc(MY._WALKFRAMES) == 0)
				{
					// play the second half of the animation
 					while(MY._ANIMDIST < 100)
					{
						wait(1);
 						// calculate a percentage out of the animation time
						MY._ANIMDIST += 8.0 * TIME;   // attack in ~1 second
						// set the frame from the percentage
	  					// -old- SET_FRAME	ME,robot_attack_str,MY._ANIMDIST;
						ent_frame(robot_attack_str,MY._ANIMDIST);
					}
				}// END NEW STYLE ATTACK ANIMATION
			}
		}// END if((RESULT > 0) && (YOU == player))
		else
		{
			MY._COUNTER = 0;
			return(-1);	// can not see player
		}
		waitt(2);	// space shots appart (so they don't hit each other!
		MY._COUNTER -= 1;
	}// END  while((MY._STATE == _STATE_ATTACK) && (MY._COUNTER > 0))
}

// Desc: approach the player with random deviation
//			do not approach any closer then 50 units
//
//	Note: only rotates by PANning
//
//	Calls: actor_turn()
//			 actor_move()
//
//]- Mod Date: 10/24/00 DCP
//]-			Increased range that robot stops approaching player to 100 units (from 50)
//]-
// Mod Date: 06/05/01 DCP
//			Replaced TO_ANGLE with vec_to_angle()
function attack_approach()
{
	// calculate a direction to walk into
	temp.X = player.X - MY.X;
	temp.Y = player.Y - MY.Y;
	temp.Z = 0;
//---	TO_ANGLE MY_ANGLE,temp;
	vec_to_angle(MY_ANGLE,temp);
	// ADD random deviation angle
	MY._TARGET_PAN = MY_ANGLE.PAN - 15 + RANDOM(30);

	while((MY._STATE == _STATE_ATTACK) && (MY._COUNTER > 0))
	{
	// turn towards player
		MY_ANGLE.PAN = MY._TARGET_PAN;
		MY_ANGLE.TILT = 0;
		MY_ANGLE.ROLL = 0;
		force = MY._FORCE * 2;
		actor_turn();

		// walk towards him if not too close
		temp = (player.X - MY.X)*(player.X - MY.X)+(player.Y - MY.Y)*(player.Y - MY.Y);
		if(temp > 10000)  // 100^2
		{
			force = MY._FORCE;
			MY._MOVEMODE = _MODE_WALKING;
			actor_move();
		}

		wait(1);
		MY._COUNTER -= TIME;
	}
}

// low on health => try to run away
function state_escape()
{
IFDEF WAR_CHAT_ON;
msg.STRING = war_escape_str;
show_message();
ENDIF;
	MY._STATE = _STATE_ESCAPE;
	while(MY._STATE == _STATE_ESCAPE)
	{
		if(MY._HEALTH <= 0)
		{
			EXCLUSIVE_ENTITY;
			wait(1);
			state_die();
			return;
		}

		// turn away from player
		temp.X = MY.X - player.X;
		temp.Y = MY.Y - player.Y;
		temp.Z = MY.Z - player.Z;
		vec_to_angle(MY_ANGLE,temp);
		force = MY._FORCE * 6;
		actor_turn();

		force = MY._FORCE * 4;
		MY._MOVEMODE = _MODE_WALKING;
		actor_move();

		wait(1);
	}
}


// Desc: Die:
//				-stop moving
//				-stop scanning and shooting
//				-null out my.event
//				-play death animation
//				-become passable
//
//]- Mod Date: 5/8/00 @ 752 by Doug Poston
//]-           Modified to use new animation system (SET_CYCLE/FRAME)
//]-
//]- Mod Date: 11/8/00 DCP
//]-          Replace set_frame with ent_frame
//]-
//]-
//]-	Mod Date: 08/22/01 DCP
//]-		Use advanced animation for death (twice attack ticks).
//
//
//	Notes: Uses entity's _AMIMDIST value as a 'percent death' value (0 start, 100 end)
function state_die()
{
IFDEF WAR_CHAT_ON;
msg.STRING = war_dead_str;
show_message();
ENDIF;
	MY._MOVEMODE = 0;		// don't move anymore
	MY._STATE = _STATE_DIE;
	MY.ENABLE_SCAN = OFF;		// get deaf and blind
	MY.ENABLE_SHOOT = OFF;
	MY.EVENT = NULL;			// and don't react anymore

	// check if we have a marker...
	if(MY.ENTITY1 != 0)
	{
		// if so, remove it.
		ent_remove(MY.ENTITY1);
	}

	// check for *ADVANCED ANIMATION* (frame names and entity tick/dist values)
	if(int(MY._WALKFRAMES) < 0)
	{
		// reset entity's animation time to zero
		MY._ANIMDIST = 0;

		while(MY._ANIMDIST < 100)
		{
			// if you have more than one attacking animation, here's where you would test for it...
			// calculate a percentage out of the animation time
			MY._ANIMDIST +=  100*(TIME / (INT(((-MY._ADVANIM_TICK)&MASK_ANIM_ATTACK_TICKS)>>9))); // (x>>10) * 2
			// set the frame from the percentage
			ent_frame(anim_death_str,MY._ANIMDIST);
			wait(1);
		}
	}
	else
	{
		// decide whether it's a frame number (old) or frame name (new) animation
		if(frc(MY._WALKFRAMES) > 0)// OLD STYLE ATTACK ANIMATION
		{
 			MY.FRAME = 1 + MY._WALKFRAMES + MY._RUNFRAMES + MY._ATTACKFRAMES + 1;
			MY.NEXT_FRAME = 0;	// inbetween to the real next frame
			while(MY.FRAME <= (1 + MY._WALKFRAMES + MY._RUNFRAMES + MY._ATTACKFRAMES + MY._DIEFRAMES))
			{
				wait(1);
				MY.FRAME += 0.7 * TIME;
			}
		}// END OLD STYLE Death ANIMATION
		else // new animation format    (frc(MY._WALKFRAMES) == 0)
		{
			// reset entity's animation time to zero
			MY._ANIMDIST = 0;

			while(MY._ANIMDIST < 100)
			{
				wait(1);
				// calculate a percentage out of the animation time
				MY._ANIMDIST += 5.0 * TIME;   // death in ~1.25 seconds
				// set the frame from the percentage
				// -old- SET_FRAME	ME,anim_death_str,MY._ANIMDIST;
				ent_frame(anim_death_str,MY._ANIMDIST);
			}
		}// END NEW STYLE ATTACK ANIMATION
	} // END NOT ADVANCED


	// If entity explodes after death
	if((ME != player) && ((MY._HITMODE & MODE_HIT) == HIT_EXPLO))//(MY._HITMODE & HIT_EXPLO))
	{

		morph(ACTOR_EXPLO,ME);
	  	MY._DIEFRAMES = ACTOR_EXPLO_FRAMES;
	  	actor_explode();       // ends with the removal of this entity
		return;
	}

  	// If entity 'gibs' after death
	if((ME != player) && ((MY._HITMODE & MODE_HIT) == HIT_GIB))//(MY._HITMODE & HIT_GIB))
	{
	  	_gib(25);             		// use new "gib" function
	  	actor_explode();     // ends with the removal of this entity
		return;
	}
	MY.PASSABLE = ON;   // body remains
}




// Desc: used to "tag" the last know target location
//       "CREATE <arrow.pcx>, MY.POS, _last_know_target_loc;"
function _last_know_target_loc()
{
	YOUR.ENTITY1 = ME;
	MY.INVISIBLE = ON;
	MY.PASSABLE = ON;
}

// Desc: move to the entity1 location
function hunt_approach()
{
	ent_marker = MY.ENTITY1;
	// calculate a direction to walk into
	temp.X = ent_marker.X - MY.X;
	temp.Y = ent_marker.Y - MY.Y;
	temp.Z = ent_marker.Z - MY.Z;
	vec_to_angle(MY_ANGLE,temp);
	MY._TARGET_PAN = MY_ANGLE.PAN;

   // turn towards target
	MY_ANGLE.PAN = MY._TARGET_PAN;
	MY_ANGLE.TILT = 0;
	MY_ANGLE.ROLL = 0;
	force = MY._FORCE * 2;
	actor_turn();
	if(avoid_walls() == 1)		// avoid hitting walls
	{
		force = MY._FORCE * 4;
		actor_turn();
	}


	temp = (ent_marker.X - MY.X)*(ent_marker.X - MY.X)+(ent_marker.Y - MY.Y)*(ent_marker.Y - MY.Y);
	// walk towards target only if not too close
	if(temp < 100) // 10^2
	{
		ent_remove(MY.ENTITY1);	// remove marker
		EXCLUSIVE_ENTITY;
		wait(1);
		state_wait();	// branch to wait mode
		return;
	}

	// walk towards ent_marker
	force = MY._FORCE;
	MY._MOVEMODE = _MODE_WALKING;
	actor_move();

}


// Desc: avoid hitting walls
//
// Return: 1 if to close to a wall, o otherwise
function avoid_walls()
{
	// shoot a line between the entity and the target point
	SHOOT MY.POS, ent_marker.POS;

	IF((YOU != ent_marker) && (RESULT < 50))	// too close to a wall...
	{
		// angle away from the wall.
		temp.X = (TARGET.X + (100 * NORMAL.X)) - MY.X;
		temp.Y = (TARGET.Y + (100 * NORMAL.Y)) - MY.Y;
		temp.Z = MY.Z;
		vec_to_angle(MY_ANGLE,temp);
		RETURN(1);
 	}
	RETURN(0);
}


// Desc: follow a wall until you reach a corner
//
// NOTE: to-do (pathfind.wdl?)
function follow_wall()
{
	RETURN(0);
}

// Desc: Use internal and external values to branch to other states
//
//]- Mod Date: 7/8/00 DCP
//]-				Added EXCLUSIVE_ENTITY before every BRANCH
// Mod Date: 7/26/01 MWS
//				Escape branch tests for MY._I_COWARDICE instead of constant 30
function hunt_transitions()
{
	while(MY._STATE == _STATE_HUNT)
	{
		// Check heath
		IF(MY._HEALTH <= 0)     // goto die state
		{
			EXCLUSIVE_ENTITY;
			wait(1);
			state_die();
			return;
		}

		if(MY._HEALTH <= MY._I_COWARDICE  &&  MY._I_COWARDICE >= 0)     // low health? Escape
		{
			EXCLUSIVE_ENTITY;
			wait(1);
			state_escape();
			return;
		}

  		// scan for the player coming near
		temp.PAN = 180;
		temp.TILT = 180;
		temp.Z = MY._I_ALERTNESS;
		indicator = _WATCH;
		SCAN	MY.POS,MY.ANGLE,temp;

		// if the player has been detected...
		if(MY._SIGNAL == _DETECTED)
		{
			MY._SIGNAL = 0;
			ent_remove(MY.ENTITY1);
			EXCLUSIVE_ENTITY;
			wait(1);
			state_attack();	// ATTACK!
			return;
		}

		// Check debug
		IF(freeze_actors > 0)  // goto freeze state
		{
			EXCLUSIVE_ENTITY;
			wait(1);
			state_freeze();
			return;
		}

		waitt(1);
	}
}

// Desc: if you lose your target, move towards its last know location while
//		  scanning.
function	state_hunt()
{
	MY._STATE = _STATE_HUNT;
IFDEF WAR_CHAT_ON;
msg.STRING = war_hunt_str;
show_message();
ENDIF;
	// create a "marker" at the last known player location
	create(<arrow.pcx>, PLAYER.POS, _last_know_target_loc);
	MY._MOVEMODE = _MODE_WALKING;	// stop patrolling etc.
	hunt_transitions();      // branch to other states depending on values

	while(MY._STATE == _STATE_HUNT)
	{
		// approach the marker
		hunt_approach();

		wait(1);
	}
}


// Desc: freeze in place
function state_freeze()
{
	MY._STATE = _STATE_FREEZE;
	MY._MOVEMODE = _MODE_STILL;	// stop patrolling etc.
	while(MY._STATE == _STATE_FREEZE)
	{
		if(freeze_actors > 1)
		{
			MY.PASSABLE = ON;
		}

		if(freeze_actors == 0)
		{
			state_wait();
			return;
		}

		wait(1);
	}
}

////////////////////////////////////////////////////////////////////////

// Desc: take damage and detect player
//
// Mod: 02/06/01 DCP
//		Added wait before shoot command to remove 'Dangerous instruction error'
//	   Replaced SHOOT with trace()
//
// Mod: 05/05/01 DCP
//		Modified damage from ranged explosion (replaced ABS with MAX)
// Mod Date: 05/16/02 DCP
//		Use temp in blast damage calculation to remove problem when multiple entities are hit
// Mod Date: 06/11/02 DCP
//		Added wait before trace command
function fight_event()
{
	if((EVENT_TYPE == EVENT_SCAN && indicator == _EXPLODE)
		|| (EVENT_TYPE == EVENT_SHOOT && indicator == _GUNFIRE))
	{
		MY._SIGNAL = _DETECTED;	// by shooting, player gives away his position

		if (indicator == _EXPLODE)
		{
			var	vec_temp[3];
			var	local_damage;

			vec_set(vec_temp.x,your.x);	// store source values
			// reduce damage according to distance
			// note: result is set by scan_entity to the correct distance
			local_damage = damage * max(0,(range - RESULT))/range;			// store damage

  			wait(1);	// wait a frame before doing a trace (avoid "dangerous instruction in event")
			temp = local_damage;

			// trace back to the source to see if we are protected
 			trace_mode = ignore_me + ignore_passable + ignore_passents;
 			if(trace(my.x,vec_temp.x) != 0) { return; }
		}
		else
		{
			temp = damage;
		}

		if(MY._ARMOR <= 0)
		{
			MY._HEALTH -= temp;
		}
		else
		{
			MY._ARMOR -= temp;
		}
		return;
	}

	if(EVENT_TYPE == EVENT_DETECT && YOU == player)
	{
		wait(1);	//fix for dangerous instruction
		indicator = _WATCH;
//---		SHOOT MY.POS,YOUR.POS;	// can player be seen from here?
		trace_mode = IGNORE_ME + IGNORE_PASSABLE + ACTIVATE_SHOOT;
		RESULT = trace(MY.POS,YOUR.POS); // if entity YOU was visible from MY position, its SHOOT event was triggered
		if((RESULT > 0) && (YOU == player)) // yes
		{
			MY._SIGNAL = _DETECTED;
		}
		return;
	}
}

// Desc: init actor for fighting and branch to the wait state
function actor_fight()
{
//	if(MY._ARMOR == 0) { MY._ARMOR = 100; }
	if(MY._HEALTH == 0) { MY._HEALTH = 100; }	// default health
	if(MY._FORCE == 0) { MY._FORCE = 1; }       // default force

	// Allow player to pass thru actor if frozen
	if(freeze_actors > 1) { MY.PASSABLE = ON; }

	MY._SIGNAL = 0;
	MY.ENABLE_SCAN = ON;
	MY.ENABLE_SHOOT = ON;
	MY.ENABLE_DETECT = ON;
	MY.EVENT = fight_event;

	state_wait();
}


// PLAYER ACTIONS
///////////////////////////////////////////////////////////////////////

//		player_walk_fight - player walk and fight action (basic FPS)

// temp flags only used in player_walk_fight action.
DEFINE	__NO_FALLDAMAGE, FLAG1;
DEFINE	__NO_JUMP,FLAG4;
DEFINE	__NO_BOB,FLAG5;
DEFINE	__NO_STRAFE,FLAG6;
DEFINE	__NO_TRIGGER,FLAG7;
DEFINE	__NO_DUCK,FLAG8;

/////////////////////////////////////////////////////////////////////////
// Desc: player action. Walk and fight (take damage, use gun)
//
//	Used for basic FPS type games.  Set the following skills and flags in
//WED to define the player (note: all skills default to 0, all flags
//default to OFF)
//
//	Flags
//		Flag1 - ON = *NO damage from falls*
//				 OFF = Take damage from falls
//		Flag2 - ON = move as a car (i.e. no turning unless moving),
//				 OFF = move normally
//		Flag3 - ON = adapt tilt and roll angle to slops
//				 OFF = stay upright while walking up and down slops (normal)
//		Flag4 - ON = *NO JUMPING*
//				 OFF = Allow jumping
//		Flag5 - ON = *NO first person view "head-bob" while moving*
//				 OFF = Enable first person view "head-bob"
//		Flag6 - ON = *Disable strafe*
//				 OFF = Allow strafing
//		Flag7 - ON = *Disable trigger* (open doors automatically)
//				 OFF = Trigger on
//		Flag8 - ON = *NO DUCKING*
//				 OFF = Enable ducking
//	Skills
//	_WALKSWIM_DIST, SKILL1;   	// Walk Distance . Swim Distance
//	_RUNCRAWL_DIST, SKILL2;   	// Run Distance . Crawl Distance
//	_STANDJUMP_TIME, SKILL3;  	// Stand Time . Jump Time
//	_ATTACKDUCK_TIME, SKILL4; 	// Attack Time . Duck Time
//	_RUNTHRESHOLD, SKILL14;		// Run Threshold
//	_FORCE, SKILL5;				// Force
//	_BANKING, SKILL6;				// Hitmode (actor only)
//	_MOVEMODE, SKILL7;			// Starting movemode
//	_HEALTH, SKILL9;	 			// Heath
//	_ARMOR, SKILL10;				// Armor
//
//]- Mod: 6/18/01 DCP
//]-		Created
//]-
//]- Mod: 8/21/01 DCP
//]-		Updated to use new WED skills
//
// Mod: 04/30/02 DCP
//		now calls player_move2 (improved movement and animation)
//
// uses _WALKSWIM_DIST,_RUNCRAWL_DIST,_STANDJUMP_TIME,_ATTACKDUCK_TIME
//	uses _FORCE,_BANKING,_MOVEMODE,_FIREMODE,_HEALTH,_ARMOR,_RUNTHRESHOLD
// uses __NO_FALLDAMAGE, __WHEELS, __SLOPES, __NO_JUMP, __NO_BOB, __NO_STRAFE
// uses __NO_TRIGGER, __NO_DUCK
ACTION player_walk_fight
{
// player
	// Flags-------------------------------
	IF(MY.__NO_FALLDAMAGE == ON) { MY.__FALL = OFF; }
	ELSE { MY.__FALL = ON; }
	//MY.__WHEELS = MY.FLAG2; // note: redundant
	//MY.__SLOPES = MY.FLAG3; // note: redundant
	IF(MY.__NO_JUMP == ON) { MY.__JUMP = OFF; }
	ELSE { MY.__JUMP = ON; }
	IF(MY.__NO_BOB == ON) { MY.__BOB = OFF; }
	ELSE { MY.__BOB = ON; }
	IF(MY.__NO_STRAFE == ON) { MY.__STRAFE = OFF; }
	ELSE { MY.__STRAFE = ON; }
	IF(MY.__NO_TRIGGER == ON) { MY.__TRIGGER = OFF; }
	ELSE { MY.__TRIGGER = ON; }
	IF(MY.__NO_DUCK == ON) { MY.__DUCK = OFF; }
	ELSE { MY.__DUCK = ON; }

	// Skill1------------------------------
	if (MY._HEALTH == 0) {			// if user didn't enter a value
		MY._HEALTH = 100;				// use default
	}

	if (MY._ARMOR < 0) {				// if bad value specified somehow
		MY._ARMOR = 0;					// default to zero
	}

	if( MY._FORCE <= 0)
	{
		MY._FORCE = 0.75;				// use default
	}


	player_anim_pack();           // use SKILLs 1-4 to set up animation

 	// Other-------------------------------
	MY.NARROW = ON;	// use narrow hull!
	MY.FAT = OFF;
 	MY.TRIGGER_RANGE = 5;
	if( MY._MOVEMODE <= 0)
	{
		MY._MOVEMODE = _MODE_WALKING;
	}

	if( MY._BANKING == 0)
	{
		MY._BANKING = -0.1;
	}

// NOTE: comment player_move2() and uncomment player_move() to return
//to older method of player movement/animation
//	player_move();    // basic player move loop
  	player_move2();    // advanced player move loop
	player_fight();   // basic player fight loop
	drop_shadow();		// add a drop shadow (if the player has no 'real' shadow)
	show_panels();    // show heath/armor/ammo panel
}



// Desc - An entity action that will make a generic AI player with skill
//			 settings that can be set as above in WED
////////////////////////////////////////////////////////////
// These skills can be set in WED for the intended effect //
////////////////////////////////////////////////////////////
//	_WALKSWIM_DIST, SKILL1;   	// Walk Distance . Swim Distance
//	_RUNCRAWL_DIST, SKILL2;   	// Run Distance . Crawl Distance
//	_STANDJUMP_TIME, SKILL3;  	// Stand Time . Jump Time
//	_ATTACKDUCK_TIME, SKILL4; 	// Attack Time . Duck Time
//	_RUNTHRESHOLD, SKILL14;		// Run Threshold
//	_FORCE, SKILL5;				// Force
//	_HITMODE, SKILL6;				// Hitmode (actor only)
//	_MOVEMODE, SKILL7;			// Starting movemode
//	_FIREMODE, SKILL8; 			// Firemode
//	_HEALTH, SKILL9;	 			// Heath
//	_ARMOR, SKILL10;				// Armor
//	_ALERTNESS, SKILL11; 	   // Alertness
//	_ACCURACY, SKILL12; 			// Accuracy
//	_COWARDICE, SKILL13;	 		// Cowardice
//	_MUZZLEATTACH, SKILL15;		// Muzzle vertex . Attach vertex
////////////////////////////////////////////////////////////
// 07/16/01 - MWS - Created
// 07/24/01 - MWS - Overhauled (16 WED skills now!)
//
// Mod: 8/21/01 DCP
//		Updated to use new WED skills
//
// uses _WALKSWIM_DIST,_RUNCRAWL_DIST,_STANDJUMP_TIME,_ATTACKDUCK_TIME
// uses _FORCE,_HITMODE,_MOVEMODE,_FIREMODE,_HEALTH,_ARMOR,_ALERTNESS
// uses _ACCURACY,_COWARDICE,_RUNTHRESHOLD,_MUZZLEATTACH
action actor_walk_fight
{
	// Health-
	if (MY._HEALTH <= 0) { MY._HEALTH = 50; }	// default 50 health

	// Armor-
	if (MY._ARMOR <= 0) { MY._ARMOR = 0; }	// default 0 armor

 	// Force-
	if (MY._FORCE == 0) { MY._FORCE = 1.5; } 	// default force

 	// Alertness-
	MY._I_ALERTNESS = MY._ALERTNESS;

	// Cowardice-
	MY._I_COWARDICE = MY._COWARDICE;

	// Firemode-
	if (MY._FIREMODE == 0)
	{ MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH+0.10; }	// use default

	// Accuracy-
	if (MY._ACCURACY > 0)
	{
		MY._I_ACCURACY = MY._ACCURACY; // positive value given, use specified accuracy
	}
	else
	{
		if (MY._ACCURACY < 0)
		{ MY._I_ACCURACY = 0; }	// negative value given, use perfect accuracy
		else // MY._ACCURACY == 0
		{ MY._I_ACCURACY = 5; }	// no value given, use default accuracy
	}



	// Hitmode-
	//--MY._HITMODE = MY._HITMODE;	// zero is the default, no extra checking needed


	// Muzzle Vertex-
	MY._MUZZLE_VERT = int(MY._MUZZLEATTACH);



	// uses same advanced animation packing as player (dont let the function name fool you)
	player_anim_pack();

	// Other setup
	MY._WALKSOUND = _SOUND_ROBOT;
	anim_init();	// setup animation a bit
	drop_shadow(); // attach shadow to robot
	actor_fight();	// start simple AI state machine
}


// ==========================================================================


// Desc: attach a bounding cube to the model (for testing purposes)
//		The cube will be the color of the current state
// TODO: need to line it up better with 'you' entity
function _actor_ai_testbox()
{
	my.transparent = on;
	my.alpha = 35;
	my.scale_x = (your.max_x - your.min_x) /32;
	my.scale_y = (your.max_y - your.min_y) /32;
	my.scale_z = (your.max_z - your.min_z) /32;
	my.passable = on;
	my.pan = 0; my.tilt = 0; my.roll = 0; // axis aligned
	while(YOU != NULL)
	{
		my.skin = your._STATE;	// change box color to entities state
		vec_set(my.x,you.x);
		wait(1);

	}
	ent_remove(me);
}

// Desc: action for visible ai trace
function	_actor_ai_testTrace_action()
{
	MY.FACING = OFF;
	MY.ORIENTED = ON;
	MY.PASSABLE = ON;
   MY.LIGHT = ON;       // illuminate myself
	MY.LIGHTBLUE = 255;   // blue laser
	MY.TRANSPARENT = ON;
	MY.ALPHA = 75;
	MY.BLEND = ON;
	MY.FLARE = ON;

	waitt(4);
	ent_remove(me);
}

// Desc show a visible line from my.x to you.x
function	_actor_ai_testTrace()
{
	var	temp_vec[3];
	var	temp_ang[3];
	var	length;

 	// create vector
	vec_diff(temp_vec,you.x,my.x);// calc vector
	vec_to_angle(temp_ang.pan,temp_vec);	// calc angle
	length = vec_length(temp_vec);
	vec_scale(temp_vec, 0.5); 	// find halfway
	vec_add(temp_vec,my.x);		// add to origin

	test_actor = ent_create("linebit.bmp", temp_vec.x, _actor_ai_testTrace_action);
	test_actor.SCALE_X = length/128.0;
	test_actor.SCALE_Z = 0.25;
	vec_to_angle(test_actor.pan,temp_ang);
	test_actor.pan += 90;

	test_actor = ent_create("linebit.bmp", temp_vec.x, _actor_ai_testTrace_action);
	test_actor.SCALE_X = length/128.0;
	test_actor.SCALE_Z = 0.25;
	vec_to_angle(test_actor.pan,temp_ang);
	test_actor.pan += 90;
	test_actor.tilt += 90;

}


// desc used to handle a simple "type one" actor AI
/* help This actor AI does the following:

	_WALKSWIM_DIST, SKILL1;   	// Walk Distance . Swim Distance
	_RUNCRAWL_DIST, SKILL2;   	// Run Distance . Crawl Distance
	_STANDJUMP_TIME, SKILL3;  	// Stand Time . Jump Time
	_ATTACKDUCK_TIME, SKILL4; 	// Attack Time . Duck Time
	_RUNTHRESHOLD, SKILL14;		// Run Threshold
	_FORCE, SKILL5;				// Force (1.5)
	_HITMODE, SKILL6;				// Hitmode (actor only)
	_FIREMODE, SKILL8; 			// Firemode . Damage (DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH+0.10)
	_HEALTH, SKILL9;	 			// Heath (75)
	_ARMOR, SKILL10;				// Armor (0)
	_ALERTNESS, SKILL11; 	   // Alertness.AlertCone (1000.180)
	_ACCURACY, SKILL12; 			// Accuracy  (5)
	_COWARDICE, SKILL13;	 		// Cowardice (30)
	_MUZZLEATTACH, SKILL15;		// Muzzle vertex . Attach vertex
	_WEAPONRANGE, SKILL16		// range of the weapon (1500) . time to reload (.32)

 NOTES:
		Use the flag "-d showaiboxes" to display AI bounding boxes around
	this entity.
*/
//
// uses _WALKSWIM_DIST,_RUNCRAWL_DIST,_STANDJUMP_TIME,_ATTACKDUCK_TIME
// uses _FORCE,_HITMODE,_MOVEMODE,_FIREMODE,_HEALTH,_ARMOR,_ALERTNESS
// uses _ACCURACY,_COWARDICE,_RUNTHRESHOLD,_MUZZLEATTACH,_WEAPONRANGE
ACTION	actor_ai_one
{
	// set up and call helper functions
	// Health-
	if (MY._HEALTH <= 0) { MY._HEALTH = 75; }	// default 75 health

	// Armor-
	if (MY._ARMOR <= 0) { MY._ARMOR = 0; }	// default 0 armor

 	// Force-
	if (MY._FORCE == 0) { MY._FORCE = 1.5; } 	// default force

 	// Alertness-
	temp = int(MY._ALERTNESS);
	if(temp == 0) { MY._I_ALERTNESS = 1000; }	// default alertness range
	else { MY._I_ALERTNESS = int(MY._ALERTNESS); }
	temp = frc(MY._ALERTNESS) * 1000;
	if(temp == 0) { MY._I_ALERTNESS += 0.180; }	// deault alertness cone
	else { MY._I_ALERTNESS += frc(MY._ALERTNESS); }


	// Cowardice-
	if(MY._COWARDICE == 0) { MY._I_COWARDICE = 30; }	// default of 30
	else { MY._I_COWARDICE = MY._COWARDICE; }

	// Firemode-
	if (MY._FIREMODE == 0)
	{ MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH+0.10; }	// use default

	// Accuracy-
	if (MY._ACCURACY > 0)
	{
		MY._I_ACCURACY = MY._ACCURACY; // positive value given, use specified accuracy
	}
	else
	{
		if (MY._ACCURACY < 0)
		{ MY._I_ACCURACY = 0; }	// negative value given, use perfect accuracy
		else // MY._ACCURACY == 0
		{ MY._I_ACCURACY = 5; }	// no value given, use default accuracy
	}



	// Hitmode-
	//--MY._HITMODE = MY._HITMODE;	// zero is the default, no extra checking needed

	// Muzzle Vertex-
	MY._MUZZLE_VERT = int(MY._MUZZLEATTACH);


	if((int(MY._WEAPONRANGE)) <= 0) { MY._WEAPONRANGE = 1500; } // default to 1500 quants for weapon range
	if((frc(MY._WEAPONRANGE)) == 0) { MY._WEAPONRANGE += 0.32; } // default to 32ticks for reload speed

	// uses same advanced animation packing as player (dont let the 'player' prefix fool you)
	player_anim_pack();

	// Other setup
	MY._WALKSOUND = _SOUND_ROBOT;

	anim_init();	// setup animation a bit
	drop_shadow(); // attach shadow to robot
	MY._MOVEMODE = _MODE_WALKING; // standing/walking/running
	actor_adv_anim2();	// use new animation style (with blending)

// create a test box that shows AI's state
IFDEF SHOWAIBOXES;
	ent_create("cube.mdl",my.x,_actor_ai_testbox);
ENDIF;

	actor_ai_loop_one();	// call AI loop

}


// Desc: explosion caused by actor
function _actor_ai_explode()
{
	MY.TRANSPARENT = ON;
	MY.ALPHA = 45;
	MY.PASSABLE = ON;	// don't push the player through walls

	ent_playsound(ME,explo_wham,2500);
	MY.LIGHTRED = 255;
	MY.LIGHTGREEN = 128;
	MY.LIGHTBLUE = 128;
	MY.AMBIENT = 100;
	MY.LIGHTRANGE = 50;

	// use the new sprite animation
	while(MY.SCALE_X < 7.5)
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
	ent_remove(ME);
}

// Desc: type one actor death
function _actor_ai_death_one()
{
	// If entity explodes after death
	if((MY._HITMODE & MODE_HIT) == HIT_EXPLO)
	{
		ent_create(actor_explosion_mdl,my.x,_actor_ai_explode);
	}

  	// If entity 'gibs' after death
	if((MY._HITMODE & MODE_HIT) == HIT_GIB)//(MY._HITMODE & HIT_GIB))
	{
	  	_gib(25);             	 // use new "gib" function
		ent_create(actor_explosion_mdl,my.x,_actor_ai_explode);
	}

 	ent_remove(me); // in case one of the other functions hasn't removed the actor
}


// Desc: can we see the player from our position?
//
// uses: temp
//
// returns: 0 - no
//				1 - yes
//				negitive value on error
function _actor_ai_player_trace()
{

	if(player == null) { return(-1); }   // no player
	you = player; // so "ignore_you" will work

ifdef showaitrace;
	_actor_ai_testTrace();	// show the trace
endif;
	trace_mode = ignore_me + ignore_you + ignore_passable;  // + ignore_entities; ++ add this in to see around other actors, rockets, props
	temp = trace(my.x,you.x);
	if(temp == 0) { return(1); }
	return(0);

}

DEFINE	kActorAIAvoidDist, 150;    // value used in distance traces
// desc: scan ahead and try to avoid any wall or obstacle you encounter
//
//
// note: KISS, combines slowing and 'side stepping' to do simple avoidence
//
// help: this function makes some big assumptions:
//			1) force.y = force.z = 0  (only force.x has a value)
//       2) side stepping will allow the actor to avoid the obstacle
function _actor_ai_avoid_obs()
{
	// trace ahead for obstacles
	vec_set(temp.x,nullvector);
	temp.x = kActorAIAvoidDist;
	vec_rotate(temp.x,my.pan);	// vector pointing ahead of the actor
	vec_add(temp.x,my.x);      // offset by the actor

	trace_mode = ignore_me + ignore_passable + use_box;
	temp2 = trace(my.x,temp.x);
	if(temp2 == 0) { return; }  // nothing in the way, no change needed

	// if the obstical is an entity
	if(you != null)
	{
	  	// scale walk around
		temp = (kActorAIAvoidDist - temp2)/kActorAIAvoidDist;	// 0-1
		force.y = -force.x * temp; // use forward (max) force
		force.x += force.y;
 		return;
	}
	// else the obstical is a map object
	// check normal
	// if "ramp" return (the actor will walk up on it)
	if(normal.z > 0.7) { return; }

	temp = (kActorAIAvoidDist - temp2)/kActorAIAvoidDist; // 0 - 1
	// else it is a wall
	// calculate actor's sidestep force to avoid contact
	vec_to_angle(temp2.pan,normal.x);	// global angle to player  (assume results are between -180 & 180)
	temp2.pan = ang(ang(temp2.pan) - ang(my.pan));	 // angle to turn to line up with normal
	if(temp2.pan > 0)
	{
		force.y = force.x * temp; // use forward (max) force
		force.x -= force.y;
	}
	else
	{
		force.y = -force.x * temp; // use forward (max) force
		force.x += force.y;
	}
}




// Desc: handle movement and gravity for AI
//
// uses: force.x for movement (set before calling)
//
// modifies: my._WALKDIST is given the distace the actor has moved
function _actor_ai_move_gravity()
{
	// check signal from actor_adv_anim2() to see if we have finished a previous state...
	if(my._ANIMDIST == -99)
	{
		if(MY._MOVEMODE == _MODE_JUMPING)
		{
			// exit from jumping state
			my._ANIMDIST = 0;	// signal that we have recieved the flag
			MY._MOVEMODE = _MODE_WALKING;
		}
	}// end check singal returned from actor_adv_anim2()

	scan_floor();
	move_gravity();   // uses force.x/y/z to move

 	// save movment amount for animation
	if(force.X < 0)
	{
		// moving backwards
		my._WALKDIST = -my_dist;	// my_dist is set in move_gravity, wade_gravity, or swim_gravity
	}
	else
	{
		// moving forward, sideways, or standing still
		my._WALKDIST = my_dist;		// my_dist is set in move_gravity, wade_gravity, or swim_gravity
	}
}

// Desc: handle the hunting movement for type on AI actors
//
// sets: force.x/y/z
function _actor_ai_move_hunt_one()
{
	// continue of the vector you are on
	force.x = MY._FORCE;
	force.y = 0;
	force.z = 0;
}

// Desc: handle the escape movement for type on AI actors
//
// sets: force.x/y/z
function _actor_ai_move_escape_one()
{
	// turn away from player
	temp.X = MY.X - player.X;
	temp.Y = MY.Y - player.Y;
	temp.Z = 0;
	vec_to_angle(MY_ANGLE,temp);
	force = MY._FORCE * 4;
	actor_turn();

	force.x = 2 * MY._FORCE;
	force.y = 0;
	force.z = 0;
}

// Desc: the attack handler for type one AI actors
function _actor_ai_move_attack_one()
{
// MOVEMENT
	// turn to player
	temp.X = player.X - MY.X;
	temp.Y = player.Y - MY.Y;
	temp.Z = 0;
	vec_to_angle(MY_ANGLE,temp);
	force = MY._FORCE * 2;
	actor_turn();

	force.x = MY._FORCE;
	force.y = 0;
	force.z = 0;
}



// Desc: try to shoot at player
function _actor_ai_shoot_one(firing_mode,firing_range)
{
	// calculate the gun muzzle
	if(my._MUZZLE_VERT > 0)       // if we are using a muzzle vertex
	{
		// attach to gun point
		vec_for_vertex(gun_muzzle,my,my._muzzle_vert);
	}
	else
	{
		// else use the actor origin
		vec_set(gun_muzzle,my.x);
	}

	// calculate vector to player
 	vec_diff(temp,player.x,gun_muzzle.x);

	// make sure player is withing a 90o firing cone
	vec_to_angle(temp2.pan,temp.x);	// global angle to player  (assume results are between -180 & 180)
	temp2.pan = temp2.pan - ang(my.pan);	 // relitive angle to player
	temp2.tilt = temp2.tilt - ang(my.tilt);
	temp2.pan = ang(temp2.pan);
	temp2.tilt = ang(my.tilt);
	if((abs(temp2.pan) > 45) || (abs(temp2.tilt) > 45)) { return; }

	// scale vector by range
	vec_normalize(temp,firing_range);

	// offset vertor with accuracy modifier
	temp2.pan =  (random(my._I_ACCURACY) - (0.5*(my._I_ACCURACY)));
	temp2.tilt = (random(my._I_ACCURACY) - (0.5*(my._I_ACCURACY)))/4;
	temp2.roll = 0;
 	vec_rotate(temp,temp2);

	//gun_muzzle,shot_speed,damage,fire_mode
  	vec_set(shot_speed,temp);
  	vec_set(gun_target,gun_muzzle.x);
	vec_add(gun_target,temp);  // gun target = gun_muzzle + shot_speed
	fire_mode = firing_mode;
	damage = frc(firing_mode) * 100;


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
	{
		// note: fireballs never stop moving until they hit something
		vec_scale(shot_speed,0.0625); // 1/16th the total distace
		create(fireball,gun_muzzle,bullet_shot);
	}

	// rocket model
	if((fire_mode & MODE_FIRE) == FIRE_ROCKET)
	{
		vec_scale(shot_speed,0.04); // 1/25
  		create(<rocket.mdl>,gun_muzzle,rocket_launch);
	}

	// eject brass?
	if((fire_mode & GUNFX_BRASS) != 0)
	{
	 	emit(1,gun_muzzle,particle_gunBrass); // emit brass
	}

	if((fire_mode & MODE_DAMAGE) == DAMAGE_SHOOT)
	{
		_gun_shot_damage_shoot();	// handle 'shot' weapons
	}
}


// Desc: event handler for type one AI actors
//
// NOTE: TEST explosion (is 'RESULT' always valid?)
//
// Mod Date: 05/16/02 DCP
//		Use temp in blast damage calculation to remove problem when multiple entities are hit
//
// Mod Date: 06/11/02 DCP
//		Added wait before trace command
function actor_ai_handler_one()
{

	// damage events
	if((EVENT_TYPE == EVENT_SCAN && indicator == _EXPLODE)      // caught in an explosion
		|| (EVENT_TYPE == EVENT_SHOOT && indicator == _GUNFIRE)) // if shot with weapon
	{
		MY._STATE = _STATE_ATTACK;  // actor is aware there is a player out there (may not know his location)
		// take damage
		if (indicator == _EXPLODE)
		{

			var	vec_temp[3];
			var	local_damage;

			vec_set(vec_temp.x,your.x);	// store source values
			// reduce damage according to distance
			// note: result is set by scan_entity to the correct distance
			local_damage = damage * max(0,(range - RESULT))/range;			// store damage

  			wait(1);	// wait a frame before doing a trace (avoid "dangerous instruction in event")

			// trace back to the source to see if we are protected
 			trace_mode = ignore_me + ignore_passable + ignore_passents;
 			if(trace(my.x,vec_temp.x) != 0) { return; }
			temp = local_damage;	// use the damage calculated last frame
		}
		else
		{
			temp = damage; // direct damage
		}

		if(MY._ARMOR <= 0)
		{
  			// take damage from armor first
			MY._HEALTH -= temp;
		}
		else
		{
			// damage from flesh
			MY._ARMOR -= temp;
		}
		return;
	}

	// handle further events here

}
/*
DEFINE _STATE_WAIT,1;
DEFINE _STATE_ATTACK,2;
DEFINE _STATE_ESCAPE,3;
DEFINE _STATE_DIE,4;
DEFINE _STATE_FREEZE,5;       // 05/15/01 DCP: Changed from 4->5
DEFINE _STATE_HUNT,6;
*/
// desc Main loop for type one AI actors
/* help The following values must be set for this function to be used
	....
*/
function actor_ai_loop_one()
{
	var	my_firemode;   		// the weapon information for this AI
	var	my_firerange;			// the range of the weapon
	var	my_awareness_count;	// counter, how long the AI will be alert to the player
	var	my_reload_count;		// counter, reload time for weapon
	var	my_reload_time;		// time it takes for weapon to reload

	var	my_awareness_angle;	// cone we will spot players in


	my_firemode = MY._FIREMODE;
	my_firerange = int(MY._WEAPONRANGE);
	my_reload_time = (frc(MY._WEAPONRANGE)) * 100;
	MY._FIREMODE = 0;         // used in actor_adv_anim2 to show the actor firing

	my_awareness_count = 0;	// not aware of the player
	my_reload_count = 0;		// gun loaded
	my_awareness_angle = abs((frc(MY._I_ALERTNESS) * 1000)/2);
	if(my_awareness_angle > 180) { my_awareness_angle = 180; }

	MY._STATE = _STATE_WAIT;	// start in waiting state

	MY.ENABLE_SCAN  = ON;	// explosions
	MY.ENABLE_SHOOT = ON;	// gun shots
	MY.EVENT = actor_ai_handler_one; // event handler for type one actor

	while(player != null)        // needs a player entity to attack
	{
		// check for 'freeze state'
		if(MY._STATE == _STATE_FREEZE)
		{
			// do nothing
			wait(1);
			continue;
		}

		// check for death
		if(MY._HEALTH <= 0)
		{
			MY.EVENT = NULL;
			MY._STATE = _STATE_DIE;
			MY.PASSABLE = ON;	// let the player shoot thru me
 			wait(1);	// let the animation state start the death cycle
			while(my._ANIMDIST != -99)	// let death animation run
			{
				wait(1);
			}
			_actor_ai_death_one();	// handle death
			// NOTE! _actor_ai_death_one may remove this entity! You should
			//always stop the AI at this point!
		 	return;	// return (stop the AI)
		}

		// taken enough damage to run away?
		if(MY._HEALTH < MY._I_COWARDICE)
		{
			MY._STATE = _STATE_ESCAPE;

			_actor_ai_move_escape_one();  // find escape
			_actor_ai_avoid_obs();	// scan for objects ahead of player, adjust forces to try to avoid
			_actor_ai_move_gravity();   // move with gravity (use force vector)
			MY._I_COWARDICE -= 0.125 * TIME;	// can't run away forever
			wait(1);
			continue;
		}


		// reload gun (don't reload when running away of frozen
		my_reload_count -= time;

		// is the actor aware of the player?
		if((MY._STATE == _STATE_ATTACK) || (my_awareness_count > 0))
		{
			// is the actor hiden?
			if(_actor_ai_player_trace() <= 0)
			{
				// can't see player, but remembers where he was
				MY._STATE = _STATE_HUNT;
				my_awareness_count -= TIME;  // reduce awareness count

				_actor_ai_move_hunt_one(); // find hunting vector (set force vector)
				_actor_ai_avoid_obs();	// scan for objects ahead of player, adjust forces to try to avoid
				_actor_ai_move_gravity();   // move with gravity (use force vector)
				wait(1);
				continue;
			}
			else
			{
				MY._STATE = _STATE_ATTACK;
				my_awareness_count = 320;         // time that we will hunt the player for before giving up

				if(my_reload_count <= 0)
				{
					_actor_ai_shoot_one(my_firemode,my_firerange);	// shoot at the player
					my_reload_count = my_reload_time;
				}
				_actor_ai_move_attack_one(); // find attack vector + fire
				_actor_ai_avoid_obs();	// scan for objects ahead of player, adjust forces to try to avoid
				_actor_ai_move_gravity();   // move with gravity (use force vector)
				wait(1);
				continue;
 			}


		}
		else // actor is waiting or given up
		{
			// try to aquire/re-aquire player
			if(vec_dist(my.x,player.x) < MY._I_ALERTNESS)	// player within alertness range
			{
				//...and within our view arc
				vec_diff(temp.x,player.x,my.x);	// temp point to player
				vec_to_angle(temp2.pan,temp.x);	// global angle to player  (assume results are between -180 & 180)
				temp2.pan = temp2.pan - ang(my.pan);	 // relitive angle to player
				temp2.tilt = temp2.tilt - ang(my.tilt);
				temp2.pan = ang(temp2.pan);
				temp2.tilt = ang(my.tilt);

				if((abs(temp2.pan) <= my_awareness_angle) && (abs(temp2.tilt) <= my_awareness_angle))
				{
					// and visible
					temp = _actor_ai_player_trace();
					if(temp > 0)
					{
						// set my_awareness_count
						MY._STATE = _STATE_ATTACK;
						my_awareness_count = 128;         // time that we will hunt the player for before giving up

		  		//--You don't get to shoot quite yet...		_actor_ai_shoot_one(my_firemode,my_firerange);	// shoot at the player
						_actor_ai_move_attack_one(); // find attack vector + fire
 						_actor_ai_move_gravity();   // move with gravity (use force vector)
						wait(1);
						continue;
					}
					// <=- in range AND in view cone, but trace returns negitive
				}

				//<=- in range, but not in view cone
			}
		}

		// DEFAULT STATE
		// Don't know where player is at the moment
		MY._STATE = _STATE_WAIT;	// wait state

		vec_set(force.x,nullvector);// set forces to zero
		_actor_ai_move_gravity();   // move with gravity (use force vector)
		//--waitt(4);	// 1/4 second reaction time
		wait(1);	// wait a frame
	}
}


// ========================================================================


/*

These skills are set in WED as below - 7/12/01 - MWS

_WALKSWIM_DIST	 Walk Distance . Swim Distance
_RUNCRAWL_DIST	 Run Distance . Crawl Distance
_STANDJUMP_TIME	 Stand Time . Jump Time
_ATTACKDUCK_TIME	 Attack Time . Duck Time
_RUNTHRESHOLD		 Run Threshold

Note: Times and distances after decimal use only TWO decimal places

-----------
Default animation values, taken from animate.wdl
-----------
(divide these by 4 for quarter-seconds, as they're 16ths now)
var anim_stand_ticks = 16;	// time for one standing anim cycle
var anim_jump_ticks = 6; 	// time for one jump animation cycle
var anim_attack_ticks = 16;// time for one attack animation cycle
var anim_duck_ticks = 8; 	// time for one duck animation cycle

(multiply these by 4 for quarter-widths)
var anim_walk_dist = 1; 	// dist per model width per walk cycle
var anim_swim_dist = 1; 	// dist per model width per swim cycle
var anim_run_dist = 1.5;	// dist per model width per run cycle
var anim_crawl_dist = 0.8; // dist per model width per crawl cycle
//var anim_wade_dist = 0.8;// dist per model width per crawl cycle (unused)

var walk_or_run = 12; 	// max quants per tick to switch from walk to run animation
*/
var	pap_pack1; // used to pack SKILL1
var	pap_pack2; // used to pack SKILL2

function player_anim_pack()
{
	pap_pack1 = 0;	//reset
	pap_pack2 = 0;	//reset

	// Stand Time
	temp = INT(MY._STANDJUMP_TIME);				  		// quarter seconds
	if (temp == 0) {								// no value entered in WED
		temp = 4;									// default anim_stand_ticks = 16
	}
 	pap_pack1 += temp >> 10;		  			// fractional 10 bits (2^10 = 1024)
	//pap_pack1 += temp / 1024;		  	  	// fractional 10 bits (2^10 = 1024)


	// Jump Time
	temp = INT(FRC(MY._STANDJUMP_TIME) * 100); 		// quarter seconds
	if (temp == 0) {								// no value entered in WED
		temp = 2;									// default anim_jump_ticks = 6
	}
	pap_pack1 += temp << 6;			 			// middle 6 bits (2^6 = 64)
	//pap_pack1 += temp * 64;				 	// middle 6 bits (2^6 = 64)


	// Attack Time
	temp = INT(MY._ATTACKDUCK_TIME);   					// quarter seconds
	if (temp == 0) {								// no value entered in WED
		temp = 4;									// default anim_attack_ticks = 16
	}
	pap_pack1 += temp << 12;			  		// upper 9 bits, shift 12 (2^12 = 4096)
	//pap_pack1 += temp * 4096;				// upper 9 bits, shift 12 (2^12 = 4096)


	// Duck Time
	temp = INT(FRC(MY._ATTACKDUCK_TIME) * 100);	 	// quarter seconds * 4 = game ticks
	if (temp == 0) {								// no value entered in WED
		temp = 2;									// default anim_duck_ticks = 8
	}
	pap_pack1 += temp; 							// lowest 6 bits


	// Walk Distance
	temp = INT(MY._WALKSWIM_DIST); 		// quarter widths
	if (temp == 0) {								// no value entered in WED
		temp = 4;									// default anim_walk_dist = 1
	}
	pap_pack2 += temp << 10;					// next upper 5 bits (2^10 = 1024)
	//pap_pack2 += temp * 1024;			  	// next upper 5 bits (2^10 = 1024)


	// Swim Distance
	temp = INT(FRC(MY._WALKSWIM_DIST) * 100); 		// quarter widths
	if (temp == 0) {								// no value entered in WED
		temp = 4;									// default anim_swim_dist = 1
	}
	pap_pack2 += temp;	  						// bottom 5 bits


	// Skill6------------------------------
	// Run Distance
	temp = INT(MY._RUNCRAWL_DIST);   					// quarter widths
	if (temp == 0) {								// no value entered in WED
		temp = 6;									// default anim_run_dist = 1.5
	}
	pap_pack2 += temp << 15;	  	 			// upper 6 bits (2^15 = 2^10 * 2^5 = 1024 * 32)
	//pap_pack2 += temp * 1024 * 32;	  		// upper 6 bits (2^15 = 2^10 * 2^5 = 1024 * 32)


	// Crawl Distance
	temp = INT(FRC(MY._RUNCRAWL_DIST) * 100);	  	// quarter widths
	if (temp == 0) {								// no value entered in WED
		temp = 3;									// default anim_crawl_dist = 0.8
	}
	pap_pack2 += temp << 5;			  			// upper 5 bits (2^5 = 32)
	//pap_pack2 += temp * 32;					// upper 5 bits (2^5 = 32)


	// Skill7------------------------------
	// Walk Or Run
	temp = INT(MY._RUNTHRESHOLD);   		 			// whole quants
	if (temp == 0) {								// no value entered in WED
		temp = 12;									// default walk_or_run = 12
	}
	pap_pack2 += temp >> 10;			  		// fractional 10 bits (2^10 = 1024)
	//pap_pack2 += temp / 1024;		  		// fractional 10 bits (2^10 = 1024)


	MY._ADVANIM_TICK = -1 * pap_pack1;		// activate advanced animation
	MY._ADVANIM_DIST  = -1 * pap_pack2;		// activate advanced animation
}



// Desc: what to do when the player is dead.
//
// Note: overwrite this with your own behavior on death
//		Three second delay added for effect and to fix "eye_height" reset problem
function	player_dead()
{
	waitt(48);		// wait for 3 seconds
// 	menu_main();	// bring up menu.
}

// Desc: enable the player to take damage and die
//
// Mod Date: 05/01/02
//		Replaced call to state_die with local handling of player death
function player_fight()
{
	if(MY._HEALTH == 0) { MY._HEALTH = 100; }

	MY.ENABLE_SCAN = ON;
	MY.ENABLE_SHOOT = ON;
	MY.EVENT = fight_event;

	while(MY._HEALTH > 0)
	{
		if(MY._SIGNAL == _DETECTED) 	// Hit received?
		{
			MY._SIGNAL = 0;	// reset the _signal skill
			if(person_3rd == 0) { player_shake(); }
		}
		wait(1);
	}

	// Dead
	MY._HEALTH = 0;
	weapon_remove();	// prevent dead player firing
	my._MOVEMODE = _MODE_STILL; // stop the player from moving


	if(person_3rd == 0)
	{	// 1st person die action
		MY._MOVEMODE = 0;		// don't move anymore
		MY.EVENT = NULL;		// prevent health counting down
		player_tip();
		waitt(8);
	}
	else
	{
		//state_die();
		wait(1);	// let the animation state start the death cycle
		while(my._ANIMDIST != -99)	// not done with death cycle
		{
			wait(1);
		}
	}
	my._MOVEMODE = _MODE_NONE;	// stop movment
	player_dead();// handle being dead
}





// Desc: explode into x number of random models
//
// Mod Date: 8/22/00 DCP
//				Uses function parameter (numberOfParts) to determine
//			how many 'gib' parts to create
function	_gib(numberOfParts)
{
	temp = 0;
	while(temp < numberOfParts)
	{
		create(<gibbit.mdl>, MY.POS, _gib_action);
		temp += 1;
	}

}

// Desc: Init and animate a gib-bit
//
// Mod Date: 6/29/00 Doug Poston
//				Added rotation and alpha-fading
// Mod Date: 8/31/00 DCP
//				Scale absdist vector by movement_scale
//				Scale the gibbits down by the actor_scale
function _gib_action()
{
	// scall the bits down by the actor_scale amount
	vec_scale(MY.SCALE_X,actor_scale);

	// Init gib bit
	MY._SPEED_X = 25 * (RANDOM(10) - 5);    // -125 -> +125
	MY._SPEED_Y = 25 * (RANDOM(10) - 5);    // -125 -> +125
	MY._SPEED_Z = RANDOM(35) + 15;          // 15 -> 50

	MY._ASPEED_PAN = RANDOM(35) + 35;       // 35 -> 70
	MY._ASPEED_TILT = RANDOM(35) + 35;      // 35 -> 70
	MY._ASPEED_ROLL = RANDOM(35) + 35;      // 35 -> 70

	MY.ROLL = RANDOM(180);	// start with a random orientation
	MY.PAN = RANDOM(180);

	MY.PUSH = -1;	// allow user/enemys to push thru



	// Animate gib-bit
	MY.SKILL9 = RANDOM(50);
	while(MY.SKILL9 > -75)
	{
		abspeed[0] = MY._SPEED_X * TIME;
		abspeed[1] = MY._SPEED_Y * TIME;
		abspeed[2] = MY._SPEED_Z * TIME;

		MY.PAN += MY._ASPEED_PAN * TIME;
		MY.TILT += MY._ASPEED_TILT * TIME;
		MY.ROLL += MY._ASPEED_ROLL * TIME;

		vec_scale(absdist,movement_scale);	// scale absolute distance by movement_scale
		MOVE  ME,NULLSKILL,abspeed;

		IF(BOUNCE.Z)
		{
			MY._SPEED_Z = -(MY._SPEED_Z/2);
			if(MY._SPEED_Z < 0.25)
			{
				MY._SPEED_X = 0;
				MY._SPEED_Y = 0;
				MY._SPEED_Z = 0;
				MY._ASPEED_PAN = 0;
				MY._ASPEED_TILT = 0;
				MY._ASPEED_ROLL = 0;
			}
		}

		MY._SPEED_Z -= 2;
		MY.SKILL9 -= 1;

		wait(1);
	}


	// Fade out
	MY.transparent = ON;
	MY.alpha = 100;
	while(1)
	{
   	MY.alpha -= 5*time;
		if(MY.alpha <=0)
		{
			// remove
			ent_remove(me);
			return;
		}

   	wait(1);
	}
}

//]-- NOTE: coming soon! include <war2.wdl>;