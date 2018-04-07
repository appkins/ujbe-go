package env

import (
	"github.com/spf13/viper"
)

var (
	configFilePaths = []string{
		".",
		"~/",
		"/etc/ujbe/",
	}
)

// SetUp parses all environment configuration from
// a configuration file, environment variables and
// command line flags
func SetUp() error {

	viper.SetEnvPrefix("ujbe")
	for _, path := range configFilePaths {
		viper.AddConfigPath(path)
	}

	if Debug {
	}
	return nil
}
