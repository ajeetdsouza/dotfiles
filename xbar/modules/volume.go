package modules

import (
	"bytes"
	"fmt"
	"log"
	"os/exec"

	"barista.run/bar"
	"barista.run/modules/volume"
	"barista.run/modules/volume/pulseaudio"
	"barista.run/outputs"
	"golang.org/x/exp/slices"
)

func Volume() bar.Module {
	return volume.New(pulseaudio.DefaultSink()).Output(func(v volume.Volume) bar.Output {
		if v.Mute {
			return outputs.Textf("\u200e\ufc5d --")
		}

		val := v.Pct()
		stepSize := 2 * (v.Max - v.Min) / 100
		if stepSize == 0 {
			stepSize = 1
		}

		var icon string
		switch {
		case val == 0:
			icon = "\ufa80"
		case val <= 33:
			icon = "\ufa7e"
		case val <= 67:
			icon = "\ufa7f"
		default:
			icon = "\ufa7d"
		}

		return outputs.
			Textf("%s %d%%", icon, val).
			OnClick(func(e bar.Event) {
				switch e.Button {
				case bar.ButtonLeft:
					if err := exec.Command("pavucontrol").Run(); err != nil {
						log.Println("pavucontrol exited with error: ", err)
					}
				case bar.ButtonMiddle, bar.ButtonRight:
					v.SetMuted(!v.Mute)
				case bar.ButtonBack, bar.ButtonForward:
					reverse := e.Button == bar.ButtonBack
					if err := nextSink(reverse); err != nil {
						log.Println("failed to switch audio sink: ", err)
					}
				case bar.ScrollUp:
					v.SetVolume(v.Vol + stepSize)
				case bar.ScrollDown:
					v.SetVolume(v.Vol - stepSize)
				}
			})
	})
}

func nextSink(reverse bool) error {
	sinks, err := getSinks()
	if err != nil {
		return err
	}

	defaultSink, err := getDefaultSink()
	if err != nil {
		return err
	}

	defaultSinkIdx := slices.Index(sinks, defaultSink)
	if defaultSinkIdx == -1 {
		return fmt.Errorf("could not find default sink in list of sinks")
	}

	var nextSinkIdx int
	if reverse {
		nextSinkIdx = (defaultSinkIdx + len(sinks) - 1) % len(sinks)
	} else {
		nextSinkIdx = (defaultSinkIdx + 1) % len(sinks)
	}
	nextSink := sinks[nextSinkIdx]

	return setSink(nextSink)
}

func getDefaultSink() (string, error) {
	output, err := exec.Command("pactl", "get-default-sink").Output()
	if err != nil {
		return "", err
	}
	sink := string(bytes.TrimSpace(output))
	return sink, nil
}

func getSinks() ([]string, error) {
	output, err := exec.Command("pactl", "list", "short", "sinks").Output()
	if err != nil {
		return nil, err
	}

	var sinks []string
	rows := bytes.Split(output, []byte("\n"))
	for _, row := range rows {
		if len(row) == 0 {
			continue
		}
		cols := bytes.Fields(row)
		if len(cols) > 1 {
			sinks = append(sinks, string(cols[1]))
		} else {
			return nil, fmt.Errorf("could not parse list of sinks")
		}
	}

	return sinks, nil
}

func setSink(sink string) error {
	_, err := exec.Command("pactl", "set-default-sink", sink).Output()
	return err
}
