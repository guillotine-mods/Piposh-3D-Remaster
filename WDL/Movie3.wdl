var CamLook = 1;

function LookAtMonster { CammyGo = 1; CamLook = int(random(2)) + 1; }

action Cammy
{
	while (1)
	{
		if (CammyGo == 1)
		{
			if (CamLook == my.skill1)
			{
				camera.x = my.x;
				camera.y = my.y;
				camera.z = my.z;
				camera.tilt = my.tilt;
				camera.roll = my.roll;
				camera.pan = my.pan;
			}
		}
		wait(1);
	}
}

action Mon
{
	while (1)
	{
		ent_cycle ("Talk",my.skill1);
		my.skill1 = my.skill1 + 10 * time;
		my.pan = my.pan + PanMe * time;
		wait(1);
	}
}

ACTION Movie3
{
//*****************************************************************************************************
//* Movie number 3 - Piposh calls the monster						              *
//*****************************************************************************************************


		morph (<PipPhone.mdl>,player);
		PrevX = player.x;		// Keep Piposh's position before the movie
		PrevY = player.y;
		PrevZ = player.z;
		CameraEnabled = 0;
		player.Skill1 = 1;
		player.x = 2229.733	;	// Put Piposh in a new position
		player.y = -337.000;
		player.z = -89.992;
		vec_set(temp,PiposhPhone);	// Set Piposh to look at the payphone
		vec_sub(temp,player.x);
		vec_to_angle(player.pan,temp);
		wait (1);
		LookAtPiposh();
		MoviePlaying = 1;		// Set MoviePlaying flag to prevent CameraEngine from
							// Changing the camera properties.
		Movie = 1;			// Set the Movie scene to 1
		percent = 0;
		wait (1);

		if (Movie == 1)
		{
			while (percent < 101)			// Animate Piposh picking up the phone
			{	
				my = player;
				ent_frame ("take",percent);
				percent = percent + 5;
				wait (1);
				if percent > 100 
				{ 
					Movie = 2; 
					morph (<PozPhone.mdl>,Pozmak);
					LookAtPozmak();
				}
			}
		}

		if (Movie == 2)
		{
			LookAtMonster(); 
			sPlay ("MON001.WAV");
			percent = 0;
			delay = 0;
			TalkFrame = 2;
			while (GetPosition(Voice) < 1000000) { wait(1); }
			Movie = Movie + 1;
		}


		if (Movie == 3)
		{
			LookAtPiposh(); 
			sPlay ("PIP457.WAV");
			percent = 0;
			delay = 0;
			TalkFrame = 2;
			while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			Movie = Movie + 1;
		}


		if (Movie == 4)
		{
			LookAtMonster(); 
			sPlay ("MON002.WAV");			
			percent = 0;
			delay = 0;
			TalkFrame = 2;
			while (GetPosition(Voice) < 1000000) { wait(1); }
			Movie = Movie + 1;
		}


		if (Movie == 5)
		{
			LookAtPiposh(); 
			sPlay ("PIP458.WAV");
			percent = 0;
			delay = 0;
			TalkFrame = 2;
			while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			Movie = Movie + 1;
		}

		if (Movie == 6)
		{
			LookAtMonster(); 
			sPlay ("MON003.WAV");			
			percent = 0;
			delay = 0;
			TalkFrame = 2;
			while (GetPosition(Voice) < 1000000) { wait(1); }
			Movie = Movie + 1;
		}

		if (Movie == 7)
		{
			LookAtPiposh(); 
			sPlay ("PIP459.WAV");
			percent = 0;
			delay = 0;
			TalkFrame = 2;
			while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			Movie = Movie + 1;
		}

		if (Movie == 8)
		{
			LookAtMonster(); 
			sPlay ("MON004.WAV");			
			percent = 0;
			delay = 0;
			TalkFrame = 2;
			while (GetPosition(Voice) < 1000000) { wait(1); }
			Movie = Movie + 1;
		}

		if (Movie == 9)
		{
			LookAtPiposh(); 
			sPlay ("PIP460.WAV");			
			percent = 0;
			delay = 0;
			TalkFrame = 2;
			while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			Movie = Movie + 1;
		}

		if (Movie == 10)
		{
			PanMe = 1;
			LookAtMonster(); 
			sPlay ("MON006.WAV");
			percent = 0;
			delay = 0;
			TalkFrame = 2;
			while (GetPosition(Voice) < 1000000) { wait(1); }
			Movie = Movie + 1;
		}

		if (Movie == 11)
		{
			LookAtPiposh(); 
			sPlay ("PIP461.WAV");			
			percent = 0;
			delay = 0;
			TalkFrame = 2;
			while (GetPosition(Voice) < 1000000) { Talk(); wait(1); }
			Movie = Movie + 1;
		}

		if (Movie == 12)
		{
			percent = 0;
			while (percent < 101)			// Animate Piposh throwing the phone hook away
			{
				my = player;
				player.skin = 1;
				ent_frame ("Hangup",percent);
				percent = percent + 15 * time;
				wait (1);
 				if percent > 100 { Hook.z = Hook.z - 1000; Movie = 13; }
			}
		}

		if (Movie == 13)
		{
			// Reset all properties and retun to game
			morph (<Piposh.mdl>,player);	// Return Piposh to his original model
			morph (<Pozsit.mdl>,Pozmak);	// Return Pozmak to her original model
			pozmak.skin = 1;
			player.x = PrevX;		// Restore Piposh's position from before the movie
			player.y = PrevY;
			player.z = PrevZ;
			CameraEnabled = 1;		// Enable CameraEngine to change Camera settings
			Movie = 0;			// Reset Movie flag
			MoviePlaying = 0;		// Movie has stopped
		}
}

function PipTalk
{
	delay = delay + 3 * time;
	if delay > 3 
	{
		TalkFrame = TalkFrame + 1;
		if TalkFrame > 6 { TalkFrame = 2; }
		delay = 0;
	}
	my = player;
	my.skin = TalkFrame;
	ent_frame ("Talk",((random(1) + 1) * 50));
	percent = percent + 3 * time;
	wait (1);
	if percent > 100 
	{ 
		LookAtPozmak();
		Movie = Movie + 1; 
	}
}

function PozTalk
{
	delay = delay + 3 * time;
	if delay > 3 
	{
		TalkFrame = TalkFrame + 1;
		if TalkFrame > 6 { TalkFrame = 2; }
		delay = 0;
	}
	my = pozmak;
	my.skin = TalkFrame;
	ent_frame ("Talk",((random(1) + 1) * 50));
	percent = percent + 3 * time;
	wait (1);
	if percent > 100 
	{ 
		LookAtPiposh();
		Movie = Movie + 1;
	}
}