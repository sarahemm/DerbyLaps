using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class LapAlertOptionsMenuView extends Ui.MenuInputDelegate {
    function initialize() {
        Ui.MenuInputDelegate.initialize();
    }
    function onMenuItem(item) {
    	var app = App.getApp();
        if (item == :both) {
        	lapAlertTone = true;
			lapAlertVibe = true;
        } else if (item == :tone) {
        	lapAlertTone = true;
			lapAlertVibe = false;
        } else if (item == :vibe) {
        	lapAlertTone = false;
			lapAlertVibe = true;
        } else {
        	lapAlertTone = false;
			lapAlertVibe = false;
        }
        app.setProperty("lapAlertTone", lapAlertTone);
        app.setProperty("lapAlertVibe", lapAlertVibe);
    }
}