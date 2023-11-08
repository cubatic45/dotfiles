package handler

import (
	"net/http"
	"fmt"
	"github.com/gin-gonic/gin"

)



func Handler1(w http.ResponseWriter, r *http.Request) {
	router := gin.Default()
	router.Use(CORSMiddleware())
	router.GET("/v2/chat/completions", func(c *gin.Context) {
		fmt.Fprintf(w, "{code: 200, data: 'pong123456789'}")
	})
	// router.ServeHTTP(w, r)
	// fmt.Fprintf(w, "{code: 200, data: 'pong123456789'}")
}