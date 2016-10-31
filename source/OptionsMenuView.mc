using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class OptionsMenuView extends Ui.MenuInputDelegate {
    function initialize() {
        Ui.MenuInputDelegate.initialize();
    }
    

    function onMenuItem(item) {
        if (item == :countdown) {
            Ui.pushView(new Rez.Menus.CountdownOptionsMenu(), new CountdownOptionsMenuView(), Ui.SLIDE_UP);
        }
    }

}