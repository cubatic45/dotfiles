package handler

import (
    "bytes"
    "encoding/hex"
    "encoding/json"
    "fmt"
    "io/ioutil"
    "math/rand"
    "net/http"
    "os"
    "strings"
		"copilot-gpt4-service/utils"
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

// 根据提供的json数据和headers，构造一个request对象
func FakeRequest(c *gin.Context) {
    content := c.Query("content")
    url := "https://api.githubcopilot.com/chat/completions"
    copilotToken := os.Getenv("COTOKEN")
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

// 使用 github token 获取 copilot-chat 的提示接口
func Handler(w http.ResponseWriter, r *http.Request) {
    router := gin.Default()
    router.Use(CORSMiddleware())
    router.POST("/v1/chat/completions", func(c *gin.Context) {
			utils.GetGithubTokens(c)
			utils.FakeRequest(c)
    })
    // router.ServeHTTP(w, r)
		fmt.Fprintf(w, "{code: 200, data: 'pong123456789'}")
}
