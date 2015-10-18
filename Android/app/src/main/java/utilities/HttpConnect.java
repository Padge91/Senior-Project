//package utilities;
//
//import android.util.Log;
//import com.android.volley.Request;
//import com.android.volley.RequestQueue;
//import com.android.volley.Response;
//import com.android.volley.VolleyError;
//import com.android.volley.toolbox.JsonObjectRequest;
//import com.android.volley.toolbox.StringRequest;
//import com.android.volley.toolbox.Volley;
//import org.json.JSONObject;
//
///**
// * Creates a singleton class using the android/google volley library. A RequestQueue object
// * is created to queue up the various requests passed to this class.
// * <br>
// * Constructor is private so it cannot be called outside of this class. The reason for this
// * is because we only want one object of this classes to be used throughout the entire
// * application lifecycle. For that to happen, the object has to be instantiated with the
// * Application Context.
// *
// * <p><a href="https://developer.android.com/training/volley/index.html">Volley Tutorial</a></p>
// * <p><a href="http://afzaln.com/volley/">Volley Documentation</a></p>
// */
//public class HttpConnect {
//    private static HttpConnect mInstance;
//    private RequestQueue mRequestQueue;
//
//    private HttpConnect() {
//        // getApplicationContext() is key, it keeps you from leaking the
//        // Activity or BroadcastReceiver if someone passes one in.
//        mRequestQueue = Volley.newRequestQueue(MyApplication.getAppContext());
//    }
//
//    public static synchronized HttpConnect getInstance() {
//        if (mInstance == null) {
//            mInstance = new HttpConnect();
//            //TODO Remove.. check to make sure only one object is made throughout the application
//            //lifecycle
//            Log.e("httpConnect", "creating new object");
//        }
//        return mInstance;
//    }
//
//    public RequestQueue getRequestQueue() {
//        return mRequestQueue;
//    }
//
//    public <T> void addToRequestQueue(Request<T> req) {
//        getRequestQueue().add(req);
//    }
//
//
//    /***
//     * Sends a request to the desired url using the passed in request method. Gets data from
//     * url in the form of a json object.
//     * If json data needs to be sent in the request body, convert to string before passing into
//     * data parameter.
//     *
//     * @param url Url String
//     * @param requestMethod reference Request.Method interface in Request class
//     * @param data Data String
//     * @param callback HttpResult interface method that is passed back the return data and
//     *                 a boolean upon request completion. Boolean will be true if connection
//     *                 and data transfer is successful, or false otherwise.
//     */
//    public static void requestJson(String url, int requestMethod, String data, final HttpResult callback) {
//
//        //check request method
//        if (requestMethod == Request.Method.GET) {
//            //if GET, attach data string to url..
//            if (data.length() > 0) {
//                url += data;
//            }
//            //set data to null...GET requests require a null value for the requestBody parameter
//            data = null;
//        }
//
//        JsonObjectRequest request = new JsonObjectRequest(requestMethod, url, data, new Response.Listener<JSONObject>() {
//            @Override
//            public void onResponse(JSONObject response) {
//                //TODO Remove in production phase
//                Log.i("HttoConnect-requestJson", "response: " + response.toString());
//                callback.onCallback(response, true);
//            }
//        }, new Response.ErrorListener() {
//            @Override
//            public void onErrorResponse(VolleyError error) {
//                callback.onCallback(null, false);
//            }
//        });
//
//        //add request to queue
//        getInstance().getRequestQueue().add(request);
//    }
//
//
////    public ImageLoader getImageLoader() {
////        return mImageLoader;
////    }
//}
