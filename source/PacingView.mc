using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Attention as Attn;
using Toybox.ActivityRecording as Recording;
using Toybox.Sensor as Sensor;

var pacingTimer;
var lapNbr = 1;
var session;

class PacingView extends Ui.View {
	var msTotal = mins * 60 * 1000;
	var msRemaining = msTotal;
	var msPerLap = msTotal / laps;
	var prevLapNbr = 1;
	var startVibe;
	var lapVibe;
	var doneVibe;

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.PacingLayout(dc));
    	pacingTimer = new Timer.Timer();
		pacingTimer.start(method(:timerPacingTimer), 100, true);
    	startVibe = [new Attn.VibeProfile(100, 750)];
		lapVibe = [new Attn.VibeProfile(100, 250)];
		doneVibe = [
			new Attn.VibeProfile(100, 1000),
			new Attn.VibeProfile(50,  250),
			new Attn.VibeProfile(25,  250),
			new Attn.VibeProfile(0,   250),
			new Attn.VibeProfile(25,  250),
			new Attn.VibeProfile(50,  250),
			new Attn.VibeProfile(100, 1000)
		];
		Attn.playTone(Attn.TONE_START);
		Attn.vibrate(startVibe);
		// get ready to start a new FIT recording
		session = Recording.createSession({
			:name => "Derby Laps",
			:sport => Recording.SPORT_TRAINING
		});
		// turn on the heart rate and temperature sensors and start recording
		Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE]);
		session.start();
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
    	var timeView = View.findDrawableById("time");
    	var lapView = View.findDrawableById("lap");
    	timeView.setText(Lang.format("$1$:$2$.$3$", [
    		msRemaining / 60000,
    		(msRemaining / 1000 % 60).format("%02d"),
    		msRemaining % 1000 / 100
    	]));
    	lapView.setText(lapNbr.format("%d"));
    	
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }
    
    function timerPacingTimer() {
		msRemaining -= 100;
		
    	if(msRemaining <= 0) {
    		// all done, go back to the setup screen
    		Attn.vibrate(doneVibe);
			Attn.playTone(Attn.TONE_STOP);
    		
    		pacingTimer.stop();
			// stop and save the FIT recording
    		session.stop();
    		session.save();
    		state = STATE_READY;
    		Ui.popView(Ui.SLIDE_DOWN);
			return;
    	}

		// calculate the current lap number and act on it if required
		lapNbr = ((msTotal - msRemaining) / msPerLap) + 1;
		if(lapNbr > prevLapNbr) {
			// new lap
			// add the new lap to the FIT recording session
			session.addLap();
			// show them in large text the new lap number
			// this view will pop itself after being displayed for a brief time
			Ui.pushView(new LapNotifyView(), new LapNotifyDelegate(), Ui.SLIDE_IMMEDIATE);
			// buzz to indicate the skater should be at the start line right now
			Attn.vibrate(lapVibe);
			Attn.playTone(Attn.TONE_LAP);
    	}
    	prevLapNbr = lapNbr;
    	
		Ui.requestUpdate();
    }
}

class PacingDelegate extends Ui.BehaviorDelegate {
	function onKey(evt) {
		if(evt.getKey() == Ui.KEY_ESC && evt.getType() == Ui.PRESS_TYPE_ACTION) {
			pacingTimer.stop();
			// stop and save whatever we have so far in the FIT recording
    		session.stop();
    		session.save();
    		// go back to the setup screen
			state = STATE_READY;
			Ui.popView(Ui.SLIDE_DOWN);
			return true;
		}
		
		return false;
    }
}