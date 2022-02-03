module din.notifiers.gotify;

import din;

class Gotify : Notifier {
	import easyhttp : URL;
	private URL baseURL;
	private string token;
	this(string url, string token) @safe {
		this.token = token;
		this.baseURL = URL(url);
	}
	void send(Notification toSend) @safe {
		import easyhttp : post;
		import std.algorithm : clamp, map;
		import std.conv : text;
		auto postData = [
			"message": toSend.message,
			"title": text(toSend.appTitle, toSend.appTitle ? " - " : "", toSend.title),
			"priority" : text(toSend.priority == -1 ? 5 : clamp(toSend.priority, 0, 10))
		];
		post(baseURL.absoluteURL("/message").withParams(["token":token]), postData);
	}
}
