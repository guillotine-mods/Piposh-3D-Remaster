function CheckHands()
//*******************************************************
//*      Checks the hand and give score accordingly     *
//*******************************************************
//* Winning combinations by priority order:      	*
//* 1. Same type flush - Highest card to the power of 5 *
//* 2. Mixed flush - Multiply all cards                 *
//* 3. Entire type hand - Lowest card to the power of 5 *
//* 4. Multiply same number cards 		 	*
//* 5. Add cards from the same series            	*
//* 6. Subtract lonely cards unless it is a      	*
//*    Tibatian Beast, in that case, replace it  	*
//*    with a unique card                        	*
//* 7. If there is no Pony, multiply score by	 	*
//*    number of Tibatian Beasts		 	*
//*******************************************************
{
	Cheat1 = 0;
	UpdateHands();

	ClearArrays();	// Clears previously calculated hand information
	CountCards();	// Determine how many cards are there from the same series and replace lone Tibatian Beasts with unique cards
	CountNumbers();
	
	Counter = 1;
	while (Counter < 5)
	{
		CombinationFound = 0;

		// Check for a whole hand series and than check if its a flush or not		(123)
		FindSmallest();

		Hand = 1;
		Flush = 1;

		while (Hand < 5)
		{
			Card = 1;
			while (Card < 6)
			{
				if (Counter == 1) { if (Hand1[Card] == (Smallest + 1)) { Flush = Flush + 1; Smallest = Smallest + 1; } }
				if (Counter == 2) { if (Hand2[Card] == (Smallest + 1)) { Flush = Flush + 1; Smallest = Smallest + 1; } }
				if (Counter == 3) { if (Hand3[Card] == (Smallest + 1)) { Flush = Flush + 1; Smallest = Smallest + 1; } }
				if (Counter == 4) { if (Hand4[Card] == (Smallest + 1)) { Flush = Flush + 1; Smallest = Smallest + 1; } }
				Card = Card + 1;
			}
			Hand = Hand + 1;
		}

		if (Flush == 5)
		{
			if ((NumPonys[Counter] == 5) || (NumAligators[Counter] == 5) || (NumTBs[Counter] == 5))
			{
				FindLargest();

				ResultN = int(Largest * Largest * Largest * Largest * Largest);

				Score (ResultN);
				Summary ("royal flush: ");
			}
			else
			{
				if (Counter == 1) { ResultN = int(Hand1[1] * Hand1[2] * Hand1[3] * Hand1[4] * Hand1[5]); }
				if (Counter == 2) { ResultN = int(Hand2[1] * Hand2[2] * Hand2[3] * Hand2[4] * Hand2[5]); }
				if (Counter == 3) { ResultN = int(Hand3[1] * Hand3[2] * Hand3[3] * Hand3[4] * Hand3[5]); }
				if (Counter == 4) { ResultN = int(Hand4[1] * Hand4[2] * Hand4[3] * Hand4[4] * Hand4[5]); }
				Score (ResultN);
				Summary ("flush: ");
			}
		}
		else
		{
			if ((NumPonys[Counter] == 5) || (NumAligators[Counter] == 5) || (NumTBs[Counter] == 5))
			{
				ResultN = int(Smallest * Smallest * Smallest * Smallest);
				Score (ResultN);
				Summary ("XLU TDP: ");
			}
		}

		// Check to see if there are two or more cards of the same number		( 4 )
		
		Card = 1;
		while (Card < 15)
		{
			if (Counter == 1) { if (Same1[Card] > 1) { LastScore = Card; Calc(Same1[Card]); } }
			if (Counter == 2) { if (Same2[Card] > 1) { LastScore = Card; Calc(Same2[Card]); } }
			if (Counter == 3) { if (Same3[Card] > 1) { LastScore = Card; Calc(Same3[Card]); } }
			if (Counter == 4) { if (Same4[Card] > 1) { LastScore = Card; Calc(Same4[Card]); } }
			Card = Card + 1;
		}


		Sam1 = 0;
		Sam2 = 0;
		Sam3 = 0;
		Lone1 = 0;
		Lone2 = 0;
		Lone3 = 0;

		Card = 1;
		while (Card < 6)
		{
			// Find how many cards from the same series and add their value		( 5 )
			if (Counter == 1) { if ((Type1[Card] == 1) && (NumPonys[Counter] > 1)) { Sam1 = Sam1 + Hand1[Card]; } }
			if (Counter == 2) { if ((Type2[Card] == 1) && (NumPonys[Counter] > 1)) { Sam1 = Sam1 + Hand2[Card]; } }
			if (Counter == 3) { if ((Type3[Card] == 1) && (NumPonys[Counter] > 1)) { Sam1 = Sam1 + Hand3[Card]; } }
			if (Counter == 4) { if ((Type4[Card] == 1) && (NumPonys[Counter] > 1)) { Sam1 = Sam1 + Hand4[Card]; } }

			if (Counter == 1) { if ((Type1[Card] == 2) && (NumAligators[Counter] > 1)) { Sam2 = Sam2 + Hand1[Card]; } }
			if (Counter == 2) { if ((Type2[Card] == 2) && (NumAligators[Counter] > 1)) { Sam2 = Sam2 + Hand2[Card]; } }
			if (Counter == 3) { if ((Type3[Card] == 2) && (NumAligators[Counter] > 1)) { Sam2 = Sam2 + Hand3[Card]; } }
			if (Counter == 4) { if ((Type4[Card] == 2) && (NumAligators[Counter] > 1)) { Sam2 = Sam2 + Hand4[Card]; } }

			if (Counter == 1) { if ((Type1[Card] == 3) && (NumTBs[Counter] > 1)) { Sam3 = Sam3 + Hand1[Card]; } }
			if (Counter == 2) { if ((Type2[Card] == 3) && (NumTBs[Counter] > 1)) { Sam3 = Sam3 + Hand2[Card]; } }
			if (Counter == 3) { if ((Type3[Card] == 3) && (NumTBs[Counter] > 1)) { Sam3 = Sam3 + Hand3[Card]; } }
			if (Counter == 4) { if ((Type4[Card] == 3) && (NumTBs[Counter] > 1)) { Sam3 = Sam3 + Hand4[Card]; } }

			// Subtract lonely cards						( 6 )
			if (Counter == 1) { if ((Type1[Card] == 1) && (NumPonys[Counter] == 1)) { Lone1 = Lone1 + Hand1[Card]; } }
			if (Counter == 2) { if ((Type2[Card] == 1) && (NumPonys[Counter] == 1)) { Lone1 = Lone1 + Hand2[Card]; } }
			if (Counter == 3) { if ((Type3[Card] == 1) && (NumPonys[Counter] == 1)) { Lone1 = Lone1 + Hand3[Card]; } }
			if (Counter == 4) { if ((Type4[Card] == 1) && (NumPonys[Counter] == 1)) { Lone1 = Lone1 + Hand4[Card]; } }

			if (Counter == 1) { if ((Type1[Card] == 2) && (NumAligators[Counter] == 1)) { Lone2 = Lone2 + Hand1[Card]; } }
			if (Counter == 2) { if ((Type2[Card] == 2) && (NumAligators[Counter] == 1)) { Lone2 = Lone2 + Hand2[Card]; } }
			if (Counter == 3) { if ((Type3[Card] == 2) && (NumAligators[Counter] == 1)) { Lone2 = Lone2 + Hand3[Card]; } }
			if (Counter == 4) { if ((Type4[Card] == 2) && (NumAligators[Counter] == 1)) { Lone2 = Lone2 + Hand4[Card]; } }

			if (Counter == 1) { if ((Type1[Card] == 3) && (NumTBs[Counter] == 1)) { Lone3 = Lone3 + Hand1[Card]; } }
			if (Counter == 2) { if ((Type2[Card] == 3) && (NumTBs[Counter] == 1)) { Lone3 = Lone3 + Hand2[Card]; } }
			if (Counter == 3) { if ((Type3[Card] == 3) && (NumTBs[Counter] == 1)) { Lone3 = Lone3 + Hand3[Card]; } }
			if (Counter == 4) { if ((Type4[Card] == 3) && (NumTBs[Counter] == 1)) { Lone3 = Lone3 + Hand4[Card]; } }

			Card = Card + 1;
		}

		if (Sam1 > 0) { Score (Sam1); Summary ("YISE JNFQE VTDOM XJQLS: "); }	// קלפים מסדרת הפוני הקטן
		if (Sam2 > 0) { Score (Sam2); Summary ("XJUHTBE VTDOM XJQLS: "); }	// קלפים מסדרת התמסחים
		if (Sam3 > 0) { Score (Sam3); Summary ("VFJIBJIE VFMEBE VTDOM XJQLS: "); }	// קלפים מסדרת הבהמות הטיבטיות
		if (Lone1 > 0) { Score (-Lone1); Summary ("YISE JNFQE VTDOM XJDDFB XJQLS: "); }	// קלפים בודדים מסדרת הפוני הקטן
		if (Lone2 > 0) { Score (-Lone2); Summary ("XJUHTBE VTDOM XJDDFB XJQLS: "); }	// קלפים בודדים מסדרת התמסחים
		if (Lone3 > 0) { Score (-Lone3); Summary ("VFJIBJIE VFMEBE VTDOM XJDDFB XJQLS: "); }	// קלפים בודדים מסדרת הבהמות הטיבטיות

		// If there are no ponys, multiply score by number of Tibatian Beasts		( 7 )
		if ((NumPonys[Counter] == 0) && (NumTBs[Counter] > 1)) { HandScore[Counter] = HandScore[Counter] * NumTBs[Counter]; 
		LastScore = NumTBS[Counter]; Summary ("VJIBJIE EMEBE LU ELQKE OFNFB: x"); }	// בונוס הכפלה של הבהמה הטיבטית

		// Calculate unique cards

		if (Unique[Counter] != 0)
		{
			if (Unique[Counter] == 1) 
			{ 
				Score (int(HandScore[Counter] * 3));
				Summary ("(LFQK DFSJN) 1 TQOM DHFJM ZLS: ");	// קלף מיוחד מספר 1 (ניקוד כפול)
			}
				
			if (Unique[Counter] == 2)
			{
				N = int(random(80) + 20);
				ResultN = int((HandScore[1] * N) / 100);
				Score (ResultN);
				str_cpy (FileString,"(+%20-%100) 2 TQOM DHFJM ZLS: ");	// קלף מיוחד מספר 2 (תוספת 100% - 20% מהניקוד)
				str_for_num (Summ,N);
				str_cat (FileString,Summ);
				Summary (FileString);
			}

			if (Unique[Counter] == 3)
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

				Score (int(HandScore[Counter] * Smallest));
				Summary ("(x TVFJB YIS ZLS) 4 TQOM DHFJM ZLS: ");	// קלף מיוחד מספר 4 (הכפלת ערך הקלף הקטן ביותר בניקוד)
			}

			if (Unique[Counter] == 4)
			{
				if (Counter == 1)
				{
					Counter = 2;
					Score (HandScore[2] - 100);
					LastScore = -100;
					Summary ("ELLS: ");	// קללה

					Counter = 3;
					Score (HandScore[3] - 100);
					LastScore = -100;
					Summary ("ELLS: ");

					Counter = 4;
					Score (HandScore[4] - 100);
					LastScore = -100;
					Summary ("ELLS: ");
			
					Counter = 1;
					LastScore = 0;
					Summary ("(-100 :XJBJTJ :ELLS) 4 TQOM DHFJM ZLS: ");	// קלף מיוחד מספר 4 (קללה: יריבים מפסידים 100 נקודות)
				}

				if (Counter == 2)
				{
					Counter = 1;
					Score (HandScore[1] - 100);
					LastScore = -100;
					Summary ("ELLS: ");

					Counter = 3;
					Score (HandScore[3] - 100);
					LastScore = -100;
					Summary ("ELLS: ");

					Counter = 4;
					Score (HandScore[4] - 100);
					LastScore = -100;
					Summary ("ELLS: ");
			
					Counter = 2;
					LastScore = 0;
					Summary ("(-100 :XJBJTJ :ELLS) 4 TQOM DHFJM ZLS: ");
				}

				if (Counter == 3)
				{
					Counter = 1;
					Score (HandScore[1] - 100);
					LastScore = -100;
					Summary ("ELLS: ");

					Counter = 2;
					Score (HandScore[2] - 100);
					LastScore = -100;
					Summary ("ELLS: ");

					Counter = 4;
					Score (HandScore[4] - 100);
					LastScore = -100;
					Summary ("ELLS: ");
			
					Counter = 3;
					LastScore = 0;
					Summary ("(-100 :XJBJTJ :ELLS) 4 TQOM DHFJM ZLS: ");
				}

				if (Counter == 4)
				{
					Counter = 1;
					Score (HandScore[1] - 100);
					LastScore = -100;
					Summary ("ELLS: ");

					Counter = 2;
					Score (HandScore[2] - 100);
					LastScore = -100;
					Summary ("ELLS: ");

					Counter = 3;
					Score (HandScore[3] - 100);
					LastScore = -100;
					Summary ("ELLS: ");
			
					Counter = 4;
					LastScore = 0;
					Summary ("(-100 :XJBJTJ :ELLS) 4 TQOM DHFJM ZLS: ");
				}
			}
			if (Unique[Counter] == 5)
			{
				Score(int(random(900)+100));
				Summary ("(+100-1000 VQOFV) 5 TQOM DHFJM ZLS: ");	// קלף מיוחד מספר 5 (תוספת 1000 - 100 נקודות)
			}
			if (Unique[Counter] == 6)
			{
				Score (-HandScore[Counter] + 1);
				Summary ("(EDFSN TJAUM ,LKE BNFC) 6 TQOM DHFJM ZLS: ");	// קלף מיוחד מספר 6 (גונב את כל הנקודות, משאיר אחת)
			}
		}
		
	Counter = Counter + 1;
	}

	TestDBG = HandScore[1];

//	Counter = 1;
//	while (Counter < 5)
//	{
//		LastScore = HandScore[Counter];
//		Summary ("JQFO DFSJN: ");	// ניקוד סופי
//		Counter = Counter + 1;
//	}

	FinalScore1 = HandScore[1];
	FinalScore2 = HandScore[2];
	FinalScore3 = HandScore[3];
	FinalScore4 = HandScore[4];

	GUI.visible = on;
	PanelScore.visible = on;

	play_sound (Slurp,100);
}

function Calc (N)
{
	ResultN = 1;

	while N > 0
	{
		ResultN = ResultN * LastScore;
		N = N - 1;
	}

	Score (ResultN);	

	Summary ("EEG WTP JLPB XJQLS: ");	// קלפים בעלי ערך זהה
}

function Summary (Summ)
{

	if (Counter == 1) { file_open_append ("Results1.dat"); }
	if (Counter == 2) { file_open_append ("Results2.dat"); }
	if (Counter == 3) { file_open_append ("Results3.dat"); }
	if (Counter == 4) { file_open_append ("Results4.dat"); }

	file_str_write(filehandle,Summ);
	file_var_write(filehandle,int(LastScore));
	file_str_write(filehandle,"\n");

	file_close (filehandle);

}

function SortCards(N)
{
	if (N == 2) { Sorted[1] = Hand2[1]; Sorted[2] = Hand2[2]; Sorted[3] = Hand2[3]; Sorted[4] = Hand2[4]; Sorted[5] = Hand2[5]; }
	if (N == 3) { Sorted[1] = Hand3[1]; Sorted[2] = Hand3[2]; Sorted[3] = Hand3[3]; Sorted[4] = Hand3[4]; Sorted[5] = Hand3[5]; }
	if (N == 4) { Sorted[1] = Hand4[1]; Sorted[2] = Hand4[2]; Sorted[3] = Hand4[3]; Sorted[4] = Hand4[4]; Sorted[5] = Hand4[5]; }

	Card = 0;

	while (Card == 0)	// While the array is not yet sorted
	{	
		Hand = 1;
		Card = 1;	// Flag the array as sorted, unless otherwise stated in the function
		while (Hand < 5)
		{
			if (Sorted[Hand] > Sorted[Hand + 1])	// Rearrange cards by card value
			{
				N = Sorted[Hand];
				Sorted[Hand] = Sorted[Hand + 1];
				Sorted[Hand + 1] = N;
				Card = 0;	// We have made a change, flag to run again
			}
			Hand = Hand + 1;
		}
	}

	waitt(1);
	}
}

function Score(Amount)
{
	HandScore[Counter] = HandScore[Counter] + int(Amount);
	LastScore = int(Amount);
}

function ClearArrays()
{

	HandScore [1] = 0;
	HandScore [2] = 0;
	HandScore [3] = 0;
	HandScore [4] = 0;

	Counter = 0;
	while (Counter < 5)
	{
		NumPonys[Counter] = 0;
		NumAligators[Counter] = 0;
		NumTBs[Counter] = 0;
		Unique[Counter] = 0;
		Counter = Counter + 1;
	}

	Counter = 0;
	while (Counter < 15)
	{ 
		Same1[Counter] = 0;
		Same2[Counter] = 0;
		Same3[Counter] = 0;
		Same4[Counter] = 0;
		Counter = Counter + 1;
	}

	// Clean result files

	filehandle = file_open_write("Results1.dat");
	file_close (filehandle);

	filehandle = file_open_write("Results2.dat");
	file_close (filehandle);

	filehandle = file_open_write("Results3.dat");
	file_close (filehandle);

	filehandle = file_open_write("Results4.dat");
	file_close (filehandle);
}

function CountNumbers()
{
	Card = 1;
	while (Card < 5)
	{
		N = 1;
		while (N < 6)
		{
			if (Card == 1) { Same1[Hand1[N]] = Same1[Hand1[N]] + 1; }
			if (Card == 2) { Same2[Hand2[N]] = Same2[Hand2[N]] + 1; }
			if (Card == 3) { Same3[Hand3[N]] = Same3[Hand3[N]] + 1; }
			if (Card == 4) { Same4[Hand4[N]] = Same4[Hand4[N]] + 1; }
			N = N + 1;
		}
		Card = Card + 1;
	}
}

function CountCards()
{
	Hand = 1;

	while (Hand < 5)
	{
		Ponys = 0;
		Aligators = 0;
		TibatianBeasts = 0;
		Counter = 1;

		while (Counter < 6)
		{
			if (Hand == 1)
			{ 
				if (Type1[Counter] == 1) { Ponys = Ponys + 1; }
				if (Type1[Counter] == 2) { Aligators = Aligators + 1; }
				if (Type1[Counter] == 3) { TibatianBeasts = TibatianBeasts + 1; HandTemp = Counter; }
			}
			if (Hand == 2)
			{ 
				if (Type2[Counter] == 1) { Ponys = Ponys + 1; }
				if (Type2[Counter] == 2) { Aligators = Aligators + 1; }
				if (Type2[Counter] == 3) { TibatianBeasts = TibatianBeasts + 1; HandTemp = Counter; }
			}
			if (Hand == 3)
			{ 
				if (Type3[Counter] == 1) { Ponys = Ponys + 1; }
				if (Type3[Counter] == 2) { Aligators = Aligators + 1; }
				if (Type3[Counter] == 3) { TibatianBeasts = TibatianBeasts + 1; HandTemp = Counter; }
			}
			if (Hand == 4)
			{ 
				if (Type4[Counter] == 1) { Ponys = Ponys + 1; }
				if (Type4[Counter] == 2) { Aligators = Aligators + 1; }
				if (Type4[Counter] == 3) { TibatianBeasts = TibatianBeasts + 1; HandTemp = Counter; }
			}
			Counter = Counter + 1;
		}

		NumPonys[Hand] = Ponys;
		NumAligators[Hand] = Aligators;
		NumTBs[Hand] = TibatianBeasts;

		if ((TibatianBeasts == 1) && (InGame == 0))		// Replace lone Tibatian Beasts with unique cards
		{ 
			NumTBs[Hand] = 0;
			if (Hand == 1) { Type1[HandTemp] = 4; Hand1[HandTemp] = int(random(6))+1; Unique[Hand] = Hand1[HandTemp]; }
			if (Hand == 2) { Type2[HandTemp] = 4; Hand2[HandTemp] = int(random(6))+1; Unique[Hand] = Hand2[HandTemp]; }
			if (Hand == 3) { Type3[HandTemp] = 4; Hand3[HandTemp] = int(random(6))+1; Unique[Hand] = Hand3[HandTemp]; }
			if (Hand == 4) { Type4[HandTemp] = 4; Hand4[HandTemp] = int(random(6))+1; Unique[Hand] = Hand4[HandTemp]; }
			UpdateHands();
		}
		Hand = Hand + 1;
	}
}

function HoldAllCards (N)
{
	if (N == 2) { P2C1.unlit = off; P2C2.unlit = off; P2C3.unlit = off; P2C4.unlit = off; P2C5.unlit = off; }
	if (N == 3) { P3C1.unlit = off; P3C2.unlit = off; P3C3.unlit = off; P3C4.unlit = off; P3C5.unlit = off; }
	if (N == 4) { P4C1.unlit = off; P4C2.unlit = off; P4C3.unlit = off; P4C4.unlit = off; P4C5.unlit = off; }
}

function Discard (N)
{
	if (Counter == 2)
	{
		if (N == 1) { P2C1.unlit = on; }
		if (N == 2) { P2C2.unlit = on; }
		if (N == 3) { P2C3.unlit = on; }
		if (N == 4) { P2C4.unlit = on; }
		if (N == 5) { P2C5.unlit = on; }	
	}

	if (Counter == 3)
	{
		if (N == 1) { P3C1.unlit = on; }
		if (N == 2) { P3C2.unlit = on; }
		if (N == 3) { P3C3.unlit = on; }
		if (N == 4) { P3C4.unlit = on; }
		if (N == 5) { P3C5.unlit = on; }	
	}

	if (Counter == 4)
	{
		if (N == 1) { P4C1.unlit = on; }
		if (N == 2) { P4C2.unlit = on; }
		if (N == 3) { P4C3.unlit = on; }
		if (N == 4) { P4C4.unlit = on; }
		if (N == 5) { P4C5.unlit = on; }	
	}
}

function Hold (N)
{
	if (Counter == 2)
	{
		if (N == 1) { P2C1.unlit = off; }
		if (N == 2) { P2C2.unlit = off; }
		if (N == 3) { P2C3.unlit = off; }
		if (N == 4) { P2C4.unlit = off; }
		if (N == 5) { P2C5.unlit = off; }	
	}

	if (Counter == 3)
	{
		if (N == 1) { P3C1.unlit = off; }
		if (N == 2) { P3C2.unlit = off; }
		if (N == 3) { P3C3.unlit = off; }
		if (N == 4) { P3C4.unlit = off; }
		if (N == 5) { P3C5.unlit = off; }	
	}

	if (Counter == 4)
	{
		if (N == 1) { P4C1.unlit = off;	}
		if (N == 2) { P4C2.unlit = off; }
		if (N == 3) { P4C3.unlit = off; }
		if (N == 4) { P4C4.unlit = off; }
		if (N == 5) { P4C5.unlit = off; }	
	}
}

function ScanAndHold (N)
{
	Flush = 0;
	if (N > 4) { Flush = 1; }	// If the cards are 5 and over hold them
	if (N < 5)
	{	// If the cards are lower than 5, hold them only if there are 4 or 5 cards
		if (Counter == 2) { if (Same2[N] > 3) { Flush = 1; } }
		if (Counter == 3) { if (Same3[N] > 3) { Flush = 1; } }
		if (Counter == 4) { if (Same4[N] > 3) { Flush = 1; } }
	}

	if (Flush == 1)
	{
		Card = 1;
		While (Card < 6)
		{
			if (Counter == 2) { if (Hand2[Card] == N) { Hold (Card); } }
			if (Counter == 3) { if (Hand3[Card] == N) { Hold (Card); } }
			if (Counter == 4) { if (Hand4[Card] == N) { Hold (Card); } }
			Card = Card + 1;
		}
	}
}

function ScanAndDiscard (N)
{

	Card = 1;
	While (Card < 6)
	{
		if (Counter == 2) { if (Hand2[Card] == N) { Discard (Card); } }
		if (Counter == 3) { if (Hand3[Card] == N) { Discard (Card); } }
		if (Counter == 4) { if (Hand4[Card] == N) { Discard (Card); } }
		Card = Card + 1;
	}
}

function HoldTBs()
{
	Card = 1;
	While (Card < 6)
	{
		if (Counter == 2) { if (Type2[Card] == 3) { Hold (Card); } }
		if (Counter == 3) { if (Type3[Card] == 3) { Hold (Card); } }
		if (Counter == 4) { if (Type4[Card] == 3) { Hold (Card); } }
		Card = Card + 1;
	}
}

function ShowCard()
{
	if (Hand == 1)
	{
		if (Card == 1) { P1C1.invisible = off; }
		if (Card == 2) { P1C2.invisible = off; }
		if (Card == 3) { P1C3.invisible = off; }
		if (Card == 4) { P1C4.invisible = off; }
		if (Card == 5) { P1C5.invisible = off; }
	}

	if (Hand == 2)
	{
		if (Card == 1) { P2C1.invisible = off; }
		if (Card == 2) { P2C2.invisible = off; }
		if (Card == 3) { P2C3.invisible = off; }
		if (Card == 4) { P2C4.invisible = off; }
		if (Card == 5) { P2C5.invisible = off; }
	}

	if (Hand == 3)
	{
		if (Card == 1) { P3C1.invisible = off; }
		if (Card == 2) { P3C2.invisible = off; }
		if (Card == 3) { P3C3.invisible = off; }
		if (Card == 4) { P3C4.invisible = off; }
		if (Card == 5) { P3C5.invisible = off; }
	}

	if (Hand == 4)
	{
		if (Card == 1) { P4C1.invisible = off; }
		if (Card == 2) { P4C2.invisible = off; }
		if (Card == 3) { P4C3.invisible = off; }
		if (Card == 4) { P4C4.invisible = off; }
		if (Card == 5) { P4C5.invisible = off; }
	}
}


function HideAll()
{
	if (P1C1 == null) { wait(1); }

	P1C1.invisible = on; P1C1.unlit = on;
	P1C2.invisible = on; P1C2.unlit = on;
	P1C3.invisible = on; P1C3.unlit = on;
	P1C4.invisible = on; P1C4.unlit = on;
	P1C5.invisible = on; P1C5.unlit = on;

	P2C1.invisible = on; P2C1.unlit = on;
	P2C2.invisible = on; P2C2.unlit = on;
	P2C3.invisible = on; P2C3.unlit = on;
	P2C4.invisible = on; P2C4.unlit = on;
	P2C5.invisible = on; P2C5.unlit = on;

	P3C1.invisible = on; P3C1.unlit = on;
	P3C2.invisible = on; P3C2.unlit = on;
	P3C3.invisible = on; P3C3.unlit = on;
	P3C4.invisible = on; P3C4.unlit = on;
	P3C5.invisible = on; P3C5.unlit = on;

	P4C1.invisible = on; P4C1.unlit = on;
	P4C2.invisible = on; P4C2.unlit = on;
	P4C3.invisible = on; P4C3.unlit = on;
	P4C4.invisible = on; P4C4.unlit = on;
	P4C5.invisible = on; P4C5.unlit = on;
}

function ReplaceCards()
//************************************************//
//* Scan cards and rerandom cards that are unlit *//
//************************************************//
{
	if (P1C1.unlit == on) { SelectCard ("11"); }
	if (P1C2.unlit == on) { SelectCard ("12"); }
	if (P1C3.unlit == on) { SelectCard ("13"); }
	if (P1C4.unlit == on) { SelectCard ("14"); }
	if (P1C5.unlit == on) { SelectCard ("15"); }

	if (P2C1.unlit == on) { SelectCard ("21"); }
	if (P2C2.unlit == on) { SelectCard ("22"); }
	if (P2C3.unlit == on) { SelectCard ("23"); }
	if (P2C4.unlit == on) { SelectCard ("24"); }
	if (P2C5.unlit == on) { SelectCard ("25"); }

	if (P3C1.unlit == on) { SelectCard ("31"); }
	if (P3C2.unlit == on) { SelectCard ("32"); }
	if (P3C3.unlit == on) { SelectCard ("33"); }
	if (P3C4.unlit == on) { SelectCard ("34"); }
	if (P3C5.unlit == on) { SelectCard ("35"); }

	if (P4C1.unlit == on) { SelectCard ("41"); }
	if (P4C2.unlit == on) { SelectCard ("42"); }
	if (P4C3.unlit == on) { SelectCard ("43"); }
	if (P4C4.unlit == on) { SelectCard ("44"); }
	if (P4C5.unlit == on) { SelectCard ("45"); }

	UpdateHands();
	FlipAllCards (90);
	CheckHands();
	InGame = 0;
}

action DealAll
{
	GUI.visible = off;
	GUI.bmap = bPoker1;
	PanelScore.visible = off;
	InGame = 3;
	HideAll();
	Deck.z = FullDeck;
	FlipAllCards(270);
	waitt (3);

	SelectCard ("11"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("12"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("13"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("14"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("15"); play_sound (CardFlip,100); waitt(3);

	SelectCard ("21"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("22"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("23"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("24"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("25"); play_sound (CardFlip,100); waitt(3);

	SelectCard ("31"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("32"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("33"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("34"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("35"); play_sound (CardFlip,100); waitt(3);

	SelectCard ("41"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("42"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("43"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("44"); play_sound (CardFlip,100); waitt(3);
	SelectCard ("45"); play_sound (CardFlip,100); waitt(3);

	UpdateHands(); 
	FlipPlayerCards();

	AI();

	InGame = 1;
}

function FlipAllCards(Counter)
{
	P1C1.tilt = Counter;
	P1C2.tilt = Counter;
	P1C3.tilt = Counter;
	P1C4.tilt = Counter;
	P1C5.tilt = Counter;

	P2C1.tilt = Counter;
	P2C2.tilt = Counter;
	P2C3.tilt = Counter;
	P2C4.tilt = Counter;
	P2C5.tilt = Counter;

	P3C1.tilt = Counter;
	P3C2.tilt = Counter;
	P3C3.tilt = Counter;
	P3C4.tilt = Counter;
	P3C5.tilt = Counter;

	P4C1.tilt = Counter;
	P4C2.tilt = Counter;
	P4C3.tilt = Counter;
	P4C4.tilt = Counter;
	P4C5.tilt = Counter;
}

function FlipPlayerCards()
{
	P1C1.tilt = 90;
	P1C2.tilt = 90;
	P1C3.tilt = 90;
	P1C4.tilt = 90;
	P1C5.tilt = 90;
}

function UpdateHands()
{
	DoMorphs();

	P1C1.skin = Hand1[1];
	P1C2.skin = Hand1[2];
	P1C3.skin = Hand1[3];
	P1C4.skin = Hand1[4];
	P1C5.skin = Hand1[5];

	P2C1.skin = Hand2[1];
	P2C2.skin = Hand2[2];
	P2C3.skin = Hand2[3];
	P2C4.skin = Hand2[4];
	P2C5.skin = Hand2[5];

	P3C1.skin = Hand3[1];
	P3C2.skin = Hand3[2];
	P3C3.skin = Hand3[3];
	P3C4.skin = Hand3[4];
	P3C5.skin = Hand3[5];

	P4C1.skin = Hand4[1];
	P4C2.skin = Hand4[2];
	P4C3.skin = Hand4[3];
	P4C4.skin = Hand4[4];
	P4C5.skin = Hand4[5];
}

function DoMorphs()
{
	// Player 1
	if (Type1[1] == 1) { morph (<cards1.mdl>,P1C1); }
	if (Type1[2] == 1) { morph (<cards1.mdl>,P1C2); }
	if (Type1[3] == 1) { morph (<cards1.mdl>,P1C3); }
	if (Type1[4] == 1) { morph (<cards1.mdl>,P1C4); }
	if (Type1[5] == 1) { morph (<cards1.mdl>,P1C5); }

	if (Type1[1] == 2) { morph (<cards2.mdl>,P1C1); }
	if (Type1[2] == 2) { morph (<cards2.mdl>,P1C2); }
	if (Type1[3] == 2) { morph (<cards2.mdl>,P1C3); }
	if (Type1[4] == 2) { morph (<cards2.mdl>,P1C4); }
	if (Type1[5] == 2) { morph (<cards2.mdl>,P1C5); }

	if (Type1[1] == 3) { morph (<cards3.mdl>,P1C1); }
	if (Type1[2] == 3) { morph (<cards3.mdl>,P1C2); }
	if (Type1[3] == 3) { morph (<cards3.mdl>,P1C3); }
	if (Type1[4] == 3) { morph (<cards3.mdl>,P1C4); }
	if (Type1[5] == 3) { morph (<cards3.mdl>,P1C5); }

	if (Type1[1] == 4) { morph (<cards4.mdl>,P1C1); }
	if (Type1[2] == 4) { morph (<cards4.mdl>,P1C2); }
	if (Type1[3] == 4) { morph (<cards4.mdl>,P1C3); }
	if (Type1[4] == 4) { morph (<cards4.mdl>,P1C4); }
	if (Type1[5] == 4) { morph (<cards4.mdl>,P1C5); }

	// Player 2
	if (Type2[1] == 1) { morph (<cards1.mdl>,P2C1); }
	if (Type2[2] == 1) { morph (<cards1.mdl>,P2C2); }
	if (Type2[3] == 1) { morph (<cards1.mdl>,P2C3); }
	if (Type2[4] == 1) { morph (<cards1.mdl>,P2C4); }
	if (Type2[5] == 1) { morph (<cards1.mdl>,P2C5); }

	if (Type2[1] == 2) { morph (<cards2.mdl>,P2C1); }
	if (Type2[2] == 2) { morph (<cards2.mdl>,P2C2); }
	if (Type2[3] == 2) { morph (<cards2.mdl>,P2C3); }
	if (Type2[4] == 2) { morph (<cards2.mdl>,P2C4); }
	if (Type2[5] == 2) { morph (<cards2.mdl>,P2C5); }

	if (Type2[1] == 3) { morph (<cards3.mdl>,P2C1); }
	if (Type2[2] == 3) { morph (<cards3.mdl>,P2C2); }
	if (Type2[3] == 3) { morph (<cards3.mdl>,P2C3); }
	if (Type2[4] == 3) { morph (<cards3.mdl>,P2C4); }
	if (Type2[5] == 3) { morph (<cards3.mdl>,P2C5); }

	if (Type2[1] == 4) { morph (<cards4.mdl>,P2C1); }
	if (Type2[2] == 4) { morph (<cards4.mdl>,P2C2); }
	if (Type2[3] == 4) { morph (<cards4.mdl>,P2C3); }
	if (Type2[4] == 4) { morph (<cards4.mdl>,P2C4); }
	if (Type2[5] == 4) { morph (<cards4.mdl>,P2C5); }

	// Player 3
	if (Type3[1] == 1) { morph (<cards1.mdl>,P3C1); }
	if (Type3[2] == 1) { morph (<cards1.mdl>,P3C2); }
	if (Type3[3] == 1) { morph (<cards1.mdl>,P3C3); }
	if (Type3[4] == 1) { morph (<cards1.mdl>,P3C4); }
	if (Type3[5] == 1) { morph (<cards1.mdl>,P3C5); }

	if (Type3[1] == 2) { morph (<cards2.mdl>,P3C1); }
	if (Type3[2] == 2) { morph (<cards2.mdl>,P3C2); }
	if (Type3[3] == 2) { morph (<cards2.mdl>,P3C3); }
	if (Type3[4] == 2) { morph (<cards2.mdl>,P3C4); }
	if (Type3[5] == 2) { morph (<cards2.mdl>,P3C5); }

	if (Type3[1] == 3) { morph (<cards3.mdl>,P3C1); }
	if (Type3[2] == 3) { morph (<cards3.mdl>,P3C2); }
	if (Type3[3] == 3) { morph (<cards3.mdl>,P3C3); }
	if (Type3[4] == 3) { morph (<cards3.mdl>,P3C4); }
	if (Type3[5] == 3) { morph (<cards3.mdl>,P3C5); }

	if (Type3[1] == 4) { morph (<cards4.mdl>,P3C1); }
	if (Type3[2] == 4) { morph (<cards4.mdl>,P3C2); }
	if (Type3[3] == 4) { morph (<cards4.mdl>,P3C3); }
	if (Type3[4] == 4) { morph (<cards4.mdl>,P3C4); }
	if (Type3[5] == 4) { morph (<cards4.mdl>,P3C5); }

	// Player 4
	if (Type4[1] == 1) { morph (<cards1.mdl>,P4C1); }
	if (Type4[2] == 1) { morph (<cards1.mdl>,P4C2); }
	if (Type4[3] == 1) { morph (<cards1.mdl>,P4C3); }
	if (Type4[4] == 1) { morph (<cards1.mdl>,P4C4); }
	if (Type4[5] == 1) { morph (<cards1.mdl>,P4C5); }

	if (Type4[1] == 2) { morph (<cards2.mdl>,P4C1); }
	if (Type4[2] == 2) { morph (<cards2.mdl>,P4C2); }
	if (Type4[3] == 2) { morph (<cards2.mdl>,P4C3); }
	if (Type4[4] == 2) { morph (<cards2.mdl>,P4C4); }
	if (Type4[5] == 2) { morph (<cards2.mdl>,P4C5); }

	if (Type4[1] == 3) { morph (<cards3.mdl>,P4C1); }
	if (Type4[2] == 3) { morph (<cards3.mdl>,P4C2); }
	if (Type4[3] == 3) { morph (<cards3.mdl>,P4C3); }
	if (Type4[4] == 3) { morph (<cards3.mdl>,P4C4); }
	if (Type4[5] == 3) { morph (<cards3.mdl>,P4C5); }

	if (Type4[1] == 4) { morph (<cards4.mdl>,P4C1); }
	if (Type4[2] == 4) { morph (<cards4.mdl>,P4C2); }
	if (Type4[3] == 4) { morph (<cards4.mdl>,P4C3); }
	if (Type4[4] == 4) { morph (<cards4.mdl>,P4C4); }
	if (Type4[5] == 4) { morph (<cards4.mdl>,P4C5); }
}

ACTION player_fly
{
	MY._MOVEMODE = _MODE_DRIVING;
	MY._FORCE = 2;
	MY._BANKING = 2;
	MY.__JUMP = ON;
	MY.__DUCK = ON;
	MY.__STRAFE = OFF;
	MY.__BOB = ON;
	drop_shadow();

	player_move2();
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

		// if we are not in 'still' mode
		if(MY._MOVEMODE != _MODE_STILL)
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
					move_gravity2();
				}  // END (not in water)
			}// END not swimming
		} // END not in 'still' mode

		// animate the actor
		actor_anim();

		move_view_3rd();

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		wait(1);
	}  // END while((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}

function move_gravity2()
{
	// Filter the forces and frictions dependent on the state of the actor,
	// and then apply them, and move him

	// accelerate the entity relative speed by the force
	// -old method- ACCEL	speed,force,friction;
 	// replaced min with max (to eliminate 'creep')
	temp = max((1-TIME*friction),0);
//	MY._SPEED_X = (TIME * force.x) + (temp * MY._SPEED_X);    // vx = ax*dt + max(1-f*dt,0) * vx
	MY._SPEED_X = 0;
	MY._SPEED_Y = (TIME * force.y) + (temp * MY._SPEED_Y);    // vy = ay*dt + max(1-f*dt,0) * vy
	MY._SPEED_Z = (TIME * absforce.z) + (temp * MY._SPEED_Z);
//	MY._SPEED_Z = force.z;
	// calculate relative distances to move
	dist.x = MY._SPEED_X * TIME;  	// dx = vx * dt
	dist.y = MY._SPEED_Y * TIME;     // dy = vy * dt
	dist.z = MY._SPEED_Z * TIME;                      // dz = 0  (only gravity and jumping)

	// calculate absolute distance to move
	absdist.x = absforce.x * TIME * TIME;   // dx = ax*dt^2
	absdist.y = absforce.y * TIME * TIME;   // dy = ay*dt^2
	absdist.z = MY._SPEED_Z * TIME;         // dz = vz*dt

	// Now move ME by the relative and the absolute speed
	YOU = NULL;	// YOU entity is considered passable by MOVE

	vec_scale(dist,movement_scale);	// scale distance by movement_scale
	// jcl: removed absdist scaling because absdist is calculated from external forces
	//--- vec_scale(absdist,movement_scale);	// scale absolute distance by movement_scale


	// Replaced the double MOVE with a single MOVE and a distance check
//-old-	move(ME,dist,NULLVECTOR);
// Store the distance covered, for animation
//-old-	my_dist = RESULT;
//-	move(ME,NULLVECTOR,absdist);
 	move(ME,dist,absdist);
	if(RESULT > 0)
	{
		// only use the relative distance traveled (for animation)
		my_dist = vec_length(dist);
	}
	else
	{
		// player is not moving, do not animate
		my_dist = 0;
	}


	// Store the distance for player 1st person head bobbing
	// (only for single player system)
	if(ME == player)
	{
		player_dist += SQRT(dist.X*dist.X + dist.Y*dist.Y);
	}
//jcl 07-03-00 end of patch
}


