module din.notifiers.pushover;

private import din;

class Pushover : Notifier {
	private string[] targets;
	private string _APIKey;
	@property string APIKey(string key) {
		return _APIKey = key;
	}
	void setTargets(string[] targs) {
		targets = targs;
	}
	void send(Notification toSend) {
		import std.net.curl : post, HTTP;
		import std.algorithm : min, max, map;
		import std.json;
		import std.conv : text;
		import std.uri;
		import std.string;
		auto client = HTTP();
		client.verifyPeer(false);
		foreach (id; targets) {
			auto postData = ["token":_APIKey, "user":id, "message":toSend.Message, "priority":text(max(-1, min(2, toSend.Priority)))];
			if (toSend.Time !is toSend.Time.init)
				postData["timestamp"] = text(toSend.Time.toUnixTime());
			if (toSend.URL !is toSend.URL.init)
				postData["url"] = toSend.URL;
			auto json = parseJSON(post("https://api.pushover.net/1/messages.json", format("%(%(%c%)=%(%c%)&%)", postData).encode(), client));
			if (json.object["status"].integer == 0)
				throw new Exception("Unable to send Pushover notification: " ~ map!((a) => a.str)(json.object["errors"].array).join(", "));
		}
	}
	@property bool needsAPIKey() {
		return true;
	}
}