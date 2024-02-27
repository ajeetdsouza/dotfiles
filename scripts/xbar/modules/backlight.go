package modules

import (
	"log"
	"os/exec"

	"barista.run/bar"
	"barista.run/outputs"
	backlight "github.com/jakobgrine/barista-backlight"
)

func Backlight() bar.Module {
	return backlight.New("intel_backlight").Output(func(b *backlight.Backlight) bar.Output {
		val := b.Percent()
		stepSize := 2 * b.Max / 100

		var icon string
		switch {
		case val <= 33:
			icon = "󰃞"
		case val <= 67:
			icon = "󰃟"
		default:
			icon = "󰃠"
		}

		return outputs.Textf("%s %d%%", icon, val).OnClick(func(e bar.Event) {
			switch e.Button {
			case bar.ButtonLeft:
				if err := exec.Command("arandr").Run(); err != nil {
					log.Println("arandr exited with error: ", err)
				}
			case bar.ScrollUp:
				if err := b.SetBrightness(b.Bri + stepSize); err != nil {
					log.Println("failed to set brightness: ", err)
				}
			case bar.ScrollDown:
				if err := b.SetBrightness(b.Bri - stepSize); err != nil {
					log.Println("failed to set brightness: ", err)
				}
			}
		})
	})
}
