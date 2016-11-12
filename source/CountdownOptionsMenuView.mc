using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class CountdownOptionsMenuView extends Ui.MenuInputDelegate {
    function initialize() {
        Ui.MenuInputDelegate.initialize();
    }
    function onMenuItem(item) {
    	var app = App.getApp();
        if (item == :on) {
            countdownEnabled = true;
        } else if (item == :off) {
            countdownEnabled = false;
        }
        app.setProperty("countdownEnabled", countdownEnabled);
    }

}