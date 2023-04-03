package modules

import (
	"time"

	"barista.run/bar"
	"barista.run/modules/clock"
	"barista.run/outputs"
)

func Time() bar.Module {
	return clock.Local().Output(time.Minute, func(now time.Time) bar.Output {
		return outputs.Text(now.Format("\uf5ed 2006-01-02 15:04"))
	})
}
