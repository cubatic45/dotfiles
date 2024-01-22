package tools

import (
	"os"
	"path"
	"reflect"
	"fmt"
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
			fmt.Printf(" \033[34m%-20s:\033[0m %v\n",  typeOfS.Field(i).Name, field.Interface())
		}
	}
	fmt.Println()
}
