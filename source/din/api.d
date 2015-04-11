module din.api;
private {
	import din.notifiers.pushover;
	import din.notifiers.notifymyandroid;
	import din.notifiers.toasty;
	import din.notifiers.prowl;
	import din.notifiers.faast;
}
///Push notification services supported by this library
enum pushService { Pushover, NotifyMyAndroid, Toasty, Prowl, Faast };
/**
 * Interface for preparing notifiers and sending notifications to multiple
 * services simultaneously.
 */
public class Din {
	private Notifier[] notifiers;
	/**
	 * Sends a notification to all registered notification services and their
	 * targets.
	 * Params: toSend = The notification that will be sent out
	 */
	public void send(Notification toSend) {
		foreach (notifier; notifiers)
			notifier.send(toSend);
	}
	/**
	 * Registers a notification service with this instance.
	 * Params:
	 *  service = Type of service to register
	 *  APIKey = The key that grants this application access to the service
	 *  targets = Strings identifying the endpoints receiving the notifications
	 */
	public void addNotifier(pushService service, string APIKey, string[] targets) {
		auto notifier = createNotifier(service, targets);
		notifier.APIKey = APIKey;
		notifiers ~= notifier;
	}
	/**
	 * Registers a notification service with this instance.
	 * Params:
	 *  service = Type of service to register
	 *  targets = Strings identifying the endpoints receiving the notifications
	 */
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
		final switch (service) {
			case pushService.Pushover: notifier = new Pushover; break;
			case pushService.NotifyMyAndroid: notifier = new NotifyMyAndroid; break;
			case pushService.Toasty: notifier = new Toasty; break;
			case pushService.Prowl: notifier = new Prowl; break;
			case pushService.Faast: notifier = new Faast; break;
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

static if (!__traits(compiles, (clamp(0, 0, 0)))) { //For dmd <= 2.067 compatibility
	import std.algorithm : min, max;
	T clamp(T)(T val, T lesser, T greater) {
		return min(greater, max(lesser, val));
	}
} else
	public import std.algorithm : clamp;