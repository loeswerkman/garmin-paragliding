import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

const PAGE_COUNT = 4;
const MAP_PAGE = 2;

function createPage(page as Number) as [WatchUi.View, WatchUi.BehaviorDelegate] {
    if (page == MAP_PAGE) {
        var map = new WatchUi.MapTrackView();
        var settings = System.getDeviceSettings();
        map.setScreenVisibleArea(0, 0, settings.screenWidth, settings.screenHeight);
        return [map, new ParaglidingDelegate(page)];
    }
    return [new ParaglidingView(page), new ParaglidingDelegate(page)];
}

class ParaglidingDelegate extends WatchUi.BehaviorDelegate {

    private var _page as Number;

    function initialize(page as Number) {
        BehaviorDelegate.initialize();
        _page = page;
    }

    function onNextPage() as Boolean {
        return showPage((_page + 1) % PAGE_COUNT, WatchUi.SLIDE_UP);
    }

    function onPreviousPage() as Boolean {
        return showPage((_page + PAGE_COUNT - 1) % PAGE_COUNT, WatchUi.SLIDE_DOWN);
    }

    // START button (or screen tap) starts the flight, pressing again stops and saves it.
    function onSelect() as Boolean {
        getApp().toggleRecording();
        WatchUi.requestUpdate();
        return true;
    }

    // Block exiting the app while a flight is being recorded.
    function onBack() as Boolean {
        return getApp().isRecording();
    }

    private function showPage(page as Number, transition as WatchUi.SlideType) as Boolean {
        var views = createPage(page);
        WatchUi.switchToView(views[0], views[1], transition);
        return true;
    }
}
