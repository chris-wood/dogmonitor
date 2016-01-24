device.on("soundReading", function(sensordata) {
    local body = {
        time = sensordata["time_stamp"],
        value = sensordata["value"]
    }
    uploadReading(body, true);
});

function uploadReading(object, log) {
    local data = http.jsonencode(object);

    server.log("Sending:");
    server.log(data);

    local url  = "http://homeautomation-1176.appspot.com/sound";
    local headers = { "Content-Type" : "application/json" };
    HttpPostWrapper(url, headers, data, log);
}

// Http Request Handler
function HttpPostWrapper (url, headers, string, log) {
    local request = http.post(url, headers, string);
    local response = request.sendsync();
    if (log) {
        server.log(http.jsonencode(response));
    }
    return response;
}

// Loop indefinitely...
function loopFunction() {
    local body = {
        time = 0,
        value = 0
    }
    uploadReading(body, false);
    imp.wakeup(1.0, loopFunction); // send once every second...
}
// loopFunction();
