package utils

import (
  "encoding/json"
  "fmt"
  "io/ioutil"
  "net/http"
  "copilot-gpt4-service/config"
  "math/rand"
  "strings"
  "time"

  "github.com/gin-gonic/gin"
)

var tokens = make(map[string]Token)

type Token struct {
  Token     string `json:"token"`
  ExpiresAt int64  `json:"expires_at"`
}

// 设置 copilot token 到缓存
func setTokenToCache(githubToken string, copilotToken Token) {
  tokens[githubToken] = copilotToken
}

// 从缓存中获取 copilot token
func getTokenFromCache(githubToken string) *Token {
  extraTime := rand.Intn(600) + 300
  if token, ok := tokens[githubToken]; ok {
      if token.ExpiresAt > time.Now().Unix()+int64(extraTime) {
          return &token
      }
  }
  return &Token{}
}

// 在获取 copilot token 时，先从缓存中获取，如果未获取到，再通过 HTTP 请求获取，并设置缓存
func getCopilotToken(c *gin.Context, githubToken string) {
  token := getTokenFromCache(githubToken)
  if token.Token == "" {
    getTokenUrl := "https://api.github.com/copilot_internal/v2/token"
    client := &http.Client{}
    req, _ := http.NewRequest("GET", getTokenUrl, nil)
    req.Header.Set("Authorization", "token "+githubToken)
    response, err := client.Do(req)
    if err != nil || response.StatusCode != 200 {
      c.JSON(response.StatusCode, gin.H{"error": err.Error()})
    }
    defer response.Body.Close()

    body, _ := ioutil.ReadAll(response.Body)

    copilotToken := &Token{}
    if err = json.Unmarshal(body, &copilotToken); err != nil {
      fmt.Println("err", err)
    }
    token.Token = copilotToken.Token
    setTokenToCache(githubToken, *copilotToken)
  }
  config.CoToken = token.Token
}

// 从请求头部获取 github token
func GetGithubTokens(c *gin.Context) {
  githubToken := strings.TrimPrefix(c.GetHeader("Authorization"), "Bearer ")
  if githubToken == "" {
    c.JSON(http.StatusUnauthorized, gin.H{
      "message": "Unauthorized",
    })
    return
  }
  // 从 github token 获取 copilot token
  getCopilotToken(c, githubToken)
}
