package cache

import (
	"database/sql"
	_ "github.com/mattn/go-sqlite3"
)

// Cache_Instance is a global variable that is used to access the cache.
var Cache_Instance *Cache = NewCache(true, "cache.sqlite3")

type Authorization struct {
	Token     string `json:"token"`
	ExpiresAt int64  `json:"expires_at"`
}

// Cache is a struct that contains the cache information.
type Cache struct {
	cache      bool
	cache_path string
	Db         *sql.DB
	Data       map[string]Authorization
}

// Create a new Cache instance.
func NewCache(cache bool, cache_path string) *Cache {
	c := &Cache{
		cache:      cache,
		cache_path: cache_path,
	}
	return c
}

// Connect to the database or initialize the map
func (c *Cache) connect() {
	if c.cache && c.Db == nil {
		var err error
		c.Db, err = sql.Open("sqlite3", c.cache_path)
		if err != nil {
			panic(err)
		}
		_, err = c.Db.Exec("CREATE TABLE IF NOT EXISTS cache(app_token TEXT PRIMARY KEY, c_token TEXT, expires_at INTEGER)")
	} else if !c.cache && c.Data == nil {
		c.Data = make(map[string]Authorization)
	}
}

// Get the Authorization from the cache.
func (c *Cache) Get(app_token string) (Authorization, bool) {
	c.connect()
	if c.cache {
		var authorization Authorization
		err := c.Db.QueryRow("SELECT * FROM cache WHERE app_token = ?", app_token).Scan(&app_token, &authorization.Token, &authorization.ExpiresAt)
		if err != nil {
			return Authorization{}, false
		}
		return authorization, true
	} else {
		if authorization, ok := c.Data[app_token]; ok {
			return authorization, true
		}
		return Authorization{}, false
	}
}

// Set the Authorization in the cache.
func (c *Cache) Set(app_token string, authorization Authorization) error {
	c.connect()
	if c.cache {
		_, err := c.Db.Exec("INSERT INTO cache VALUES (?, ?, ?)", app_token, authorization.Token, authorization.ExpiresAt)
		if err != nil {
			return err
		}
		return nil
	} else {
		c.Data[app_token] = authorization
		return nil
	}
}

// Delete the Authorization from the cache.
func (c *Cache) Delete(app_token string) error {
	c.connect()
	if c.cache {
		_, err := c.Db.Exec("DELETE FROM cache WHERE app_token = ?", app_token)
		if err != nil {
			return err
		}
		return nil
	} else {
		if _, ok := c.Data[app_token]; ok {
			delete(c.Data, app_token)
		}
		return nil
	}
}

// Close the database connection.
func (c *Cache) Close() {
	if c.cache && c.Db != nil {
		c.Db.Close()
		c.Db = nil
	} else if !c.cache && c.Data != nil {
		c.Data = nil
	}
}
