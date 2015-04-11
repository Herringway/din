module din.notifiers.notifymyandroid;

private import din;

class NotifyMyAndroid : Notifier {
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
		import std.conv : text;
		import std.uri;
		import std.string;
		auto client = HTTP();
		client.verifyPeer(false);
		auto postData = ["apikey":targets.join(","), "event":toSend.Title, "application":toSend.AppTitle, "description":toSend.Message, "priority":text(clamp(toSend.Priority, -2, 2))];
		if (toSend.URL != toSend.URL.init)
			postData["url"] = toSend.URL;
		post("https://www.notifymyandroid.com/publicapi/notify", format("%(%(%c%)=%(%c%)&%)", postData).encode(), client);
	}
	@property bool needsAPIKey() {
		return false;
	}
}