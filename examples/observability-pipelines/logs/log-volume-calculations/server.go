package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println(r.Method, r.RequestURI)
	})
	http.ListenAndServe("localhost:8888", nil)
}
