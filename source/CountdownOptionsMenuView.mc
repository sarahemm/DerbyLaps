using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class CountdownOptionsMenuView extends Ui.MenuInputDelegate {

    function onMenuItem(item) {
        if (item == :item_1) {
            countdownToggle = false;
        } else if (item == :item_2) {
            countdownToggle = true;
        }
    }

}