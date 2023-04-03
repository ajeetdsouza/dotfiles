package modules

import (
	"barista.run/bar"
	"barista.run/modules/sysinfo"
	"barista.run/outputs"
)

// CPU returns the CPU load average over the last minute.
func CPU() bar.Module {
	return sysinfo.New().Output(func(s sysinfo.Info) bar.Output {
		return outputs.Textf("\ufb19 %0.2f", s.Loads[0])
	})
}
