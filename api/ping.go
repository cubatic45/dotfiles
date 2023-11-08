package handler

import (
	"net/http"
)

// 当前端请求api时，返回{code: 200, data: 'pong'}内容给他
func ping(w http.ResponseWriter, r *http.Request) {


	// 返回HTTP状态码200
	w.WriteHeader(http.StatusOK)
	// 返回http响应内容
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	w.Header().Set("Access-Control-Max-Age", "86400")
	// 返回内容
	// fmt.Fprintf(w, "{code: 200, data: 'pong123456789'}")
}
