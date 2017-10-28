package de.kinemic.example.gesturereceiver;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

/**
 * Created by Fabian on 25.10.17.
 */

public class DrawingView extends View {

    public int width;
    public  int height;
    private boolean forward;
    private boolean right;
    private Bitmap mBitmap;
    private Canvas mCanvas;
    private Path mPath;
    private Paint mBitmapPaint;
    Context mContext;
    private Paint circlePaint;
    protected Path circlePath;
    private Paint mPaint;
    private int mColorIntex = 0;
    private final int[] mColors = new int[] {Color.GREEN, Color.BLUE, Color.RED, Color.YELLOW, Color.MAGENTA, Color.CYAN};

    public DrawingView(Context context) {
        super(context);
        mContext=context;
        mPath = new Path();
        mBitmapPaint = new Paint(Paint.DITHER_FLAG);
        mPaint = new Paint();
        mPaint.setAntiAlias(true);
        mPaint.setDither(true);
        mPaint.setColor(Color.GREEN);
        mPaint.setStyle(Paint.Style.STROKE);
        mPaint.setStrokeJoin(Paint.Join.ROUND);
        mPaint.setStrokeCap(Paint.Cap.ROUND);
        mPaint.setStrokeWidth(12);
        circlePaint = new Paint();
        circlePath = new Path();
        circlePaint.setAntiAlias(true);
        circlePaint.setColor(Color.BLUE);
        circlePaint.setStyle(Paint.Style.STROKE);
        circlePaint.setStrokeJoin(Paint.Join.MITER);
        circlePaint.setStrokeWidth(4f);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        width = w;
        height = h;
        mBitmap = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
        mCanvas = new Canvas(mBitmap);
        touch_up();
        touch_move(w/2, h/2, false);
        invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        canvas.drawBitmap( mBitmap, 0, 0, mBitmapPaint);
        canvas.drawPath( mPath,  mPaint);
        canvas.drawPath( circlePath,  circlePaint);
    }

    protected float mX;
    protected float mY;
    private static final float TOUCH_TOLERANCE = 4;
    private static final String API_URI = "http://192.168.0.1:5000/";
    private boolean up = false;

    private void touch_start(float x, float y) {

        mPath.reset();
        //mPath.moveTo(x, y);
        mX = x;
        mY = y;
        up = false;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    protected void touch_move(float x, float y, boolean pressed) {
 float dx = Math.abs(x - mX);
        float dy = Math.abs(y - mY);
        if (dx >= TOUCH_TOLERANCE || dy >= TOUCH_TOLERANCE) {
            if (pressed && !up) {
                //mPath.quadTo(mX, mY, (x + mX) / 2, (y + mY) / 2);
            } else if (pressed && up) {
                touch_start(x, y);
            } else if (!pressed && !up) {
                touch_up();
            }
            mX = x;
            mY = y;
            circlePath.reset();
            //circlePath.setLastPoint(width/2 + 300,height/2);
            circlePath.addCircle(width/2 , height/2, 300, Path.Direction.CW);
            circlePath.close();
            circlePath.setLastPoint(width/2 - 300,height/2);

            circlePath.lineTo(width/2 + 300,height/2 + 0);
            circlePath.setLastPoint(width/2 + 0,height/2 - 300);
            circlePath.lineTo(width/2 + 0,height/2 + 300);
            circlePath.addCircle(mX, mY, 30, Path.Direction.CW);
            direction((float) (mX-(width/2.)));
            power(-1.f * (float) (mY-(height/2.)));

        }
    }

    private void touch_up() {
        up = true;

        mPath.lineTo(mX, mY);
        circlePath.reset();
        // commit the path to our offscreen
        //mCanvas.drawPath(mPath,  mPaint);
        // kill this so we don't double draw
        mPath.reset();
    }

    /* move the cursor (circle) with touch */
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public boolean onTouchEvent(MotionEvent event) {
        float x = event.getX();
        float y = event.getY();
        Log.d("x (Touch event): ", String.valueOf(x));
        Log.d("y (Touch event): ", String.valueOf(y));

        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                Log.d("ACTION","DOWN");
                //touch_start(x, y);
                invalidate();
                break;
            case MotionEvent.ACTION_MOVE:
                Log.d("ACTION","MOVE");
                touch_move(x, y, false);
                invalidate();
                break;
            case MotionEvent.ACTION_UP:
                Log.d("ACTION","UP");
                //touch_up();
                invalidate();
                break;
        }
        return true;
    }

    public void nextColor() {
        mColorIntex = (mColorIntex + 1) % mColors.length;
        mPaint.setColor(mColors[mColorIntex]);
    }

    public void prevColor() {
        mColorIntex = (mColorIntex + mColors.length - 1) % mColors.length;
        mPaint.setColor(mColors[mColorIntex]);
    }

    private void direction(float direction) {
        Log.d("DIRECTION", ""+direction);
        if (direction > 0 && !right) {
            moveCar("right");
            right = !right;
        } else if (direction < 0 && right) {
            moveCar("left");
            right = !right;
        }
    }


    private void power(float power) {
        Log.d("POWER", ""+power);
        if (power > 0 && !forward) {
            moveCar("backward");
            forward = !forward;
        } else if (power < 0 && forward) {
            moveCar("forward");
            forward = !forward;
        }
    }

    public void moveCar(String method) {

        Log.i("testAdress", "start");
        RequestQueue queue = Volley.newRequestQueue(getContext());
        String url = API_URI + method;
        Log.i("url", url);
        // Request a string response from the provided URL.
        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        // Display the first 500 characters of the response string.
                        int stringLength = response.length();
                        //testResult.setText("Response is: " + response.substring(0, stringLength - 1));
                        Log.i("Response", response.substring(0, stringLength - 1));
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.e("Response ERROR",error.toString());
                //testResult.setText("That didn't work!");
                error.printStackTrace();
            }
        });
        // Add the request to the RequestQueue.
        queue.add(stringRequest);
    }
}
