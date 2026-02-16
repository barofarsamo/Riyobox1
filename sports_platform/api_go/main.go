package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
	"github.com/gorilla/websocket"
)

var (
	ctx = context.Background()
	rdb *redis.Client
)

func main() {
	// Initialize Redis
	rdb = redis.NewClient(&redis.Options{
		Addr: "localhost:6379",
	})

	// Microservices Integration
	// Rust Analytics -> :8081
	// Java Payment -> :8082
	// Node Chat -> :4000

	r := gin.Default()

	// REST API
	sports := r.Group("/sports")
	{
		sports.GET("/fixtures", getFixtures)
		sports.GET("/live", handleLiveWS)
	}

	fmt.Println("Sports API (Go) running on :8080")
	r.Run(":8080")
}

func getFixtures(c *gin.Context) {
	cacheKey := "fixtures_today"
	val, err := rdb.Get(ctx, cacheKey).Result()
	if err == nil {
		c.Data(http.StatusOK, "application/json", []byte(val))
		return
	}

	data := map[string]interface{}{
		"response": []interface{}{},
	}
	jsonData, _ := json.Marshal(data)
	rdb.Set(ctx, cacheKey, jsonData, 60*time.Second)

	c.JSON(http.StatusOK, data)
}

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool { return true },
}

func handleLiveWS(c *gin.Context) {
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		return
	}
	defer conn.Close()

	for {
		update := map[string]interface{}{
			"type": "live_update",
			"match": map[string]interface{}{
				"fixture": map[string]interface{}{"id": 123},
				"goals": map[string]interface{}{"home": 1, "away": 0},
			},
		}
		msg, _ := json.Marshal(update)
		if err := conn.WriteMessage(websocket.TextMessage, msg); err != nil {
			break
		}
		time.Sleep(30 * time.Second)
	}
}
