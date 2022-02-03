module din.notifiers.pushover;

private import din;

class Pushover : Notifier {
	private string[] targets;
	private string _APIKey;
	///
	this(string apiKey, string[] targs) @safe {
		_APIKey = apiKey;
		targets = targs;
	}
	/// Send a Pushover notification
	void send(Notification toSend) @safe {
		import easyhttp : post, URL;
		import std.algorithm : clamp, map;
		import std.conv : text;
		import std.json : parseJSON;
		import std.string : join;
		foreach (id; targets) {
			auto postData = [
				"token": _APIKey,
				"user": id,
				"message": toSend.message,
				"priority": clamp(toSend.priority, -1, 2).text
			];
			if (toSend.time !is toSend.time.init) {
				postData["timestamp"] = toSend.time.toUnixTime().text;
			}
			if (toSend.url !is toSend.url.init) {
				postData["url"] = toSend.url;
			}
			auto json = parseJSON(post(URL("https://api.pushover.net/1/messages.json"), postData).content);
			if (json.objectNoRef["status"].integer == 0) {
				throw new Exception("Unable to send Pushover notification: " ~ json.objectNoRef["errors"].arrayNoRef.map!((a) => a.str).join(", "));
			}
		}
	}
}
