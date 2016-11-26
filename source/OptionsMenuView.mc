using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class OptionsMenuView extends Ui.MenuInputDelegate {
    function initialize() {
        Ui.MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :countdown) {
            Ui.pushView(new Rez.Menus.OnOffMenu(), new CountdownOptionsMenuView(), Ui.SLIDE_UP);
        }
        if (item == :saveactivity) {
            Ui.pushView(new Rez.Menus.OnOffMenu(), new SaveActivityOptionsMenuView(), Ui.SLIDE_UP);
        }
        if (item == :lapalert) {
            Ui.pushView(new Rez.Menus.LapAlertMenu(), new LapAlertOptionsMenuView(), Ui.SLIDE_UP);
        }
    }
}