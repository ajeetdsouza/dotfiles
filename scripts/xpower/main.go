package main

import (
	"fmt"
	"log"
	"os/exec"
	"strings"
)

type PowerOption struct {
	Name    string
	Command *exec.Cmd
}

func main() {
	options := []PowerOption{
		{"Lock", exec.Command("xsecurelock")},
		{"Logout", exec.Command("i3-msg", "exit")},
		{"Poweroff", exec.Command("systemctl", "poweroff")},
		{"Reboot", exec.Command("systemctl", "reboot")},
		{"Suspend", exec.Command("systemctl", "suspend")},
	}

	rofi := exec.Command("rofi", "-dmenu", "-dpi", "1", "-i", "-p", "power")

	inputBuilder := new(strings.Builder)
	for _, option := range options {
		if _, err := fmt.Fprintf(inputBuilder, "%s\n", option.Name); err != nil {
			log.Fatalf("error writing to rofi: %v", err)
		}
	}
	input := inputBuilder.String()
	rofi.Stdin = strings.NewReader(input)

	output, err := rofi.Output()
	if err != nil {
		log.Fatalf("error running rofi: %v", err)
	}
	selection := strings.TrimSpace(string(output))

	var option PowerOption
	for _, o := range options {
		if o.Name == selection {
			option = o
			break
		}
	}
	if err := option.Command.Run(); err != nil {
		log.Fatalf("error running command: %v", err)
	}
}
