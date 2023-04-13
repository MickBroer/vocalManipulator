Tdef(\guiControl, {
	loop{
		~rateVal = (~rate + rrand(~minRandRate, ~maxRandRate)).clip(0.05, 3);
		~rateNB.valueAction_(~rateVal);
		1.5.wait;

	};
}).clock_(AppClock);

Tdef(\sequencer, {
	~i = 0;
	loop{
		var index;
		var detuneIndex;
		~pitchBuf.get(0, {|i| ~midi = i.cpsmidi.round(1)});
		index = ~fit.(~midi);
		~pitch = if (~notes == [])
		{[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].choose + 12}
		{~notes[index] + 12};

		if (~lock == 1) {
			detuneIndex = ~fit.(~detune);
			~detune = ~notes[detuneIndex];
		};

		Synth(\vocalSynth, [
			\pitch, (~pitch + ~detune).midicps,
			\atk, ~atk,
			\rel, ~rel,
			\panpos, {rrand(-0.8, 0.8)}.value,
			\synthAmp, {exprand(0.001, 0.5)}.value,
			\filterfreq, {exprand(100, 4000)}.value,
			\out, ~masterBus
		], addAction:\addToHead);

		~activeNotes[~i] = Synth(\autotune, [
			\pitch, (~pitch + ~detune).midicps,
			\autotuneAmp, {exprand(0.2, 1)}.value,
			\deltime, {exprand(0.0001, 0.2)}.value,
			\atk, ~atk,
			\rel, ~rel,
			\panpos, {rrand(-0.8, 0.8)}.value,
			\inAmp, 1,
			\wet, ~wet,
			\out, ~masterBus
		], addAction:\addToHead);

		~i = ~i + 1 % 128;
		~activeNotes.collect{
			| synth |
			if (synth == nil) {} {
				if (synth.isPlaying == false) {}
				{
					synth.set(
						\pitch, (~pitch + ~detune).midicps,
						\panpos, {rrand(-0.8, 0.8)}.value,
						\inAmp, 1,
						\wet, ~wet
					);
				}
			};
		};
		~rateVal.wait;
	};
}).clock_(AppClock);