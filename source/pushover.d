module pushover;

private import std.uri;
private import std.string;
private import std.net.curl;
private import notifier;
private import std.conv : text;
private import std.algorithm : min, max, map;
private import std.json;

class Pushover : Notifier {
	private string[] targets;
	private string _APIKey;
	@property string APIKey(string key) {
		return _APIKey = key;
	}
	void setTargets(string[] targs) {
		targets = targs;
	}
	void send(notification toSend) {
		auto client = HTTP();
		client.verifyPeer(false);
		foreach (id; targets) {
			auto postData = ["token":_APIKey, "user":id, "message":toSend.message, "priority":text(max(-1, min(2, toSend.priority)))];
			if (toSend.time !is toSend.time.init)
				postData["timestamp"] = text(toSend.time.toUnixTime());
			if (toSend.url !is toSend.url.init)
				postData["url"] = toSend.url;
			auto json = parseJSON(post("https://api.pushover.net/1/messages.json", format("%(%(%c%)=%(%c%)&%)", postData).encode(), client));
			if (json.object["status"].integer == 0)
				throw new Exception("Unable to send Pushover notification: " ~ map!((a) => a.str)(json.object["errors"].array).join(", "));
		}
	}
	@property bool needsAPIKey() {
		return true;
	}
}
void sendPushoverMessage(string APIKey, string userSecret, string title, string message) {
	auto client = HTTP();
	client.verifyPeer(false);
	auto content = post("https://api.pushover.net/1/messages.json", format("token=%s&user=%s&message=%s", APIKey, userSecret, message).encode(), client);
}