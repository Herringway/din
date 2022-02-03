module din.system;

version(Have_easysettings) {
	import din.notifiers.gotify;
	import din.notifiers.multi;
	import din.notifiers.prowl;
	import din.notifiers.pushover;
	import easysettings;

	private struct Settings {
		PushoverTargets[] pushover;
		GotifyTargets[] gotify;
		ProwlTargets[] prowl;
	}

	private struct PushoverTargets {
		string[] devices;
		string appToken;
		string[] userTokens;
		string defaultSound = "pushover";
		bool isValid() @safe {
			return (appToken != "") && (userTokens.length > 0);
		}
	}
	private struct GotifyTargets {
		string token;
		string url;
		bool isValid() @safe {
			return (token != "") && (url != "");
		}
	}
	private struct ProwlTargets {
		string[] targets;
		string token;
		bool isValid() @safe {
			return targets.length > 0;
		}
	}

	MultiNotifier prepareSystemNotifier() @system {
		auto notifier = new MultiNotifier;
		auto settings = loadSettings!Settings("din");
		foreach (pushover; settings.pushover) {
			if (pushover.isValid) {
				notifier.add(new Pushover(pushover.appToken, pushover.userTokens));
			}
		}
		foreach (gotify; settings.gotify) {
			if (gotify.isValid) {
				notifier.add(new Gotify(gotify.url, gotify.token));
			}
		}
		foreach (prowl; settings.prowl) {
			if (prowl.isValid) {
				auto newNotifier = new Prowl(prowl.targets);
				newNotifier.apiKey = prowl.token;
				notifier.add(newNotifier);
			}
		}
		return notifier;
	}
}
