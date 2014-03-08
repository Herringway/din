module toasty;

private import std.uri;
private import std.string;
private import std.net.curl;
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
	void send(notification toSend) {
		auto client = HTTP();
		client.verifyPeer(false);
		client.addRequestHeader("Content-Type", "multipart/form-data");
		foreach (id; targets) {
			auto postData = ["title":toSend.title, "sender":toSend.apptitle, "text":toSend.message];
			post(format("http://api.supertoasty.com/notify/%s", id), format("%(%(%c%)=%(%c%)&%)", postData).encode(), client);
		}
	}
	@property bool needsAPIKey() {
		return false;
	}
}