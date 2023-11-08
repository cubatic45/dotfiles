package handler

import (
	"copilot-gpt4-service/utils"

	"github.com/gin-gonic/gin"
)

func chat(c *gin.Context) {
	// 从请求头部获取 github token，然后获取 copilot token
	utils.GetGithubTokens(c)
	// 构造请求
	utils.FakeRequest(c)
}
