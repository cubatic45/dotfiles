package utils

import (
	"copilot-gpt4-service/cache"
	"encoding/json"
	"fmt"
	"io"
	"math/rand"
	"net/http"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

// Set the Authorization in the cache.
func setAuthorizationToCache(copilotToken string, authorization cache.Authorization) {
	// authorizations[copilotToken] = authorization
	cache.Cache_Instance.Set(copilotToken, authorization)
}

// Obtain the Authorization from the cache.
func getAuthorizationFromCache(copilotToken string) *cache.Authorization {
	extraTime := rand.Intn(600) + 300
	if authorization, ok := cache.Cache_Instance.Get(copilotToken); ok {
		if authorization.ExpiresAt > time.Now().Unix()+int64(extraTime) {
			return &authorization
		}
	}
	return &cache.Authorization{}
}

// When obtaining the Authorization, first attempt to retrieve it from the cache. If it is not available in the cache, retrieve it through an HTTP request and then set it in the cache.
func GetAuthorizationFromToken(copilotToken string) (string, bool) {
	authorization := getAuthorizationFromCache(copilotToken)
	if authorization.Token == "" {
		getAuthorizationUrl := "https://api.github.com/copilot_internal/v2/token"
		client := &http.Client{}
		req, _ := http.NewRequest("GET", getAuthorizationUrl, nil)
		req.Header.Set("Authorization", "token "+copilotToken)
		response, err := client.Do(req)
		if err != nil {
			if response == nil {
				// handle connection not available
				// c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
				return "", false
			}
			// c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error(), "code": response.StatusCode})
			return "", false
		}
		if response.StatusCode != 200 {
			// body, _ := io.ReadAll(response.Body)
			// c.JSON(response.StatusCode, gin.H{"error": string(body), "code": response.StatusCode})
			return "", false
		}
		defer response.Body.Close()

		body, _ := io.ReadAll(response.Body)

		newAuthorization := &cache.Authorization{}
		if err = json.Unmarshal(body, &newAuthorization); err != nil {
			fmt.Println("err", err)
		}
		authorization.Token = newAuthorization.Token
		setAuthorizationToCache(copilotToken, *newAuthorization)
	}
	return authorization.Token, true
}

// Retrieve the GitHub Copilot Plugin Token from the request header.
func GetAuthorization(c *gin.Context) (string, bool) {
	copilotToken := strings.TrimPrefix(c.GetHeader("Authorization"), "Bearer ")
	if copilotToken == "" {
		return "", false
	} else {
		return copilotToken, true
	}
	// if copilotToken == "" {
	// 	c.JSON(http.StatusUnauthorized, gin.H{
	// 		"message": "Unauthorized",
	// 	})
	// 	return false
	// }
	// Obtain the Authorization from the GitHub Copilot Plugin Token.
	// return getAuthorizationFromToken(c, copilotToken)
}
