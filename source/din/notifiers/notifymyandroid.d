module din.notifiers.notifymyandroid;

private import din;

class NotifyMyAndroid : Notifier {
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
		import std.conv : text;
		import std.uri;
		import std.string;
		import std.algorithm : clamp;
		auto postData = ["apikey":targets.join(","), "event":toSend.title, "application":toSend.appTitle, "description":toSend.message, "priority":text(clamp(toSend.priority, -2, 2))];
		if (toSend.url != toSend.url.init)
			postData["url"] = toSend.url;
		postContent("https://www.notifymyandroid.com/publicapi/notify", postData);
	}
	@property bool needsAPIKey() {
		return false;
	}
}