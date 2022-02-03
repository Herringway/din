module din.notifiers.prowl;

import din;

class Prowl : Notifier {
	private string[] targets;
	///The optional API key used to identify the appllication
	string apiKey;

	///
	this(string[] targs) @safe {
		targets = targs;
	}

	/// Send a Prowl notification
	void send(Notification toSend) @safe {
		import easyhttp : post, URL;
		import std.algorithm : clamp;
		import std.conv : text;
		import std.string : join;
		auto postData = [
			"apikey": targets.join(","),
			"event": toSend.title,
			"application": toSend.appTitle,
			"description": toSend.message,
			"url": toSend.url,
			"priority": text(clamp(toSend.priority, -2, 2))
		];
		if (apiKey != apiKey.init) {
			postData["providerkey"] = apiKey;
		}
		post(URL("https://api.prowlapp.com/publicapi/add"), postData);
	}
}
