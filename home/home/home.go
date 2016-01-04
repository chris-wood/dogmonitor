package hello

import (
    "encoding/json"
    "fmt"
    "net/http"
    "log"

    // "google.golang.org/appengine"
    // "google.golang.org/appengine/log"
)

type SoundReading struct {
    Time int `json:"time"`
    Value int `json:"value"`
}

var soundReadings []SoundReading;

func init() {
    soundReadings = make([]SoundReading, 100) // 100 to start, it grows underneath

    http.HandleFunc("/", homeHandler)
    http.HandleFunc("/sound", soundHandler)
}

// curl -H "Content-Type: application/json" -X POST -d '{"time": 100, "value": 120}' http://localhost:8080/sound
func homeHandler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprint(w, "Welcome home.")
}

func soundHandler(w http.ResponseWriter, r *http.Request) {
    switch r.Method {
        case "GET": // Serve the resource.
            reading := soundReadings[len(soundReadings)-1]
            
            readingJson, err := json.Marshal(reading)
            if err != nil {
                http.Error(w, err.Error(), http.StatusInternalServerError)
                return
            }

            w.Header().Set("Content-Type", "application/json")
            w.Write(readingJson)

            break
        case "POST": // Create a new record.
            decoder := json.NewDecoder(r.Body)
            var reading SoundReading
            err := decoder.Decode(&reading)
            if err != nil {
                fmt.Println(err);
            } else {
                soundReadings = append(soundReadings, reading)
            }

            // c := appengine.NewContext(r)
            log.Printf("Saving value: %v\n", reading)
            break
        default:
            // Give an error message.
    }
}
