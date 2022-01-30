module din.notifiers.prowl;

private import din;

class Prowl : Notifier {
	private string[] targets;
	private string _APIKey;
	string apiKey(string key) {
		return _APIKey = key;
	}
	void setTargets(string[] targs) {
		targets = targs;
	}
	void send(Notification toSend) {
		import easyhttp : post, URL;
		import std.algorithm : clamp, map;
		import std.conv : text;
		import std.string : join;
		auto postData = ["apikey":targets.join(","), "event":toSend.title, "application":toSend.appTitle, "description":toSend.message, "url":toSend.url, "priority":text(clamp(toSend.priority, -2, 2))];
		if (_APIKey != _APIKey.init)
			postData["providerkey"] = _APIKey;
		post(URL("https://api.prowlapp.com/publicapi/add"), postData);
	}
	bool needsAPIKey() {
		return false;
	}
}