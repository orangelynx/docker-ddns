package main

import (
	"encoding/json"
	"os"
)

type Config struct {
	SharedSecret string
	HostsFile    string
}

func (conf *Config) LoadConfig(path string) {
	file, err := os.Open(path)
	if err != nil {
		panic(err)
	}
	decoder := json.NewDecoder(file)
	err = decoder.Decode(&conf)
	if err != nil {
		panic(err)
	}
}
