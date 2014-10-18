module din.api;
private {
	import din.notifiers.pushover;
	import din.notifiers.notifymyandroid;
	import din.notifiers.toasty;
	import din.notifiers.prowl;
	import din.notifiers.faast;
}

enum pushService { Pushover, NotifyMyAndroid, Toasty, Prowl, Faast };
class Din {
	Notifier[] notifiers;

	public void send(notification toSend) {
		foreach (notifier; notifiers)
			notifier.send(toSend);
	}
	public void addNotifier(pushService service, string APIKey, string[] targets) {
		auto notifier = createNotifier(service, targets);
		notifier.APIKey = APIKey;
		notifiers ~= notifier;
	}
	public void addNotifier(pushService service, string[] targets) {
		auto notifier = createNotifier(service, targets);
		if (notifier.needsAPIKey)
			throw new Exception("Unable to create instance of this notifier without an API Key");
		notifiers ~= notifier;
	}
	private Notifier createNotifier(pushService service, string[] targets) {
		import std.string : format;
		if (targets.length == 0)
			throw new Exception(format("%s: No targets specified", service));
		Notifier notifier;
		switch (service) {
			case pushService.Pushover: notifier = new Pushover; break;
			case pushService.NotifyMyAndroid: notifier = new NotifyMyAndroid; break;
			case pushService.Toasty: notifier = new Toasty; break;
			case pushService.Prowl: notifier = new Prowl; break;
			case pushService.Faast: notifier = new Faast; break;
			default: throw new Exception("Unsupported service");
		}
		notifier.setTargets(targets);
		return notifier;
	}
}
interface Notifier {
	void send(notification toSend);
	void setTargets(string[] targets);
	@property bool needsAPIKey();
	@property string APIKey(string key);
}
struct notification {
	import std.datetime : SysTime;
	string title;
	string apptitle;
	string message;
	string url;
	byte priority = 0;
	SysTime time;
}