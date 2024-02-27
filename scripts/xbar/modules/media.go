package modules

import (
	"time"

	"barista.run/bar"
	"barista.run/modules/media"
	"barista.run/outputs"
)

func Media() bar.Module {
	return media.New("spotify").Output(func(info media.Info) bar.Output {
		var icon string
		switch info.PlaybackStatus {
		case media.Disconnected:
			return nil
		case media.Playing:
			icon = ""
		case media.Paused:
			icon = ""
		case media.Stopped:
			icon = ""
		}

		return outputs.
			Textf("%s %s - %s", icon, info.Artist, info.Title).
			OnClick(func(e bar.Event) {
				switch e.Button {
				case bar.ButtonLeft:
					info.PlayPause()
				case bar.ScrollDown, bar.ScrollRight:
					info.Seek(time.Second)
				case bar.ButtonBack:
					info.Previous()
				case bar.ScrollUp, bar.ScrollLeft:
					info.Seek(-time.Second)
				case bar.ButtonRight, bar.ButtonForward:
					info.Next()
				}
			})
	})
}
