bmap Meter1 = <Meter1.bmp>;
bmap Meter2 = <Meter2.bmp>;
bmap bVS = <Fight.pcx>;
bmap clouds = <clds.pcx>;
bmap YouWin = <YouWin.bmp>;
bmap YouLose = <YouLose.bmp>;

var CheatHit;
var CONST_INTRO = 100;
var OppCounter = 0;
var PipCounter = 0;
var OppPhase = 0;
var OppHit = 0;
var OppZ = 0;
var CONST_HIT = 60;
var OppGotHit = 0;

panel pWinLose
{
	bmap = YouWin;
	layer = 5;
	pos_x = 150;
	pos_y = 150;
	alpha = 0;
	flags = refresh,d3d,transparent,overlay;
}

panel VSImage
{
	layer = -0.2;
	bmap = bVS;
	pos_x = 0;
	pos_y = 0;
	flags = refresh,d3d;
}

panel HealthBar
{
	layer = -0.1;
	window 22,26,205,36,Meter2,opphealth,0;
	window 408,26,205,36,Meter1,piphealth,0;
	flags = refresh,d3d;
}

function updatepanel
{
	if (opponent == null) { wait(1); }
	OppHealth = opponent.health;
	PipHealth = 205 - player.health;
}

ACTION PiposhHit
{
	if ((Holding > 0) && (Round == 5)) { return; }
	if (opponent == null) { wait(1); }

	if ((you == opponent && me == player && opponent.hittype == 4 && Round == 1) 
	|| (Round == 5))
	{
		my = player;
		opponent.hittype = 0;

		while (1)
		{
			ent_frame ("Squish",100);
			my.health = 0;
			wait(1);
		}
	}

	if (opponent.hittype == 4) { opponent.hittype = 0; }

}

ACTION player_move2
{
	Death = 0;
	pWinLose.visible = off;
	pWinLose.Alpha = 0;

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

	while (VSShow != 0) { wait(1); }

	while (Intro < CONST_INTRO)
	{
		ent_cycle ("Intro",Intro);
		Intro = Intro + 2 * time;
		wait(1);
	}
	play_sound (Bell,30);

	// while we are in a valid movemode
	while ((MY._MOVEMODE > 0) && (MY._MOVEMODE <= _MODE_STILL) && (player.health > 0))
	{

	if (Opponent == null) { Wait(1); }

	vec_set(temp,Opponent.x);
	vec_sub(temp,player.x);
	vec_to_angle(player.pan,temp);
	player.tilt = 0;

	if (opponent.health <= 0)
	{
		while(1)
		{
			ent_cycle ("Win",my.skill1);
			my.skill1 = my.skill1 + 10 * time;
			wait(1);
		}
	}

	if ((player.hitting > 0) && (player.thrown == 0) && (VSShow == 0))
	{
		if (player.hittype == 1) { ent_frame ("Kafa",player.hitting); }
		if (player.hittype == 2) { ent_frame ("Kick",player.hitting); }
		if (player.hittype == 3) { ent_frame ("Spin",player.hitting); }
		if (player.hittype == 4) { ent_frame ("Rasia",player.hitting); }

		player.hitting = player.hitting + 10 * time;

		if ((player.hitting > CONST_HIT) && (OppGotHit == 0))
		{
			if ((abs(player.x - opponent.x) < 100) && (abs(player.y - opponent.y) < 100))
			{
				if (Cheat3 > 0) { kill(); }
				else
				{
					HitSound(); 
					OppGotHit = 1;
					opponent.hits = opponent.hits + 1;
				
					if (opponent.hits < 5)
					{
						opponent.skill38 = 20;
						opponent.skill41 = int(random(5)) * 25;
						DoDamage();
					}
				}
			}

		}

		if (player.hitting > 99) { player.hitting = 0; OppGotHit = 0; opponent.anim = 1; AnimTemp = 0; }

		wait(1);

	}

	if (Holding == 1) { ent_frame ("Hold",0); wait(1); }

	if ((player.hitting == 0) && (player.thrown == 0) && (Holding != 1))
	{

		// if we are not in 'still' mode
		if ((MY._MOVEMODE != _MODE_STILL) && (player.thrown == 0))
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
		actor_anim();

		// Wait one tick, then repeat
		wait(1);
		}

		if (player.thrown > 0) { wait(1); }

	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

function Kill
{
	actor_explode();
}

ACTION Piposh
{
	player = my;
	my.health = 205;
	my.hits = 0;

	wait(1);

	my.push = -2;
	my.enable_push = on;
	my.event = PiposhHit;
	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 0.75;
	MY._BANKING = -0.1;
	MY.__JUMP = OFF;
	MY.__DUCK = ON;
	MY.__STRAFE = ON;
	MY.__BOB = ON;
	MY.__TRIGGER = ON;
	MY.__SLOPES == OFF;

	var TheSkin;

	TheSkin = int(random(6)) + 1;

	if (TheSkin < 4) { my.skin = TheSkin; } else { my.skin = TheSkin + 1; }
	
	player_move2();
}

function Slap
{
	if (Holding == 1) { Holding = 2; return; }

	if (player.hitting == 0)	// Wait until player has finished previous hit
	{
		player.hitting = 1;
		player.hittype = 1;
	}
}

function Kick
{
	if (Holding == 1) { Holding = 2; return; }

	if (player.hitting == 0)	// Wait until player has finished previous hit
	{
		player.hitting = 1;
		player.hittype = 2;
	}
}

function Spin
{
	if (Holding == 1) { Holding = 2; return; }

	if (player.hitting == 0)	// Wait until player has finished previous hit
	{
		player.hitting = 1;
		player.hittype = 3;
	}
}

function Rasia
{
	if (Holding == 1) { Holding = 2; return; }

	if (player.hitting == 0)	// Wait until player has finished previous hit
	{
		player.hitting = 1;
		player.hittype = 4;
	}
}

function StrafeRight
{
	my = player;
	force.y = 20;
	actor_move();
}

function StrafeLeft
{
	my = player;
	force.y = -20;
	actor_move();
}

on_z = slap();
on_x = kick();
on_c = spin();
on_v = rasia();

function ChangeOpponent
{
	if (Village[4] == 0) { Round = 5; }
	if (Village[3] == 0) { Round = 4; }
	if (Village[2] == 0) { Round = 3; }
	if (Village[1] == 0) { Round = 2; }
	if (Village[0] == 0) { Round = 1; }

	if (Round == 0) { Round = 1; }

	if (Round == 1)
	{
		morph (<FFatass.mdl>,my);
		my.scale_x = 1;
		my.scale_y = 1;
		my.scale_z = 1;
	}
	
	if (Round == 2)
	{
		morph (<FChick.mdl>,my);
		my.scale_x = 0.7;
		my.scale_y = 0.7;
		my.scale_z = 0.7;
	}

	if (Round == 3)
	{
		morph (<FYoyo.mdl>,my);
		my.scale_x = 0.7;
		my.scale_y = 0.7;
		my.scale_z = 0.7;
	}

	if (Round == 4)
	{
		morph (<FCap.mdl>,my);
		my.scale_x = 0.7;
		my.scale_y = 0.7;
		my.scale_z = 0.7;
	}

	if (Round == 5)
	{
		morph (<FBully.mdl>,my);
		my.scale_x = 1;
		my.scale_y = 1;
		my.scale_z = 1;
	}
}

action Opp
{
	ChangeOpponent();
	opponent = my;
	my.health = 205;
	my.hits = 0;
	my.hitting = 0;
	OppPhase = 0;
	OppCounter = 0;
	OppHit = 0;
	Shield = 25 * Round;

	wait(1);

	my.push = -1;
	MY._FORCE = 2;
	//MY._WALKSOUND = _SOUND_ROBOT;
	anim_init();
	 // attach shadow to robot

	MY._STATE = _STATE_ATTACK;
	MY._MOVEMODE = _MODE_ATTACK;	// stop patrolling etc.

	while (VSShow != 0) { wait(1); }

	while (Intro < CONST_INTRO)
	{
		force = 0;
		actor_move();
		ent_cycle ("Intro",Intro * Round);
		wait(1);
	}

	FatZ = my.z;

	// fire and close distance
	while (1)
	{
		if (player.health <= 0)
		{
			while(1)
			{
				ent_cycle ("Win",my.skill1);
				my.skill1 = my.skill1 + 10 * time;
				if (Round == 5) { my.skill1 = my.skill1 + 20 * time; }
				wait(1);
			}
		}

		while (Cheat3 > 0)
		{
			Cheat3 = Cheat3 - 1;
			wait(1);
		}

		DoHit();
		Attack();

		if ((opponent.hitting == 0) && (OppPhase == 0) && (OppCounter == 0))
		{
			my.z = FatZ;
		
			// fire two or three times
			MY._COUNTER = 1.5 + RANDOM(1);
	
	 		// check to see if player is shootable,
 			if((attack_fire()) == -1)
	 		{
	 			// cannot see player
				LookAtPlayer();

	 		  	EXCLUSIVE_ENTITY; wait(1); BRANCH state_hunt;
	 		}


			while(my._counter > 0) 
			{
				DoHit();
				Attack();
				LookAtPlayer();

				ent_cycle ("stand",my.skill30);
				my.skill30 = my.skill30 + 6 * time;
				wait(1);
			
			}	// don't continue until attack_fire is finished
	
	
			// walk towards player for one to three seconds

			MY._COUNTER = 30;

			approach();

			if (int(Random(5) > 2)) 
			{ 
				if (Round < 4) { Round1(); } else { Round2(); }
			}

			while(my._counter > 0) { DoHit(); LookAtPlayer(); wait(1); } // don't continue until attack_approach is finished
		}

		wait(1);
	}
}

function DoHit
{
	if ((opponent.hits > 4) || (opponent.health <= 0)) { OppHit = 1; }

	while (opponent.skill38 > 0)
	{
		ent_cycle ("Ouch",opponent.skill41);
		opponent.skill38 = opponent.skill38 - 3 * time;
		wait(1);
	}
}

function LookAtPlayer
{
	vec_set(temp,Player.x);
	vec_sub(temp,Opponent.x);
	vec_to_angle(Opponent.pan,temp);
	my.tilt = 0;
	my.roll = 0;
}

function approach()
{
	// calculate a direction to walk into
	temp.X = player.X - MY.X;
	temp.Y = player.Y - MY.Y;
	temp.Z = 0;

	while((MY._STATE == _STATE_ATTACK) && (MY._COUNTER > 0))
	{
		DoHit();

		if (OppHit == 1) { Attack(); }
		// walk towards him if not too close
		temp = (player.X - MY.X)*(player.X - MY.X)+(player.Y - MY.Y)*(player.Y - MY.Y);
		if(temp > 10000)  // 100^2
		{
			force = MY._FORCE;
			MY._MOVEMODE = _MODE_WALKING;
			if (OppHit == 0) { actor_move(); }
		}

		wait(1);
		MY._COUNTER -= TIME;
	}

}

function DODamage
{
	CheatHit = 1;

	if (Cheat1 == 1) { CheatHit = 3; opponent.hits = 5; }

	TempHealth = opponent.health;	// Store current health

	if (player.hittype == 1) { opponent.health = opponent.health - ((int(Random(30)) + 20) * CheatHit); shedblood (2); }
	if (player.hittype == 2) { opponent.health = opponent.health - ((int(Random(50)) + 10) * CheatHit); shedblood (2); }
	if (player.hittype == 3) { opponent.health = opponent.health - ((int(Random(100))) * CheatHit)    ; shedblood (2); }
	if (player.hittype == 4) { opponent.health = opponent.health - ((int(Random(50)) + 30) * CheatHit); shedblood (2); }

	// Calcualte opponent shield
	opponent.health = opponent.health + int(random(Shield)) + int(Shield / 2);			// Random a value between 1/2 Shield and Shield
	if (opponent.health >= TempHealth) { opponent.health = TempHealth - (int(random(10)) + 5); }	// Make sure the attack actually hurts the opponent
}

function StayDown
{
	DoDamage();

	if (opponent.health > 0)
	{
		OppCounter = 0;
		OppPhase = 1;
	}
	else
	{
		wait(1);
	}
}

function Attack
{
	if (Round == 1)
	{
		if (OppHit == 1)
		{
			if (OppPhase == 0)
			{
				ent_frame ("Hit",OppCounter);
				OppCounter = OppCounter + 6 * time;
				if (OppCounter > 99) { StayDown(); }
			}
				
			if (OppPhase == 1)
			{
				ent_cycle ("Delay",OppCounter);
				OppCounter = OppCounter + 30 * time;
				if (OppCOunter > 499) { OppCounter = 100; OppPhase = 2; }
			}
	
			if (OppPhase == 2)
			{
				ent_frame ("Hit",OppCounter);
				OppCounter = OppCounter - 15 * time;
				if (OppCounter < 1) { OppCounter = 0; OppPhase = 0; my.hits = 0; OppHit = 0; }
			}

		}

		if (opponent.hitting > 0)
		{
			if (opponent.hittype == 1)
			{
				ent_frame ("Roll",opponent.hitting);
				opponent.hitting = opponent.hitting + 10 * time;
				if ((opponent.hitting > CONST_HIT) && (GotHit == 0)) { GotHit = 1; CheckHit(); }

				if (opponent.hitting > 99) { opponent.hitting = 0; ent_frame ("stand",0); GotHit = 0;}
			}

			if (opponent.hittype == 2)
			{
				ent_cycle ("Fly",opponent.hitting);
				opponent.hitting = opponent.hitting + 60 * time;
				opponent.z = opponent.z + 15 * time;
				opponent.skill21 = opponent.skill21 + 3 * time;
				if (opponent.skill21 > 50) { opponent.skill21 = 0; opponent.hittype = 3; }
				StompPlayer();
			}
	
			if (opponent.hittype == 3)
			{
				ent_frame ("Fall",0);
				opponent.z = opponent.z - 30 * time;
				opponent.skill21 = opponent.skill21 + 3 * time;
				if (opponent.skill21 > 25) { opponent.skill21 = 0; opponent.hittype = 4; opponent.hitting = 0; ent_frame ("stand",0); }
			}
		}
	}

	if (Round == 2)
	{
		if (OppHit == 1)
		{
			if (OppPhase == 0)
			{
				ent_frame ("Hit",OppCounter);
				OppCounter = OppCounter + 6 * time;
				if (OppCounter > 99) { StayDown(); }
			}
				
			if (OppPhase == 1)
			{
				ent_cycle ("Delay",OppCounter);
				OppCounter = OppCounter + 30 * time;
				if (OppCOunter > 499) { OppCounter = 0; OppPhase = 2; }
			}
	
			if (OppPhase == 2)
			{
				ent_frame ("Getup",OppCounter);
				OppCounter = OppCounter + 6 * time;
				if (OppCounter > 99) { OppCounter = 0; OppPhase = 0; my.hits = 0; OppHit = 0; }
			}
		}

		if (opponent.hitting > 0)
		{
			if (opponent.hittype == 1)
			{
				ent_frame ("punch",opponent.hitting);
				opponent.hitting = opponent.hitting + 15 * time;

				if ((opponent.hitting > CONST_HIT) && (GotHit == 0))
				{ 
					if ((abs(player.x - opponent.x) < 100) && (abs(player.y - opponent.y) < 100))
					{
						HitSound();
						GotHit = 1;
						my = player; 
						my.anim = 0;
						if (opponent.health > 0) 
						{ 
							player.Health = player.Health - (int(Random(10)) + 5); shedblood (1); 
							if (player.health <= 0) { PlayerDie(); }
						}


						while (my.anim < 15)
						{
							my.anim = my.anim + 3 * time;
							ent_frame("Ouch",0); 
							wait(1);
						}

						my = opponent; 
					}
				}

				if (Opponent.hitting > 99) { opponent.hitting = 0; ent_frame ("stand",0); GotHit = 0; }

				wait(1);
			}

			if (opponent.hittype == 2)
			{
				ent_frame ("kick",opponent.hitting);
				opponent.hitting = opponent.hitting + 6 * time;
				if ((opponent.hitting > CONST_HIT) && (GotHit == 0)) { GotHit = 1; CheckHit(); }
				if (opponent.hitting > 99) { opponent.hitting = 0; ent_frame ("stand",0); GotHit = 0; }
				wait(1);
			}
		}
	}	

	if (Round == 3)
	{

		if (OppHit == 1)
		{
			if (OppPhase == 0)
			{
				ent_frame ("Hit",OppCounter);
				OppCounter = OppCounter + 6 * time;
				if (OppCounter > 99) { StayDown(); }
			}
				
			if (OppPhase == 1)
			{
				ent_cycle ("Delay",OppCounter);
				OppCounter = OppCounter + 30 * time;
				if (OppCOunter > 499) { OppCounter = 0; OppPhase = 2; }
			}
	
			if (OppPhase == 2)
			{
				ent_frame ("Getup",OppCounter);
				OppCounter = OppCounter + 4 * time;
				if (OppCounter > 99) { OppCounter = 0; OppPhase = 0; my.hits = 0; OppHit = 0; }
			}
		}

		if (opponent.hitting > 0)
		{
			if (opponent.hittype == 1)
			{
				ent_frame ("Slice",opponent.hitting);
				opponent.hitting = opponent.hitting + 15 * time;
				if ((opponent.hitting > CONST_HIT) && (GotHit == 0))
				{ 
					if ((abs(player.x - opponent.x) < 100) && (abs(player.y - opponent.y) < 100)) { HitSound(); GotHit = 1; CheckHit(); }
				}

				if (opponent.hitting > 99) { opponent.hitting = 0; ent_frame ("stand",0); GotHit = 0; }
			}

			if (opponent.hittype == 2)
			{
				ent_frame ("Slash",opponent.hitting);
				opponent.hitting = opponent.hitting + 15 * time;
				if ((opponent.hitting > CONST_HIT) && (GotHit == 0))
				{ 
					if ((abs(player.x - opponent.x) < 200) && (abs(player.y - opponent.y) < 200)) { HitSound(); GotHit = 1; CheckHit(); }
				}

				if (opponent.hitting > 99) { opponent.hitting = 0; ent_frame ("stand",0); GotHit = 0; }
			}
		}
	
	}

	if (Round == 4)
	{

		if (OppHit == 1)
		{
			if (OppPhase == 0)
			{
				ent_frame ("Hit",OppCounter);
				OppCounter = OppCounter + 3 * time;
				if (OppCounter > 99) { StayDown(); }
			}
				
			if (OppPhase == 1)
			{
				ent_cycle ("Delay",OppCounter);
				OppCounter = OppCounter + 30 * time;
				if (OppCOunter > 499) { OppCounter = 0; OppPhase = 2; }
			}
	
			if (OppPhase == 2)
			{
				ent_frame ("Getup",OppCounter);
				OppCounter = OppCounter + 6 * time;
				if (OppCounter > 99) { OppCounter = 0; OppPhase = 0; my.hits = 0; OppHit = 0; }
			}
		}

		if (opponent.hitting > 0)
		{
			if (opponent.hittype == 1)
			{
				ent_frame ("Headspin",opponent.hitting);

				if (opponent.health > 0) 
				{
					if ((abs(player.x - opponent.x) < 100) && (abs(player.y - opponent.y) < 100)) 
					{ HitSound(); player.health = player.health - (int(random(9)) + 3); shedblood (1); }
				}

				if (player.health <= 0) { opponent.hitting = 0; ent_frame ("stand",0); checkhit(); } 

				opponent.hitting = opponent.hitting + 9 * time;

				if (opponent.hitting > 99) { opponent.hitting = 0; ent_frame ("stand",0); }
			}

			if (opponent.hittype == 2)
			{
				ent_frame ("Cartwheel",opponent.hitting);
				opponent.hitting = opponent.hitting + 6 * time;

				if ((opponent.hitting > CONST_HIT) && (GotHit == 0))
				{ 
					if ((abs(player.x - opponent.x) < 100) && (abs(player.y - opponent.y) < 100)) { HitSound(); GotHit = 1; CheckHit(); }
				}

				if (opponent.hitting > 99) { opponent.hitting = 0; ent_frame ("stand",0); GotHit = 0; }
			}
		}
	}

	if (Round == 5)
	{

		if (OppHit == 1)
		{

			if (OppPhase == 0)
			{
				ent_frame ("Hit",OppCounter);
				OppCounter = OppCounter + 3 * time;
				if (OppCounter > 99) { StayDown(); }
			}
			
			if (OppPhase == 1)
			{
				ent_cycle ("Delay",OppCounter);
				OppCounter = OppCounter + 30 * time;
				if (OppCOunter > 499) { OppCounter = 0; OppPhase = 2; }
			}
	
			if (OppPhase == 2)
			{
				ent_frame ("Getup",OppCounter);
				OppCounter = OppCounter + 3 * time;
				if (OppCounter > 99) { OppCounter = 0; OppPhase = 0; my.hits = 0; OppHit = 0; }
			}
		}

		if (opponent.hitting > 0)
		{
			if (opponent.hittype == 1)
			{
				ent_frame ("Punch",opponent.hitting);
				opponent.hitting = opponent.hitting + 6 * time;

				if ((opponent.hitting > CONST_HIT) && (GotHit == 0))
				{ 
					if ((abs(player.x - opponent.x) < 100) && (abs(player.y - opponent.y) < 100)) { HitSound(); GotHit = 1; CheckHit(); }
				}

				if (opponent.hitting > 99) { opponent.hitting = 0; ent_frame ("stand",0); GotHit = 0; }


			}

			if (opponent.hittype == 2)
			{
				ent_frame ("Hammer",opponent.hitting);
				opponent.hitting = opponent.hitting + 6 * time;

				if (opponent.hitting > 99)
				{ 
					if ((abs(player.x - opponent.x) < 100) && (abs(player.y - opponent.y) < 100)) { HitSound(); PiposhHit(); }

					opponent.hitting = 0; 
					ent_frame ("stand",0);
				}

			}
		}
	}

}

function PlayerDie
{
	my = player;
	player.thrown = 0;
	while (player.thrown < 101) 
	{
		dist.x = -2;
		dist.y = 0;
		dist.z = 0;

		// calculate absolute distance to move
		absdist.x = absforce.x * TIME * TIME;
		absdist.y = absforce.y * TIME * TIME;
		absdist.z = MY._SPEED_Z * TIME;

		move(player,dist,absdist);
		player.thrown = player.thrown + 2;
		ent_frame ("thrown",player.thrown);
		wait(1);
		player.skill19 = 0;
	}
}