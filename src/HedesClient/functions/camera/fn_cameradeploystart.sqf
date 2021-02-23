private _sound 			= param[0, "OMComputerSystemStart"];
private _text 			= param[1, "DEPLOYinG"];
private _transition 	= param[2, "BLACK OUT"];
private _duration 		= param[3, 2];

playSound _sound;
titleCut [_text, _transition, 2];