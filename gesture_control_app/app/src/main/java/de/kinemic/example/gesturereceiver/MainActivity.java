package de.kinemic.example.gesturereceiver;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONException;

import java.util.Date;

import de.kinemic.toolbox.AdvancedGestureActivity;
import de.kinemic.toolbox.event.PublisherEvent;

public class MainActivity extends AdvancedGestureActivity {

    private TextView mSensorInfo;
    private TextView mStreamInfo;
    private TextView mLastInfo;
    private TextView mActiveInfo;
    private TextView mLastEventInfo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mSensorInfo = (TextView) findViewById(R.id.meta_sensor_info);
        mStreamInfo = (TextView) findViewById(R.id.meta_stream_info);
        mLastInfo = (TextView) findViewById(R.id.meta_last_info);
        mActiveInfo = (TextView) findViewById(R.id.meta_active_info);
        mLastEventInfo = (TextView) findViewById(R.id.event_info);
    }

    @Override
    protected String getPublisherIP() {
        return "127.0.0.1";
    }

    @Override
    protected void handleEvent(final PublisherEvent event) throws JSONException {
        runOnUiThread(new Runnable() {
            @Override public void run() {
                Date now = new Date();
                try {
                    switch (event.type) {

                        case Gesture:
                            PublisherEvent.Gesture gesture = event.asGesture();
                            Log.d("Events", "Gesture: " + gesture.name);
                            mLastEventInfo.setText(now.toString() + " Gesture: " + gesture.name);
                            if ("Swipe R".equals(gesture.name)) {
                                Toast.makeText(MainActivity.this, "Right", Toast.LENGTH_SHORT).show();
                                break;
                            } else if ("Swipe L".equals(gesture.name)) {
                                Toast.makeText(MainActivity.this, "Left", Toast.LENGTH_SHORT).show();
                                break;
                            }

                            onGesture(gesture);
                            break;
                        case Writing:
                            break;
                        case MouseEvent:
                            break;
                        case Activation:
                            PublisherEvent.Activation activation = event.asActivation();
                            Log.d("Events", "Activation: " + activation.active);
                            mLastEventInfo.setText(now.toString() + "Activation: Stream " + (activation.active ? "resumed" : "paused"));
                            break;
                        case WritingSegment:
                            break;
                        case Heartbeat:
                            PublisherEvent.Heartbeat h = event.asHeartbeat();
                            Log.d("Events", "Heartbeat [active: " + h.active + ", last: " + h.last + ", stream: " + h.stream + ", sensor: " + h.sensor + "]");
                            mSensorInfo.setText(h.sensor);
                            mStreamInfo.setText(h.stream);
                            mLastInfo.setText("" + h.last);
                            mActiveInfo.setText("" + h.active);
                            break;
                    }
                } catch (JSONException e) {
                }
            }
        });
    }

    protected void onGesture(PublisherEvent.Gesture gesture) {
        if (gesture.name.equals("Rotate RL")) {
            Intent intent = new Intent(this, MouseEventActivity.class);
            startActivity(intent);
        }
    }
}
