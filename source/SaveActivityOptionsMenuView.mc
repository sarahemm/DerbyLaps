using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class SaveActivityOptionsMenuView extends Ui.MenuInputDelegate {
    function initialize() {
        Ui.MenuInputDelegate.initialize();
    }
    function onMenuItem(item) {
    	var app = App.getApp();
        if (item == :on) {
            saveActivity = true;
        } else if (item == :off) {
            saveActivity = false;
        }
        app.setProperty("saveActivity", saveActivity);
    }

}