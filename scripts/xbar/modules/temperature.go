package modules

import (
	"time"

	"barista.run/bar"
	"barista.run/modules/cputemp"
	"barista.run/outputs"
	"github.com/martinlindhe/unit"
)

func Temperature() bar.Module {
	return cputemp.New().
		RefreshInterval(time.Second).
		Output(func(t unit.Temperature) bar.Output {
			tCelsius := int(t.Celsius())

			var icon string
			switch {
			case tCelsius < 20:
				icon = ""
			case tCelsius < 40:
				icon = ""
			case tCelsius < 60:
				icon = ""
			case tCelsius < 80:
				icon = ""
			default:
				icon = ""
			}

			urgent := tCelsius > 95
			return outputs.Textf("%s %2d°C", icon, tCelsius).Urgent(urgent)
		})
}
