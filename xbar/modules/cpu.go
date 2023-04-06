package modules

import (
	"runtime"

	"barista.run/bar"
	"barista.run/modules/sysinfo"
	"barista.run/outputs"
)

// CPU returns the CPU load average over the last minute.
func CPU() bar.Module {
	numCPUs := runtime.NumCPU()
	return sysinfo.New().Output(func(s sysinfo.Info) bar.Output {
		loadAvg := s.Loads[0]
		urgent := loadAvg > float64(numCPUs)
		return outputs.Textf("\ufb19 %0.2f", loadAvg).Urgent(urgent)
	})
}
