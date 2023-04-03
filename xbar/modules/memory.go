package modules

import (
	"barista.run/bar"
	"barista.run/modules/meminfo"
	"barista.run/outputs"
)

func Memory() bar.Module {
	return meminfo.New().Output(func(m meminfo.Info) bar.Output {
		memAvailable := m["MemAvailable"].Gibibytes()
		memTotal := m["MemTotal"].Gibibytes()
		return outputs.Textf("\uf85a %.1f/%.1fGiB", memAvailable, memTotal)
	})
}
