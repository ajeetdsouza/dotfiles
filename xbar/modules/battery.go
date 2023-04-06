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
		case battery.Unknown, battery.Disconnected:
			icon = "\uf590"
		case battery.NotCharging:
			icon = "\ufba3"
		case battery.Full:
			icon = "\uf578"
		case battery.Charging:
			switch {
			case val < 25:
				icon = "\uf585"
			case val < 35:
				icon = "\uf586"
			case val < 45:
				icon = "\uf587"
			case val < 65:
				icon = "\uf588"
			case val < 85:
				icon = "\uf589"
			case val < 95:
				icon = "\uf58a"
			default:
				icon = "\uf584"
			}
		case battery.Discharging:
			switch {
			case val < 5:
				icon = "\uf58d"
			case val < 15:
				icon = "\uf579"
			case val < 25:
				icon = "\uf57a"
			case val < 35:
				icon = "\uf57b"
			case val < 45:
				icon = "\uf57c"
			case val < 55:
				icon = "\uf57d"
			case val < 65:
				icon = "\uf57e"
			case val < 75:
				icon = "\uf57f"
			case val < 85:
				icon = "\uf580"
			case val < 95:
				icon = "\uf581"
			default:
				icon = "\uf578"
			}
		}

		urgent := info.Status == battery.Discharging && val < 10
		return outputs.Textf("%s %d%%", icon, val).Urgent(urgent)
	})
}
