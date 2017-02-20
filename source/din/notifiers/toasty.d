module din.notifiers.toasty;

private import din;

class Toasty : Notifier {
	private string[] targets;
	private string _APIKey;
	@property string apiKey(string key) {
		return _APIKey = key;
	}
	void setTargets(string[] targs) {
		targets = targs;
	}
	void send(Notification toSend) {
		import std.uri;
		import std.string;
		import requests : postContent, MultipartForm, formData;
		foreach (id; targets) {
			MultipartForm form;
			form.add(formData("title", toSend.title));
			form.add(formData("sender", toSend.appTitle));
			form.add(formData("text", toSend.message));
			postContent(format("http://api.supertoasty.com/notify/%s", id),  form);
		}
	}
	@property bool needsAPIKey() {
		return false;
	}
}