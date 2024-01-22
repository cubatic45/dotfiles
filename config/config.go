package config

import (
	"fmt"
	"os"
	"strconv"
	"flag"

	"github.com/joho/godotenv"
)

type Config struct {
	Port         string
	Cache        bool
	CachePath    string
	Host         string
	Debug        bool
	Logging      bool
	LogLevel     string
	CopilotToken string
}

var ConfigInstance *Config = &Config{}

func init() {
	flag.StringVar(&ConfigInstance.Host, "host", "", "Service listen address.")
	flag.StringVar(&ConfigInstance.Port, "port", "", "Service listen port.")
	flag.StringVar(&ConfigInstance.CachePath, "cache_path", "", "Path to the persistent cache.")
	flag.StringVar(&ConfigInstance.LogLevel, "log_level", "", "Log level, optional values: panic, fatal, error, warn, info, debug, trace (note: valid only when log_level is true).")
	flag.StringVar(&ConfigInstance.CopilotToken, "copilot_token", "", "Default Github Copilot Token, if this is set, the Token carried in the request will be ignored. Default is empty.")
	flag.BoolVar(&ConfigInstance.Cache, "cache", false, "Whether persistence is enabled or not.")
	flag.BoolVar(&ConfigInstance.Debug, "debug", false, "Enable debug mode, if enabled, more logs will be output.")
	flag.BoolVar(&ConfigInstance.Logging, "logging", false, "Enable logging.")

	// if exists config.env, load it
	if _, err := os.Stat("config.env"); err == nil {
		err := godotenv.Load("config.env")
		if err != nil {
			fmt.Println("Error loading config.env file")
		}
	}

	flag.Parse()
	ConfigInstance.Host = getFlagOrEnvOrDefault(ConfigInstance.Host, "HOST", "0.0.0.0")
	ConfigInstance.Port = getFlagOrEnvOrDefault(ConfigInstance.Port, "PORT", "8080")
	ConfigInstance.CachePath = getFlagOrEnvOrDefault(ConfigInstance.CachePath, "CACHE_PATH", "db/cache.sqlite3")
	ConfigInstance.LogLevel = getFlagOrEnvOrDefault(ConfigInstance.LogLevel, "LOG_LEVEL", "info")
	ConfigInstance.CopilotToken = getFlagOrEnvOrDefault(ConfigInstance.CopilotToken, "COPILOT_TOKEN", "")
	ConfigInstance.Cache = getFlagOrEnvOrDefaultBool(ConfigInstance.Cache, "CACHE", true)
	ConfigInstance.Debug = getFlagOrEnvOrDefaultBool(ConfigInstance.Debug, "DEBUG", false)
	ConfigInstance.Logging = getFlagOrEnvOrDefaultBool(ConfigInstance.Logging, "LOGGING", false)
}

func getFlagOrEnvOrDefault(flagValue string, key string, defaultValue string) string {
	if flagValue != "" {
		return flagValue
	}
	return getEnvOrDefault(key, defaultValue)
}

func getFlagOrEnvOrDefaultBool(flagValue bool, key string, defaultValue bool) bool {
	if flagValue {
		return flagValue
	}
	return getEnvOrDefaultBool(key, defaultValue)
}

func getEnvOrDefault(key string, defaultValue string) string {
	value, exists := os.LookupEnv(key)
	if !exists {
		return defaultValue
	}
	return value
}

func getEnvOrDefaultBool(key string, defaultValue bool) bool {
	value, exists := os.LookupEnv(key)
	if !exists {
		return defaultValue
	}
	s, err := strconv.ParseBool(value)
	if err != nil {
		fmt.Println("Error parsing boolean value for key:", key)
		panic(err)
	}
	return s
}
