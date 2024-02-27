package modules

import (
	"barista.run/bar"
	"barista.run/modules/battery"
	"barista.run/outputs"
)

func Battery() bar.Module {
	return battery.All().Output(func(info battery.Info) bar.Output {
		val := info.RemainingPct()

		var icon string
		switch info.Status {
		case battery.Disconnected, battery.NotCharging, battery.Unknown:
			icon = "󱉞"
		case battery.Full:
			icon = "󰁹"
		case battery.Charging:
			switch {
			case val <= 5:
				icon = "󰢟"
			case val <= 15:
				icon = "󰢜"
			case val <= 25:
				icon = "󰂆"
			case val <= 35:
				icon = "󰂇"
			case val <= 45:
				icon = "󰂈"
			case val <= 55:
				icon = "󰢝"
			case val <= 65:
				icon = "󰂉"
			case val <= 75:
				icon = "󰢞"
			case val <= 85:
				icon = "󰂊"
			case val <= 99:
				icon = "󰂋"
			default:
				icon = "󰂅"
			}
		case battery.Discharging:
			switch {
			case val <= 5:
				icon = "󰂎"
			case val <= 15:
				icon = "󰁺"
			case val <= 25:
				icon = "󰁻"
			case val <= 35:
				icon = "󰁼"
			case val <= 45:
				icon = "󰁽"
			case val <= 55:
				icon = "󰁾"
			case val <= 65:
				icon = "󰁿"
			case val <= 75:
				icon = "󰂀"
			case val <= 85:
				icon = "󰂁"
			case val <= 99:
				icon = "󰂂"
			default:
				icon = "󰁹"
			}
		}

		urgent := info.Status == battery.Discharging && val < 10
		return outputs.Textf("%s %d%%", icon, val).Urgent(urgent)
	})
}
