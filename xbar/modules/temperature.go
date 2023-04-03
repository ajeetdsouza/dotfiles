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
				icon = "\uf2cb"
			case tCelsius < 40:
				icon = "\uf2ca"
			case tCelsius < 60:
				icon = "\uf2c9"
			case tCelsius < 80:
				icon = "\uf2c8"
			default:
				icon = "\uf2c7"
			}

			return outputs.Textf("%s %2d°C", icon, tCelsius)
		})
}
