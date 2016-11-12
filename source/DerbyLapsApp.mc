using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

enum {
	STATE_SET_LAPS,
	STATE_SET_MINS,
	STATE_READY,
	STATE_COUNTDOWN,
	STATE_RUNNING
}
	
var state = STATE_SET_LAPS;
var laps = 27;
var mins = 5;

var countdownEnabled = true;

class DerbyLapsApp extends App.AppBase {
	function initialize() {
		AppBase.initialize();
	}
	
    //! onStart() is called on application start up
    function onStart(state) {
    	// do the initial load of properties from the object store
    	onSettingsChanged();
    }

    //! onStop() is called when your application is exiting
    function onStop(state) {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new SetupView(), new SetupDelegate() ];
    }
    
    function onSettingsChanged() {
    	var app = App.getApp();
		countdownEnabled = app.getProperty("countdownEnabled");
		Sys.println(countdownEnabled);
    }
}
