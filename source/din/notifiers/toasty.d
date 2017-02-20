module din.notifiers.toasty;

private import din;

class Toasty : Notifier {
	private string[] targets;
	private string _APIKey;
	package string apiKey(string key) {
		return _APIKey = key;
	}
	package void setTargets(string[] targs) {
		targets = targs;
	}
	package void send(Notification toSend) {
		import requests : formData, MultipartForm, postContent;
		import std.format : format;
		foreach (id; targets) {
			MultipartForm form;
			form.add(formData("title", toSend.title));
			form.add(formData("sender", toSend.appTitle));
			form.add(formData("text", toSend.message));
			postContent(format("http://api.supertoasty.com/notify/%s", id),  form);
		}
	}
	package bool needsAPIKey() {
		return false;
	}
}