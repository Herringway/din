module faast;

private import std.uri;
private import std.string;
private import std.net.curl;
private import din;


class Faast : Notifier {
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
			auto postData = ["user_credentials":id, "notification[title]":toSend.title, "notification[subtitle]":toSend.apptitle, "notification[message]":toSend.message, "notification[long_message]":toSend.message];
			if (_APIKey != _APIKey.init)
				postData["providerkey"] = _APIKey;
			post("https://www.appnotifications.com/account/notifications.json", format("%(%(%c%)=%(%c%)&%)", postData).encode(), client);
		}
	}
	@property bool needsAPIKey() {
		return false;
	}
}