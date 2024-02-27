package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"xbar/modules"

	"barista.run"
	"github.com/google/uuid"
)

func main() {
	if err := setupLogging(); err != nil {
		log.Fatal("error setting up logging: ", err)
	}

	if err := barista.Run(
		modules.Media(),
		modules.CPU(),
		modules.Memory(),
		modules.Temperature(),
		// modules.Backlight(),
		modules.Volume(),
		// modules.Battery(),
		modules.Time(),
	); err != nil {
		log.Fatal("error in barista: ", err.Error())
	}
}

func setupLogging() error {
	logDir := filepath.Join(os.TempDir(), "xbar")
	if err := os.MkdirAll(logDir, 0755); err != nil {
		return fmt.Errorf("failed to create log directory: %s: %w", logDir, err)
	}

	fileName, err := uuid.NewRandom()
	if err != nil {
		return fmt.Errorf("failed to generate UUID: %w", err)
	}

	logPath := filepath.Join(logDir, fileName.String()+".log")
	logFile, err := os.OpenFile(logPath, os.O_WRONLY|os.O_CREATE|os.O_EXCL|os.O_APPEND, 0644)
	if err != nil {
		return fmt.Errorf("failed to open log file: %s: %w", logPath, err)
	}

	log.SetOutput(logFile)
	return nil
}
