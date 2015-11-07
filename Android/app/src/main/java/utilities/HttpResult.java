package utilities;

import org.json.JSONObject;

/**
 * Created by Sam.I on 10/13/2015.
 */
public interface HttpResult {
//    void onCallback(String response, boolean success);

    void onCallback(JSONObject response, boolean success);
//    void onCallback(Object response, boolean success);
}
