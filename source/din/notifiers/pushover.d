module din.notifiers.pushover;

private import din;

class Pushover : Notifier {
	private string[] targets;
	private string _APIKey;
	package string apiKey(string key) {
		return _APIKey = key;
	}
	package void setTargets(string[] targs) {
		targets = targs;
	}
	package void send(Notification toSend) {
		import requests : postContent;
		import std.algorithm : clamp, map;
		import std.conv : text;
		import std.json : parseJSON;
		import std.string : join;
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
	package bool needsAPIKey() {
		return true;
	}
}