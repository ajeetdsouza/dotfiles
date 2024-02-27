package modules

import (
	"time"

	"barista.run/bar"
	"barista.run/modules/clock"
	"barista.run/outputs"
)

func Time() bar.Module {
	return clock.Local().Output(time.Minute, func(now time.Time) bar.Output {
		hour := now.Local().Hour() % 12

		var icon string
		switch hour {
		case 0:
			icon = "󱑊"
		case 1:
			icon = "󱐿"
		case 2:
			icon = "󱑀"
		case 3:
			icon = "󱑁"
		case 4:
			icon = "󱑂"
		case 5:
			icon = "󱑃"
		case 6:
			icon = "󱑄"
		case 7:
			icon = "󱑅"
		case 8:
			icon = "󱑆"
		case 9:
			icon = "󱑇"
		case 10:
			icon = "󱑈"
		case 11:
			icon = "󱑉"
		}
		return outputs.Textf("%s %s", icon, now.Format("2006-01-02 15:04"))
	})
}
