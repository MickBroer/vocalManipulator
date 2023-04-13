~fit = {
	| val |
	var noteArray = Array.new(~notes.size);
	var min = 12;
	var index;
	val = val % 12;
	~notes.collect{
		| noteVal, i |
		var dif = noteVal - val;
		dif = dif.abs.asInteger;
		noteArray = noteArray.add(dif);
		if (noteArray[i] <= min){
			min = noteArray[i];
			index = i;
		};
	};
	index;
};
