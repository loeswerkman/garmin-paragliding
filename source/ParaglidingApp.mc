import Toybox.Activity;
import Toybox.ActivityRecording;
import Toybox.Application;
import Toybox.Lang;
import Toybox.Position;
import Toybox.Timer;
import Toybox.WatchUi;

class ParaglidingApp extends Application.AppBase {

    var verticalSpeed as Float = 0.0;

    private var _session as ActivityRecording.Session?;
    private var _timer as Timer.Timer = new Timer.Timer();
    private var _lastAltitude as Float?;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        _timer.start(method(:onTick), 1000, true);
    }

    function onStop(state as Dictionary?) as Void {
        _timer.stop();
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        if (isRecording()) {
            toggleRecording();
        }
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return createPage(0);
    }

    function isRecording() as Boolean {
        return _session != null;
    }

    function toggleRecording() as Void {
        var session = _session;
        if (session == null) {
            session = ActivityRecording.createSession({
                :name => "Paragliding",
                :sport => Activity.SPORT_HANG_GLIDING
            });
            session.start();
            _session = session;
        } else {
            session.stop();
            session.save();
            _session = null;
        }
    }

    // GPS fixes are consumed by the activity session and map; nothing to do here.
    function onPosition(info as Position.Info) as Void {
    }

    // Runs every second, so the altitude delta equals the vertical speed in m/s.
    function onTick() as Void {
        var info = Activity.getActivityInfo();
        var altitude = info != null ? info.altitude : null;
        var last = _lastAltitude;
        if (altitude != null && last != null) {
            verticalSpeed = altitude - last;
        }
        _lastAltitude = altitude;
        WatchUi.requestUpdate();
    }
}

function getApp() as ParaglidingApp {
    return Application.getApp() as ParaglidingApp;
}
