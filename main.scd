/*
-------------------------------------------------------
vocalManipulator, multi-fx processing, meant for vocals

         ------------        ------------
 in --> | Autotune   | ---> | distortion | --> Out
         ------------        ------------

             Made by Mick Broer, 2023
-------------------------------------------------------
*/
Server.killAll;

Server.default.options.memSize_(2.pow(16));

Server.default.boot;

~activeNotes = Array.newClear(128);
~notes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
~index = 0;
~midi = 60;
~wet = 1;
~rate = 0.1;
~minRandRate = 0;
~maxRandRate = 0;
~rateVal = 0.1;
~atk = 0.2.linlin(0.0, 1.0, 0.001, 2);
~rel = 1.linlin(0.0, 1.0, 0.001, 2);
~detune = 0;
~path = PathName(thisProcess.nowExecutingPath).parentPath;

Server.default.waitForBoot{

	~pitchBuf = Buffer.alloc(s, 1);
	~masterBus = Bus.audio(s, 2);
	~analysisBus = Bus.control(s, 2);

	Server.default.sync;

	PathName(~path ++ "src/").entries.collect{ | file | file.fullPath.load };

	Server.default.sync;

	~master = Synth(\master_FX, [\in, ~masterBus]);
}