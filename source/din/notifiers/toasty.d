module din.notifiers.toasty;

private import din;

class Toasty : Notifier {
	private string[] targets;
	private string _APIKey;
	@property string APIKey(string key) {
		return _APIKey = key;
	}
	void setTargets(string[] targs) {
		targets = targs;
	}
	void send(Notification toSend) {
		import std.uri;
		import std.string;
		import std.net.curl;
		auto client = HTTP();
		client.verifyPeer(false);
		client.addRequestHeader("Content-Type", "multipart/form-data");
		foreach (id; targets) {
			auto postData = ["title":toSend.Title, "sender":toSend.AppTitle, "text":toSend.Message];
			post(format("http://api.supertoasty.com/notify/%s", id), format("%(%(%c%)=%(%c%)&%)", postData).encode(), client);
		}
	}
	@property bool needsAPIKey() {
		return false;
	}
}