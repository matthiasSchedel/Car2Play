package de.kinemic.example.gesturereceiver;

import android.content.Context;
import android.graphics.Path;
import android.os.Handler;
import android.os.Bundle;

import org.json.JSONException;

import de.kinemic.toolbox.AdvancedGestureActivity;
import de.kinemic.toolbox.event.PublisherEvent;

/**
 * An activity which lets you use the airmouse feature to draw on the screen.
 * To switch between reposition and manipulation ues the toggle gesture.
 * To switch between pen up and pen down switch from vertical to horizontal hand position.
 * You can swap color with the swipe gestures.
 * Leave this acivity either by pressing backbutton or executing the Rotate LR gesture.
 */
public class MouseEventActivity extends AdvancedGestureActivity {

    GestureDrawView mDrawView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mDrawView = new GestureDrawView(this);
        setContentView(mDrawView);
    }

    @Override
    protected void onResume() {
        super.onResume();

        /* trigger delayed reset */
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                requestOrientationReset();
            }
        }, 500L);
    }

    private static class GestureDrawView extends DrawingView {
        private boolean mActive = true;
        /* mapping from mouse coords to pixels */
        private final double MOUSE_PIXEL_FACTOR = -16.;

        public GestureDrawView(Context context) {
            super(context);
        }

        /* draw with gestures (hand vertical is pen up) */
        private void onMouseEvent(PublisherEvent.MouseEvent event) {
            switch (event.type) {

                case Toggle:
                    mActive = !mActive;

                    if (!mActive) {
                        circlePath.reset();
                        circlePath.addCircle(mX, mY, 15, Path.Direction.CW);
                        invalidate();
                    }
                    break;
                case Move:
                    if (mActive) {
                        touch_move(
                                (float) (mX + event.dx * MOUSE_PIXEL_FACTOR),
                                (float) (mY + event.dy * MOUSE_PIXEL_FACTOR),
                                !event.palmVertical);
                        invalidate();
                    }
                    break;
            }
        }

    }

    @Override
    protected void handleEvent(PublisherEvent event) throws JSONException {
        if (event.type == PublisherEvent.Type.MouseEvent) {
            final PublisherEvent.MouseEvent mouseEvent = event.asMouseEvent();
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mDrawView.onMouseEvent(mouseEvent);
                }
            });
        } else if (event.type == PublisherEvent.Type.Gesture) {
            final PublisherEvent.Gesture gesture = event.asGesture();
            // close on Rotate RL
            if ("Rotate LR".equals(gesture.name)) {
                finish();
            } else if ("Circle R".equals(gesture.name)) {
                requestOrientationReset();
            } else if ("Circle L".equals(gesture.name)) {
                requestOrientationReset();
            } else {
                if ("Swipe R".equals(gesture.name)) {
                    mDrawView.nextColor();
                } else if ("Swipe L".equals(gesture.name)) {
                    mDrawView.prevColor();
                }
            }
        }
    }
}
