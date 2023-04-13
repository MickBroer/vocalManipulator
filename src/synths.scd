SynthDef(\autotune, {
	var amp, drysig, sig, freq, env, midi;
	drysig = SoundIn.ar(0, \inAmp.kr(1, 0.01));
	sig = CombC.ar(drysig, 0.2, \deltime.kr(0, 0.1), 0);
	env = Env([0.0001, 1, 0.0001], [\atk.ir(0.001), \rel.ir(1)], \exp).kr(2);
	amp = Amplitude.kr(sig);
	amp = Clip.kr(amp);
	freq = Pitch.kr(sig);
	FluidKrToBuf.kr([freq[0]], ~pitchBuf);
	freq = Clip.kr(freq, 40, 2000);
	sig = PitchShift.ar(sig, 0.2, (\pitch.kr(60, 0.1)).midicps / freq[0]);
	sig = Mix.ar([drysig * (1 - \wet.kr(0, 0.1)), sig * \wet.kr]);
	sig = Pan2.ar(sig, \panpos.kr(0, 0.1));
	sig = sig * env;
	sig = Limiter.ar(sig, 0.8) * \autotuneAmp.kr(1, 0.1);
	Out.kr(~analysisBus, [amp * \wet.kr, freq[0]]);
	Out.ar(\out.ir(0), sig);
}).add;

SynthDef(\vocalSynth, {
	var amp, freq, env, sig;
	env = Env([0, 1, 0], [\atk.ir(0.001), \rel.ir(1)]).kr(2);
	amp = In.ar(~analysisBus, 2)[0];
	freq = In.ar(~analysisBus, 2)[1];
	sig = Saw.ar(freq) * amp * \synthAmp.ir(0) * env;
	sig = BPF.ar(sig, \filterfreq.ir(440), 1);
	sig = PitchShift.ar(sig, 0.2, (\pitch.ir(60)).midicps / freq);
	sig = Pan2.ar(sig, \panpos.ir(0));
	Out.ar(\out.ir(0), sig);
}).add;

SynthDef(\master_FX, {
	var dry, wet, sig;
	dry = In.ar(\in.ir(0), 2);

	//distortion
	wet = Normalizer.ar(Clip.ar(dry * \gain.kr(1, 0.1), \clip.kr(1) * -1, \clip.kr), 1);
	sig = Mix.ar([dry * (1 - \wetlevel.kr(0, 0.1)), wet * \wetlevel.kr]) * \amp.kr(1, 0.1);
	Out.ar(\out.ir(0), sig);
}).add;