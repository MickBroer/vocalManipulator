// GUI
Window.closeAll;

~window = Window.new('vocal manipulator', 800@600, false, true)
.background_(Color(1, 1, 1, 0))
.onClose_({
	Tdef(\sequencer).stop;
	Tdef(\guiControl).stop;
})
.front;

//grain rate
StaticText(~window, Rect(20, 100, 100, 15))
.string_("rate");

Button.new(~window, Rect(20, 40, 30, 30))
.states_([["", Color.white, Color.white], ["", Color.green, Color.green]])
.action_({
	| obj |
	obj.value;
	if (obj.value == 1, {
		Tdef(\guiControl).play;
		Tdef(\sequencer).play
	}, {
		Tdef(\sequencer).stop;
		Tdef(\guiControl).stop;
	};
)});

~rateS = Slider.new(~window, Rect(60, 100, 100, 15))
.value_(~rate.explin(0.05, 3, 0.0, 1.0))
.action_({
	| obj |
	~rate = obj.value.linexp(0.0, 1.0, 0.05, 3).lag(0.1);
	~rateNB.value_(~rate);
});

~rateNB = NumberBox.new(~window, Rect(180, 100, 40, 15))
.value_(~rate)
.clipLo_(0.05)
.clipHi_(3.0)
.action_({
	| obj |
	~rate = obj.value.lag(0.1);
	~rateS.valueAction_(obj.value.explin(0.05, 3, 0.0, 1.0));
});

Knob.new(~window, Rect(250, 90, 30, 30))
.value_(0)
.action_({
	| obj |
	~minRandRate = (-0.2 * obj.value.lag(0.1));
	~maxRandRate = (0.2 * obj.value.lag(0.1));
});

EnvelopeView(~window, Rect(60, 150, 100, 50))
.thumbSize_(10)
.drawLines_(true)
.value_([[0.0, 0.2, 1],[0.0, 1, 0.0]])
.drawRects_(true)
.setEditable(0,false)
.action_({
	| obj |
	~atk = obj.value[1][1].linlin(0.0, 1.0, 0.001, 2);
	~rel = obj.value[1][2].linlin(0.0, 1.0, 0.001, 2);
});


StaticText(~window, Rect(23, 240, 100, 15))
.string_("wet");

~wetS = Slider.new(~window, Rect(60, 240, 100, 15))
.value_(~wet)
.action_({
	| obj |
	~wet = obj.value;
	~wetNB.value_(~wet);
});

~wetNB = NumberBox.new(~window, Rect(180, 240, 40, 15))
.value_(~wet)
.clipLo_(0.0)
.clipHi_(1.0)
.action_({
	| obj |
	~wet = obj.value;
	~wetS.valueAction_(~wet);
});

StaticText(~window, Rect(23, 260, 100, 15))
.string_("tune");

~detuneS = Slider(~window, Rect(60, 260, 100, 15))
.value_(~detune)
.action_({
	| obj |
	~detune = obj.value.linlin(0.0, 1.0, 0.0, 36.0);
	~detuneNB.value_(~detune)
});

~detuneNB = NumberBox(~window, Rect(180, 260, 40, 15))
.clipLo_(0.0)
.clipHi_(36.0)
.value_(~detune)
.action_({
	| obj |
	~detune = obj.value;
	~detune.valueAction_(~detune);
});

~lockButton = Button(~window, Rect(240, 260, 60, 15))
.states_([
	['lock', Color.black, Color.white],
	['unlock', Color.black, Color.red]])
.action_({
	| obj |
	if (obj.value == 0) {~lock = 0.postln;}
	{~lock == 1.postln;}
});


StaticText(~window, Rect(23, 280, 100, 15))
.string_("dist.");

~distortionS = Slider(~window, Rect(60, 280, 100, 15))
.action_({
	| obj |
	~master.set(
		\gain, obj.value.linexp(0.0, 1.0, 1.0, 20),
		\clip, obj.value.linexp(0.0, 1.0, 1.0, 0.001),
		\wetlevel, obj.value);
	~distortionNB.value_(obj.value);
});

~distortionNB = NumberBox(~window, Rect(180, 280, 40, 15))
.clipLo_(0.0)
.clipHi_(36.0)
.value_(~detune)
.action_({
	| obj |
	~master.set(
		\gain, obj.value.linexp(0.0, 1.0, 1.0, 20),
		\clip, obj.value.linexp(0.0, 1.0, 1.0, 0.001),
		\wetlevel, obj.value);
	~distortionS.valueAction_(obj.value);
});


ServerMeterView(s, ~window, 20@350, 1, 2);

~menu = PopUpMenu(~window, Rect(350, 40, 100, 30))
.items_([
	"- scale -",
	"C",
	"Cm",
	"C#",
	"C#m",
	"D",
	"Dm",
	"D#",
	"D#m"
	"E",
	"Em",
	"F",
	"Fm",
	"F#",
	"F#m",
	"G",
	"Gm",
	"G#",
	"G#m",
	"A",
	"Am",
	"A#",
	"A#m",
	"B",
	"Bm"
])
.action_({
	| menu |
	case
	{menu.value.value == 1} {~notes = [0, 2, 4, 5, 7, 9, 11]}
	{menu.value == 2} {~notes = [0, 2, 3, 5, 7, 8, 10]}
	{menu.value == 3} {~notes = [0, 2, 4, 5, 7, 9, 11] + 1}
	{menu.value == 4} {~notes = [0, 2, 3, 5, 7, 8, 10] + 1}
	{menu.value == 5} {~notes = [0, 2, 4, 5, 7, 9, 11] + 2}
	{menu.value == 6} {~notes = [0, 2, 3, 5, 7, 8, 10] + 2}
	{menu.value == 7} {~notes = [0, 2, 4, 5, 7, 9, 11] + 3}
	{menu.value == 8} {~notes = [0, 2, 3, 5, 7, 8, 10] + 3}
	{menu.value == 9} {~notes = [0, 2, 4, 5, 7, 9, 11] + 4}
	{menu.value == 10} {~notes = [0, 2, 3, 5, 7, 8, 10] + 4}
	{menu.value == 11} {~notes = [0, 2, 4, 5, 7, 9, 11] + 5}
	{menu.value == 12} {~notes = [0, 2, 3, 5, 7, 8, 10] + 5}
	{menu.value == 13} {~notes = [0, 2, 4, 5, 7, 9, 11] + 6}
	{menu.value == 14} {~notes = [0, 2, 3, 5, 7, 8, 10] + 6}
	{menu.value == 15} {~notes = [0, 2, 4, 5, 7, 9, 11] + 7}
	{menu.value == 16} {~notes = [0, 2, 3, 5, 7, 8, 10] + 7}
	{menu.value == 17} {~notes = [0, 2, 4, 5, 7, 9, 11] + 8}
	{menu.value == 18} {~notes = [0, 2, 3, 5, 7, 8, 10] + 8}
	{menu.value == 19} {~notes = [0, 2, 4, 5, 7, 9, 11] + 9}
	{menu.value == 20} {~notes = [0, 2, 3, 5, 7, 8, 10] + 9}
	{menu.value == 21} {~notes = [0, 2, 4, 5, 7, 9, 11] + 10}
	{menu.value == 22} {~notes = [0, 2, 3, 5, 7, 8, 10] + 10}
	{menu.value == 23} {~notes = [0, 2, 4, 5, 7, 9, 11] + 11}
	{menu.value == 24} {~notes = [0, 2, 3, 5, 7, 8, 10] + 11};
	~notes.postln;
});

Button(~window, Rect(500, 40, 100, 30))
.states_([['manual scale', Color.black, Color.white]])
.action_({
	~menu.value_(0);
	~notes = [];
	~keyboard = KeyboardWindow(12, 3, 0, Rect(400, 400, 200, 50));
	~keyboard.downAction_({
		| ch, note, vel |
		~notes = ~notes.add(note % 12);
	})
});

Button(~window, Rect(650, 40, 100, 30))
.states_([['clear scale', Color.black, Color.white]])
.action_({
	~menu.value_(0);
	~notes = [];
});