//*********************************************************
//*                   Afgan cards system                  *
//*********************************************************

var AFG[32] = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;

entity AFG_Show
{
	type = <LeCards.mdl>;
	layer = 20;
	view = camera;
	x = 200;
	y = -4;
	z = -10;
	pan = -90;
	ambient = 100;
}

action AFG_Take
{
	AFG[my.skill1] = 1;
	WriteGameData(0);

	AFG_Show.skin = my.skill1;

	remove (my);

	AFG_Show.tilt = random(20) - 10;

	AFG_Show.visible = on;
	AFG_Show.alpha = 100;

	waitt (60);

	AFG_Show.transparent = on;
	
	while(AFG_Show.alpha > 3) { AFG_Show.alpha = AFG_Show.alpha - 3 * time; wait(1); }

	AFG_Show.alpha = 0;
	AFG_Show.visible = off;
}

function AFGremove { remove (my); }

action AFG_Card
{
	my.passable = on;

	my.event = AFG_Take;
	my.enable_click = on;

	while (1)
	{
		if (AFG[my.skill1] == 1) { AFGremove(); }	// Player has this card
		wait(1);
	}
}