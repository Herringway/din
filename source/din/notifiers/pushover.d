module din.notifiers.pushover;

private import din;

class Pushover : Notifier {
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
		import std.json;
		import std.conv : text;
		import std.uri;
		import std.string;
		foreach (id; targets) {
			auto postData = ["token":_APIKey, "user":id, "message":toSend.message, "priority":text(clamp(toSend.priority, -1, 2))];
			if (toSend.time !is toSend.time.init)
				postData["timestamp"] = text(toSend.time.toUnixTime());
			if (toSend.url !is toSend.url.init)
				postData["url"] = toSend.url;
			auto json = parseJSON(postContent("https://api.pushover.net/1/messages.json", postData));
			if (json.object["status"].integer == 0)
				throw new Exception("Unable to send Pushover notification: " ~ map!((a) => a.str)(json.object["errors"].array).join(", "));
		}
	}
	@property bool needsAPIKey() {
		return true;
	}
}