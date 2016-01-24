// Globals
local rxLEDToggle = 1;  // These variables keep track of rx/tx LED state
local txLEDToggle = 1;
arduino <- hardware.uart57;
rxLed <- hardware.pin8;
txLed <- hardware.pin9;

function getTime() {
    local date = date(time(), "l");
    local sec = stringTime(date["sec"]);
    local min = stringTime(date["min"]);
    local hour = stringTime(date["hour"]);
    local day = stringTime(date["day"]);
    local month = date["month"];
    local year = date["year"];
    return year+"-"+month+"-"+day+" "+hour+":"+min+":"+sec;
}

function stringTime(num) {
    if (num < 10) {
        return "0"+ num;
    } else {
        return "" + num;
    }
}

// initUart() will simply initialize the UART pins, baud rate, parity, and
//  callback function.
function initUart()
{
    hardware.configure(UART_57);    // Using UART on pins 5 and 7
    // 19200 baud works well, no parity, 1 stop bit, 8 data bits.
    // Provide a callback function, serialRead, to be called when data comes in:
    arduino.configure(19200, 8, PARITY_NONE, 1, NO_CTSRTS, serialRead);
}

// serialRead() will be called whenever serial data is passed to the imp. It
//  will read the data in, and send it out to the agent.
function serialRead()
{
    local soundValue = arduino.read();
    local soundReading = {
        value = soundValue,
        time_stamp = 0,
    }

    // Push the sound reading to the agent
    agent.send("soundReading", soundReading);

    // Inidicate physical activity
    toggleRxLED();
}

// initLEDs() simply initializes the LEDs, and turns them off. Remember that the
// LEDs are active low (writing high turns them off).
function initLEDs()
{
    rxLed.configure(DIGITAL_OUT);
    txLed.configure(DIGITAL_OUT);
    rxLed.write(1);
    txLed.write(1);
}

// This function turns an LED on/off quickly on pin 9.
// It first turns the LED on, then calls itself again in 50ms to turn the LED off
function toggleTxLED()
{
    txLEDToggle = txLEDToggle ? 0 : 1;    // toggle the txLEDtoggle variable
    if (!txLEDToggle)
    {
        imp.wakeup(0.05, toggleTxLED.bindenv(this)); // if we're turning the LED on, set a timer to call this function again (to turn the LED off)
    }
    txLed.write(txLEDToggle);  // TX LED is on pin 8 (active-low)
}

// This function turns an LED on/off quickly on pin 8.
// It first turns the LED on, then calls itself again in 50ms to turn the LED off
function toggleRxLED()
{
    rxLEDToggle = rxLEDToggle ? 0:1;    // toggle the rxLEDtoggle variable
    if (!rxLEDToggle)
    {
        imp.wakeup(0.05, toggleRxLED.bindenv(this)); // if we're turning the LED on, set a timer to call this function again (to turn the LED off)
    }
    rxLed.write(rxLEDToggle);   // RX LED is on pin 8 (active-low)
}

agent.on("initsuccess", function(msg) {
    rxLed.write(0);
    imp.sleep(1);
    rxLed.write(1);
});

// Start.
initLEDs();
initUart();
agent.send("init", "let's get it started in heah");
