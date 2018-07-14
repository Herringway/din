module din.notifiers.pushover;

private import din;

class Pushover : Notifier {
	private string[] targets;
	private string _APIKey;
	string apiKey(string key) {
		return _APIKey = key;
	}
	void setTargets(string[] targs) {
		targets = targs;
	}
	void send(Notification toSend) {
		import requests : postContent;
		import std.algorithm : clamp, map;
		import std.conv : text;
		import std.json : parseJSON;
		import std.string : assumeUTF, join;
		foreach (id; targets) {
			auto postData = ["token":_APIKey, "user":id, "message":toSend.message, "priority":text(clamp(toSend.priority, -1, 2))];
			if (toSend.time !is toSend.time.init)
				postData["timestamp"] = text(toSend.time.toUnixTime());
			if (toSend.url !is toSend.url.init)
				postData["url"] = toSend.url;
			auto json = parseJSON(assumeUTF(postContent("https://api.pushover.net/1/messages.json", postData).data));
			if (json.object["status"].integer == 0)
				throw new Exception("Unable to send Pushover notification: " ~ map!((a) => a.str)(json.object["errors"].array).join(", "));
		}
	}
	bool needsAPIKey() {
		return true;
	}
}