package tools

import (
	"os"
	"path"
	"reflect"
	"fmt"
	"net"
	"strings"

	"copilot-gpt4-service/log"
)

// MkdirAllIfNotExists
// If the directory (or the directory of the file) does not exist, create it.
func MkdirAllIfNotExists(pathname string, perm os.FileMode) error {
	dir := path.Dir(pathname)
	if _, err := os.Stat(dir); err != nil {
		if os.IsNotExist(err) {
			if err := os.MkdirAll(dir, perm); err != nil {
				return err
			}
		}
	}
	return nil
}

func GetIPv4NetworkIPs() ([]string, error) {
	ips, err := GetNetworkIPs()
	ip4s := make([]string, 0)
	if err != nil {
		log.ZLog.Log.Error().Err(err).Msg("GetIPv4NetworkIPs: GetNetworkIPs() error")
		return nil, err
	}

	for _, ip := range ips {
		// check if the ip is a valid IPv4 address
		if strings.Count(ip, ".") == 3 {
			ip4s = append(ip4s, ip)
		}
	}

	log.ZLog.Log.Debug().Msgf("\nGetIPv4NetworkIPs:\n %v\n", strings.Join(ip4s, "\n "))

	return ip4s, nil
}

func GetNetworkIPs() ([]string, error) {
	ifaces, err := net.Interfaces()
	if err != nil {
		log.ZLog.Log.Error().Err(err).Msg("GetNetworkIp: net.Interfaces() error")
		return nil, err
	}

	ips := make([]string, 0)
	for _, i := range ifaces {
		addrs, err := i.Addrs()
		if err != nil {
			log.ZLog.Log.Error().Err(err).Msgf("GetNetworkIp: i.Addrs() error for interface %v", i)
			continue
		}
		for _, addr := range addrs {
			switch v := addr.(type) {
			case *net.IPNet:
				ips = append(ips, v.IP.String())
			case *net.IPAddr:
				ips = append(ips, v.IP.String())
			}
		}
	}

	log.ZLog.Log.Debug().Msgf("\nGetNetworkIp:\n %v\n", strings.Join(ips, "\n "))

	return ips, nil
}

func PrintStructFieldsAndValues(s interface{}, title string) {
	v := reflect.ValueOf(s)

	if v.Kind() == reflect.Ptr {
		v = v.Elem()
	}

	if v.Kind() != reflect.Struct {
		fmt.Println("The provided value is not a struct!")
		return
	}

	typeOfS := v.Type()

	fmt.Println()
	if title != "" {
		fmt.Printf("%s\n", title)
	}
	for i := 0; i < v.NumField(); i++ {
		field := v.Field(i)
		if field.CanInterface() {
			fmt.Printf(" - %-20s :\033[32m %v\033[0m\n",  typeOfS.Field(i).Name, field.Interface())
		}
	}
	fmt.Println()
}
