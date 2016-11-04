using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Attention as Attn;

class LapNotifyView extends Ui.View {
	var timer;
	
	function initialize() {
		Ui.View.initialize();
	}
	
    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.LapNotifyLayout(dc));
      	timer = new Timer.Timer();
    	timer.start(method(:timerHide), 1500, true);

    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    	var lapView = View.findDrawableById("lap");
    	var lapLabelView = View.findDrawableById("lapLabel");
    	if(msRemaining <= 0) {
	    	lapLabelView.setText(Rez.Strings.Laps);
	    	lapView.setText(Rez.Strings.done);
    	} else {
	    	lapLabelView.setText(Rez.Strings.Lap);
    		lapView.setText(lapNbr.format("%d"));
    	}
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

	function timerHide() {
		timer.stop();
		Ui.popView(Ui.SLIDE_IMMEDIATE);
	}
}

class LapNotifyDelegate extends Ui.BehaviorDelegate {
	function initialize() {
		Ui.BehaviorDelegate.initialize();
	}
	
	function onKey(evt) {
		return false;
    }
}