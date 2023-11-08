package handler

import (
	"github.com/gin-gonic/gin"

	"copilot-gpt4-service/utils"
)

func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "*")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "*")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(200)
			return
		}

		c.Next()
	}
}

func Handler(c *gin.Context) {
	gin.SetMode(gin.ReleaseMode)
	gin := gin.Default()
	gin.Use(CORSMiddleware())

	utils.GetGithubTokens(c)
	// 构造请求
	utils.FakeRequest(c)
	gin.ServeHTTP(c.Writer, c.Request)
}
