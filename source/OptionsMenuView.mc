using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class OptionsMenuView extends Ui.MenuInputDelegate {

    function onMenuItem(item) {
        if (item == :item_1) {
            Ui.pushView(new Rez.Menus.CountdownOptionsMenu(), new CountdownOptionsMenuView(), Ui.SLIDE_UP);
        } else if (item == :item_2) {
            Sys.println("item 2");
        }
    }

}