using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Attention as Attn;

var countdownToggle = false;
var bpmCheckTimer;
var sensorInfo;

class SetupView extends Ui.View {
	var bmpHeart;
	
	function initialize() {
		Ui.View.initialize();
	}
	
    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.SetupLayout(dc));
       	
		// load the heart icon we'll use to indicate heart rate data
		bmpHeart = Ui.loadResource(Rez.Drawables.heart);

       	// turn on the heart rate and temperature sensors so we can show if they're working
		Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE]);
		sensorInfo = Sensor.getInfo();
		
		// set up a timer to check twice a second if we're getting heart rate info
		bpmCheckTimer = new Timer.Timer();
		bpmCheckTimer.start(method(:timerBpmCheckTimer), 500, true);		
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
    	// update the display for the current state
    	var lapsView = View.findDrawableById("laps");
    	var minsView = View.findDrawableById("mins");
    	var minsLabelView = View.findDrawableById("minsLabel");
    	var readyView = View.findDrawableById("ready");
    	var heartView = View.findDrawableById("heartIcon");
    	
		if(state == STATE_SET_LAPS) {
			lapsView.setColor(Gfx.COLOR_GREEN);
			minsView.setColor(Gfx.COLOR_LT_GRAY);
			lapsView.setText(laps.format("%d"));
		} else if(state == STATE_SET_MINS) {
			lapsView.setColor(Gfx.COLOR_LT_GRAY);
			minsView.setColor(Gfx.COLOR_GREEN);
			minsView.setText(mins.format("%d"));
			if(mins == 1) {
				minsLabelView.setText(Rez.Strings.minute);
			} else {
				minsLabelView.setText(Rez.Strings.minutes);
			}
			readyView.setColor(Gfx.COLOR_BLACK);
		} else if(state == STATE_READY) {
			minsView.setColor(Gfx.COLOR_WHITE);
			lapsView.setColor(Gfx.COLOR_WHITE);
			readyView.setColor(Gfx.COLOR_GREEN);
		}	
        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

		// this has to come after the layout redraw or it draws over top of us
        if(sensorInfo.heartRate) {
	    	dc.drawBitmap(heartView.locX, heartView.locY, bmpHeart);
	    }
    
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }
	
	function timerBpmCheckTimer() {
		sensorInfo = Sensor.getInfo();
		Ui.requestUpdate();
	}
}

class SetupDelegate extends Ui.BehaviorDelegate {
	var shortVibe = [new Attn.VibeProfile(100, 250)];

	function initialize() {
		Ui.BehaviorDelegate.initialize();
	}

	function onKey(evt) {
    	if(evt.getKey() == Ui.KEY_ENTER && evt.getType() == Ui.PRESS_TYPE_ACTION) {
    		// go to the next state
        	state += 1;
        	
        	// check toggle for whether to start with countdown or not
        	if(!countdownToggle) {
        		if(state == STATE_COUNTDOWN) {
					Ui.pushView(new CountdownView(), new CountdownDelegate(), Ui.SLIDE_UP);
        		}
        	} else if(state == STATE_COUNTDOWN) {
        		state = STATE_RUNNING;
        		Attn.vibrate(shortVibe);
				Ui.pushView(new PacingView(), new PacingDelegate(), Ui.SLIDE_UP);
        	}	
    	} else if(evt.getKey() == Ui.KEY_ESC && evt.getType() == Ui.PRESS_TYPE_ACTION) {
			// go back to the previous state (if possible)
        	state -= 1;
        	if(state < 0) {
        		// exit the app
        		Ui.popView(Ui.SLIDE_DOWN);
        	}
    	} else if(evt.getKey() == Ui.KEY_UP && evt.getType() == Ui.PRESS_TYPE_ACTION) {
			incrementCurrentField();
    	} else if(evt.getKey() == Ui.KEY_DOWN && evt.getType() == Ui.PRESS_TYPE_ACTION) {
			decrementCurrentField();
    	} else {
    		return false;
    	}
    	Ui.requestUpdate();
    	return true;
    }
    
    function onTap(evt){
    	var coord = evt.getCoordinates();
		if(mDevice.equals("vivoactive")) {
			if( (Math.pow((coord[0] - 20),2) + Math.pow((coord[1] - 125),2) < Math.pow(15, 2)) && evt.getType() == Ui.CLICK_TYPE_TAP) {
				incrementCurrentField();
			} else if( (Math.pow((coord[0] - 185),2) + Math.pow((coord[1] - 125),2) < Math.pow(20, 2)) && evt.getType() == Ui.CLICK_TYPE_TAP) {
				decrementCurrentField();
			}
		} else if(mDevice.equals("vivoactive_hr")) {
      		if(coord[0] > 100 && coord[1] > 140 && evt.getType() == Ui.CLICK_TYPE_TAP) {
				incrementCurrentField();
	       	} else if(coord[0] < 50 && coord[1] > 140 && evt.getType() == Ui.CLICK_TYPE_TAP) {
				decrementCurrentField();
			}
       	} else {
    		return false;
    	}
    	Ui.requestUpdate();    
    	return true;
    }
    
    function onMenu() {
        Ui.pushView(new Rez.Menus.OptionsMenu(), new OptionsMenuView(), Ui.SLIDE_UP);
        return true;
    }
    
    function incrementCurrentField() {
    	if(state == STATE_SET_LAPS) {
			laps += 1;
			if(laps > 99) { laps = 99; }
		} else if(state == STATE_SET_MINS) {
			mins += 1;
			if(mins > 30) { mins = 30; }
		}
	}
	
	function decrementCurrentField() {
		if(state == STATE_SET_LAPS) {
			laps -= 1;
			if(laps < 1) { laps = 1; }
		} else if(state == STATE_SET_MINS) {
			mins -= 1;
			if(mins < 1) { mins = 1; }
		}
	}
}
