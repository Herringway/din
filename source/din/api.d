module din.api;
private {
	import din.notifiers.pushover;
	import din.notifiers.notifymyandroid;
	import din.notifiers.toasty;
	import din.notifiers.prowl;
	import din.notifiers.faast;
}
///Push notification services supported by this library
enum PushService { pushover, notifyMyAndroid, toasty, prowl, faast };
deprecated("Use PushService instead") alias pushService = PushService;
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
	public void addNotifier(PushService service, string apiKey, string[] targets) {
		auto notifier = createNotifier(service, targets);
		notifier.apiKey = apiKey;
		notifiers ~= notifier;
	}
	/**
	 * Registers a notification service with this instance.
	 * Params:
	 *  service = Type of service to register
	 *  targets = Strings identifying the endpoints receiving the notifications
	 */
	public void addNotifier(PushService service, string[] targets) {
		auto notifier = createNotifier(service, targets);
		if (notifier.needsAPIKey)
			throw new Exception("Unable to create instance of this notifier without an API Key");
		notifiers ~= notifier;
	}
	private Notifier createNotifier(PushService service, string[] targets) {
		import std.string : format;
		if (targets.length == 0)
			throw new Exception(format("%s: No targets specified", service));
		Notifier notifier;
		final switch (service) {
			case PushService.pushover: notifier = new Pushover; break;
			case PushService.notifyMyAndroid: notifier = new NotifyMyAndroid; break;
			case PushService.toasty: notifier = new Toasty; break;
			case PushService.prowl: notifier = new Prowl; break;
			case PushService.faast: notifier = new Faast; break;
		}
		notifier.setTargets(targets);
		return notifier;
	}
}
package interface Notifier {
	void send(notification toSend);
	void setTargets(string[] targets);
	@property bool needsAPIKey();
	@property string apiKey(string key);
}
/**
 * Struct containing notification data. Fill in as much as possible for best
 * results. Note that not all services are guaranteed to support all fields.
 */
struct Notification {
	import std.datetime : SysTime;
	string title;
	deprecated alias Title = title;
	string appTitle;
	deprecated alias AppTitle = appTitle;
	string message;
	deprecated alias Message = message;
	string url;
	deprecated alias URL = url;
	byte priority = 0;
	deprecated alias Priority = priority;
	SysTime time;
	deprecated alias Time = time;
}
deprecated("Use Notification instead") alias notification = Notification;