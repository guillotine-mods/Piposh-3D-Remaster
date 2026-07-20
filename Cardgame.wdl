include <IO.wdl>;

bmap bPoker1 = <PokrPNL1.bmp>;
bmap bPoker2 = <PokrPNL2.pcx>;
bmap bPoker1A = <PokrPNLL.bmp>;
bmap bPoker1B = <PokrPNLP.bmp>;
string stringtemp;

var Talking = 0;

synonym P1C1 { type entity; }	// Player 1 hand
synonym P1C2 { type entity; }
synonym P1C3 { type entity; }
synonym P1C4 { type entity; }
synonym P1C5 { type entity; }

synonym P2C1 { type entity; }	// Player 2 hand
synonym P2C2 { type entity; }
synonym P2C3 { type entity; }
synonym P2C4 { type entity; }
synonym P2C5 { type entity; }

synonym P3C1 { type entity; }	// Player 3 hand
synonym P3C2 { type entity; }
synonym P3C3 { type entity; }
synonym P3C4 { type entity; }
synonym P3C5 { type entity; }

synonym P4C1 { type entity; }	// Player 4 hand
synonym P4C2 { type entity; }
synonym P4C3 { type entity; }
synonym P4C4 { type entity; }
synonym P4C5 { type entity; }

synonym Deck { type entity; }

sound CardFlip = <SFX005.WAV>;
sound Slurp = <SFX006.WAV>;
sound BGMusic = <SNG029.WAV>;
sound Ambient = <SFX061.WAV>;

sound SFX015 = <SFX015.WAV>;
sound SFX017 = <SFX017.WAV>;
sound SFX018 = <SFX018.WAV>;
sound SFX030 = <SFX030.WAV>;

sound CheatSound = <SFX035.WAV>;

var SND1 = 0;
var SND2 = 0;

var ShkFly = 0;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing vars.
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode

string txt1a = "                                                        ";
string txt2a = "                                                        ";
string txt3a = "                                                        ";
string txt4a = "                                                        ";
string txt5a = "                                                        ";
string txt6a = "                                                        ";
string txt7a = "                                                        ";
string txt8a = "                                                        ";

string txt1b = "                                                        ";
string txt2b = "                                                        ";
string txt3b = "                                                        ";
string txt4b = "                                                        ";
string txt5b = "                                                        ";
string txt6b = "                                                        ";
string txt7b = "                                                        ";
string txt8b = "                                                        ";

string txt1c = "                                                        ";
string txt2c = "                                                        ";
string txt3c = "                                                        ";
string txt4c = "                                                        ";
string txt5c = "                                                        ";
string txt6c = "                                                        ";
string txt7c = "                                                        ";
string txt8c = "                                                        ";

string txt1d = "                                                        ";
string txt2d = "                                                        ";
string txt3d = "                                                        ";
string txt4d = "                                                        ";
string txt5d = "                                                        ";
string txt6d = "                                                        ";
string txt7d = "                                                        ";
string txt8d = "                                                        ";

string cheatstring = "                                    ";

string Summ = "                                                        ";

var FinalScore1;
var FinalScore2;
var FinalScore3;
var FinalScore4;

var Shake;

var Scene = 0;

var N = 0;
var ResultN = 0;
var HandScore[5] = 0,0,0,0,0;
var Cheat1 = 0;

var Piposh = 0;
var Shik = 0;
var Nanny = 0;
var Rogale = 0;

var Who = 0;
var What = 0;

var Sorted[6] = 0,0,0,0,0,0;

var Hand1[6] = 0,0,0,0,0,0;	// Players hand numbers
var Hand2[6] = 0,0,0,0,0,0;
var Hand3[6] = 0,0,0,0,0,0;
var Hand4[6] = 0,0,0,0,0,0;

var Type1[6] = 0,0,0,0,0,0;	// Players hand signs
var Type2[6] = 0,0,0,0,0,0;
var Type3[6] = 0,0,0,0,0,0;
var Type4[6] = 0,0,0,0,0,0;

string Summ = "                                                                       ";

var Sam1 = 0;
var Sam2 = 0;
var Sam3 = 0;

var Lone1 = 0;
var Lone2 = 0;
var Lone3 = 0;
var Cheat1 = 0;

var LastScore = 0;
var TestDBG = 0;
var Ponys = 0;
var Aligators = 0;
var TibatianBeasts = 0;
var CombinationFound = 0;
var Same1[15] = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
var Same2[15] = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
var Same3[15] = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
var Same4[15] = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;

var NumPonys[5] = 0,0,0,0,0;
var NumAligators[5] = 0,0,0,0,0;
var NumTBs[5] = 0,0,0,0,0;
var Unique[5] = 0,0,0,0,0;

var Amount = 0;
var HandTemp = 0;
var filehandle;
var FullDeck = 0;
var Smallest = 0;
var Largest = 0;
var Flush = 0;
var Winner = 0;
var CamShow = 0;

var PiposhWinLose = 0;

string FileString = "                                             ";
var FileVar = 0;
string HandX = " ";
string Card1 = " ";
var Hand = 0;
var Card = 0;
var Counter = 0;
var InGame = 0;
string Data = "  ";
String Data1 = "  ";
string Data2 = "  ";

panel GUI
{
	bmap = bPoker1;
	pos_x = 0;
	layer = 2;
	flags = refresh,d3d,overlay;

	button = 0, 0, bPoker1B, bPoker1, bPoker1A, InfoOpen, InfoClose, null;
}

panel PanelScore
{
	pos_x = 0;
	layer = 3;
	flags = refresh,d3d,overlay;
 	digits 10,40,5,standard_font,1,FinalScore1;
 	digits 10,100,5,standard_font,1,FinalScore2;
	digits 10,160,5,standard_font,1,FinalScore3;
 	digits 10,220,5,standard_font,1,FinalScore4;
}


include <Cards.wdl>;

text K1
{
	layer = 3;
	pos_x = 70;
	pos_y = 15;
	font = standard_font;
	strings = 10;
	flags = d3d;
}

text K2
{
	layer = 3;
	pos_x = 70;
	pos_y = 70;
	font = standard_font;
	strings = 10;
	flags = d3d;
}

text K3
{
	layer = 3;
	pos_x = 70;
	pos_y = 135;
	font = standard_font;
	strings = 10;
	flags = d3d;
}

text K4
{
	layer = 3;
	pos_x = 70;
	pos_y = 195;
	font = standard_font;
	strings = 10;
	flags = d3d;
}

action InfoOpen
{
	GUI.bmap = bPoker2;
	ShowSummary();
}

action InfoClose
{
	GUI.bmap = bPoker1;
	HideSummary();
}

action LightMe
{
	GUI.bmap = bPoker1A;
}

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
function main()
{
	wait(3);

	varLevelID = _MANSION;

	PiposhWinLose = 0;

	warn_level = 0;	// announce bad texture sizes and bad wdl code
	tex_share = on;	// map entities share their textures
	mouse_range = 8000;

	load_level(<Cardgame.WMB>); 

	VoiceInit();
	Initialize();

	Winner = 0;

	Piposh = 0;
	Shik = 0;
	Nanny = 0;
	Rogale = 0;

	Cheat1 = 0;

	Finalscore1 = 0;
	Finalscore2 = 0;
	Finalscore3 = 0;
	Finalscore4 = 0;

	PiposhWinLose = 0;

	while (total_frames == 0) { wait(1); }	// Wait until engine has done loading level and has started running

	play_loop (BGMusic,20); SND1 = result;
	play_loop (Ambient,20); SND2 = result;

	sPlay ("MSC006.WAV");
}

action DefineMe
{
	player = my;
}

action pipDrunk
{
	my.invisible = on;

	while(1)
	{
		if (PiposhWinLose == 0) { my.invisible = on; }
		if (PiposhWinLose == -1) { my.invisible = off; Talk(); }
		if (PiposhWinLose == -2) 
		{ 
			my.z = my.z - 50 * time; my.skill8 = my.skill8 + 1 * time; 
			if (my.skill8 > 10) { PiposhWinLose = -3; Shake = 10; }
		}
		
		wait(1);
	}
}

action Chand
{
	while(1)
	{
		if (PiposhWinLose == -2) 
		{ 
			my.z = my.z - 50 * time; 
		}

		wait(1);
	}
}

action Sleep
{
	my.invisible = on;
	my.passable = on;

	while(1)
	{
		if (PiposhWinLose == 1) { my.invisible = off; } else { my.invisible = on; }

		if ((CamShow > 1) && (my.flag1 == on)) { my.invisible = on; my.shadow = off; }
		if (my.flag1 == on) { talk(); }
		if (my.flag2 == on)
		{
			if (Scene == 2) { Talk(); } else { my.skin = 1; }
		}

		if (my.flag3 == on)
		{
			if (ShkFly == 1)
			{
				if (my.skill39 == 0 ) { play_sound (SFX017,100); my.skill39 = 1; }
				ent_frame ("Fly",my.skill20);
				my.skill20 = my.skill20 + 10 * time;
			}
		}

		wait(1);
	}
}

action MyCamera
{
	vec_set(temp,deck.x);
	vec_sub(temp,camera.x);
	vec_to_angle(camera.pan,temp);
	wait(1);

	while(PiposhWinLose == 0)
	{
		if (player == null) { wait(1); }
		camera.x = my.x;
		camera.y = my.y;
		camera.z = my.z;
		player.x = camera.x;
		player.y = camera.y;
		player.z = camera.z;

		wait(1);
	}

	stop_sound (SND1);
	stop_sound (SND2);
}

action CamLose
{
	my.skill10 = my.z;

	while(1)
	{
		my.z = my.skill10;

		if (PiposhWinLose == -3)
		{
			if (my.skill40 == 0) { sPlay ("SFX141.WAV"); my.skill40 = 1; }
			if (Shake > 0) { Shake = Shake - 1 * time; my.z = my.z + ((int(random(3)) - 1) * 20) * time; } else { PiposhWinLose = -4; }
		}

		if (PiposhWinLose < 0)
		{	
			HideSummary();
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

action CamWin
{
	while(1)
	{
		if (PiposhWinLose > 0)
		{
			if (my.flag1 == on)
			{
				vec_set(temp,player.x);
				vec_sub(temp,my.x);
				vec_to_angle(my.pan,temp);
			}

			if (CamShow == my.skill1)
			{
				HideSummary();
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

action CardClicked
{
	if (my.skill1 != 1) { msg.string = "WLU ZLSE AL EG !JE"; show_message(); }

	else
	{
		if (my.unlit == on) { my.unlit = off; } else { my.unlit = on; }
	}
	
}

action DefineCard
{
	my.enable_click = on;
	my.event = CardClicked;
	my.ambient = 60;
	my.unlit = on;

	if (my.skill1 == 1)
	{
		if (my.skill2 == 1) { P1C1 = my; }
		if (my.skill2 == 2) { P1C2 = my; }
		if (my.skill2 == 3) { P1C3 = my; }
		if (my.skill2 == 4) { P1C4 = my; }
		if (my.skill2 == 5) { P1C5 = my; }
	}

	if (my.skill1 == 2)
	{
		if (my.skill2 == 1) { P2C1 = my; }
		if (my.skill2 == 2) { P2C2 = my; }
		if (my.skill2 == 3) { P2C3 = my; }
		if (my.skill2 == 4) { P2C4 = my; }
		if (my.skill2 == 5) { P2C5 = my; }
	}

	if (my.skill1 == 3)
	{
		if (my.skill2 == 1) { P3C1 = my; }
		if (my.skill2 == 2) { P3C2 = my; }
		if (my.skill2 == 3) { P3C3 = my; }
		if (my.skill2 == 4) { P3C4 = my; }
		if (my.skill2 == 5) { P3C5 = my; }
	}

	if (my.skill1 == 4)
	{
		if (my.skill2 == 1) { P4C1 = my; }
		if (my.skill2 == 2) { P4C2 = my; }
		if (my.skill2 == 3) { P4C3 = my; }
		if (my.skill2 == 4) { P4C4 = my; }
		if (my.skill2 == 5) { P4C5 = my; }
	}
}

function SelectCard (Data)
//*******************************************************//
//* 	    Randomize a card for a certain hand         *//
//*******************************************************//
{
	str_cpy (Data1,Data);
	str_cpy (Data2,Data);

	str_trunc (Data1,1);
	str_cpy (HandX,Data1);
	Hand = str_to_num(HandX);

	str_clip (Data2, 1);
	str_cpy (Card1,Data2);
	Card = str_to_num(Card1);

	if (Hand == 1) { Hand1[Card] = int(random(14))+1; Type1[Card] = int(random(3))+1; }
	if (Hand == 2) { Hand2[Card] = int(random(14))+1; Type2[Card] = int(random(3))+1; }
	if (Hand == 3) { Hand3[Card] = int(random(14))+1; Type3[Card] = int(random(3))+1; }
	if (Hand == 4) { Hand4[Card] = int(random(14))+1; Type4[Card] = int(random(3))+1; }

	ShowCard();

	Deck.z = Deck.z - 1;
}

action Deal
{
	if (Piposh >= 5) { return; }
	if (InGame == 0) { Winner = 0; DealAll(); HideSummary(); }			// New deal
	else { if (InGame == 1) { InGame = 0; ReplaceCards(); UpdateSummary(); } } 	// Replace cards
}

action DefineDeck
{
	Deck = my;
	FullDeck = my.z;
	my.event = Deal;
	my.enable_click = on;

	HideAll();
}

action Picture
{
	my.skin = int(random(12)) + 1;
}

function FindSmallest()
{
	Card = 1;
	Smallest = 20;

	//Find the smallest member
	while (Card < 6)
	{
		if (Counter == 1) { if (Hand1[Card] < Smallest) { Smallest = Hand1[Card]; } }
		if (Counter == 2) { if (Hand2[Card] < Smallest) { Smallest = Hand2[Card]; } }
		if (Counter == 3) { if (Hand3[Card] < Smallest) { Smallest = Hand3[Card]; } }
		if (Counter == 4) { if (Hand4[Card] < Smallest) { Smallest = Hand4[Card]; } }
		Card = Card + 1;
	}
}

function FindLargest()
{
	Card = 1;
	Largest = 0;

	//Find the largest member
	while (Card < 6)
	{
		if (Counter == 1) { if (Hand1[Card] > Largest) { Largest = Hand1[Card]; } }
		if (Counter == 2) { if (Hand2[Card] > Largest) { Largest = Hand2[Card]; } }
		if (Counter == 3) { if (Hand3[Card] > Largest) { Largest = Hand3[Card]; } }
		if (Counter == 4) { if (Hand4[Card] > Largest) { Largest = Hand4[Card]; } }
		Card = Card + 1;
	}
}

function AI()
/**********************************************************************************\
*                                                                                  * 
* This is where the computer opponents decide which cards to keep and which cards  *
* to replace by doing a number of priority calculations and other boring stuff     *
*                                                                                  * 
\**********************************************************************************/
{

	ClearArrays();	// Clears previously calculated hand information
	CountCards();
	CountNumbers();

	Counter = 2;

	while (Counter < 5)
	{

//***************************************************************************************************************************************

	// Lets see if we have a flush or a near flush

	Card = 1;
	
	SortCards(Counter);	// Sort the card array

	Card = 1;
	Flush = 1;

	while (Card < 5)	// After we have sorted the array, lets count how many consecutive numbers we have
	{
		if (Sorted[Card] == (Sorted[Card + 1] - 1))
		{ 
			Flush = Flush + 1; 
		}
		else
		{
			if (Sorted[1] == (Sorted[2] - 1)) { CombinationFound = Sorted[5]; } else { CombinationFound = Sorted[1]; }
		}
		Card = Card + 1;
	}

	if (Flush == 5) { HoldAllCards (Counter); }	// We have a flush, hold all cards!

	if (Flush == 4)
	{
		HoldAllCards(Counter);
		ScanAndDiscard (CombinationFound);	// Discard the card that does not match the flush
	}

	if (Flush < 4)					// We are too far away from a flush, lets see what else we got
	{

		// If we have a full herd, hold all cards
		if (Counter == 2) { if (Type2[1] == Type2[2] == Type2[3] == Type2[4] == Type2[5]) { HoldAllCards (Counter); } }
		if (Counter == 3) { if (Type3[1] == Type3[2] == Type3[3] == Type3[4] == Type3[5]) { HoldAllCards (Counter); } }
		if (Counter == 4) { if (Type4[1] == Type4[2] == Type4[3] == Type4[4] == Type4[5]) { HoldAllCards (Counter); } }


		// Lets see how many cards of the same number we've got, we will hold multiple cards greater than 5 (or more than 3 cards of lower value)

		Hand = 1;
		while (Hand < 15)
		{
			if (Counter == 2) { if (Same2[Hand] > 1) { ScanAndHold (Hand); } }
			if (Counter == 3) { if (Same3[Hand] > 1) { ScanAndHold (Hand); } }
			if (Counter == 4) { if (Same4[Hand] > 1) { ScanAndHold (Hand); } }
			Hand = Hand + 1;
		}

// Finally, lets hold Tibetian beast cards, if there is only one card, hold it, if there is more than one, hold them only if we are not holding Ponys

		if (NumTBs[Counter] == 1) { HoldTBs(); }
		if (NumTBs[Counter] > 1)
		{
			Flush = 0;
			Hand = 1;
			while (Hand < 6)
			{
				if (Counter == 2)
				{
					if (Type2[Hand] == 1)
					{
						if (Hand == 1) { if (P2C1.unlit == off) { Flush = 1; } }
						if (Hand == 2) { if (P2C2.unlit == off) { Flush = 1; } }
						if (Hand == 3) { if (P2C3.unlit == off) { Flush = 1; } }
						if (Hand == 4) { if (P2C4.unlit == off) { Flush = 1; } }
						if (Hand == 5) { if (P2C5.unlit == off) { Flush = 1; } }
					}
				}

				if (Counter == 3)
				{
					if (Type3[Hand] == 1)
					{
						if (Hand == 1) { if (P3C1.unlit == off) { Flush = 1; } }
						if (Hand == 2) { if (P3C2.unlit == off) { Flush = 1; } }
						if (Hand == 3) { if (P3C3.unlit == off) { Flush = 1; } }
						if (Hand == 4) { if (P3C4.unlit == off) { Flush = 1; } }
						if (Hand == 5) { if (P3C5.unlit == off) { Flush = 1; } }
					}
				}

				if (Counter == 4)
				{
					if (Type4[Hand] == 1)
					{
						if (Hand == 1) { if (P4C1.unlit == off) { Flush = 1; } }
						if (Hand == 2) { if (P4C2.unlit == off) { Flush = 1; } }
						if (Hand == 3) { if (P4C3.unlit == off) { Flush = 1; } }
						if (Hand == 4) { if (P4C4.unlit == off) { Flush = 1; } }
						if (Hand == 5) { if (P4C5.unlit == off) { Flush = 1; } }
					}
				}

				Hand = Hand + 1;
			}

			if (Flush == 0) { HoldTBs(); }	// We can safetly hold them now
		}


	}

//***************************************************************************************************************************************
	Counter = Counter + 1;
	}
}

function Debugy
{
	filehandle = file_open_append ("Debug.txt");
	file_var_write (filehandle,Sorted[1]);
	file_var_write (filehandle,Sorted[2]);
	file_var_write (filehandle,Sorted[3]);
	file_var_write (filehandle,Sorted[4]);
	file_var_write (filehandle,Sorted[5]);
	file_close (filehandle);
}

function ShowSummary
{
	K1.visible = on;
	K2.visible = on;
	K3.visible = on;
	K4.visible = on;
}

function HideSummary
{
	K1.visible = off;
	K2.visible = off;
	K3.visible = off;
	K4.visible = off;
}

action Mug { my.alpha = 80; }

function UpdateSummary
{
	exclusive_global;

	Card = 2;

	Hand = 2;

	filehandle = file_open_read ("Results1.dat");

	file_str_read (filehandle,txt1a); k1.string[2] = txt1a;
	file_str_read (filehandle,txt2a); k1.string[3] = txt2a;
	file_str_read (filehandle,txt3a); k1.string[4] = txt3a;
	file_str_read (filehandle,txt4a); k1.string[5] = txt4a;
	file_str_read (filehandle,txt5a); k1.string[6] = txt5a;
	file_str_read (filehandle,txt6a); k1.string[7] = txt6a;
	file_str_read (filehandle,txt7a); k1.string[8] = txt7a;
	file_str_read (filehandle,txt8a); k1.string[9] = txt8a;

	file_close (filehandle);

	filehandle = file_open_read ("Results2.dat");

	file_str_read (filehandle,txt1b); k2.string[2] = txt1b;
	file_str_read (filehandle,txt2b); k2.string[3] = txt2b;
	file_str_read (filehandle,txt3b); k2.string[4] = txt3b;
	file_str_read (filehandle,txt4b); k2.string[5] = txt4b;
	file_str_read (filehandle,txt5b); k2.string[6] = txt5b;
	file_str_read (filehandle,txt6b); k2.string[7] = txt6b;
	file_str_read (filehandle,txt7b); k2.string[8] = txt7b;
	file_str_read (filehandle,txt8b); k2.string[9] = txt8b;

	file_close (filehandle);

	filehandle = file_open_read ("Results3.dat");

	file_str_read (filehandle,txt1c); k3.string[2] = txt1c;
	file_str_read (filehandle,txt2c); k3.string[3] = txt2c;
	file_str_read (filehandle,txt3c); k3.string[4] = txt3c;
	file_str_read (filehandle,txt4c); k3.string[5] = txt4c;
	file_str_read (filehandle,txt5c); k3.string[6] = txt5c;
	file_str_read (filehandle,txt6c); k3.string[7] = txt6c;
	file_str_read (filehandle,txt7c); k3.string[8] = txt7c;
	file_str_read (filehandle,txt8c); k3.string[9] = txt8c;

	file_close (filehandle);

	filehandle = file_open_read ("Results4.dat");

	file_str_read (filehandle,txt1d); k4.string[2] = txt1d;
	file_str_read (filehandle,txt2d); k4.string[3] = txt2d;
	file_str_read (filehandle,txt3d); k4.string[4] = txt3d;
	file_str_read (filehandle,txt4d); k4.string[5] = txt4d;
	file_str_read (filehandle,txt5d); k4.string[6] = txt5d;
	file_str_read (filehandle,txt6d); k4.string[7] = txt6d;
	file_str_read (filehandle,txt7d); k4.string[8] = txt7d;
	file_str_read (filehandle,txt8d); k4.string[9] = txt8d;

	file_close (filehandle);

	if ((HandScore[1] > HandScore[2]) && (HandScore[1] > HandScore[3]) && (HandScore[1] > HandScore[4]))
	{
		Winner = 1;

		if (Piposh > 0) { Piposh = Piposh - 1; }

		Shik = Shik + 1;
		Rogale = Rogale + 1;
		Nanny = Nanny + 1;
	}

	if ((HandScore[2] > HandScore[1]) && (HandScore[2] > HandScore[3]) && (HandScore[2] > HandScore[4]))
	{
		Winner = 2;

		Piposh = Piposh + 1;
		Rogale = Rogale + 1;
		Nanny = Nanny + 1;
	}

	if ((HandScore[3] > HandScore[1]) && (HandScore[3] > HandScore[2]) && (HandScore[3] > HandScore[4]))
	{
		Winner = 3;

		Piposh = Piposh + 1;
		Shik = Shik + 1;
		Rogale = Rogale + 1;
	}

	if ((HandScore[4] > HandScore[1]) && (HandScore[4] > HandScore[2]) && (HandScore[4] > HandScore[3]))
	{
		Winner = 4;

		Piposh = Piposh + 1;
		Shik = Shik + 1;
		Nanny = Nanny + 1;
	}

	if (Piposh >= 5) { SayWin (Winner); while (Talking > 0) { wait(1); } panelscore.visible = off; GUI.visible = off; PiposhLoses(); return; }
	if ((Shik >= 5) && (Nanny >= 5) && (Rogale >= 5)) { panelscore.visible = off; GUI.visible = off; PiposhWins(); return; }

	SayWin (Winner);
	while (Talking > 0) { wait(1); }
	SayLose (Winner);
}

action NannyN
{
	my.skill1 = 1;
	while (1)
	{
		if (PiposhWinLose > 0) { my.invisible = on; my.shadow = off; }
		if (Talking == my.skill8) { Talk(); } else { Blink(); }
		if (Talking > 0) { if (GetPosition(Voice) >= 1000000) { Talking = 0; } }
		if (my.skill1 == 1) { ent_cycle ("Sit",my.skill2); }
		if (my.skill1 == 2) { ent_cycle ("Idle",my.skill2); }
		if ((Winner > 0) && (Winner == my.skill8)) { ent_cycle ("Win",my.skill2); }
		if ((Winner > 0) && (Winner != my.skill8)) { ent_cycle ("Lose",my.skill2); }
		my.skill2 = my.skill2 + 6 * time;
		if ((int(random(200)) == 100) && (my.skill1 == 1) && (Winner != my.skill8)) { my.skill1 = 2; my.skill2 = 0; }
		if ((my.skill2 > 100) && (my.skill1 == 2) && (Winner ==0)) { my.skill2 = 0; my.skill1 = 1; }
		wait(1);
	}
}

action Wine
{
	while(1)
	{
		if (my.skill2 > 3) { my.skin = my.skin + 1; my.skill2 = 0; }
		if (my.skin > 3) { my.skin = 1; }
		my.skill2 = my.skill2 + 1 * time;
		if (my.skill1 == 1) { ent_frame ("Step",piposh * 20); }
		if (my.skill1 == 2) { ent_frame ("Step",rogale * 20); }
		if (my.skill1 == 3) { ent_frame ("Step",nanny * 20); }
		if (my.skill1 == 4) { ent_frame ("Step",shik * 20); }
		wait(1);
	}
}

function cheat
{
	str_cpy (cheatstring,"");
	msg.string = cheatstring;
	msg.visible = on;
	inkey (cheatstring);

	if (str_cmpi (cheatstring,"Poker face") == 1) { msg.string = "cheat enabled"; show_message(); FlipAllCards (90); play_sound (CheatSound,100); }

	if (str_cmpi (cheatstring,"cards up my sleeve") == 1) 
	{ 
		msg.string = "cheat enabled"; 
		show_message(); 
		SelectCard ("11");
		SelectCard ("12");
		SelectCard ("13");
		SelectCard ("14");
		SelectCard ("15");

		deck.z = deck.z + 5;

		UpdateHands(); 

		play_sound (CheatSound,100);
	}

	if (str_cmpi (cheatstring,"power card") == 1) 
	{
		if (Cheat1 == 1) { msg.string = "Not Again!"; show_message(); }
		else
		{
			Cheat1 = 1;
			msg.string = "cheat enabled"; 
			show_message();

			temp = int(Random(5)) + 1;
		
			Type1[temp] = 4;
			Hand1[temp] = int(random(6)) + 1;

			UpdateHands();

			play_sound (CheatSound,100);
		}
	}

	str_cpy (cheatstring,"");
}

action WalkInCircle
{
	my._movemode = 1;
	my.passable = on;
	my.skill5 = 1;

	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path(my.x,temp);
	if (result == 0) { my._MOVEMODE = 0; }

	ent_waypoint(my._TARGET_X,1);

	while (my._MOVEMODE > 0)
	{
		if (PiposhWinLose > 0) { my.invisible = on; my.shadow = off; } else { my.invisible = off; my.shadow = on; }
		// find direction
		temp.x = MY._TARGET_X - MY.X;
		temp.y = MY._TARGET_Y - MY.Y;
		temp.z = 0;
		result = vec_to_angle(my_angle,temp);

		if (result < 25) { my.skill5 = my.skill5 + 1; ent_nextpoint(my._TARGET_X); }
		if (my.skill5 > 15) { my.skill5 = 1; }

		force = 1;
		actor_turnto(my_angle.PAN);
		force = 2;
		actor_move();

		if ((my.skill5 == 1) || (my.skill5 == 2))
		{
			ent_cycle ("Salute",my.skill1);
			my.skill1 = my.skill1 + 5 * time;
		}
		else
		{
			ent_cycle ("Walk",my.skill1);
			my.skill1 = my.skill1 + 5 * time;
		}


		wait(1);
	}
}

on_tab = cheat;

function SayLose (TheWinner)
{
	Who = TheWinner;

	while (Who == TheWinner) { Who = int(random(4)) + 1; }
	What = int(random(3)) + 1;

	if (Who == 1)
	{
		if (What == 1) { sPlay ("PIP437.WAV"); }
		if (What == 2) { sPlay ("PIP438.WAV"); }
		if (What == 3) { sPlay ("PIP439.WAV"); }
	}

	if (Who == 2)
	{
		if (What == 1) { sPlay ("SHK057.WAV"); }
		if (What == 2) { sPlay ("SHK058.WAV"); }
		if (What == 3) { sPlay ("SHK059.WAV"); }
	}

	if (Who == 3)
	{
		if (What == 1) { sPlay ("NAN032.WAV"); }
		if (What == 2) { sPlay ("NAN033.WAV"); }
		if (What == 3) { sPlay ("NAN034.WAV"); }
	}

	if (Who == 4)
	{
		if (What == 1) { sPlay ("ROG020.WAV"); }
		if (What == 2) { sPlay ("ROG021.WAV"); }
		if (What == 3) { sPlay ("ROG022.WAV"); }
	}

	Talking = Who;
}

function SayWin (TheWinner)
{
	What = int(random(3)) + 1;

	if (TheWinner == 1)
	{
		if (What == 1) { sPlay ("PIP434.WAV"); }
		if (What == 2) { sPlay ("PIP435.WAV"); }
		if (What == 3) { sPlay ("PIP436.WAV"); }
	}

	if (TheWinner == 2)
	{
		if (What == 1) { sPlay ("SHK060.WAV"); }
		if (What == 2) { sPlay ("SHK062.WAV"); }
		if (What == 3) { sPlay ("SHK063.WAV"); }
	}

	if (TheWinner == 3)
	{
		if (What == 1) { sPlay ("NAN035.WAV"); }
		if (What == 2) { sPlay ("NAN036.WAV"); }
		if (What == 3) { sPlay ("NAN030.WAV"); }
	}

	if (TheWinner == 4)
	{
		if (What == 1) { sPlay ("ROG023.WAV"); }
		if (What == 2) { sPlay ("ROG024.WAV"); }
		if (What == 3) { sPlay ("ROG025.WAV"); }
	}

	Talking = TheWinner;
}

function PiposhWins
{
	PiposhWinLose = 1;
	CamShow = 1;

	sPlay ("PIP440.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }

	CamShow = 2;
	Scene = 1;

	while (CamShow == 2) { wait(1); }

	CamShow = 3;
	Scene = 1;

	sPlay ("MAR029.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }

	CamShow = 4;
	Scene = 2;

	sPlay ("NAN039.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }

	CamShow = 5;
	Scene = 1;

	sPlay ("MAR030.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }

	CamShow = 6;
	Scene = 3;

	sPlay ("KVC034.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }

	play_sound (SFX030,100);
	CamShow = 7;
	Scene = 44;

	sPlay ("PIP442.WAV");
	while (CamShow == 7) { wait(1); }

	Scene = 1;
	play_sound (SFX018,100);

	sPlay ("MAR033.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }

	CamShow = 8;
	Scene = 10;

	waitt (8);

	Scene = 0;
	play_sound (SFX030,100);

	sPlay ("PIP443.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }

	play_sound (SFX018,100);

	Scene = 10;
	waitt (8);

	CamShow = 20;

	sPlay ("YCH018.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }

	Scene = 11;

	sPlay ("SHK064.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }

	Scene = 12;

	sPlay ("SHK065.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }

	sPlay ("YCH019.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }

	Mansion[1] = 1;
	WriteGameData (0);

	Run ("Final.exe");
}

action Doory
{
	my.skill40 = my.pan;

	while(1)
	{
		if (Scene == 44) { my.pan = my.skill40 - 90; } else { my.pan = my.skill40; }
		if (CamShow == 8) { my.pan = my.skill40 - 15; }
		if (Scene == 10) { my.pan = my.skill40; }
		wait(1);
	}
}

function PiposhLoses
{
	PiposhWinLose = -1;
	sPlay ("PIP441.WAV");
	while (GetPosition(Voice) < 1000000) { wait(1); }
	PiposhWinLose = -2;
	while (PiposhWinLose != -4) { wait(1); }
	
	main();
}

action Bad1
{
	my.skill1 = my.x;
	my.x = my.x - 500;

	while(1)
	{
		if (CamShow == 2)
		{
			if (Scene == 1)
			{ 
				if (my.x < my.skill1)
				{
					my.x = my.x + 8 * time; 
					ent_cycle ("Push",my.skill2);
					my.skill2 = my.skill2 + 10 * time;
				}
				else { Scene = 2; }
			}

			if (Scene == 2) { ent_frame ("Stand",0); Blink(); }

			if (Scene == 4)
			{ 
				my.x = my.x + 8 * time; 
				ent_cycle ("Push",my.skill2);
				my.skill2 = my.skill2 + 10 * time;
			}
		}

		wait(1);
	}
}

action Bad2
{
	while(1)
	{
		if (CamShow == 2)
		{
			if (Scene == 2)
			{
				ent_frame ("Peek",my.skill1);
				my.skill1 = my.skill1 + 3 * time;
				if (my.skill1 > 100) { Scene = 3; }
			}

			if ((Scene == 3) || (Scene == 4))
			{
				my.skill10 = my.skill10 + 1 * time;
				if (my.skill10 > 30) { ent_frame ("StandLeft",0); } else { ent_frame ("StandFront",0); }
				Blink();
			}
		}

		wait(1);
	}
}

action Yachdal
{
	while(1)
	{
		if (CamShow == 2)
		{
			if (my.skill40 == 0) { sPlay ("YCH006.WAV"); my.skill40 = 1; }
			if (GetPosition(Voice) < 1000000) { talk2(); }
			if (Scene == 3) 
			{ 
				if (my.skill39 == 0 ) { play_sound (SFX015,100); my.skill39 = 1; }
				ent_frame ("Ouch",my.skill1); my.skill1 = my.skill1 + 20 * time; if (my.skill1 > 100) { Scene = 4; }
			}
			if (Scene == 4) { my.invisible = on; my.shadow = off; }
			Blink();
		}

		wait(1);
	}
}

action Yachdal2
{
	while(1)
	{
		ent_cycle ("Scream",my.skill1);
		my.skill1 = my.skill1 + 20 * time;
		
		if (Scene == 4)
		{
			my.invisible = off;
			my.shadow = on;
			my.x = my.x + 8 * time;

			my.skill10 = my.skill10 + 1 * time;
			if (my.skill10 > 50) { CamShow = 0.5; }
		}

		wait(1);
	}
}

action X1
{
	while(1)
	{
		if (PiposhWinLose > 0) { if (CamShow > 2) { my.invisible = off; my.shadow = on; } }
		if (Scene == 3) { Talk(); } else { ent_frame ("Stand",0); Blink(); }
		wait(1);
	}
}

action X2
{
	while(1)
	{
		if (PiposhWinLose > 0) { if (CamShow > 2) { my.invisible = off; my.shadow = on; } }
		if (Scene == 1) { Talk(); } else { ent_frame ("Stand",0); Blink(); }
		wait(1);
	}
}

action X3
{
	my.skill40 = my.pan;

	while(1)
	{
		if (PiposhWinLose > 0) { if (CamShow > 2) { if (Scene > 3) { my.invisible = off; my.shadow = on; player = my; }	} }
		if (Scene == 44) 
		{ 
			if (GetPosition (Voice) < 1000000)
			{
				my.skill45 = my.skill45 + 1 * time;
				if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
			}
			else
			{
				Blink();
			}

			if (my.skill2 < 27)
			{
				ent_cycle ("Run",my.skill1);
				my.skill1 = my.skill1 + 10 * time;

				my.x = my.x - 20 * time;
				my.y = my.y + 6 * time;

				my.skill2 = my.skill2 + 1 * time;
			}

			else
			{
				if (my.skill3 < 100)
				{
					ent_frame ("FKick",my.skill3);
					my.skill3 = my.skill3 + 7 * time;
					if (my.skill3 > 80) { ShkFly = 1; }
				}
				else
				{
					my.pan = my.skill40 + 180;

					ent_cycle ("Run",my.skill1);
					my.skill1 = my.skill1 + 10 * time;

					my.x = my.x + 20 * time;
					my.y = my.y - 6 * time;

					my.skill2 = my.skill2 + 1 * time;

					if (my.skill2 > 50) { CamShow = 5; my.invisible = on; my.shadow = off; }
				}
			}

		}

		wait(1);
	}
}

action X4
{
	while(1)
	{
		if (PiposhWinLose > 0) { if (CamShow > 2) { if (CamSHow == 8) { my.invisible = off; my.shadow = on; } } }
		Talk();
		if (Scene == 10) { my.invisible = on; my.shadow = off; }
		wait(1);
	}
}

action t1
{
	while(1)
	{
		if (CamShow == 20)
		{
			ent_cycle ("Run",my.skill2);
			my.skill2 = my.skill2 + 8 * time;
			my.x = my.x + 8 * time;
		}
		
		wait(1);
	}
}

action t2
{
	my.skill40 = my.pan;
	my.skill10 = my.x;
	my.x = my.x - 600;

	while(1)
	{
		if (CamShow == 20)
		{
			if (Scene == 11)
			{
				if (my.x < my.skill10)
				{
					ent_cycle ("Run",my.skill1);
					my.skill1 = my.skill1 + 8 * time;
					my.x = my.x + 8 * time;
					my.skill45 = my.skill45 + 1 * time;
					if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
				}
				else
				{
					my.pan = my.skill40 - 90;
					talk();
				}
			}

			if (Scene > 11)
			{
				my.pan = my.skill40;
				ent_cycle ("Run",my.skill1);
				my.skill1 = my.skill1 + 8 * time;
				my.x = my.x + 8 * time;

				my.skill30 = my.skill30 + 1 * time;
				if (my.skill30 > 100) { Scene = 13; }

				my.skill45 = my.skill45 + 1 * time;
				if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
			}
		}

		wait(1);
	}
}

action t3
{
	ent_frame ("Fly",0);

	while(1)
	{
		if (Scene == 13)
		{
			ent_frame ("Fly",my.skill1);
			my.skill1 = my.skill1 + 5 * time;
		}

		wait(1);
	}
}

function Talk()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) 
	{ 
		if (PiposhWinLose == 0)
		{
			if (my == player) { ent_frame ("Talk",int(random(8)) * 14.2); } else { ent_frame ("Talk",int(random(5)) * 25); }
		}

		else
		{
			ent_frame ("Talk",int(random(6)) * 20);
		}
	}
}

function Talk2()
{
	my.skill45 = my.skill45 + 1 * time;
	if (my.skill45 > 1.5) { my.skin = int(random(7))+1; my.skill45 = 0; }
	if (int(random(40)) == 20) 
	{ 
		ent_frame ("Speech",int(random(8)) * 14.2); } 
	}
}

function Blink()
{
	if (my.skill22 > 0) { my.skill22 = my.skill22 - 1 * time; }
	if (my.skill22 < 0) 
	{ 
		my.skin = 1; }
		if (int(random(100)) == 50) { my.skin = 7; my.skill22 = 5; }
	}
}