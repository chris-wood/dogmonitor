#require "Plotly.class.nut:1.0.0"

function postToPlotly(reading) {
    local timestamp = plot1.getPlotlyTimestamp();
    server.log(reading["value"]);
    plot1.post([
        {
            "name" : "Sound Value",
            "x" : [timestamp],
            "y" : [reading["value"]]
        }
    ]);
}

plot1 <- Plotly("caw4567", "hmez80vzy5", "DogMonitor", true, ["Sound Value"], function(error, response, decoded) {
    device.on("soundReading", postToPlotly);
    server.log("See plot at " + plot1.getUrl());
    server.log(error);
});

function loopFunction() {
    local data = {
        value = 0
    }
    postToPlotly(data);
    imp.wakeup(0.5, loopFunction);
}
loopFunction();

// local tokens = {
//     sensortoken = "lvh90wnkyz"
// }

// device.on("init" function(msg) {
    
//     server.log("ON INIT!");
    
//     // Init Plotly Data Object (No sensor data here)
//     local data = [{
//         x = [],
//         y = [],
//         stream = {
//             token = tokens.sensortoken,
//             maxpoints = 25
//         }
//     }];

//     // Plotly Layout Object
//     local layout = {
//         fileopt = "extend",
//         filename = "Dog Monitor"

//     };

//     // format object to be POSTed
//     local payload = {
//         un = "caw4567",
//         key = "hmez80vzy5",
//         origin = "plot",
//         platform = "electricimp",
//         args = http.jsonencode(data),
//         kwargs = http.jsonencode(layout),
//         version = "0.0.1"
//     };

//     // encode data and log
//     local url = "https://plot.ly/clientresp";
//     local headers = { "Content-Type" : "application/json" };
//     local body = http.urlencode(payload);
//     HttpPostWrapper(url, headers, body, true);

//     // when a response is received and the graph is ready to
//     // accept a stream, send the device a init:success message!
//     device.send("initsuccess", "success");
// });

device.on("soundReading", function(sensordata) {
    // local headers = {"plotly-streamtoken" : tokens.sensortoken };
    // local body = {
        // x = sensordata.time_stamp,
        // y = sensordata.value
    // }
    // local data = http.jsonencode(body);
    
    postToPlotly(sensordata);

    // server.log("sending data to server");
    // server.log(data);
    
    // local url  = "http://stream.plot.ly"
    // HttpPostWrapper(url, headers, data, true);
});

// Http Request Handler
function HttpPostWrapper (url, headers, string, log) {
    local request = http.post(url, headers, string);
    local response = request.sendsync();
    if (log)
        server.log(http.jsonencode(response));
    return response;
}

// function loggerCallback(error, response, decoded) {
//     if(error == null) {
//         server.log(response.body);
//     } else {
//         server.log(error);
//     }
// }

// function postToPlotly(reading) {
//     local timestamp = plot1.getPlotlyTimestamp();
//     plot1.post([
//         {
//             "name" : "Sound",
//             "x" : [timestamp],
//             "y" : [reading["value"]]
//         }], loggerCallback);
// }


// // When the imp sends data to the agent, that data needs to be relayed to the
// // other agent. We need to construct a simple URL with a parameter to send
// // the data.
// local constructorCallback = function(error, response, decoded) {
//     if (error != null) {
//         server.log(error);
//         return;
//     }
    
//     device.on("soundReading", postToPlotly(reading));
    
//     plot1.setTitle("Dog Monitor", function(error, response, decoded) {

//         if(error != null) {
//             server.log(error);
//             return;
//         }

//         plot1.setAxisTitles("time", "Reading", function(error, response, decoded) {
//             if(error != null) {
//                 server.log(error);
//                 return;
//             }

//             local style =
//             [
//                 {
//                     "name" : "Sound",
//                     "type": "scatter",
//                     "marker": {"symbol": "square", "color": "purple"}

//                 }
//             ];
//             plot1.setStyleDirectly(style, function(error, response, decoded) {
//                 if(error != null) {
//                     server.log(error);
//                     return;
//                 }
//             });
//         });
//     });
// }

// local traces = ["Sound"];
// plot1 <- Plotly("caw4567", "hmez80vzy5", "my_file_name", true, traces, constructorCallback);

// // The request handler will be called whenever this agent receives an HTTP
// // request. We need to parse the request, look for the key "data". If we 
// // found "data", send that value over to the imp.
// function requestHandler(request, response)
// {
//     try
//     {
//         // Check for "data" key.
//         if ("data" in request.query)
//         {
//             // If we see "data", send that value over to the imp.
//             // Label the data "dataToSerial" (data to serial output).
//             local data = request.query.data
//             server.log("Received data: " + data);
//             device.send("dataToSerial", data);
//         }
//         // send a response back saying everything was OK.
//         response.send(200, "OK");
//     }
//     catch (ex)  // In case of an error, produce an error code.
//     {
//         response.send(500, "Internal Server Error: " + ex);
//     }
// }
// http.onrequest(requestHandler);
