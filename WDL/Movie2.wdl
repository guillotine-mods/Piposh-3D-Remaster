var CamNow = 1;

function LookAtPiposh1
{
	camera.x = 2191.422;
	camera.y = 10.888;
	camera.z = -89.992;
	vec_set(temp,player.x);		// Set the camera to look at Piposh
	vec_sub(temp,camera.x);
	vec_to_angle(camera.pan,temp);
}

function LookAtPiposh2
{
	camera.x = 2082.388;
	camera.y = 268.999;
	camera.z = -89.992;
	vec_set(temp,player.x);		// Set the camera to look at Piposh
	vec_sub(temp,camera.x);
	vec_to_angle(camera.pan,temp);
}

function LookAtPiposh3
{
	camera.x = 2001.448;
	camera.y = -192.518;
	camera.z = -89.992;
	vec_set(temp,player.x);		// Set the camera to look at Piposh
	vec_sub(temp,camera.x);
	vec_to_angle(camera.pan,temp);
}


ACTION Movie2
{
//*****************************************************************************************************
//* Movie number 2 - Piposh tries to sneak into the asylum disguised as a bush, but one of the agents *
//* trip him 											      *
//*****************************************************************************************************

		MoviePlaying = 1;

		sPlay ("PIP498.WAV");

		morph (<PipBush.mdl>,player);
			PrevX = player.x;		// Keep Piposh's position before the movie
			PrevY = player.y;
			PrevZ = player.z;
			camera.x = 1875.286;
			camera.y = 104.067;
			camera.z = -89.992;
			vec_set(temp,CameraLook1);	// Set the camera to look at the wall
			vec_sub(temp,camera.x);
			vec_to_angle(camera.pan,temp);
			CameraEnabled = 0;
			player.Skill1 = 1;
			player.x = 2065.537;	// Put Piposh in a new position
			player.y = 460.996;
			player.z = -89.992;
			vec_set(temp,PipLook1);	// Set Piposh to look straight ahead
			vec_sub(temp,player.x);
			vec_to_angle(player.pan,temp);
			wait (1);
			MoviePlaying = 1;		// Set MoviePlaying flag to prevent CameraEngine from
							// Changing the camera properties.
			wait (1);

			while (player.x > 1880)			// Animate Piposh strafing left
			{	
				my = player;
				ent_cycle ("strafe",percent);
				percent = percent + 15 * time;
				player.x = player.x - 3 * time;
				wait (1);
			}

			percent = 0;

			while (percent < 101)			// Animate Piposh looking around
			{	
				my = player;
				ent_frame ("look",percent);
				percent = percent + 9 * time;
				wait (1);
			}
		
			percent = 0;

			while (player.y > 286)			// Animate Piposh running
			{	
				my = player;
				ent_cycle ("run",percent);
				percent = percent + 15 * time;
				player.y = player.y - 30 * time;
				if (player.y < 300) { morph (<BadTrip.mdl>,BadGuy1); } 	// Bad guy trips Piposh
				wait (1);
			}

			percent = 0;

			TempX = player.x;	// Keep Piposh's position before taking a dive
			TempY = player.y;
			TempZ = player.z;

			sPlay ("SFX053.WAV");

			while (percent < 51)			// Piposh is taking a dive camera #1
			{
				ent_frame ("trip",percent);
				percent = percent + 3 * time;
				player.y = player.y - 8 * time;
				//LookAtPiposh1();
				wait (1);
			}		

			//player.x = TempX;
			//player.y = TempY;
			//player.z = TempZ;
			//percent = 0;

			while (percent < 101)			// Piposh is taking a dive camera #2
			{
				ent_frame ("trip",percent);
				percent = percent + 3 * time;
				player.y = player.y - 8 * time;
				LookAtPiposh3();
				wait (1);
			}

			ent_frame ("Talk",0);
			sPlay ("PIP452.WAV");

			while (GetPosition(Voice) < 1000000)
			{
				if (int(random(20)) == 10) { ent_frame ("Talk",int(random(5)) * 25); }
				if (CamNow == 1) { LookAtPiposh1(); }
				if (CamNow == 2) { LookAtPiposh2(); }
				if (CamNow == 3) { LookAtPiposh3(); }
				if (int(random(80)) == 40) { CamNow = int(random(3)) + 1; }
				wait(1);
			}

			// Reset all properties and retun to game
			morph (<Piposh.mdl>,player);	// Return Piposh to his original model
			morph (<BadSit1.mdl>,BadGuy1);  // Return the bad guy to his original model
			player.x = PrevX;		// Restore Piposh's position from before the movie
			player.y = PrevY;
			player.z = PrevZ;
			CameraEnabled = 1;		// Enable CameraEngine to change Camera settings
			Movie = 0;			// Reset Movie flag
			MoviePlaying = 0;		// Movie has stopped
			Done2 = 1;
}