package utilities;

import org.json.JSONObject;

public interface HttpResult {
//    void onCallback(String response, boolean success);

    void onCallback(JSONObject response, boolean success);
//    void onCallback(Object response, boolean success);
}
