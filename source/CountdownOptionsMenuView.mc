using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class CountdownOptionsMenuView extends Ui.MenuInputDelegate {
    function initialize() {
        Ui.MenuInputDelegate.initialize();
    }
    

    function onMenuItem(item) {
        if (item == :on) {
            countdownToggle = false;
        } else if (item == :off) {
            countdownToggle = true;
        }
    }

}