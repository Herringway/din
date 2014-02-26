module notifymyandroid;

private import std.uri;
private import std.string;
private import std.net.curl;
private import std.stdio;
private import notifier;
private import std.conv : text;
private import std.algorithm : min, max;


class NotifyMyAndroid : Notifier {
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
		auto postData = ["apikey":targets.join(","), "event":toSend.title, "application":toSend.apptitle, "description":toSend.message, "priority":text(max(-2, min(2, toSend.priority)))];
		if (toSend.url != toSend.url.init)
			postData["url"] = toSend.url;
		post("https://www.notifymyandroid.com/publicapi/notify", format("%(%(%c%)=%(%c%)&%)", postData).encode(), client);
	}
	@property bool needsAPIKey() {
		return false;
	}
}
void sendNMAMessage(string[] targetkeys, string appname, string event, string message, string url = "", int priority = 0) {
	auto client = HTTP();
	client.verifyPeer(false);
	auto content = post("https://www.notifymyandroid.com/publicapi/notify", format("apikey=%s&application=%s&event=%s&description=%s&priority=%s&url=%s", targetkeys.join(","), appname, event, message, priority, url).encode(), client);
}