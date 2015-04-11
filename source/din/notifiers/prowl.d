module din.notifiers.prowl;

private import din;

class Prowl : Notifier {
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
		import std.algorithm : map;
		import std.conv : text;
		import std.uri;
		import std.string;
		auto client = HTTP();
		client.verifyPeer(false);
		auto postData = ["apikey":targets.join(","), "event":toSend.Title, "application":toSend.AppTitle, "description":toSend.Message, "url":toSend.URL, "priority":text(clamp(toSend.Priority, -2, 2))];
		if (_APIKey != _APIKey.init)
			postData["providerkey"] = _APIKey;
		post("https://api.prowlapp.com/publicapi/add", format("%(%(%c%)=%(%c%)&%)", postData).encode(), client);
	}
	@property bool needsAPIKey() {
		return false;
	}
}