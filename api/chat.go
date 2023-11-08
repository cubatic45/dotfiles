package handler

import (
	"fmt"

	"copilot-gpt4-service/utils"

	"github.com/gin-gonic/gin"
)

func Handler(c *gin.Context) {
	// 从请求头部获取 github token，然后获取 copilot token
	utils.GetGithubTokens(c)
	// 构造请求
	utils.FakeRequest(c)

	fmt.Fprintf(c.Writer, "<h1>Hello from Go!</h1>")

}