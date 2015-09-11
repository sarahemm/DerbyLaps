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

class DerbyLapsApp extends App.AppBase {

    //! onStart() is called on application start up
    function onStart() {
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new SetupView(), new SetupDelegate() ];
    }
}
