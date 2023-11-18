package main

import (
	"bytes"
	"copilot-gpt4-service/config"
	"copilot-gpt4-service/utils"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"math/rand"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
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

type JsonData struct {
	Messages    interface{} `json:"messages"`
	Model       string      `json:"model"`
	Temperature float64     `json:"temperature"`
	TopP        float64     `json:"top_p"`
	N           int64       `json:"n"`
	Stream      bool        `json:"stream"`
	Intent      bool        `json:"intent"`
}

type Delta struct {
	Content string `json:"content"`
}

type Choice struct {
	Delta Delta `json:"delta"`
	Index int   `json:"index"`
}

type Data struct {
	Choices []Choice `json:"choices,omitempty"`
	Created int      `json:"created,omitempty"`
	ID      string   `json:"id,omitempty"`
}

func genHexStr(length int) string {
	bytes := make([]byte, length/2)
	if _, err := rand.Read(bytes); err != nil {
		panic(err)
	}
	return hex.EncodeToString(bytes)
}

// 构造请求头
func createHeaders(copilotToken string) map[string]string {
	headers := make(map[string]string, 0)
	headers["Authorization"] = "Bearer " + copilotToken
	headers["X-Request-Id"] = genHexStr(8) + "-" + genHexStr(4) + "-" + genHexStr(4) + "-" + genHexStr(4) + "-" + genHexStr(12)
	headers["Vscode-Sessionid"] = genHexStr(8) + "-" + genHexStr(4) + "-" + genHexStr(4) + "-" + genHexStr(4) + "-" + genHexStr(25)
	headers["Vscode-Machineid"] = genHexStr(64)
	headers["Editor-Version"] = "vscode/1.83.1"
	headers["Editor-Plugin-Version"] = "copilot-chat/0.8.0"
	headers["Openai-Organization"] = "github-copilot"
	headers["Openai-Intent"] = "conversation-panel"
	headers["Content-Type"] = "text/event-stream; charset=utf-8"
	headers["User-Agent"] = "GitHubCopilotChat/0.8.0"
	headers["Accept"] = "*/*"
	headers["Accept-Encoding"] = "gzip,deflate,br"
	headers["Connection"] = "close"

	return headers
}

// 根据提供的 json 数据和 headers，构造一个 request 对象
func FakeRequest(c *gin.Context) {
	content := c.Query("content")
	url := "https://api.githubcopilot.com/chat/completions"
	copilotToken := config.CoToken
	headers := createHeaders(copilotToken)
	jsonBody := &JsonData{
		Messages: []map[string]string{
			{"role": "system",
				"content": "\nYou are ChatGPT, a large language model trained by OpenAI.\nKnowledge cutoff: 2021-09\nCurrent model: gpt-4\nCurrent time: 2023/11/7 11: 39: 14\n"},
			{"role": "user",
				"content": content},
		},
		Model:       "gpt-4",
		Temperature: 0.5,
		TopP:        1,
		N:           1,
		Stream:      true,
		Intent:      true,
	}
	_ = c.BindJSON(&jsonBody)

	jsonData, err := json.Marshal(jsonBody)
	if err != nil {
		return
	}

	req, _ := http.NewRequest("POST", url, bytes.NewReader(jsonData))
	for k, v := range headers {
		req.Header.Set(k, v)
	}

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("发送请求错误")
	} else {
		defer resp.Body.Close()
		if resp.StatusCode != http.StatusOK {
			//body, _ := ioutil.ReadAll(resp.Body)
			return
		} else {
			c.Writer.Header().Set("Transfer-Encoding", "chunked")
			c.Writer.Header().Set("X-Accel-Buffering", "no")
			c.Header("Content-Type", "text/event-stream; charset=utf-8")
			c.Header("Cache-Control", "no-cache")
			c.Header("Connection", "keep-alive")
			body := make([]byte, 1024) // 定义一个缓冲区，每次读取的数据大小为1024字节
			for {
				n, err := resp.Body.Read(body)
				if err != nil && err != io.EOF {
					// 处理读取错误
					break
				}
				if n > 0 {
					c.Writer.WriteString(string(body[:n]))
					c.Writer.Flush()
					time.Sleep(100 * time.Millisecond)
				}
				if err == io.EOF {
					// 数据读取完毕，退出循环
					break
				}
			}
		}
	}

}

func copilotProxy(c *gin.Context) {
	// 从请求头部获取 github token，然后获取 copilot token
	utils.GetGithubTokens(c)
	FakeRequest(c)
}

func main() {
	router := gin.Default()
	router.Use(CORSMiddleware())
	router.POST("/v1/chat/completions", copilotProxy)
	router.Run(":8080")
}
