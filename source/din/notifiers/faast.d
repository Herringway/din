module din.notifiers.faast;

private import din;

class Faast : Notifier {
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
		foreach (id; targets) {
			auto postData = ["user_credentials":id, "notification[title]":toSend.title, "notification[subtitle]":toSend.appTitle, "notification[message]":toSend.message, "notification[long_message]":toSend.message];
			if (_APIKey != _APIKey.init)
				postData["providerkey"] = _APIKey;
			postContent("https://www.appnotifications.com/account/notifications.json", postData);
		}
	}
	bool needsAPIKey() {
		return false;
	}
}