module din.notifiers.prowl;

private import din;

class Prowl : Notifier {
	private string[] targets;
	private string _APIKey;
	@property string apiKey(string key) {
		return _APIKey = key;
	}
	void setTargets(string[] targs) {
		targets = targs;
	}
	void send(Notification toSend) {
		import requests : postContent;
		import std.algorithm : map, clamp;
		import std.conv : text;
		import std.uri;
		import std.string;
		auto postData = ["apikey":targets.join(","), "event":toSend.title, "application":toSend.appTitle, "description":toSend.message, "url":toSend.url, "priority":text(clamp(toSend.priority, -2, 2))];
		if (_APIKey != _APIKey.init)
			postData["providerkey"] = _APIKey;
		postContent("https://api.prowlapp.com/publicapi/add", postData);
	}
	@property bool needsAPIKey() {
		return false;
	}
}