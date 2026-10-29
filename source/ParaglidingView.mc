import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.WatchUi;

// Draws the data pages: 0 = vario + ground speed, 1 = altitude, 3 = compass.
class ParaglidingView extends WatchUi.View {

    private var _page as Number;

    function initialize(page as Number) {
        View.initialize();
        _page = page;
    }

    function onUpdate(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var info = Activity.getActivityInfo();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        if (getApp().isRecording()) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(w / 2, h * 0.08, Graphics.FONT_XTINY, "REC", Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(w / 2, h * 0.08, Graphics.FONT_XTINY, "START to record", Graphics.TEXT_JUSTIFY_CENTER);
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        if (_page == 0) {
            var speed = info != null ? info.currentSpeed : null;
            drawField(dc, h * 0.35, "VARIO m/s", getApp().verticalSpeed.format("%+.1f"));
            drawField(dc, h * 0.7, "SPEED km/h", speed != null ? (speed * 3.6).format("%.0f") : "--");
        } else if (_page == 1) {
            var altitude = info != null ? info.altitude : null;
            drawField(dc, h * 0.5, "ALTITUDE m", altitude != null ? altitude.format("%.0f") : "--");
        } else {
            var heading = info != null ? info.currentHeading : null;
            drawCompass(dc, heading != null ? heading : 0.0);
        }
    }

    private function drawField(dc as Dc, y as Numeric, label as String, value as String) as Void {
        dc.drawText(dc.getWidth() / 2, y, Graphics.FONT_SMALL, label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth() / 2, y + dc.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_LARGE, value, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Heading is in radians clockwise from north; "N" is drawn where north lies relative to the watch top.
    private function drawCompass(dc as Dc, heading as Float) as Void {
        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;
        var r = cx * 0.7;
        dc.drawCircle(cx, cy, r);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx - r * Math.sin(heading), cy - r * Math.cos(heading), Graphics.FONT_MEDIUM, "N", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var degrees = (Math.toDegrees(heading).toNumber() + 360) % 360;
        dc.drawText(cx, cy, Graphics.FONT_LARGE, degrees.format("%d"), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
