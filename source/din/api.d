module din.api;
private {
	import din.notifiers.pushover;
	import din.notifiers.notifymyandroid;
	import din.notifiers.toasty;
	import din.notifiers.prowl;
	import din.notifiers.faast;
}

enum pushService { Pushover, NotifyMyAndroid, Toasty, Prowl, Faast };
public class Din {
	Notifier[] notifiers;

	public void send(Notification toSend) {
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
package interface Notifier {
	void send(notification toSend);
	void setTargets(string[] targets);
	@property bool needsAPIKey();
	@property string APIKey(string key);
}
/**
 * Struct containing notification data. Fill in as much as possible for best
 * results. Note that not all services are guaranteed to support all fields.
 */
struct Notification {
	import std.datetime : SysTime;
	string Title;
	deprecated alias title = Title;
	string AppTitle;
	deprecated alias apptitle = AppTitle;
	string Message;
	deprecated alias message = Message;
	string URL;
	deprecated alias url = URL;
	byte Priority = 0;
	deprecated alias priority = Priority;
	SysTime Time;
	deprecated alias time = Time;
}
deprecated("Use Notification instead") alias notification = Notification;