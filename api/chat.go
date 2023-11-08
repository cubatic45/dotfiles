package handler

import (
	"bytes"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math/rand"
	"net/http"
	"copilot-gpt4-service/config"
	"copilot-gpt4-service/utils"
	"strings"

	"github.com/gin-gonic/gin"
)

// 当前端请求api时，返回{code: 200, data: 'pong'}内容给他
func Ping(w http.ResponseWriter, r *http.Request) {
	// 返回HTTP状态码200
	w.WriteHeader(http.StatusOK)
	// 返回http响应内容
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
	w.Header().Set("Access-Control-Max-Age", "86400")
	// 返回内容
	fmt.Fprintf(w, "{code: 200, data: 'pong123456789'}")
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
	Choices []Choice `json:"choices"`
	Created int      `json:"created"`
	ID      string   `json:"id"`
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

func FakeRequest(c *gin.Context) {
	content := c.Query("content")
	// 获取post请求的参数

	form := c.PostFormMap("top_p")

	fmt.Println("content", content, c.PostForm("top_p"), form)
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
	fmt.Println("jsonBody", jsonBody)
	_ = c.BindJSON(&jsonBody)

	jsonData, err := json.Marshal(jsonBody)
	if err != nil {
		fmt.Println("序列化错误了")
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
			return
		} else {
			body, _ := ioutil.ReadAll(resp.Body)
			jsonStr := strings.TrimPrefix(string(body), "data: ")
			// 这里就是stream数据流
			c.Data(200, "text/event-stream; charset=utf-8", body)
			r := &Data{}
			err = json.Unmarshal([]byte(jsonStr), &r)
			if err != nil {
				// fmt.Println("json 反序列化失败: ", err)
				return
			}
		}
	}
}

func copilotProxy(c *gin.Context) {
	// 从请求头部获取 github token，然后获取 copilot token
	utils.GetGithubTokens(c)
	// 构造请求
	FakeRequest(c)
}
