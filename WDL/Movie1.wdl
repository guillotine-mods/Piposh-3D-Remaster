var CammyGo = 0;
var PanMe = 0;
Var AlreadyCalled = 0;

function LookAtPiposh
{
	CammyGo = 0;

	if ((int(random(2)) == 1) || (Movie == 11) || (Movie > 14) || (Movie < 2))
	{
		camera.x = 2139;		// Set the camera in a new position
		camera.y = -302;
		camera.z = -100;
		vec_set(temp,player.x);		// Set the camera to look at Piposh
		vec_sub(temp,camera.x);
		vec_to_angle(camera.pan,temp);
		camera.tilt = camera.tilt + 20;	// Move camera's tilt 20 quants up

		vec_set(temp,PiposhPhone);	// Set Piposh to look at the payphone
		vec_sub(temp,player.x);
		vec_to_angle(player.pan,temp);
	}
	else
	{
		camera.x = 2311;
		camera.y = -304;
		camera.z = -60;
		vec_set(temp,player.x);		// Set the camera to look at Piposh
		vec_sub(temp,camera.x);
		vec_to_angle(camera.pan,temp);

		vec_set(temp,camera.x);		// Set the camera to look at Piposh
		vec_sub(temp,player.x);
		vec_to_angle(player.pan,temp);

		player.tilt = 0;
		player.roll = 0;
	}
}

function LookAtPozmak
{
	camera.x = pozmak.x + 50;
	camera.y = pozmak.y - 50;
	camera.z = pozmak.z + 50;
	vec_set(temp,Pozmak.x);		// Set the camera to look at Pozmak
	vec_sub(temp,camera.x);
	vec_to_angle(camera.pan,temp);
}


ACTION Movie1
{
//*****************************************************************************************************
//* Movie number 1 - Piposh calls Pozmak on the payphone and tells her there is an emergency and that *
//* she has to let him into the asylum                                                                *
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
			Percent = 0;
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
			percent = 0;
			while (percent < 101)			// Animate Pozmak picking up the phone
			{
				my = Pozmak;
				my.skin = 1;
				ent_frame ("take",percent);
				percent = percent + 15 * time;
				wait (1);
				if percent > 60 { Hook.z = Hook.z + 1000; }
				if percent > 100
				{ 
					Movie = 3; 
				}
			}
		}

		if (Movie == 3)
		{
			LookAtPiposh(); 
			sPlay ("PIP462.WAV");
			percent = 0;
			delay = 0;
			TalkFrame = 2;
			while (GetPosition(Voice) < 1000000) { my = player; Talk(); wait(1); }
			Movie = Movie + 1;
		}

		if (AlreadyCalled == 1)
		{
			if (Movie == 4)
			{
				LookAtPozmak(); 
				sPlay ("POZ006.WAV");
				percent = 0;
				delay = 0;
				TalkFrame = 2;
				while (GetPosition(Voice) < 1000000) { my = pozmak; Talk(); wait(1); }
				Movie = 17;
			}
		}

		if (AlreadyCalled == 0)
		{
			if (Movie == 4)
			{
				LookAtPozmak(); 
				sPlay ("POZ001.WAV");
				percent = 0;
				delay = 0;
				TalkFrame = 2;
				while (GetPosition(Voice) < 1000000) { my = pozmak; Talk(); wait(1); }
				Movie = Movie + 1;
			}

			if (Movie == 5)
			{
				LookAtPiposh(); 
				sPlay ("PIP463.WAV");			
				percent = 0;
				delay = 0;
				TalkFrame = 2;
				while (GetPosition(Voice) < 1000000) { my = player; Talk(); wait(1); }
				Movie = Movie + 1;
			}

			if (Movie == 6)
			{
				LookAtPozmak(); 
				sPlay ("POZ002.WAV");
				percent = 0;
				delay = 0;
				TalkFrame = 2;
				while (GetPosition(Voice) < 1000000) { my = pozmak; Talk(); wait(1); }
				Movie = Movie + 1;
			}

			if (Movie == 7)
			{
				LookAtPiposh(); 
				sPlay ("PIP464.WAV");			
				percent = 0;
				delay = 0;
				TalkFrame = 2;
				while (GetPosition(Voice) < 1000000) { my = player; Talk(); wait(1); }
				Movie = Movie + 1;
			}

			if (Movie == 8)
			{
				LookAtPozmak(); 
				sPlay ("POZ003.WAV");
				percent = 0;
				delay = 0;
				TalkFrame = 2;
				while (GetPosition(Voice) < 1000000) { my = pozmak; Talk(); wait(1); }
				Movie = Movie + 1;
			}

			if (Movie == 9)
			{
				LookAtPiposh(); 
				sPlay ("PIP465.WAV");			
				percent = 0;
				delay = 0;
				TalkFrame = 2;
				while (GetPosition(Voice) < 1000000) { my = player; Talk(); wait(1); }
				Movie = Movie + 1;
			}

			if (Movie == 10)
			{
				DialogChoice = 0;
				DialogIndex = 52; 
				ShowDialog();
	
				while (Dialog.visible == on) { wait(1); }
	
				Movie = 11;
			}

			if (Movie == 11)
			{
				LookAtPiposh(); 
				if (DialogChoice == 1) { sPlay ("PIP466.WAV"); }
				if (DialogChoice == 2) { sPlay ("PIP467.WAV"); }
				if (DialogChoice == 3) { sPlay ("PIP468.WAV"); }
				percent = 0;
				delay = 0;
				TalkFrame = 2;
				while (GetPosition(Voice) < 1000000) { my = player; Talk(); wait(1); }
				Movie = Movie + 1;
			}

			if (Movie == 12)
			{
				LookAtPozmak(); 
				sPlay ("POZ004.WAV");
				percent = 0;
				delay = 0;
				TalkFrame = 2;
				while (GetPosition(Voice) < 1000000) { my = pozmak; Talk(); wait(1); }
				Movie = Movie + 1;
			}

			if (Movie == 13)
			{
				LookAtPiposh(); 
				sPlay ("PIP469.WAV");			
				percent = 0;
				delay = 0;
				TalkFrame = 2;
				while (GetPosition(Voice) < 1000000) { my = player; Talk(); wait(1); }
				Movie = Movie + 1;
			}

			if (Movie == 14)
			{
				LookAtPozmak(); 
				sPlay ("POZ005.WAV");
				percent = 0;
				delay = 0;
				TalkFrame = 2;
				while (GetPosition(Voice) < 1000000) { my = pozmak; Talk(); wait(1); }
				Movie = Movie + 1;
			}

			if (Movie == 15)
			{
				LookAtPiposh(); 
				sPlay ("PIP470.WAV");			
				percent = 0;
				delay = 0;
				TalkFrame = 2;
				while (GetPosition(Voice) < 1000000) { my = player; Talk(); wait(1); }
				Movie = Movie + 1;
			}

			if (Movie == 16)
			{
				LookAtPiposh(); 
				sPlay ("PIP499.WAV");			
				percent = 0;
				delay = 0;
				TalkFrame = 2;
				while (GetPosition(Voice) < 1000000) 
				{
					my = player; 
					ent_frame ("Shout",0);
					my.skill11 = my.skill11 + 1 * time;
					if (my.skill11 > 1.5) { my.skin = int(random(8))+1; my.skill11 = 0; }
					wait(1); 
				}
				Movie = Movie + 1;
			}
		}

		if (Movie == 17)
		{
			LookAtPiposh(); 
			percent = 0;
			while (percent < 101)			// Animate Piposh throwing the phone hook away
			{
				my = player;
				player.skin = 1;
				ent_frame ("Hangup",percent);
				percent = percent + 15 * time;
				wait (1);
 				if percent > 100 { Hook.z = Hook.z - 1000; Movie = 18; }
			}
		}

		if (Movie == 18)
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
			AlreadyCalled = 1;
			Done1 = 1;
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