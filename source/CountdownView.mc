using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Attention as Attn;

class CountdownView extends Ui.View {
	var secs = 3;
	var timer;
	var shortVibe;
	var longVibe;
	
    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.CountdownLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
      	timer = new Timer.Timer();
    	timer.start(method(:timerCountdown), 1000, true);
    	shortVibe = [new Attn.VibeProfile(100, 250)];
    	Attn.vibrate(shortVibe);
		Attn.playTone(Attn.TONE_KEY);
    }

    //! Update the view
    function onUpdate(dc) {
    
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }
    
	function timerCountdown() {
		secs -= 1;
		var countdownView = View.findDrawableById("countdown");
		countdownView.setText(secs.format("%d"));
		if(secs == 0) {
			timer.stop();
			Ui.popView(Ui.SLIDE_DOWN);
			state = STATE_RUNNING;
			Ui.pushView(new PacingView(), new PacingDelegate(), Ui.SLIDE_UP);
	 	} else {
	 		Attn.vibrate(shortVibe);
			Attn.playTone(Attn.TONE_KEY);
	 	}
		Ui.requestUpdate();
	}
}

class CountdownDelegate extends Ui.BehaviorDelegate {
	function onKey(evt) {
		return false;
    }
}