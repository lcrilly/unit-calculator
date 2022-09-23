package main

import (
    "fmt";
    "math";
    "strings";
    "io";
    "io/ioutil";
    "encoding/json";
    "net/http";
    "unit.nginx.org/go"
)

type Req struct {
    Operand float64
}

type Res struct {
    Result float64
}

func squareRoot(r *http.Request) string {
    body, _ := ioutil.ReadAll(r.Body)

    var req Req
    json.Unmarshal([]byte(fmt.Sprintf("%s", body)), &req)

    result := &Res {
        Result: math.Sqrt(req.Operand),
    }
    data, _ := json.Marshal(result)
    return strings.ToLower(string(data))
}

func main() {
    http.HandleFunc("/",func (w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json; charset=utf-8")
        io.WriteString(w, squareRoot(r))
    })
    unit.ListenAndServe(":8080", nil)
}
